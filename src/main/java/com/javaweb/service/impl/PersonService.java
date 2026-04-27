package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.entity.AcademicProfileEntity;
import com.javaweb.entity.AwardRecordEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.familytree.service.FamilyTreeReadService;
import com.javaweb.model.dto.FamilyTreeMemberListItemDTO;
import com.javaweb.model.dto.PersonDTO;
import com.javaweb.repository.AcademicProfileRepository;
import com.javaweb.repository.AwardRecordRepository;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.FamilyTreeRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.service.IPersonService;
import com.javaweb.utils.FamilyTreeBranchUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.MonthDay;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class PersonService implements IPersonService {
    private static final int MAX_TREE_DEPTH = 64;
    private static final int MAX_GENERATION = 50;
    private static final int MAX_SHORT_TEXT_LENGTH = 255;
    private static final int MAX_NOTE_LENGTH = 5000;
    private static final DateTimeFormatter DIRECTORY_DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final Pattern DOD_DISPLAY_MARKER = Pattern.compile("\\[\\[DOD_DISPLAY=([^\\]]*)\\]\\]");
    private static final Pattern PARTIAL_DOD_DISPLAY_PATTERN = Pattern.compile("^(\\d{2}/\\d{2}|\\d{4})$");
    private static final Set<String> ALLOWED_GENDERS =
            Collections.unmodifiableSet(new HashSet<>(Arrays.asList("male", "female", "other")));

    private final PersonRepository personRepository;
    private final BranchRepository branchRepository;
    private final FamilyTreeRepository familyTreeRepository;
    private final FamilyTreeReadService familyTreeReadService;
    private final FamilyTreeContextService familyTreeContextService;
    private final AcademicProfileRepository academicProfileRepository;
    private final AwardRecordRepository awardRecordRepository;
    private final UserRepository userRepository;

    public PersonService(PersonRepository personRepository,
                         BranchRepository branchRepository,
                         FamilyTreeRepository familyTreeRepository,
                         FamilyTreeReadService familyTreeReadService,
                         FamilyTreeContextService familyTreeContextService,
                         AcademicProfileRepository academicProfileRepository,
                         AwardRecordRepository awardRecordRepository,
                         UserRepository userRepository) {
        this.personRepository = personRepository;
        this.branchRepository = branchRepository;
        this.familyTreeRepository = familyTreeRepository;
        this.familyTreeReadService = familyTreeReadService;
        this.familyTreeContextService = familyTreeContextService;
        this.academicProfileRepository = academicProfileRepository;
        this.awardRecordRepository = awardRecordRepository;
        this.userRepository = userRepository;
    }

    @Override
    public PersonDTO createPerson(PersonDTO personDTO) {
        if (personDTO == null) {
            throw new IllegalArgumentException("Dữ liệu thành viên không hợp lệ");
        }
        if (personDTO.getExistingPersonId() != null) {
            PersonEntity existing = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(personDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thành viên có sẵn: " + personDTO.getExistingPersonId()));
            FamilyTreeEntity familyTree = resolveEffectiveFamilyTree(personDTO.getFamilyTreeId(), existing.getFamilyTree());
            assertSameFamilyTree(existing, familyTree, "Thành viên");
            Integer normalizedGeneration = normalizeGeneration(personDTO.getGeneration(), true);
            String normalizedGender = normalizeGender(personDTO.getGender(), false);
            validateBirthAndDeathDates(personDTO.getDob(), personDTO.getDod());
            existing.setFamilyTree(familyTree);
            existing.setBranch(resolveBranchOrDefault(null, existing.getBranch(), familyTree));
            existing.setGeneration(normalizedGeneration);
            if (normalizedGender != null) {
                existing.setGender(normalizedGender);
            }
            if (personDTO.getDob() != null) {
                existing.setDob(java.sql.Date.valueOf(personDTO.getDob()));
            }
            if (personDTO.getDod() != null) {
                existing.setDod(java.sql.Date.valueOf(personDTO.getDod()));
            }
            if (personDTO.getAvatar() != null && !personDTO.getAvatar().trim().isEmpty()) {
                existing.setAvatar(personDTO.getAvatar().trim());
            }
            applyAdditionalFields(existing, personDTO, false);
            PersonEntity saved = personRepository.save(existing);
            evictFamilyTreeCache();
            return refreshPersonSnapshot(saved.getId());
        }
        String normalizedFullName = normalizeRequiredFullName(personDTO.getFullName());
        FamilyTreeEntity familyTree = resolveEffectiveFamilyTree(personDTO.getFamilyTreeId(), null);
        Integer normalizedGeneration = normalizeGeneration(personDTO.getGeneration(), true);
        String normalizedGender = normalizeGender(personDTO.getGender(), false);
        validateBirthAndDeathDates(personDTO.getDob(), personDTO.getDod());

        PersonEntity personEntity = new PersonEntity();
        personEntity.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        personEntity.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        personEntity.setFullName(normalizedFullName);
        personEntity.setGeneration(normalizedGeneration);
        personEntity.setGender(normalizedGender);
        personEntity.setAvatar(personDTO.getAvatar());
        personEntity.setFamilyTree(familyTree);
        applyAdditionalFields(personEntity, personDTO, true);
        personEntity.setBranch(resolveMainBranch(familyTree));
        PersonEntity saved = personRepository.save(personEntity);
        evictFamilyTreeCache();
        return refreshPersonSnapshot(saved.getId());
    }

    @Override
    public long countPersons() {
        Long familyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        return familyTreeId == null ? 0 : personRepository.countByFamilyTree_Id(familyTreeId);
    }

    @Override
    @Transactional(readOnly = true)
    public PersonDTO findPersonById(Long personId) {
        return familyTreeReadService.findPersonById(personId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PersonDTO> findAttachablePersonsByBranchId(Long branchId, String fullName, String gender, LocalDate dob) {
        if (branchId == null) {
            return new ArrayList<>();
        }
        String normalizedFullName = fullName == null || fullName.trim().isEmpty() ? null : fullName.trim();
        String normalizedGender = gender == null || gender.trim().isEmpty() ? null : gender.trim().toLowerCase();
        java.sql.Date dobDate = dob == null ? null : java.sql.Date.valueOf(dob);
        return personRepository.findAttachablePersons(normalizedFullName, normalizedGender, dobDate)
                .stream()
                .map(entity -> {
                    PersonDTO dto = new PersonDTO();
                    dto.setId(entity.getId());
                    dto.setFullName(entity.getFullName());
                    dto.setGender(entity.getGender());
                    dto.setAvatar(entity.getAvatar());
                    dto.setUserId(entity.getUserId());
                    dto.setDob(toLocalDate(entity.getDob()));
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public PersonDTO addSpouse(Long personId, PersonDTO spouseDTO) {
        if (spouseDTO == null) {
            throw new IllegalArgumentException("Dữ liệu vợ/chồng không hợp lệ");
        }
        if (spouseDTO.getFullName() == null || spouseDTO.getFullName().trim().isEmpty()) {
            if (spouseDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Họ tên vợ/chồng không được để trống");
            }
        }
        PersonEntity person = personRepository.findByIdAndSpouseIsNull(personId).orElseThrow(
                () -> new IllegalArgumentException("Không tìm thấy thành viên hoặc thành viên đã có vợ/chồng: " + personId)
        );
        FamilyTreeEntity familyTree = resolveEffectiveFamilyTree(spouseDTO.getFamilyTreeId(), person.getFamilyTree());
        ensurePersonInCurrentFamilyTree(person);
        String normalizedPersonGender = normalizeGender(person.getGender(), true);
        String expectedSpouseGender = expectedSpouseGender(normalizedPersonGender);

        PersonEntity spouse;
        if (spouseDTO.getExistingPersonId() != null) {
            spouse = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(spouseDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Thành viên được chọn làm vợ/chồng không khả dụng"));
            if (Objects.equals(spouse.getId(), person.getId())) {
                throw new IllegalArgumentException("Không thể tự ghép một thành viên làm vợ/chồng của chính mình");
            }
            assertSameFamilyTree(spouse, familyTree, "Vợ/chồng");
            validateExistingSpouseGender(spouse, expectedSpouseGender);
            validateBirthAndDeathDates(toLocalDate(spouse.getDob()), toLocalDate(spouse.getDod()));
            spouse.setGeneration(person.getGeneration());
            spouse.setFamilyTree(familyTree);
            spouse.setBranch(resolveBranchOrDefault(null, person.getBranch(), familyTree));
            if (spouseDTO.getGender() != null && !spouseDTO.getGender().trim().isEmpty()) {
                validateRequestedSpouseGender(spouseDTO.getGender(), expectedSpouseGender);
            }
            spouse.setGender(expectedSpouseGender);
            if (spouseDTO.getAvatar() != null && !spouseDTO.getAvatar().trim().isEmpty()) {
                spouse.setAvatar(spouseDTO.getAvatar());
            }
            if (spouseDTO.getDob() != null) {
                spouse.setDob(java.sql.Date.valueOf(spouseDTO.getDob()));
            }
            if (spouseDTO.getDod() != null) {
                spouse.setDod(java.sql.Date.valueOf(spouseDTO.getDod()));
            }
            validateBirthAndDeathDates(toLocalDate(spouse.getDob()), toLocalDate(spouse.getDod()));
            applyAdditionalFields(spouse, spouseDTO, false);
        } else {
            String normalizedSpouseFullName = normalizeRequiredFullName(spouseDTO.getFullName());
            validateBirthAndDeathDates(spouseDTO.getDob(), spouseDTO.getDod());
            validateRequestedSpouseGender(spouseDTO.getGender(), expectedSpouseGender);
            spouse = new PersonEntity();
            spouse.setFullName(normalizedSpouseFullName);
            spouse.setGender(expectedSpouseGender);
            spouse.setDob(spouseDTO.getDob() == null ? null : java.sql.Date.valueOf(spouseDTO.getDob()));
            spouse.setDod(spouseDTO.getDod() == null ? null : java.sql.Date.valueOf(spouseDTO.getDod()));
            spouse.setGeneration(person.getGeneration());
            spouse.setFamilyTree(familyTree);
            spouse.setBranch(resolveBranchOrDefault(null, person.getBranch(), familyTree));
            spouse.setAvatar(spouseDTO.getAvatar());
            applyAdditionalFields(spouse, spouseDTO, true);
        }
        spouse = personRepository.save(spouse);

        person.setSpouse(spouse);
        spouse.setSpouse(person);
        personRepository.save(person);
        personRepository.save(spouse);

        evictFamilyTreeCache();
        return refreshPersonSnapshot(person.getId());
    }

    @Override
    @Transactional
    public PersonDTO addChild(Long personId, PersonDTO childDTO) {
        if (childDTO == null) {
            throw new IllegalArgumentException("Dữ liệu con không hợp lệ");
        }
        if (childDTO.getFullName() == null || childDTO.getFullName().trim().isEmpty()) {
            if (childDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Họ tên người con không được để trống");
            }
        }
        PersonEntity parent = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Không tìm thấy cha/mẹ: " + personId)
        );
        FamilyTreeEntity familyTree = resolveEffectiveFamilyTree(childDTO.getFamilyTreeId(), parent.getFamilyTree());
        ensurePersonInCurrentFamilyTree(parent);
        if (!isAllowedChildBranch(parent.getBranch())) {
            throw new IllegalArgumentException("Chỉ được phép thêm con cho thành viên ở chi gốc hoặc chi 1, 2");
        }

        PersonEntity child;
        if (childDTO.getExistingPersonId() != null) {
            child = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(childDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Thành viên được chọn làm con không khả dụng"));
            if (Objects.equals(child.getId(), parent.getId())) {
                throw new IllegalArgumentException("Không thể tự gán một thành viên làm con của chính mình");
            }
            assertSameFamilyTree(child, familyTree, "Thành viên");
            Integer expectedGeneration = parent.getGeneration() == null ? 1 : parent.getGeneration() + 1;
            child.setGeneration(expectedGeneration);
            child.setFamilyTree(familyTree);
            child.setBranch(resolveChildBranch(parent, familyTree));
            if (childDTO.getGender() != null && !childDTO.getGender().trim().isEmpty()) {
                child.setGender(normalizeGender(childDTO.getGender(), false));
            }
            if (childDTO.getAvatar() != null && !childDTO.getAvatar().trim().isEmpty()) {
                child.setAvatar(childDTO.getAvatar());
            }
            if (childDTO.getDob() != null) {
                child.setDob(java.sql.Date.valueOf(childDTO.getDob()));
            }
            if (childDTO.getDod() != null) {
                child.setDod(java.sql.Date.valueOf(childDTO.getDod()));
            }
            validateBirthAndDeathDates(toLocalDate(child.getDob()), toLocalDate(child.getDod()));
            applyAdditionalFields(child, childDTO, false);
        } else {
            String normalizedChildFullName = normalizeRequiredFullName(childDTO.getFullName());
            String normalizedChildGender = normalizeGender(childDTO.getGender(), false);
            validateBirthAndDeathDates(childDTO.getDob(), childDTO.getDod());
            child = new PersonEntity();
            child.setFullName(normalizedChildFullName);
            child.setGender(normalizedChildGender);
            child.setDob(childDTO.getDob() == null ? null : java.sql.Date.valueOf(childDTO.getDob()));
            child.setDod(childDTO.getDod() == null ? null : java.sql.Date.valueOf(childDTO.getDod()));
            child.setGeneration(parent.getGeneration() == null ? 1 : parent.getGeneration() + 1);
            child.setFamilyTree(familyTree);
            child.setBranch(resolveChildBranch(parent, familyTree));
            child.setAvatar(childDTO.getAvatar());
            applyAdditionalFields(child, childDTO, true);
        }

        if ("female".equalsIgnoreCase(parent.getGender())) {
            child.setMother(parent);
            child.setFather(parent.getSpouse());
        } else {
            child.setFather(parent);
            child.setMother(parent.getSpouse());
        }
        validateChildDatesWithParents(child);

        personRepository.save(child);
        syncNumberedBranchesAfterTreeChange(familyTree);
        evictFamilyTreeCache();
        return refreshPersonSnapshot(parent.getId());
    }

    @Override
    @Transactional
    public PersonDTO updatePerson(Long personId, PersonDTO personDTO) {
        if (personDTO == null) {
            throw new IllegalArgumentException("Dữ liệu cập nhật không hợp lệ");
        }
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Không tìm thấy thành viên: " + personId)
        );
        FamilyTreeEntity familyTree = resolveEffectiveFamilyTree(personDTO.getFamilyTreeId(), person.getFamilyTree());
        ensurePersonInCurrentFamilyTree(person);

        if (personDTO.getFullName() != null && !personDTO.getFullName().trim().isEmpty()) {
            person.setFullName(normalizeRequiredFullName(personDTO.getFullName()));
        }
        person.setGender(normalizeGender(personDTO.getGender(), false));
        person.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        person.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        validateBirthAndDeathDates(personDTO.getDob(), personDTO.getDod());
        if (personDTO.getGeneration() != null) {
            person.setGeneration(normalizeGeneration(personDTO.getGeneration(), false));
        }
        if (personDTO.getAvatar() != null && !personDTO.getAvatar().trim().isEmpty()) {
            person.setAvatar(personDTO.getAvatar());
        }
        applyAdditionalFields(person, personDTO, true);

        if (personDTO.getBranch() != null && !personDTO.getBranch().trim().isEmpty()) {
            person.setBranch(resolveBranch(personDTO.getBranch(), familyTree));
        }
        person.setFamilyTree(familyTree);
        validateChildDatesWithParents(person);

        personRepository.save(person);
        evictFamilyTreeCache();
        return refreshPersonSnapshot(person.getId());
    }

    @Override
    @Transactional
    public void deletePerson(Long personId) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Không tìm thấy thành viên: " + personId)
        );
        ensurePersonInCurrentFamilyTree(person);
        if (person.getUserId() != null) {
            detachPersonFromTreeAndBranch(person);
            syncNumberedBranchesAfterTreeChange(person.getFamilyTree());
            evictFamilyTreeCache();
            return;
        }

        long childrenCount = personRepository.countChildrenByParentId(personId);
        if (childrenCount > 0) {
            throw new IllegalArgumentException(
                    "Không thể xóa thành viên này vì vẫn còn con. Vui lòng xóa con trước, sau đó mới xóa cha/mẹ."
            );
        }

        PersonEntity spouse = person.getSpouse();
        if (spouse != null) {
            spouse.setSpouse(null);
            person.setSpouse(null);
            detachFromBranchIfOrphan(spouse);
            personRepository.save(spouse);
        }

        personRepository.delete(person);
        syncNumberedBranchesAfterTreeChange(person.getFamilyTree());
        evictFamilyTreeCache();
    }

    private void evictFamilyTreeCache() {
        familyTreeReadService.evictCache();
    }

    private void detachPersonFromTreeAndBranch(PersonEntity person) {
        List<PersonEntity> children = personRepository.findChildrenByParentId(person.getId());
        for (PersonEntity child : children) {
            if (child.getFather() != null && Objects.equals(child.getFather().getId(), person.getId())) {
                child.setFather(null);
            }
            if (child.getMother() != null && Objects.equals(child.getMother().getId(), person.getId())) {
                child.setMother(null);
            }
            personRepository.save(child);
        }

        PersonEntity spouse = person.getSpouse();
        if (spouse != null) {
            spouse.setSpouse(null);
            person.setSpouse(null);
            detachFromBranchIfOrphan(spouse);
            personRepository.save(spouse);
        }

        person.setFather(null);
        person.setMother(null);
        person.setBranch(null);
        person.setFamilyTree(null);
        person.setGeneration(null);
        personRepository.save(person);
    }



    @Override
    @Transactional(readOnly = true)
    public List<PersonDTO> findRootPersonsByBranchId(Long branchId) {
        return familyTreeReadService.findRootPersonsByBranchId(branchId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PersonDTO> findMembersByBranchWithFilters(Long branchId,
                                                           Integer generation,
                                                           String fullName,
                                                           String gender,
                                                           String lifeStatus,
                                                           Integer birthYearFrom,
                                                           Integer birthYearTo,
                                                           Long focusPersonId) {
        return familyTreeReadService.findMembersByBranchWithFilters(
                branchId,
                generation,
                fullName,
                gender,
                lifeStatus,
                null,
                birthYearFrom,
                birthYearTo,
                focusPersonId
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<FamilyTreeMemberListItemDTO> findMemberDirectory(Long familyTreeId) {
        if (familyTreeId == null || familyTreeId <= 0) {
            return new ArrayList<>();
        }

        List<PersonEntity> persons = personRepository.findAllByFamilyTreeIdWithRelations(familyTreeId);
        if (persons.isEmpty()) {
            return new ArrayList<>();
        }

        List<Long> userIds = persons.stream()
                .map(PersonEntity::getUserId)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, UserEntity> usersById = userIds.isEmpty()
                ? new LinkedHashMap<Long, UserEntity>()
                : userRepository.findByIdIn(userIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, user -> user, (left, right) -> left, LinkedHashMap::new));

        Map<String, String> educationByExactKey = buildEducationByExactKey(familyTreeId);
        Map<String, String> educationByUniqueName = buildEducationByUniqueName(familyTreeId, persons);

        return persons.stream()
                .sorted(Comparator
                        .comparing((PersonEntity person) -> person.getGeneration() == null ? Integer.MAX_VALUE : person.getGeneration())
                        .thenComparing(PersonEntity::getId, Comparator.nullsLast(Long::compareTo)))
                .map(person -> toDirectoryItem(person, usersById, educationByExactKey, educationByUniqueName))
                .collect(Collectors.toList());
    }

    private List<PersonDTO> buildTreeRoots(Long branchId, boolean strictMainScope) {
        TreeGraph graph = buildTreeGraph(branchId, strictMainScope);
        if (graph.membersById.isEmpty()) {
            return new ArrayList<>();
        }

        List<PersonDTO> roots = new ArrayList<>();
        Set<Long> consumed = new LinkedHashSet<>();
        for (PersonEntity candidate : graph.rootCandidates) {
            if (candidate == null || candidate.getId() == null || consumed.contains(candidate.getId())) {
                continue;
            }
            PersonEntity spouse = candidate.getSpouse();
            if (spouse != null
                    && spouse.getId() != null
                    && graph.membersById.containsKey(spouse.getId())
                    && spouse.getId() < candidate.getId()) {
                continue;
            }
            roots.add(toPersonDTOByBranch(candidate, branchId, graph.childrenByParentId));
            consumed.add(candidate.getId());
            if (spouse != null && spouse.getId() != null && graph.membersById.containsKey(spouse.getId())) {
                consumed.add(spouse.getId());
            }
        }

        if (!roots.isEmpty()) {
            normalizeDtoMarriageLinks(roots);
            return roots;
        }
        PersonEntity fallback = graph.membersById.values().iterator().next();
        List<PersonDTO> fallbackRoots = new ArrayList<>(Collections.singletonList(
                toPersonDTOByBranch(fallback, branchId, graph.childrenByParentId)
        ));
        normalizeDtoMarriageLinks(fallbackRoots);
        return fallbackRoots;
    }

    private TreeGraph buildTreeGraph(Long branchId, boolean strictMainScope) {
        List<PersonEntity> members = (branchId != null && branchId > 0)
                ? personRepository.findAllByBranchIdWithRelations(branchId)
                : personRepository.findAllWithRelations();
        if (members == null || members.isEmpty()) {
            return new TreeGraph(new LinkedHashMap<>(), new LinkedHashMap<>(), new ArrayList<>());
        }

        Map<Long, PersonEntity> membersById = members.stream()
                .filter(Objects::nonNull)
                .filter(item -> item.getId() != null)
                .collect(Collectors.toMap(
                        PersonEntity::getId,
                        item -> item,
                        (left, right) -> left,
                        LinkedHashMap::new
                ));
        normalizeReciprocalSpouseLinks(membersById);

        Map<Long, List<PersonEntity>> childrenByParentId = new LinkedHashMap<>();
        for (PersonEntity member : membersById.values()) {
            Long parentId = resolveCanonicalParentId(member, membersById);
            if (parentId != null) {
                childrenByParentId.computeIfAbsent(parentId, key -> new ArrayList<>()).add(member);
            }
        }
        for (List<PersonEntity> children : childrenByParentId.values()) {
            children.sort(childCreationComparator());
        }

        List<PersonEntity> candidates = membersById.values().stream()
                .filter(member -> !hasParentInCollection(member, membersById))
                .sorted(personTreeComparator())
                .collect(Collectors.toList());

        if (isStrictMainTreeScope(branchId, strictMainScope)) {
            List<PersonEntity> levelOneRoots = candidates.stream()
                    .filter(root -> root != null && root.getGeneration() != null && root.getGeneration() == 1)
                    .sorted(personTreeComparator())
                    .collect(Collectors.toList());
            if (!levelOneRoots.isEmpty()) {
                Set<Long> allowedIds = collectConnectedIds(levelOneRoots, membersById, childrenByParentId);
                Map<Long, PersonEntity> strictMembersById = membersById.entrySet().stream()
                        .filter(entry -> allowedIds.contains(entry.getKey()))
                        .collect(Collectors.toMap(
                                Map.Entry::getKey,
                                Map.Entry::getValue,
                                (left, right) -> left,
                                LinkedHashMap::new
                        ));
                Map<Long, List<PersonEntity>> strictChildrenByParentId = new LinkedHashMap<>();
                for (Map.Entry<Long, List<PersonEntity>> entry : childrenByParentId.entrySet()) {
                    Long parentId = entry.getKey();
                    if (!allowedIds.contains(parentId)) {
                        continue;
                    }
                    List<PersonEntity> filtered = entry.getValue().stream()
                            .filter(Objects::nonNull)
                            .filter(child -> child.getId() != null && allowedIds.contains(child.getId()))
                            .sorted(childCreationComparator())
                            .collect(Collectors.toList());
                    if (!filtered.isEmpty()) {
                        strictChildrenByParentId.put(parentId, filtered);
                    }
                }
                List<PersonEntity> strictCandidates = levelOneRoots.stream()
                        .filter(root -> root != null && root.getId() != null && allowedIds.contains(root.getId()))
                        .sorted(personTreeComparator())
                        .collect(Collectors.toList());
                if (strictCandidates.isEmpty() && !strictMembersById.isEmpty()) {
                    strictCandidates.add(strictMembersById.values().iterator().next());
                }
                return new TreeGraph(strictMembersById, strictChildrenByParentId, strictCandidates);
            }
        }

        if (candidates.isEmpty() && !membersById.isEmpty()) {
            candidates.add(membersById.values().iterator().next());
        }
        return new TreeGraph(membersById, childrenByParentId, candidates);
    }

    private void normalizeReciprocalSpouseLinks(Map<Long, PersonEntity> membersById) {
        if (membersById == null || membersById.isEmpty()) {
            return;
        }
        for (PersonEntity person : membersById.values()) {
            if (person == null || person.getId() == null) {
                continue;
            }
            PersonEntity spouse = person.getSpouse();
            if (spouse == null || spouse.getId() == null) {
                continue;
            }
            if (Objects.equals(spouse.getId(), person.getId())) {
                person.setSpouse(null);
                continue;
            }
            PersonEntity spouseInScope = membersById.get(spouse.getId());
            if (spouseInScope == null) {
                continue;
            }
            // Loose mode: if spouse_id points to a valid person, accept and mirror immediately.
            spouseInScope.setSpouse(person);
        }
    }

    private Long resolveCanonicalParentId(PersonEntity child, Map<Long, PersonEntity> membersById) {
        if (child == null || child.getId() == null || membersById == null || membersById.isEmpty()) {
            return null;
        }
        PersonEntity father = child.getFather();
        PersonEntity mother = child.getMother();

        PersonEntity fatherInScope = (father != null && father.getId() != null && membersById.containsKey(father.getId()))
                ? membersById.get(father.getId())
                : null;
        PersonEntity motherInScope = (mother != null && mother.getId() != null && membersById.containsKey(mother.getId()))
                ? membersById.get(mother.getId())
                : null;

        Integer childGen = child.getGeneration();
        if (fatherInScope != null && isParentGenerationValid(fatherInScope, childGen)) {
            return fatherInScope.getId();
        }
        if (motherInScope != null && isParentGenerationValid(motherInScope, childGen)) {
            return motherInScope.getId();
        }

        // Fallback when generation data is missing/inconsistent.
        if (fatherInScope != null) {
            return fatherInScope.getId();
        }
        if (motherInScope != null) {
            return motherInScope.getId();
        }
        return null;
    }

    private boolean isParentGenerationValid(PersonEntity parent, Integer childGeneration) {
        if (parent == null) return false;
        if (childGeneration == null || parent.getGeneration() == null) return true;
        return parent.getGeneration() < childGeneration;
    }

    private boolean isStrictMainTreeScope(Long branchId, boolean strictMainScope) {
        return strictMainScope && branchId != null && branchId <= 0;
    }

    private Set<Long> collectConnectedIds(List<PersonEntity> roots,
                                          Map<Long, PersonEntity> membersById,
                                          Map<Long, List<PersonEntity>> childrenByParentId) {
        Set<Long> visited = new LinkedHashSet<>();
        List<PersonEntity> stack = new ArrayList<>(roots == null ? Collections.emptyList() : roots);
        while (!stack.isEmpty()) {
            PersonEntity current = stack.remove(stack.size() - 1);
            if (current == null || current.getId() == null || !membersById.containsKey(current.getId())) {
                continue;
            }
            Long currentId = current.getId();
            if (!visited.add(currentId)) {
                continue;
            }

            PersonEntity spouse = current.getSpouse();
            if (spouse != null && spouse.getId() != null && membersById.containsKey(spouse.getId())) {
                stack.add(spouse);
            }

            List<PersonEntity> children = childrenByParentId.getOrDefault(currentId, Collections.emptyList());
            for (PersonEntity child : children) {
                if (child != null && child.getId() != null && membersById.containsKey(child.getId())) {
                    stack.add(child);
                }
            }
        }
        return visited;
    }

    private boolean hasParentInCollection(PersonEntity member, Map<Long, PersonEntity> membersById) {
        if (member == null || membersById == null || membersById.isEmpty()) {
            return false;
        }
        PersonEntity father = member.getFather();
        if (father != null && father.getId() != null && membersById.containsKey(father.getId())) {
            return true;
        }
        PersonEntity mother = member.getMother();
        return mother != null && mother.getId() != null && membersById.containsKey(mother.getId());
    }

    private Comparator<PersonEntity> personTreeComparator() {
        return (a, b) -> {
            int genA = a.getGeneration() == null ? Integer.MAX_VALUE : a.getGeneration();
            int genB = b.getGeneration() == null ? Integer.MAX_VALUE : b.getGeneration();
            if (genA != genB) {
                return Integer.compare(genA, genB);
            }
            LocalDate dobA = toLocalDate(a.getDob());
            LocalDate dobB = toLocalDate(b.getDob());
            if (dobA != null && dobB != null) {
                int dobCompare = dobA.compareTo(dobB);
                if (dobCompare != 0) {
                    return dobCompare;
                }
            }
            if (dobA == null && dobB != null) {
                return 1;
            }
            if (dobA != null && dobB == null) {
                return -1;
            }
            long idA = a.getId() == null ? Long.MAX_VALUE : a.getId();
            long idB = b.getId() == null ? Long.MAX_VALUE : b.getId();
            return Long.compare(idA, idB);
        };
    }

    private Comparator<PersonEntity> childCreationComparator() {
        return Comparator.comparing(person -> person.getId() == null ? Long.MAX_VALUE : person.getId());
    }

    private PersonDTO toPersonDTO(PersonEntity entity) {
        return toPersonDTO(entity, 0, null, new LinkedHashSet<>());
    }

    private PersonDTO toPersonDTOByBranch(PersonEntity entity, Long branchId, Map<Long, List<PersonEntity>> childrenByParentId) {
        return toPersonDTOByBranch(entity, 0, branchId, new LinkedHashSet<>(), childrenByParentId);
    }

    private PersonDTO toPersonDTO(PersonEntity entity, int level) {
        return toPersonDTO(entity, level, null, new LinkedHashSet<>());
    }

    private PersonDTO toPersonDTO(PersonEntity entity, int level, Long branchId, Set<Long> path) {
        if (entity == null) {
            return null;
        }

        if (level >= MAX_TREE_DEPTH) {
            return buildPersonDtoWithoutChildren(entity, branchId);
        }

        Long entityId = entity.getId();
        if (entityId != null && path.contains(entityId)) {
            return buildPersonDtoWithoutChildren(entity, branchId);
        }

        Set<Long> nextPath = new LinkedHashSet<>(path);
        if (entityId != null) {
            nextPath.add(entityId);
        }

        PersonDTO dto = buildPersonDtoWithoutChildren(entity, branchId);
        dto.setGeneration(level + 1);
        List<PersonEntity> children;
        if (branchId != null) {
            children = personRepository.findChildrenByParentIdAndBranchId(entity.getId(), branchId);
        } else {
            children = personRepository.findChildrenByParentId(entity.getId());
        }
        dto.setChildren(children.stream()
                .filter(child -> child != null && (child.getId() == null || !nextPath.contains(child.getId())))
                .map(child -> toPersonDTO(child, level + 1, branchId, nextPath))
                .collect(Collectors.toList()));
        return dto;
    }

    private PersonDTO toPersonDTOByBranch(PersonEntity entity,
                                          int level,
                                          Long branchId,
                                          Set<Long> path,
                                          Map<Long, List<PersonEntity>> childrenByParentId) {
        if (entity == null) {
            return null;
        }
        if (level >= MAX_TREE_DEPTH) {
            return buildPersonDtoWithoutChildren(entity, branchId);
        }

        Long entityId = entity.getId();
        if (entityId != null && path.contains(entityId)) {
            return buildPersonDtoWithoutChildren(entity, branchId);
        }

        Set<Long> nextPath = new LinkedHashSet<>(path);
        if (entityId != null) {
            nextPath.add(entityId);
        }

        PersonDTO dto = buildPersonDtoWithoutChildren(entity, branchId);
        dto.setGeneration(level + 1);
        List<PersonEntity> children = entityId == null
                ? Collections.emptyList()
                : childrenByParentId.getOrDefault(entityId, Collections.emptyList());
        dto.setChildren(children.stream()
                .filter(child -> child != null && (child.getId() == null || !nextPath.contains(child.getId())))
                .map(child -> toPersonDTOByBranch(child, level + 1, branchId, nextPath, childrenByParentId))
                .collect(Collectors.toList()));
        return dto;
    }

    private PersonDTO findNodeInTree(List<PersonDTO> roots, Long personId) {
        if (roots == null || personId == null) {
            return null;
        }
        for (PersonDTO root : roots) {
            PersonDTO found = findNodeInTree(root, personId);
            if (found != null) {
                return found;
            }
        }
        return null;
    }

    private PersonDTO findNodeInTree(PersonDTO node, Long personId) {
        if (node == null || personId == null) {
            return null;
        }
        if (Objects.equals(node.getId(), personId)) {
            return node;
        }
        List<PersonDTO> children = node.getChildren();
        if (children == null || children.isEmpty()) {
            return null;
        }
        for (PersonDTO child : children) {
            PersonDTO found = findNodeInTree(child, personId);
            if (found != null) {
                return found;
            }
        }
        return null;
    }

    private void flattenTree(List<PersonDTO> roots, List<PersonDTO> out, Set<Long> seen) {
        if (roots == null) {
            return;
        }
        for (PersonDTO root : roots) {
            flattenTree(root, out, seen);
        }
    }

    private void flattenTree(PersonDTO node, List<PersonDTO> out, Set<Long> seen) {
        if (node == null || out == null || seen == null) {
            return;
        }
        Long id = node.getId();
        if (id != null && seen.contains(id)) {
            return;
        }
        if (id != null) {
            seen.add(id);
        }
        out.add(node);
        List<PersonDTO> children = node.getChildren();
        if (children == null || children.isEmpty()) {
            return;
        }
        for (PersonDTO child : children) {
            flattenTree(child, out, seen);
        }
    }

    private String normalizeTextFilter(String raw) {
        if (raw == null) return null;
        String value = Normalizer.normalize(raw.trim().toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('\u0111', 'd');
        return value.isEmpty() ? null : value;
    }

    private Integer normalizeGenerationFilter(Integer generation) {
        if (generation == null || generation <= 0) {
            return null;
        }
        return generation;
    }

    private Integer normalizeYearFilter(Integer year) {
        if (year == null || year <= 0) {
            return null;
        }
        return year;
    }

    private boolean memberMatchesFilters(PersonDTO member,
                                         Integer generation,
                                         String name,
                                         String gender,
                                         String lifeStatus,
                                         Integer birthYearFrom,
                                         Integer birthYearTo) {
        if (member == null) return false;
        boolean selfMatch = matchesProfile(
                member.getFullName(),
                member.getGender(),
                member.getDob(),
                member.getDod(),
                member.getGeneration(),
                generation,
                name,
                gender,
                lifeStatus,
                birthYearFrom,
                birthYearTo
        );
        boolean spouseMatch = matchesProfile(
                member.getSpouseFullName(),
                member.getSpouseGender(),
                member.getSpouseDob(),
                member.getSpouseDod(),
                member.getSpouseGeneration(),
                generation,
                name,
                gender,
                lifeStatus,
                birthYearFrom,
                birthYearTo
        );
        return selfMatch || spouseMatch;
    }

    private boolean matchesProfile(String fullName,
                                   String genderValue,
                                   LocalDate dob,
                                   LocalDate dod,
                                   Integer generationValue,
                                   Integer generationFilter,
                                   String nameFilter,
                                   String genderFilter,
                                   String lifeStatusFilter,
                                   Integer birthYearFrom,
                                   Integer birthYearTo) {
        if (generationFilter != null && !Objects.equals(generationFilter, generationValue)) {
            return false;
        }
        if (nameFilter != null) {
            String nameValue = fullName == null ? "" : normalizeTextFilter(fullName);
            if (nameValue == null) {
                nameValue = "";
            }
            if (!nameValue.contains(nameFilter)) {
                return false;
            }
        }
        if (genderFilter != null) {
            String currentGender = genderValue == null ? "" : genderValue.trim().toLowerCase();
            if (!genderFilter.equals(currentGender)) {
                return false;
            }
        }
        if (lifeStatusFilter != null) {
            boolean isAlive = dod == null;
            if ("alive".equals(lifeStatusFilter) && !isAlive) {
                return false;
            }
            if ("deceased".equals(lifeStatusFilter) && isAlive) {
                return false;
            }
        }
        int birthYear = dob == null ? -1 : dob.getYear();
        if (birthYearFrom != null && (birthYear < 0 || birthYear < birthYearFrom)) {
            return false;
        }
        if (birthYearTo != null && (birthYear < 0 || birthYear > birthYearTo)) {
            return false;
        }
        return true;
    }

    private List<PersonDTO> dedupeAndSortMembersForList(List<PersonDTO> members) {
        normalizeDtoMarriageLinksFlat(members);
        List<PersonDTO> sorted = new ArrayList<>(members == null ? Collections.emptyList() : members);
        sorted.sort((a, b) -> {
            int genA = a.getGeneration() == null ? Integer.MAX_VALUE : a.getGeneration();
            int genB = b.getGeneration() == null ? Integer.MAX_VALUE : b.getGeneration();
            if (genA != genB) {
                return Integer.compare(genA, genB);
            }
            LocalDate dobA = a.getDob();
            LocalDate dobB = b.getDob();
            if (dobA != null && dobB != null) {
                int dobCompare = dobA.compareTo(dobB);
                if (dobCompare != 0) {
                    return dobCompare;
                }
            }
            if (dobA == null && dobB != null) {
                return 1;
            }
            if (dobA != null && dobB == null) {
                return -1;
            }
            long idA = a.getId() == null ? Long.MAX_VALUE : a.getId();
            long idB = b.getId() == null ? Long.MAX_VALUE : b.getId();
            return Long.compare(idA, idB);
        });

        Set<Long> consumed = new LinkedHashSet<>();
        List<PersonDTO> result = new ArrayList<>();
        for (PersonDTO person : sorted) {
            if (person == null || person.getId() == null || consumed.contains(person.getId())) {
                continue;
            }
            result.add(person);
            consumed.add(person.getId());
            if (person.getSpouseId() != null) {
                consumed.add(person.getSpouseId());
            }
        }
        return result;
    }

    private void normalizeDtoMarriageLinks(List<PersonDTO> roots) {
        if (roots == null || roots.isEmpty()) return;
        List<PersonDTO> all = new ArrayList<>();
        flattenTree(roots, all, new LinkedHashSet<>());
        normalizeDtoMarriageLinksFlat(all);
    }

    private void normalizeDtoMarriageLinksFlat(List<PersonDTO> nodes) {
        if (nodes == null || nodes.isEmpty()) return;
        Map<Long, PersonDTO> byId = nodes.stream()
                .filter(Objects::nonNull)
                .filter(item -> item.getId() != null)
                .collect(Collectors.toMap(
                        PersonDTO::getId,
                        item -> item,
                        (left, right) -> left,
                        LinkedHashMap::new
                ));

        Map<Long, List<Long>> claimantsByTarget = new LinkedHashMap<>();
        for (PersonDTO person : byId.values()) {
            if (person == null || person.getId() == null) {
                continue;
            }
            Long spouseId = person.getSpouseId();
            if (spouseId != null && !Objects.equals(spouseId, person.getId()) && byId.containsKey(spouseId)) {
                claimantsByTarget.computeIfAbsent(spouseId, key -> new ArrayList<>()).add(person.getId());
            }
        }

        // Clear only invalid self-link entries.
        for (PersonDTO person : byId.values()) {
            if (person.getId() == null) continue;
            Long spouseId = person.getSpouseId();
            if (spouseId != null && Objects.equals(spouseId, person.getId())) {
                clearSpouseFields(person);
            }
        }

        // Pass 1: synchronize only reciprocal links (A -> B and B -> A).
        for (PersonDTO person : byId.values()) {
            if (person == null || person.getId() == null) continue;
            Long spouseId = person.getSpouseId();
            if (spouseId == null || Objects.equals(spouseId, person.getId())) continue;
            PersonDTO spouse = byId.get(spouseId);
            if (spouse == null || spouse.getId() == null) continue;
            if (Objects.equals(spouse.getSpouseId(), person.getId())) {
                bindSpouseFields(person, spouse);
                bindSpouseFields(spouse, person);
            }
        }

        // Pass 2: fill reverse link only for unique one-way claims.
        for (PersonDTO person : byId.values()) {
            if (person == null || person.getId() == null) continue;
            Long spouseId = person.getSpouseId();
            if (spouseId == null || Objects.equals(spouseId, person.getId())) continue;
            PersonDTO spouse = byId.get(spouseId);
            if (spouse == null || spouse.getId() == null) continue;

            if (spouse.getSpouseId() == null) {
                List<Long> claimants = claimantsByTarget.getOrDefault(spouseId, Collections.emptyList());
                if (claimants.size() == 1 && Objects.equals(claimants.get(0), person.getId())) {
                    bindSpouseFields(spouse, person);
                }
                continue;
            }

            // If spouse points to someone else, do not override either side.
            if (!Objects.equals(spouse.getSpouseId(), person.getId())) {
                continue;
            }
        }
    }

    private FamilyTreeMemberListItemDTO toDirectoryItem(PersonEntity person,
                                                        Map<Long, UserEntity> usersById,
                                                        Map<String, String> educationByExactKey,
                                                        Map<String, String> educationByUniqueName) {
        FamilyTreeMemberListItemDTO item = new FamilyTreeMemberListItemDTO();
        item.setId(person.getId());
        item.setFullName(trimToEmpty(person.getFullName()));
        item.setGeneration(person.getGeneration());
        item.setGender(toVietnameseGender(person.getGender()));
        item.setDateOfBirth(formatDirectoryDate(toLocalDate(person.getDob())));
        item.setDateOfDeath(resolveDodDisplay(toLocalDate(person.getDod()), person.getOtherNote()));
        item.setFatherFullName(person.getFather() != null ? trimToEmpty(person.getFather().getFullName()) : "");
        item.setMotherFullName(person.getMother() != null ? trimToEmpty(person.getMother().getFullName()) : "");
        item.setSpouseFullName(person.getSpouse() != null ? trimToEmpty(person.getSpouse().getFullName()) : "");
        item.setMaritalStatus(person.getSpouse() != null ? "\u0110\u00e3 k\u1ebft h\u00f4n" : "");
        item.setEducation(resolveEducation(person, educationByExactKey, educationByUniqueName));
        item.setBloodType("");
        item.setPhoneNumber(resolvePhoneNumber(person, usersById));
        item.setAddress(resolveAddress(person));
        return item;
    }

    private String resolveEducation(PersonEntity person,
                                    Map<String, String> educationByExactKey,
                                    Map<String, String> educationByUniqueName) {
        String exactKey = buildPersonEducationKey(person);
        String exactValue = exactKey == null ? "" : trimToEmpty(educationByExactKey.get(exactKey));
        if (!exactValue.isEmpty()) {
            return exactValue;
        }
        return trimToEmpty(educationByUniqueName.get(normalizeTextFilter(person.getFullName())));
    }

    private Map<String, String> buildEducationByExactKey(Long familyTreeId) {
        Map<String, LinkedHashSet<String>> valuesByKey = new LinkedHashMap<>();
        for (AcademicProfileEntity profile : academicProfileRepository.findAllByFamilyTreeIdOrderByDegreeNameAscBirthYearAsc(familyTreeId)) {
            String key = buildEducationKey(profile.getFullName(), profile.getBirthYear());
            if (key == null) {
                continue;
            }
            appendEducation(valuesByKey, key, profile.getDegreeName(), profile.getAcademicRank(), profile.getSpecialty());
        }
        return valuesByKey.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, entry -> String.join("; ", entry.getValue()),
                        (left, right) -> left, LinkedHashMap::new));
    }

    private Map<String, String> buildEducationByUniqueName(Long familyTreeId, List<PersonEntity> persons) {
        Map<String, Integer> nameCounts = new LinkedHashMap<>();
        for (PersonEntity person : persons) {
            String normalizedName = normalizeTextFilter(person.getFullName());
            if (normalizedName == null) {
                continue;
            }
            nameCounts.put(normalizedName, nameCounts.getOrDefault(normalizedName, 0) + 1);
        }

        Map<String, LinkedHashSet<String>> valuesByName = new LinkedHashMap<>();
        for (AcademicProfileEntity profile : academicProfileRepository.findAllByFamilyTreeIdOrderByDegreeNameAscBirthYearAsc(familyTreeId)) {
            String normalizedName = normalizeTextFilter(profile.getFullName());
            if (normalizedName == null || nameCounts.getOrDefault(normalizedName, 0) != 1) {
                continue;
            }
            appendEducation(valuesByName, normalizedName, profile.getDegreeName(), profile.getAcademicRank(), profile.getSpecialty());
        }
        for (AwardRecordEntity award : awardRecordRepository.findAllByFamilyTreeIdOrderByAwardYearDescIdDesc(familyTreeId)) {
            String normalizedName = normalizeTextFilter(award.getFullName());
            if (normalizedName == null || nameCounts.getOrDefault(normalizedName, 0) != 1) {
                continue;
            }
            appendEducation(valuesByName, normalizedName, award.getEducationLevel(), null, award.getSchoolName());
        }
        return valuesByName.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, entry -> String.join("; ", entry.getValue()),
                        (left, right) -> left, LinkedHashMap::new));
    }

    private void appendEducation(Map<String, LinkedHashSet<String>> valuesByKey,
                                 String key,
                                 String first,
                                 String second,
                                 String third) {
        if (key == null) {
            return;
        }
        LinkedHashSet<String> values = valuesByKey.computeIfAbsent(key, ignored -> new LinkedHashSet<>());
        appendIfHasText(values, first);
        appendIfHasText(values, second);
        appendIfHasText(values, third);
    }

    private void appendIfHasText(LinkedHashSet<String> values, String value) {
        String normalized = trimToEmpty(value);
        if (!normalized.isEmpty()) {
            values.add(normalized);
        }
    }

    private String buildPersonEducationKey(PersonEntity person) {
        if (person == null) {
            return null;
        }
        LocalDate birthDate = toLocalDate(person.getDob());
        Integer birthYear = birthDate == null ? null : birthDate.getYear();
        return buildEducationKey(person.getFullName(), birthYear);
    }

    private String buildEducationKey(String fullName, Integer birthYear) {
        String normalizedName = normalizeTextFilter(fullName);
        if (normalizedName == null || birthYear == null || birthYear <= 0) {
            return null;
        }
        return normalizedName + "|" + birthYear;
    }

    private String toVietnameseGender(String gender) {
        String normalized = trimToEmpty(gender).toLowerCase();
        if ("male".equals(normalized)) {
            return "Nam";
        }
        if ("female".equals(normalized)) {
            return "N\u1eef";
        }
        if ("other".equals(normalized)) {
            return "Kh\u00e1c";
        }
        return "";
    }

    private String formatDirectoryDate(LocalDate date) {
        return date == null ? "" : DIRECTORY_DATE_FORMAT.format(date);
    }

    private String resolvePhoneNumber(PersonEntity person, Map<Long, UserEntity> usersById) {
        if (person == null || person.getUserId() == null) {
            return "";
        }
        UserEntity user = usersById.get(person.getUserId());
        return user == null ? "" : trimToEmpty(user.getPhone());
    }

    private String resolveAddress(PersonEntity person) {
        String currentResidence = person == null ? "" : trimToEmpty(person.getCurrentResidence());
        if (!currentResidence.isEmpty()) {
            return currentResidence;
        }
        return person == null ? "" : trimToEmpty(person.getHometown());
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private void bindSpouseFields(PersonDTO person, PersonDTO spouse) {
        if (person == null || spouse == null || spouse.getId() == null) {
            return;
        }
        person.setSpouseId(spouse.getId());
        person.setSpouseFullName(spouse.getFullName());
        person.setSpouseGender(spouse.getGender());
        person.setSpouseGeneration(spouse.getGeneration());
        person.setSpouseBranchName(spouse.getBranchName());
        person.setSpouseAvatar(spouse.getAvatar());
        person.setSpouseDob(spouse.getDob());
        person.setSpouseDod(spouse.getDod());
        person.setSpouseHometown(spouse.getHometown());
        person.setSpouseCurrentResidence(spouse.getCurrentResidence());
        person.setSpouseOccupation(spouse.getOccupation());
        person.setSpouseOtherNote(spouse.getOtherNote());
        person.setSpouseDodDisplay(spouse.getDodDisplay());
    }

    private void clearSpouseFields(PersonDTO person) {
        if (person == null) return;
        person.setSpouseId(null);
        person.setSpouseFullName(null);
        person.setSpouseGender(null);
        person.setSpouseGeneration(null);
        person.setSpouseBranchName(null);
        person.setSpouseAvatar(null);
        person.setSpouseDob(null);
        person.setSpouseDod(null);
        person.setSpouseHometown(null);
        person.setSpouseCurrentResidence(null);
        person.setSpouseOccupation(null);
        person.setSpouseOtherNote(null);
        person.setSpouseDodDisplay(null);
    }

    private PersonDTO buildPersonDtoWithoutChildren(PersonEntity entity, Long branchId) {
        PersonDTO dto = new PersonDTO();
        dto.setId(entity.getId());
        dto.setFullName(entity.getFullName());
        dto.setGender(entity.getGender());
        dto.setAvatar(entity.getAvatar());
        dto.setHometown(entity.getHometown());
        dto.setCurrentResidence(entity.getCurrentResidence());
        dto.setOccupation(entity.getOccupation());
        dto.setOtherNote(stripDodDisplayMarker(entity.getOtherNote()));
        dto.setUserId(entity.getUserId());
        dto.setGeneration(entity.getGeneration());
        if (entity.getFather() != null) {
            dto.setFatherId(entity.getFather().getId());
        }
        if (entity.getMother() != null) {
            dto.setMotherId(entity.getMother().getId());
        }
        if (entity.getBranch() != null) {
            dto.setBranch(String.valueOf(entity.getBranch().getId()));
            dto.setBranchName(entity.getBranch().getName());
        }
        dto.setDob(toLocalDate(entity.getDob()));
        dto.setDod(toLocalDate(entity.getDod()));
        dto.setDodDisplay(resolveDodDisplay(dto.getDod(), entity.getOtherNote()));
        if (entity.getSpouse() != null) {
            dto.setSpouseId(entity.getSpouse().getId());
            dto.setSpouseFullName(entity.getSpouse().getFullName());
            dto.setSpouseGender(entity.getSpouse().getGender());
            dto.setSpouseGeneration(entity.getSpouse().getGeneration());
            if (entity.getSpouse().getBranch() != null) {
                dto.setSpouseBranchName(entity.getSpouse().getBranch().getName());
            }
            dto.setSpouseAvatar(entity.getSpouse().getAvatar());
            dto.setSpouseDob(toLocalDate(entity.getSpouse().getDob()));
            dto.setSpouseDod(toLocalDate(entity.getSpouse().getDod()));
            dto.setSpouseDodDisplay(resolveDodDisplay(dto.getSpouseDod(), entity.getSpouse().getOtherNote()));
            dto.setSpouseHometown(entity.getSpouse().getHometown());
            dto.setSpouseCurrentResidence(entity.getSpouse().getCurrentResidence());
            dto.setSpouseOccupation(entity.getSpouse().getOccupation());
            dto.setSpouseOtherNote(stripDodDisplayMarker(entity.getSpouse().getOtherNote()));
        }
        dto.setChildren(new ArrayList<>());
        return dto;
    }

    private PersonDTO buildPersonDetailDto(PersonEntity entity) {
        PersonDTO dto = buildPersonDtoWithoutChildren(entity, null);
        if (entity.getId() == null) {
            return dto;
        }
        List<PersonEntity> children = personRepository.findChildrenByParentId(entity.getId());
        dto.setChildren(children.stream()
                .map(child -> {
                    PersonDTO childDto = new PersonDTO();
                    childDto.setId(child.getId());
                    childDto.setFullName(child.getFullName());
                    childDto.setGender(child.getGender());
                    childDto.setAvatar(child.getAvatar());
                    childDto.setGeneration(child.getGeneration());
                    childDto.setDob(toLocalDate(child.getDob()));
                    childDto.setDod(toLocalDate(child.getDod()));
                    childDto.setDodDisplay(resolveDodDisplay(childDto.getDod(), child.getOtherNote()));
                    return childDto;
                })
                .collect(Collectors.toList()));
        return dto;
    }

    private LocalDate toLocalDate(java.util.Date date) {
        if (date == null) {
            return null;
        }
        if (date instanceof java.sql.Date) {
            return ((java.sql.Date) date).toLocalDate();
        }
        return java.time.Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    private void applyAdditionalFields(PersonEntity person, PersonDTO dto, boolean overwriteNull) {
        if (person == null || dto == null) {
            return;
        }
        String hometown = normalizeOptionalText(dto.getHometown(), MAX_SHORT_TEXT_LENGTH);
        String currentResidence = normalizeOptionalText(dto.getCurrentResidence(), MAX_SHORT_TEXT_LENGTH);
        String occupation = normalizeOptionalText(dto.getOccupation(), MAX_SHORT_TEXT_LENGTH);
        String otherNote = normalizeOptionalText(stripDodDisplayMarker(dto.getOtherNote()), MAX_NOTE_LENGTH);
        String dodDisplay = normalizeDodDisplay(dto.getDodDisplay(), dto.getDod());
        String storedOtherNote = mergeOtherNoteAndDodDisplay(otherNote, dto.getDod() == null ? dodDisplay : null);
        if (overwriteNull || hometown != null) {
            person.setHometown(hometown);
        }
        if (overwriteNull || currentResidence != null) {
            person.setCurrentResidence(currentResidence);
        }
        if (overwriteNull || occupation != null) {
            person.setOccupation(occupation);
        }
        if (overwriteNull || storedOtherNote != null) {
            person.setOtherNote(storedOtherNote);
        }
    }

    private String normalizeOptionalText(String value, int maxLen) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim().replaceAll("\\s+", " ");
        if (trimmed.length() > maxLen) {
            throw new IllegalArgumentException("Nội dung vượt quá độ dài cho phép");
        }
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeDodDisplay(String dodDisplay, LocalDate dod) {
        if (dod != null) {
            return null;
        }
        String normalized = normalizeOptionalText(dodDisplay, 20);
        if (normalized == null) {
            return null;
        }
        if (!isValidPartialDodDisplay(normalized)) {
            throw new IllegalArgumentException("Ngay mat chi nhap theo dang dd/MM hoac yyyy khi chua ro du ngay thang nam");
        }
        return normalized;
    }

    private boolean isValidPartialDodDisplay(String value) {
        if (!PARTIAL_DOD_DISPLAY_PATTERN.matcher(value).matches()) {
            return false;
        }
        if (value.indexOf('/') < 0) {
            return true;
        }
        String[] parts = value.split("/");
        try {
            int day = Integer.parseInt(parts[0]);
            int month = Integer.parseInt(parts[1]);
            MonthDay.of(month, day);
            return true;
        } catch (DateTimeException | NumberFormatException ex) {
            return false;
        }
    }

    private String mergeOtherNoteAndDodDisplay(String otherNote, String dodDisplay) {
        String normalizedNote = normalizeOptionalText(stripDodDisplayMarker(otherNote), MAX_NOTE_LENGTH);
        String normalizedDodDisplay = dodDisplay == null ? null : dodDisplay.trim();
        if (normalizedDodDisplay == null || normalizedDodDisplay.isEmpty()) {
            return normalizedNote;
        }
        String marker = "[[DOD_DISPLAY=" + normalizedDodDisplay + "]]";
        return normalizedNote == null ? marker : normalizedNote + "\n" + marker;
    }

    private String stripDodDisplayMarker(String value) {
        if (value == null) {
            return null;
        }
        String stripped = DOD_DISPLAY_MARKER.matcher(value).replaceAll("");
        stripped = stripped.replaceAll("\\n{3,}", "\n\n").trim();
        return stripped.isEmpty() ? null : stripped;
    }

    private String extractDodDisplay(String value) {
        if (value == null) {
            return null;
        }
        Matcher matcher = DOD_DISPLAY_MARKER.matcher(value);
        if (!matcher.find()) {
            return null;
        }
        String extracted = matcher.group(1);
        return extracted == null ? null : extracted.trim();
    }

    private String resolveDodDisplay(LocalDate dod, String otherNote) {
        if (dod != null) {
            return DIRECTORY_DATE_FORMAT.format(dod);
        }
        String extracted = extractDodDisplay(otherNote);
        return extracted == null ? "" : extracted;
    }

    private String normalizeRequiredFullName(String fullName) {
        String normalized = normalizeOptionalText(fullName, 100);
        if (normalized == null) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }
        if (normalized.contains("<") || normalized.contains(">")) {
            throw new IllegalArgumentException("Họ tên chứa ký tự không hợp lệ");
        }
        return normalized;
    }

    private String normalizeGender(String gender, boolean required) {
        String normalized = normalizeOptionalText(gender, 16);
        if (normalized == null) {
            if (required) {
                throw new IllegalArgumentException("Giới tính không hợp lệ");
            }
            return null;
        }
        normalized = normalized.toLowerCase();
        if (!ALLOWED_GENDERS.contains(normalized)) {
            throw new IllegalArgumentException("Giới tính không hợp lệ");
        }
        return normalized;
    }

    private Integer normalizeGeneration(Integer generation, boolean applyDefaultIfNull) {
        Integer value = generation;
        if (value == null && applyDefaultIfNull) {
            value = 1;
        }
        if (value == null) {
            return null;
        }
        if (value < 1 || value > MAX_GENERATION) {
            throw new IllegalArgumentException("Đời phải nằm trong khoảng 1-" + MAX_GENERATION);
        }
        return value;
    }

    private void validateBirthAndDeathDates(LocalDate dob, LocalDate dod) {
        LocalDate today = LocalDate.now();
        if (dob != null && dob.isAfter(today)) {
            throw new IllegalArgumentException("Ngày sinh không được lớn hơn ngày hiện tại");
        }
        if (dod != null && dod.isAfter(today)) {
            throw new IllegalArgumentException("Ngày mất không được lớn hơn ngày hiện tại");
        }
        if (dob != null && dod != null && dod.isBefore(dob)) {
            throw new IllegalArgumentException("Ngày mất không được nhỏ hơn ngày sinh");
        }
    }

    private void validateChildDatesWithParents(PersonEntity child) {
        if (child == null || child.getDob() == null) {
            return;
        }
        LocalDate childDob = toLocalDate(child.getDob());
        validateBirthAndDeathDates(childDob, toLocalDate(child.getDod()));
        validateChildAgainstParentDates(childDob, child.getFather(), "Cha");
        validateChildAgainstParentDates(childDob, child.getMother(), "Mẹ");
    }

    private void validateChildAgainstParentDates(LocalDate childDob, PersonEntity parent, String parentLabel) {
        if (childDob == null || parent == null) {
            return;
        }
        LocalDate parentDob = toLocalDate(parent.getDob());
        if (parentDob != null && childDob.isBefore(parentDob)) {
            throw new IllegalArgumentException("Ngày sinh của con không hợp lệ với ngày sinh của " + parentLabel.toLowerCase());
        }
        LocalDate parentDod = toLocalDate(parent.getDod());
        if (parentDod != null && childDob.isAfter(parentDod)) {
            throw new IllegalArgumentException("Ngày sinh của con không hợp lệ với ngày mất của " + parentLabel.toLowerCase());
        }
    }

    private BranchEntity resolveBranch(String branchValue, FamilyTreeEntity familyTree) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = familyTree != null
                        ? branchRepository.findByIdAndFamilyTree_Id(branchId, familyTree.getId())
                        : Optional.empty();
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }

        return resolveMainBranch(familyTree);
    }

    private BranchEntity resolveBranchOrDefault(String branchValue, BranchEntity defaultBranch, FamilyTreeEntity familyTree) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = familyTree != null
                        ? branchRepository.findByIdAndFamilyTree_Id(branchId, familyTree.getId())
                        : Optional.empty();
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return defaultBranch != null ? defaultBranch : resolveBranch(null, familyTree);
    }

    private BranchEntity resolveChildBranch(PersonEntity parent, FamilyTreeEntity familyTree) {
        // New child stays in the same branch as parent.
        return resolveBranchOrDefault(null, parent != null ? parent.getBranch() : null, familyTree);
    }

    private boolean isAllowedChildBranch(BranchEntity branch) {
        if (branch == null) {
            return false;
        }
        String branchKey = FamilyTreeBranchUtils.normalizeBranchKey(branch.getName());
        return "main".equals(branchKey) || "1".equals(branchKey) || "2".equals(branchKey);
    }

    private boolean isMainBranch(BranchEntity branch) {
        return branch != null && FamilyTreeBranchUtils.isMainBranchName(branch.getName());
    }

    private BranchEntity createNextNumberedBranch(FamilyTreeEntity familyTree) {
        List<BranchEntity> branches = familyTree == null
                ? new ArrayList<BranchEntity>()
                : branchRepository.findAllByFamilyTree_IdOrderByIdAsc(familyTree.getId());
        int maxIndex = 0;
        Pattern trailingNumber = Pattern.compile("(\\d+)$");
        for (BranchEntity branch : branches) {
            if (branch == null || branch.getName() == null) {
                continue;
            }
            String name = branch.getName().trim();
            Matcher matcher = trailingNumber.matcher(name);
            if (matcher.find()) {
                try {
                    int idx = Integer.parseInt(matcher.group(1));
                    if (idx > maxIndex) {
                        maxIndex = idx;
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }
        BranchEntity newBranch = new BranchEntity();
        newBranch.setFamilyTree(familyTree);
        newBranch.setName(String.valueOf(maxIndex + 1));
        newBranch.setDescription("Tạo tự động khi thêm con của thành viên gốc");
        return branchRepository.save(newBranch);
    }

    private void detachFromBranchIfOrphan(PersonEntity candidate) {
        if (candidate == null || candidate.getId() == null) {
            return;
        }
        long childCount = personRepository.countChildrenByParentId(candidate.getId());
        boolean orphan = candidate.getFather() == null
                && candidate.getMother() == null
                && candidate.getSpouse() == null
                && childCount == 0;
        if (orphan) {
            candidate.setBranch(null);
            candidate.setFamilyTree(null);
            candidate.setGeneration(null);
        }
    }

    private void syncNumberedBranchesAfterTreeChange(FamilyTreeEntity familyTree) {
        if (familyTree == null) {
            return;
        }
        BranchEntity mainBranch = resolveMainBranch(familyTree);
        Long mainBranchId = mainBranch.getId();
        Optional<PersonEntity> rootOpt = personRepository
                .findFirstByBranch_IdAndGenerationOrderByIdAsc(mainBranchId, 1);
        if (!rootOpt.isPresent()) {
            rootOpt = personRepository.findFirstByBranch_IdOrderByGenerationAscIdAsc(mainBranchId);
        }

        Set<Long> usedBranchIds = new LinkedHashSet<>();
        if (rootOpt.isPresent()) {
            List<PersonEntity> rootChildren = personRepository.findChildrenByParentId(rootOpt.get().getId());
            for (PersonEntity child : rootChildren) {
                BranchEntity childBranch = child.getBranch();
                boolean invalidBranch = childBranch == null
                        || Objects.equals(childBranch.getId(), mainBranchId)
                        || usedBranchIds.contains(childBranch.getId());
                if (invalidBranch) {
                    childBranch = createNextNumberedBranch(familyTree);
                    child.setBranch(childBranch);
                    personRepository.save(child);
                }
                usedBranchIds.add(childBranch.getId());
            }
        }

        List<BranchEntity> allBranches = branchRepository.findAllByFamilyTree_IdOrderByIdAsc(familyTree.getId());
        for (BranchEntity branch : allBranches) {
            if (branch == null || branch.getId() == null) {
                continue;
            }
            if (Objects.equals(branch.getId(), mainBranchId)) {
                continue;
            }
            if (usedBranchIds.contains(branch.getId())) {
                continue;
            }
            if (!isNumberedBranch(branch.getName())) {
                continue;
            }
            long membersInBranch = personRepository.countByBranch_Id(branch.getId());
            if (membersInBranch == 0) {
                try {
                    branchRepository.delete(branch);
                } catch (Exception ignored) {
                }
            }
        }
    }

    private boolean isNumberedBranch(String name) {
        if (name == null) {
            return false;
        }
        String value = name.trim();
        if (value.isEmpty()) {
            return false;
        }
        for (int i = 0; i < value.length(); i++) {
            if (!Character.isDigit(value.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private static final class TreeGraph {
        private final Map<Long, PersonEntity> membersById;
        private final Map<Long, List<PersonEntity>> childrenByParentId;
        private final List<PersonEntity> rootCandidates;

        private TreeGraph(Map<Long, PersonEntity> membersById,
                          Map<Long, List<PersonEntity>> childrenByParentId,
                          List<PersonEntity> rootCandidates) {
            this.membersById = membersById;
            this.childrenByParentId = childrenByParentId;
            this.rootCandidates = rootCandidates;
        }
    }

    private BranchEntity resolveMainBranch(FamilyTreeEntity familyTree) {
        if (familyTree == null) {
            throw new IllegalArgumentException("Không tìm thấy cây gia phả đang chọn");
        }
        List<BranchEntity> branches = branchRepository.findAllByFamilyTree_IdOrderByIdAsc(familyTree.getId());
        if (!branches.isEmpty()) {
            branches.sort(Comparator
                    .comparing((BranchEntity branch) -> FamilyTreeBranchUtils.branchOrder(branch.getName()))
                    .thenComparing(branch -> branch.getId() == null ? Long.MAX_VALUE : branch.getId()));
            for (BranchEntity branch : branches) {
                if (isMainBranch(branch)) {
                    return branch;
                }
            }
            return branches.get(0);
        }

        BranchEntity defaultBranch = new BranchEntity();
        defaultBranch.setFamilyTree(familyTree);
        defaultBranch.setName("Chính");
        defaultBranch.setDescription("Chi gốc được tạo tự động");
        return branchRepository.save(defaultBranch);
    }

    private PersonDTO refreshPersonSnapshot(Long personId) {
        if (personId == null) {
            throw new IllegalArgumentException("Không tìm thấy thành viên: null");
        }
        return familyTreeReadService.findPersonById(personId);
    }

    private String expectedSpouseGender(String normalizedPersonGender) {
        if ("male".equals(normalizedPersonGender)) {
            return "female";
        }
        if ("female".equals(normalizedPersonGender)) {
            return "male";
        }
        throw new IllegalArgumentException("Chỉ hỗ trợ thêm vợ/chồng cho thành viên có giới tính nam hoặc nữ");
    }

    private void validateExistingSpouseGender(PersonEntity spouse, String expectedSpouseGender) {
        String spouseGender = spouse.getGender();
        if (spouseGender != null && !spouseGender.trim().isEmpty()) {
            spouseGender = normalizeGender(spouseGender, false);
        }
        if (spouseGender != null && !expectedSpouseGender.equals(spouseGender)) {
            throw new IllegalArgumentException("Giới tính vợ/chồng không phù hợp");
        }
    }

    private void validateRequestedSpouseGender(String requestedGender, String expectedSpouseGender) {
        if (requestedGender == null || requestedGender.trim().isEmpty()) {
            return;
        }
        String normalized = normalizeGender(requestedGender, false);
        if (!expectedSpouseGender.equals(normalized)) {
            throw new IllegalArgumentException("Giới tính vợ/chồng không phù hợp");
        }
    }

    private FamilyTreeEntity resolveEffectiveFamilyTree(Long requestedFamilyTreeId, FamilyTreeEntity defaultFamilyTree) {
        if (requestedFamilyTreeId != null && requestedFamilyTreeId > 0) {
            familyTreeContextService.resolveCurrentFamilyTreeId(requestedFamilyTreeId);
            return familyTreeRepository.findById(requestedFamilyTreeId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cây gia phả đang chọn"));
        }
        if (defaultFamilyTree != null) {
            return defaultFamilyTree;
        }
        Long currentFamilyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        if (currentFamilyTreeId == null) {
            throw new IllegalArgumentException("Không tìm thấy cây gia phả đang chọn");
        }
        return familyTreeRepository.findById(currentFamilyTreeId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cây gia phả đang chọn"));
    }

    private void ensurePersonInCurrentFamilyTree(PersonEntity person) {
        if (person == null) {
            return;
        }
        Long currentFamilyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        Long personFamilyTreeId = person.getFamilyTree() != null ? person.getFamilyTree().getId() : null;
        if (currentFamilyTreeId != null && personFamilyTreeId != null && !Objects.equals(currentFamilyTreeId, personFamilyTreeId)) {
            throw new IllegalArgumentException("Thành viên không thuộc cây gia phả đang chọn");
        }
    }

    private void assertSameFamilyTree(PersonEntity person, FamilyTreeEntity familyTree, String label) {
        if (person == null || familyTree == null || person.getFamilyTree() == null) {
            return;
        }
        if (!Objects.equals(person.getFamilyTree().getId(), familyTree.getId())) {
            throw new IllegalArgumentException(label + " đã thuộc một cây gia phả khác");
        }
    }
}

