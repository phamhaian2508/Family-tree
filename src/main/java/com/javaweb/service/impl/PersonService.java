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
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class PersonService implements IPersonService {
    private static final int MAX_TREE_DEPTH = 64;

    @Autowired
    PersonRepository personRepository;

    @Autowired
    BranchRepository branchRepository;

    @Override
    public void createPerson(PersonDTO personDTO) {
        if (personDTO.getExistingPersonId() != null) {
            PersonEntity existing = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(personDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Person available not found: " + personDTO.getExistingPersonId()));
            existing.setBranch(resolveBranchOrDefault(null, existing.getBranch()));
            existing.setGeneration(personDTO.getGeneration() != null ? personDTO.getGeneration() : 1);
            if (personDTO.getGender() != null && !personDTO.getGender().trim().isEmpty()) {
                existing.setGender(personDTO.getGender().trim().toLowerCase());
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
        if (personDTO.getFullName() == null || personDTO.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        PersonEntity personEntity = new PersonEntity();
        personEntity.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        personEntity.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        personEntity.setFullName(personDTO.getFullName().trim());
        personEntity.setGeneration(personDTO.getGeneration() != null ? personDTO.getGeneration() : 1);
        personEntity.setGender(personDTO.getGender());
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
        if (spouseDTO.getFullName() == null || spouseDTO.getFullName().trim().isEmpty()) {
            if (spouseDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Spouse full name is required");
            }
        }
        PersonEntity person = personRepository.findByIdAndSpouseIsNull(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found or already has spouse: " + personId)
        );

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
            applyAdditionalFields(spouse, spouseDTO, false);
        } else {
            String spouseGender = spouseDTO.getGender() == null ? "" : spouseDTO.getGender().trim().toLowerCase();
            if (!spouseGender.isEmpty() && !"female".equals(spouseGender)) {
                throw new IllegalArgumentException("Chi duoc phep them vo co gioi tinh nu");
            }
            spouse = new PersonEntity();
            spouse.setFullName(spouseDTO.getFullName());
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
        if (childDTO.getFullName() == null || childDTO.getFullName().trim().isEmpty()) {
            if (childDTO.getExistingPersonId() == null) {
                throw new IllegalArgumentException("Child full name is required");
            }
        }
        PersonEntity parent = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Parent not found: " + personId)
        );

        PersonEntity child;
        if (childDTO.getExistingPersonId() != null) {
            child = personRepository.findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(childDTO.getExistingPersonId())
                    .orElseThrow(() -> new IllegalArgumentException("Child person is not available"));
            if (Objects.equals(child.getId(), parent.getId())) {
                throw new IllegalArgumentException("Parent cannot be child of itself");
            }
            if (child.getGeneration() == null) {
                child.setGeneration(parent.getGeneration() == null ? 1 : parent.getGeneration() + 1);
            }
            child.setBranch(resolveChildBranch(parent));
            if (childDTO.getGender() != null && !childDTO.getGender().trim().isEmpty()) {
                child.setGender(childDTO.getGender());
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
            applyAdditionalFields(child, childDTO, false);
        } else {
            child = new PersonEntity();
            child.setFullName(childDTO.getFullName());
            child.setGender(childDTO.getGender());
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

        personRepository.save(child);
        syncNumberedBranchesAfterTreeChange();
        return toPersonDTO(parent);
    }

    @Override
    @Transactional
    public PersonDTO updatePerson(Long personId, PersonDTO personDTO) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );

        if (personDTO.getFullName() != null && !personDTO.getFullName().trim().isEmpty()) {
            person.setFullName(personDTO.getFullName().trim());
        }
        person.setGender(personDTO.getGender());
        person.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        person.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        if (personDTO.getGeneration() != null) {
            person.setGeneration(personDTO.getGeneration());
        }
        if (personDTO.getAvatar() != null && !personDTO.getAvatar().trim().isEmpty()) {
            person.setAvatar(personDTO.getAvatar());
        }
        applyAdditionalFields(person, personDTO, true);

        if (personDTO.getBranch() != null && !personDTO.getBranch().trim().isEmpty()) {
            person.setBranch(resolveBranch(personDTO.getBranch()));
        }

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

        List<PersonEntity> candidates = personRepository.findRootCandidatesByBranchId(branchId);
        List<PersonDTO> roots = new ArrayList<>();
        Set<Long> consumed = new LinkedHashSet<>();
        for (PersonEntity candidate : candidates) {
            if (candidate == null || candidate.getId() == null) {
                continue;
            }
            if (consumed.contains(candidate.getId())) {
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
                    // Keep only one root per spouse pair in the same branch (lower id).
                    continue;
                }
            }
            roots.add(toPersonDTOByBranch(candidate, branchId));
            consumed.add(candidate.getId());
            if (spouse != null && spouse.getId() != null) {
                consumed.add(spouse.getId());
            }
        }

        if (!roots.isEmpty()) {
            return roots;
        }

        Optional<PersonEntity> fallback = personRepository.findFirstByBranch_IdOrderByGenerationAscIdAsc(branchId);
        if (!fallback.isPresent()) {
            return new ArrayList<>();
        }
        roots.add(toPersonDTOByBranch(fallback.get(), branchId));
        return roots;
    }

    private PersonDTO toPersonDTO(PersonEntity entity) {
        return toPersonDTO(entity, 0, null, new LinkedHashSet<>());
    }

    private PersonDTO toPersonDTOByBranch(PersonEntity entity, Long branchId) {
        return toPersonDTO(entity, 0, branchId, new LinkedHashSet<>());
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
        String hometown = normalizeOptionalText(dto.getHometown());
        String currentResidence = normalizeOptionalText(dto.getCurrentResidence());
        String occupation = normalizeOptionalText(dto.getOccupation());
        String otherNote = normalizeOptionalText(dto.getOtherNote());
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

    private String normalizeOptionalText(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
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
        // Child of root member starts a new branch sequence: 1, 2, 3, ...
        if (parent != null && parent.getGeneration() != null && parent.getGeneration() <= 1) {
            return createNextNumberedBranch();
        }
        return resolveBranchOrDefault(null, parent != null ? parent.getBranch() : null);
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

