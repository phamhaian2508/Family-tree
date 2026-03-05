package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.model.dto.PersonDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.service.IPersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class PersonService implements IPersonService {
    private static final int MAX_TREE_DEPTH = 64;
    private static final int MAX_GENERATION = 50;
    private static final int MAX_SHORT_TEXT_LENGTH = 255;
    private static final int MAX_NOTE_LENGTH = 5000;
    private static final Set<String> ALLOWED_GENDERS =
            Collections.unmodifiableSet(new HashSet<>(Arrays.asList("male", "female", "other")));

    @Autowired
    PersonRepository personRepository;

    @Autowired
    BranchRepository branchRepository;

    @Override
    public void createPerson(PersonDTO personDTO) {
        if (personDTO == null) {
            throw new IllegalArgumentException("Du lieu thanh vien khong hop le");
        }
        if (personDTO.getExistingPersonId() != null) {
            PersonEntity existing = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(personDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Person available not found: " + personDTO.getExistingPersonId()));
            Integer normalizedGeneration = normalizeGeneration(personDTO.getGeneration(), true);
            String normalizedGender = normalizeGender(personDTO.getGender(), false);
            validateBirthAndDeathDates(personDTO.getDob(), personDTO.getDod());
            existing.setBranch(resolveBranchOrDefault(null, existing.getBranch()));
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
            personRepository.save(existing);
            return;
        }
        String normalizedFullName = normalizeRequiredFullName(personDTO.getFullName());
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
        applyAdditionalFields(personEntity, personDTO, true);
        personEntity.setBranch(resolveMainBranch());
        personRepository.save(personEntity);
    }

    @Override
    public long countPersons() {
        return personRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public PersonDTO findPersonById(Long personId) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );
        return buildPersonDetailDto(person);
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
            throw new IllegalArgumentException("Du lieu vo/chong khong hop le");
        }
        if (spouseDTO.getFullName() == null || spouseDTO.getFullName().trim().isEmpty()) {
            if (spouseDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Spouse full name is required");
            }
        }
        PersonEntity person = personRepository.findByIdAndSpouseIsNull(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found or already has spouse: " + personId)
        );
        String normalizedPersonGender = normalizeGender(person.getGender(), true);
        if (!"male".equals(normalizedPersonGender)) {
            throw new IllegalArgumentException("Chi cho phep them vo cho thanh vien nam");
        }

        PersonEntity spouse;
        if (spouseDTO.getExistingPersonId() != null) {
            spouse = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(spouseDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Spouse person is not available"));
            if (Objects.equals(spouse.getId(), person.getId())) {
                throw new IllegalArgumentException("Person cannot be spouse of itself");
            }
            String spouseGender = spouse.getGender() == null ? "" : spouse.getGender().trim().toLowerCase();
            if (!"female".equals(spouseGender)) {
                throw new IllegalArgumentException("Chi duoc phep them vo co gioi tinh nu");
            }
            validateBirthAndDeathDates(toLocalDate(spouse.getDob()), toLocalDate(spouse.getDod()));
            spouse.setGeneration(person.getGeneration());
            spouse.setBranch(resolveBranchOrDefault(null, person.getBranch()));
            if (spouseDTO.getGender() != null && !spouseDTO.getGender().trim().isEmpty()) {
                String inputGender = spouseDTO.getGender().trim().toLowerCase();
                if (!"female".equals(inputGender)) {
                    throw new IllegalArgumentException("Chi duoc phep them vo co gioi tinh nu");
                }
            }
            spouse.setGender("female");
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
            String spouseGender = spouseDTO.getGender() == null ? "" : spouseDTO.getGender().trim().toLowerCase();
            if (!spouseGender.isEmpty() && !"female".equals(spouseGender)) {
                throw new IllegalArgumentException("Chi duoc phep them vo co gioi tinh nu");
            }
            spouse = new PersonEntity();
            spouse.setFullName(normalizedSpouseFullName);
            spouse.setGender("female");
            spouse.setDob(spouseDTO.getDob() == null ? null : java.sql.Date.valueOf(spouseDTO.getDob()));
            spouse.setDod(spouseDTO.getDod() == null ? null : java.sql.Date.valueOf(spouseDTO.getDod()));
            spouse.setGeneration(person.getGeneration());
            spouse.setBranch(resolveBranchOrDefault(null, person.getBranch()));
            spouse.setAvatar(spouseDTO.getAvatar());
            applyAdditionalFields(spouse, spouseDTO, true);
        }
        spouse = personRepository.save(spouse);

        person.setSpouse(spouse);
        spouse.setSpouse(person);
        personRepository.save(person);
        personRepository.save(spouse);

        return toPersonDTO(person);
    }

    @Override
    @Transactional
    public PersonDTO addChild(Long personId, PersonDTO childDTO) {
        if (childDTO == null) {
            throw new IllegalArgumentException("Du lieu con khong hop le");
        }
        if (childDTO.getFullName() == null || childDTO.getFullName().trim().isEmpty()) {
            if (childDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Child full name is required");
            }
        }
        PersonEntity parent = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Parent not found: " + personId)
        );
        if (!isAllowedChildBranch(parent.getBranch())) {
            throw new IllegalArgumentException("Chi duoc phep them con trong chi 1 hoac chi 2");
        }

        PersonEntity child;
        if (childDTO.getExistingPersonId() != null) {
            child = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(childDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Child person is not available"));
            if (Objects.equals(child.getId(), parent.getId())) {
                throw new IllegalArgumentException("Parent cannot be child of itself");
            }
            Integer expectedGeneration = parent.getGeneration() == null ? 1 : parent.getGeneration() + 1;
            child.setGeneration(expectedGeneration);
            child.setBranch(resolveChildBranch(parent));
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
            child.setBranch(resolveChildBranch(parent));
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
        syncNumberedBranchesAfterTreeChange();
        return toPersonDTO(parent);
    }

    @Override
    @Transactional
    public PersonDTO updatePerson(Long personId, PersonDTO personDTO) {
        if (personDTO == null) {
            throw new IllegalArgumentException("Du lieu cap nhat khong hop le");
        }
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );

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
            person.setBranch(resolveBranch(personDTO.getBranch()));
        }
        validateChildDatesWithParents(person);

        personRepository.save(person);
        return toPersonDTO(person);
    }

    @Override
    @Transactional
    public void deletePerson(Long personId) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );
        if (person.getUserId() != null) {
            detachPersonFromTreeAndBranch(person);
            syncNumberedBranchesAfterTreeChange();
            return;
        }

        long childrenCount = personRepository.countChildrenByParentId(personId);
        if (childrenCount > 0) {
            throw new IllegalArgumentException(
                    "Khong the xoa thanh vien nay vi van con. Vui long xoa con truoc, sau do moi xoa cha/me."
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
        syncNumberedBranchesAfterTreeChange();
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
        person.setGeneration(null);
        personRepository.save(person);
    }



    @Override
    @Transactional(readOnly = true)
    public PersonDTO findRootPersonByBranchId(Long branchId) {
        List<PersonDTO> roots = findRootPersonsByBranchId(branchId);
        if (!roots.isEmpty()) {
            return roots.get(0);
        }

        Optional<PersonEntity> optionalEntity =
                personRepository.findFirstByBranch_IdAndGenerationOrderByIdAsc(
                        branchId, 1
                );
        if (!optionalEntity.isPresent()) {
            optionalEntity = personRepository.findFirstByBranch_IdOrderByGenerationAscIdAsc(branchId);
        }
        if (!optionalEntity.isPresent()) {
            return null;
        }
        return toPersonDTOByBranch(optionalEntity.get(), branchId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PersonDTO> findRootPersonsByBranchId(Long branchId) {
        if (branchId == null) {
            return new ArrayList<>();
        }
        return buildBranchTreeRoots(branchId);
    }

    private List<PersonDTO> buildBranchTreeRoots(Long branchId) {
        List<PersonEntity> members = personRepository.findAllByBranchIdWithRelations(branchId);
        if (members == null || members.isEmpty()) {
            return new ArrayList<>();
        }

        Map<Long, PersonEntity> membersById = new LinkedHashMap<>();
        Map<Long, List<PersonEntity>> childrenByParentId = new LinkedHashMap<>();
        for (PersonEntity member : members) {
            if (member == null || member.getId() == null) {
                continue;
            }
            membersById.put(member.getId(), member);
        }
        for (PersonEntity member : membersById.values()) {
            Set<Long> parentIds = new LinkedHashSet<>();
            PersonEntity father = member.getFather();
            if (father != null && father.getId() != null && membersById.containsKey(father.getId())) {
                parentIds.add(father.getId());
            }
            PersonEntity mother = member.getMother();
            if (mother != null && mother.getId() != null && membersById.containsKey(mother.getId())) {
                parentIds.add(mother.getId());
            }
            for (Long parentId : parentIds) {
                childrenByParentId.computeIfAbsent(parentId, key -> new ArrayList<>()).add(member);
            }
        }

        List<PersonEntity> candidates = membersById.values()
                .stream()
                .filter(member -> !hasParentInsideBranch(member, branchId))
                .collect(Collectors.toList());
        if (candidates.isEmpty()) {
            candidates.add(membersById.values().iterator().next());
        }

        List<PersonDTO> roots = new ArrayList<>();
        Set<Long> consumed = new LinkedHashSet<>();
        for (PersonEntity candidate : candidates) {
            if (candidate == null || candidate.getId() == null || consumed.contains(candidate.getId())) {
                continue;
            }
            PersonEntity spouse = candidate.getSpouse();
            if (spouse != null && spouse.getId() != null) {
                if (consumed.contains(spouse.getId())) {
                    continue;
                }
                if (spouse.getBranch() != null
                        && Objects.equals(spouse.getBranch().getId(), branchId)
                        && spouse.getId() < candidate.getId()) {
                    continue;
                }
            }
            roots.add(toPersonDTOByBranch(candidate, branchId, childrenByParentId));
            consumed.add(candidate.getId());
            if (spouse != null && spouse.getId() != null) {
                consumed.add(spouse.getId());
            }
        }

        if (!roots.isEmpty()) {
            return roots;
        }

        PersonEntity fallback = membersById.values().iterator().next();
        roots.add(toPersonDTOByBranch(fallback, branchId, childrenByParentId));
        return roots;
    }

    private boolean hasParentInsideBranch(PersonEntity member, Long branchId) {
        if (member == null || branchId == null) {
            return false;
        }
        PersonEntity father = member.getFather();
        if (father != null && father.getBranch() != null && Objects.equals(father.getBranch().getId(), branchId)) {
            return true;
        }
        PersonEntity mother = member.getMother();
        return mother != null && mother.getBranch() != null && Objects.equals(mother.getBranch().getId(), branchId);
    }

    private PersonDTO toPersonDTO(PersonEntity entity) {
        return toPersonDTO(entity, 0, null, new LinkedHashSet<>());
    }

    private PersonDTO toPersonDTOByBranch(PersonEntity entity, Long branchId) {
        return toPersonDTO(entity, 0, branchId, new LinkedHashSet<>());
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
        List<PersonEntity> children = entityId == null
                ? Collections.emptyList()
                : childrenByParentId.getOrDefault(entityId, Collections.emptyList());
        dto.setChildren(children.stream()
                .filter(child -> child != null && (child.getId() == null || !nextPath.contains(child.getId())))
                .map(child -> toPersonDTOByBranch(child, level + 1, branchId, nextPath, childrenByParentId))
                .collect(Collectors.toList()));
        return dto;
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
        dto.setOtherNote(entity.getOtherNote());
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
        if (entity.getSpouse() != null
                && (branchId == null
                || (entity.getSpouse().getBranch() != null
                && Objects.equals(entity.getSpouse().getBranch().getId(), branchId)))) {
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
            dto.setSpouseHometown(entity.getSpouse().getHometown());
            dto.setSpouseCurrentResidence(entity.getSpouse().getCurrentResidence());
            dto.setSpouseOccupation(entity.getSpouse().getOccupation());
            dto.setSpouseOtherNote(entity.getSpouse().getOtherNote());
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
        String otherNote = normalizeOptionalText(dto.getOtherNote(), MAX_NOTE_LENGTH);
        if (overwriteNull || hometown != null) {
            person.setHometown(hometown);
        }
        if (overwriteNull || currentResidence != null) {
            person.setCurrentResidence(currentResidence);
        }
        if (overwriteNull || occupation != null) {
            person.setOccupation(occupation);
        }
        if (overwriteNull || otherNote != null) {
            person.setOtherNote(otherNote);
        }
    }

    private String normalizeOptionalText(String value, int maxLen) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim().replaceAll("\\s+", " ");
        if (trimmed.length() > maxLen) {
            throw new IllegalArgumentException("Noi dung vuot qua do dai cho phep");
        }
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeRequiredFullName(String fullName) {
        String normalized = normalizeOptionalText(fullName, 100);
        if (normalized == null) {
            throw new IllegalArgumentException("Ho ten khong duoc de trong");
        }
        if (normalized.contains("<") || normalized.contains(">")) {
            throw new IllegalArgumentException("Ho ten chua ky tu khong hop le");
        }
        return normalized;
    }

    private String normalizeGender(String gender, boolean required) {
        String normalized = normalizeOptionalText(gender, 16);
        if (normalized == null) {
            if (required) {
                throw new IllegalArgumentException("Gioi tinh khong hop le");
            }
            return null;
        }
        normalized = normalized.toLowerCase();
        if (!ALLOWED_GENDERS.contains(normalized)) {
            throw new IllegalArgumentException("Gioi tinh khong hop le");
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
            throw new IllegalArgumentException("Doi phai nam trong khoang 1-" + MAX_GENERATION);
        }
        return value;
    }

    private void validateBirthAndDeathDates(LocalDate dob, LocalDate dod) {
        LocalDate today = LocalDate.now();
        if (dob != null && dob.isAfter(today)) {
            throw new IllegalArgumentException("Ngay sinh khong duoc lon hon ngay hien tai");
        }
        if (dod != null && dod.isAfter(today)) {
            throw new IllegalArgumentException("Ngay mat khong duoc lon hon ngay hien tai");
        }
        if (dob != null && dod != null && dod.isBefore(dob)) {
            throw new IllegalArgumentException("Ngay mat khong duoc nho hon ngay sinh");
        }
    }

    private void validateChildDatesWithParents(PersonEntity child) {
        if (child == null || child.getDob() == null) {
            return;
        }
        LocalDate childDob = toLocalDate(child.getDob());
        validateBirthAndDeathDates(childDob, toLocalDate(child.getDod()));
        validateChildAgainstParentDates(childDob, child.getFather(), "Cha");
        validateChildAgainstParentDates(childDob, child.getMother(), "Me");
    }

    private void validateChildAgainstParentDates(LocalDate childDob, PersonEntity parent, String parentLabel) {
        if (childDob == null || parent == null) {
            return;
        }
        LocalDate parentDob = toLocalDate(parent.getDob());
        if (parentDob != null && childDob.isBefore(parentDob)) {
            throw new IllegalArgumentException("Ngay sinh cua con khong hop le voi ngay sinh cua " + parentLabel.toLowerCase());
        }
        LocalDate parentDod = toLocalDate(parent.getDod());
        if (parentDod != null && childDob.isAfter(parentDod)) {
            throw new IllegalArgumentException("Ngay sinh cua con khong hop le voi ngay mat cua " + parentLabel.toLowerCase());
        }
    }

    private BranchEntity resolveBranch(String branchValue) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = branchRepository.findById(branchId);
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }

        return resolveMainBranch();
    }

    private BranchEntity resolveBranchOrDefault(String branchValue, BranchEntity defaultBranch) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = branchRepository.findById(branchId);
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return defaultBranch != null ? defaultBranch : resolveBranch(null);
    }

    private BranchEntity resolveChildBranch(PersonEntity parent) {
        // New child stays in the same branch as parent.
        return resolveBranchOrDefault(null, parent != null ? parent.getBranch() : null);
    }

    private boolean isAllowedChildBranch(BranchEntity branch) {
        if (branch == null || branch.getName() == null) {
            return false;
        }
        String name = branch.getName().trim();
        return "1".equals(name) || "2".equals(name);
    }

    private BranchEntity createNextNumberedBranch() {
        List<BranchEntity> branches = branchRepository.findAll();
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
        newBranch.setName(String.valueOf(maxIndex + 1));
        newBranch.setDescription("Tao tu dong khi them con cua thanh vien goc");
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
            candidate.setGeneration(null);
        }
    }

    private void syncNumberedBranchesAfterTreeChange() {
        BranchEntity mainBranch = resolveMainBranch();
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
                    childBranch = createNextNumberedBranch();
                    child.setBranch(childBranch);
                    personRepository.save(child);
                }
                usedBranchIds.add(childBranch.getId());
            }
        }

        List<BranchEntity> allBranches = branchRepository.findAll();
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

    private BranchEntity resolveMainBranch() {
        Optional<BranchEntity> firstBranch = branchRepository.findFirstByOrderByIdAsc();
        if (firstBranch.isPresent()) {
            return firstBranch.get();
        }

        BranchEntity defaultBranch = new BranchEntity();
        defaultBranch.setName("Chinh");
        defaultBranch.setDescription("Chi goc duoc tao tu dong");
        return branchRepository.save(defaultBranch);
    }
}

