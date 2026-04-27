package com.javaweb.familytree.service;

import com.javaweb.entity.PersonEntity;
import com.javaweb.entity.SpouseRelationEntity;
import com.javaweb.familytree.domain.FamilyMember;
import com.javaweb.familytree.domain.FamilyTreeNode;
import com.javaweb.familytree.domain.ParentChildRelation;
import com.javaweb.familytree.domain.ParentRole;
import com.javaweb.familytree.domain.SpouseRelation;
import com.javaweb.familytree.dto.FamilyTreeAuditIssue;
import com.javaweb.familytree.dto.FamilyTreeAuditReport;
import com.javaweb.model.dto.PersonDTO;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.SpouseRelationRepository;
import com.javaweb.service.impl.FamilyTreeContextService;
import com.javaweb.utils.FamilyTreeBranchUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class FamilyTreeReadService {
    private static final DateTimeFormatter DISPLAY_DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final Pattern DOD_DISPLAY_MARKER = Pattern.compile("\\[\\[DOD_DISPLAY=([^\\]]*)\\]\\]");
    private final PersonRepository personRepository;
    private final SpouseRelationRepository spouseRelationRepository;
    private final FamilyTreeContextService familyTreeContextService;
    private final Map<Long, Dataset> cachedDatasets = new ConcurrentHashMap<>();

    public FamilyTreeReadService(PersonRepository personRepository,
                                 SpouseRelationRepository spouseRelationRepository,
                                 FamilyTreeContextService familyTreeContextService) {
        this.personRepository = personRepository;
        this.spouseRelationRepository = spouseRelationRepository;
        this.familyTreeContextService = familyTreeContextService;
    }

    public void evictCache() {
        cachedDatasets.clear();
    }

    @Transactional(readOnly = true)
    public PersonDTO findPersonById(Long personId) {
        if (personId == null) {
            throw new IllegalArgumentException("Person not found: null");
        }

        Dataset dataset = loadDataset();
        FamilyMember member = dataset.membersById.get(personId);
        if (member == null) {
            throw new IllegalArgumentException("Person not found: " + personId);
        }

        PersonDTO dto = toBasePersonDto(member);
        bindSpouses(dto, resolveNormalizedSpouses(member, dataset));
        bindParents(dto, dataset);
        bindMedia(dto);

        List<PersonDTO> children = dataset.childIdsByParentId
                .getOrDefault(personId, Collections.emptyList())
                .stream()
                .map(dataset.membersById::get)
                .filter(Objects::nonNull)
                .sorted(childMemberComparator())
                .map(this::toBasePersonDto)
                .collect(Collectors.toList());
        dto.setChildren(children);
        dto.setChildrenIds(children.stream()
                .map(PersonDTO::getId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList()));
        return dto;
    }

    @Transactional(readOnly = true)
    public List<PersonDTO> findRootPersonsByBranchId(Long branchId) {
        if (branchId == null) {
            return new ArrayList<>();
        }
        BranchView view = buildBranchView(loadDataset(), branchId);
        return buildRootDtos(view);
    }

    @Transactional(readOnly = true)
    public List<PersonDTO> findMembersByBranchWithFilters(Long branchId,
                                                          Integer generation,
                                                          String fullName,
                                                          String gender,
                                                          String lifeStatus,
                                                          LocalDate dob,
                                                          Integer birthYearFrom,
                                                          Integer birthYearTo,
                                                          Long focusPersonId) {
        if (branchId == null) {
            return new ArrayList<>();
        }

        BranchView view = buildBranchView(loadDataset(), branchId);
        List<PersonDTO> roots = buildRootDtos(view);
        if (roots.isEmpty()) {
            return new ArrayList<>();
        }

        List<PersonDTO> scopedRoots = roots;
        if (focusPersonId != null && focusPersonId > 0) {
            Long anchorId = view.anchorIdByMemberId.get(focusPersonId);
            PersonDTO focusedNode = findNodeInTree(roots, anchorId != null ? anchorId : focusPersonId);
            if (focusedNode != null) {
                scopedRoots = Collections.singletonList(focusedNode);
            }
        }

        List<PersonDTO> members = new ArrayList<>();
        flattenTree(scopedRoots, members, new LinkedHashSet<Long>());

        Integer normalizedGeneration = generation != null && generation > 0 ? generation : null;
        Integer normalizedBirthYearFrom = birthYearFrom != null && birthYearFrom > 0 ? birthYearFrom : null;
        Integer normalizedBirthYearTo = birthYearTo != null && birthYearTo > 0 ? birthYearTo : null;
        String normalizedName = normalizeSearchText(fullName);
        String normalizedGender = normalizeSimpleText(gender);
        String normalizedLifeStatus = normalizeSimpleText(lifeStatus);

        return members.stream()
                .filter(member -> matchesFilters(
                        member,
                        normalizedGeneration,
                        normalizedName,
                        normalizedGender,
                        normalizedLifeStatus,
                        dob,
                        normalizedBirthYearFrom,
                        normalizedBirthYearTo
                ))
                .sorted(personDtoComparator())
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public FamilyTreeAuditReport audit(Long branchId) {
        Dataset dataset = loadDataset();
        Long effectiveBranchId = branchId == null ? 0L : branchId;
        BranchView view = buildBranchView(dataset, effectiveBranchId);

        List<FamilyTreeAuditIssue> scopedIssues = dataset.issues.stream()
                .filter(issue -> appliesToScope(issue, view.scopedMemberIds))
                .sorted(issueComparator())
                .collect(Collectors.toList());

        int errorCount = 0;
        int warningCount = 0;
        int infoCount = 0;
        for (FamilyTreeAuditIssue issue : scopedIssues) {
            if ("ERROR".equalsIgnoreCase(issue.getSeverity())) {
                errorCount++;
            } else if ("WARNING".equalsIgnoreCase(issue.getSeverity())) {
                warningCount++;
            } else {
                infoCount++;
            }
        }

        int scopedParentChildRelations = (int) dataset.parentChildRelations.stream()
                .filter(relation -> view.scopedMemberIds.contains(relation.getChildId())
                        || view.scopedMemberIds.contains(relation.getParentId()))
                .count();
        int scopedSpouseRelations = (int) dataset.spouseRelations.stream()
                .filter(relation -> view.scopedMemberIds.contains(relation.getLeftPersonId())
                        || view.scopedMemberIds.contains(relation.getRightPersonId()))
                .count();

        return new FamilyTreeAuditReport(
                effectiveBranchId,
                dataset.membersById.size(),
                view.scopedMemberIds.size(),
                view.rootAnchorIds.size(),
                scopedParentChildRelations,
                scopedSpouseRelations,
                errorCount,
                warningCount,
                infoCount,
                scopedIssues
        );
    }

    private Dataset loadDataset() {
        Long familyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        if (familyTreeId == null) {
            return emptyDataset();
        }
        Dataset snapshot = cachedDatasets.get(familyTreeId);
        if (snapshot != null) {
            return snapshot;
        }
        synchronized (this) {
            Dataset cached = cachedDatasets.get(familyTreeId);
            if (cached != null) {
                return cached;
            }
            Dataset built = buildDataset(familyTreeId);
            cachedDatasets.put(familyTreeId, built);
            return built;
        }
    }

    private Dataset buildDataset(Long familyTreeId) {
        List<PersonEntity> entities = personRepository.findAllByFamilyTreeIdWithRelations(familyTreeId);
        List<SpouseRelationEntity> spouseRelationEntities = spouseRelationRepository.findAllByFamilyTree_IdOrderByRelationOrderAscIdAsc(familyTreeId);
        Map<Long, FamilyMember> membersById = new LinkedHashMap<>();
        for (PersonEntity entity : entities) {
            if (entity == null || entity.getId() == null) {
                continue;
            }
            FamilyMember member = new FamilyMember(
                    entity.getId(),
                    entity.getBranch() != null ? entity.getBranch().getId() : null,
                    entity.getBranch() != null ? entity.getBranch().getName() : null,
                    entity.getUserId(),
                    normalizeOptionalText(entity.getFullName()),
                    normalizeSimpleText(entity.getGender()),
                    entity.getAvatar(),
                    toLocalDate(entity.getDob()),
                    toLocalDate(entity.getDod()),
                    entity.getGeneration(),
                    normalizeOptionalText(entity.getHometown()),
                    normalizeOptionalText(entity.getCurrentResidence()),
                    normalizeOptionalText(entity.getOccupation()),
                    normalizeOptionalText(entity.getOtherNote()),
                    entity.getFather() != null ? entity.getFather().getId() : null,
                    entity.getMother() != null ? entity.getMother().getId() : null,
                    entity.getSpouse() != null ? entity.getSpouse().getId() : null
            );
            membersById.put(member.getId(), member);
        }

        IssueCollector issueCollector = new IssueCollector();
        List<ParentChildRelation> parentChildRelations = new ArrayList<>();
        Map<Long, LinkedHashSet<Long>> childrenByParentId = new LinkedHashMap<>();

        detectDuplicateMembers(membersById, issueCollector);
        buildParentChildRelations(membersById, parentChildRelations, childrenByParentId, issueCollector);
        SpouseNormalization spouseNormalization = normalizeSpouseRelations(
                membersById,
                spouseRelationEntities,
                issueCollector
        );
        detectLineageCycles(childrenByParentId, issueCollector);

        Map<Long, List<Long>> childIdsByParentId = new LinkedHashMap<>();
        for (Map.Entry<Long, LinkedHashSet<Long>> entry : childrenByParentId.entrySet()) {
            List<Long> childIds = new ArrayList<>(entry.getValue());
            childIds.sort(childIdComparator());
            childIdsByParentId.put(entry.getKey(), childIds);
        }

        return new Dataset(
                membersById,
                childIdsByParentId,
                spouseNormalization.spouseIdsByPersonId,
                spouseNormalization.relationsByPersonId,
                parentChildRelations,
                spouseNormalization.relations,
                issueCollector.toList()
        );
    }

    private Dataset emptyDataset() {
        return new Dataset(
                new LinkedHashMap<Long, FamilyMember>(),
                new LinkedHashMap<Long, List<Long>>(),
                new LinkedHashMap<Long, List<Long>>(),
                new LinkedHashMap<Long, List<SpouseRelation>>(),
                new ArrayList<ParentChildRelation>(),
                new ArrayList<SpouseRelation>(),
                new ArrayList<FamilyTreeAuditIssue>()
        );
    }

    private void buildParentChildRelations(Map<Long, FamilyMember> membersById,
                                           List<ParentChildRelation> relations,
                                           Map<Long, LinkedHashSet<Long>> childrenByParentId,
                                           IssueCollector issueCollector) {
        for (FamilyMember member : membersById.values()) {
            if (member == null || member.getId() == null) {
                continue;
            }
            validateParentReference(member, member.getFatherId(), ParentRole.FATHER, membersById, relations, childrenByParentId, issueCollector);
            validateParentReference(member, member.getMotherId(), ParentRole.MOTHER, membersById, relations, childrenByParentId, issueCollector);
        }
    }

    private void validateParentReference(FamilyMember child,
                                         Long parentId,
                                         ParentRole role,
                                         Map<Long, FamilyMember> membersById,
                                         List<ParentChildRelation> relations,
                                         Map<Long, LinkedHashSet<Long>> childrenByParentId,
                                         IssueCollector issueCollector) {
        if (child == null || child.getId() == null || parentId == null) {
            return;
        }

        if (Objects.equals(child.getId(), parentId)) {
            issueCollector.add(
                    "ERROR",
                    "self_parent_reference",
                    "Member cannot reference itself as " + role.name().toLowerCase(Locale.ROOT),
                    Arrays.asList(child.getId())
            );
            return;
        }

        FamilyMember parent = membersById.get(parentId);
        if (parent == null) {
            issueCollector.add(
                    "ERROR",
                    "orphan_parent_reference",
                    "Parent reference does not exist in person dataset",
                    Arrays.asList(child.getId(), parentId)
            );
            return;
        }

        if (role == ParentRole.FATHER && "female".equals(parent.getGender())) {
            issueCollector.add(
                    "WARNING",
                    "father_gender_mismatch",
                    "Father reference points to a member marked as female",
                    Arrays.asList(child.getId(), parentId)
            );
        }
        if (role == ParentRole.MOTHER && "male".equals(parent.getGender())) {
            issueCollector.add(
                    "WARNING",
                    "mother_gender_mismatch",
                    "Mother reference points to a member marked as male",
                    Arrays.asList(child.getId(), parentId)
            );
        }

        if (child.getGeneration() != null && parent.getGeneration() != null
                && child.getGeneration() <= parent.getGeneration()) {
            issueCollector.add(
                    "WARNING",
                    "generation_conflict",
                    "Child generation is not greater than parent generation",
                    Arrays.asList(parentId, child.getId())
            );
        }

        if (child.getDob() != null && parent.getDob() != null && child.getDob().isBefore(parent.getDob())) {
            issueCollector.add(
                    "WARNING",
                    "birth_before_parent",
                    "Child date of birth is before parent date of birth",
                    Arrays.asList(parentId, child.getId())
            );
        }

        if (child.getDob() != null && parent.getDod() != null && child.getDob().isAfter(parent.getDod())) {
            issueCollector.add(
                    "WARNING",
                    "birth_after_parent_death",
                    "Child date of birth is after parent date of death",
                    Arrays.asList(parentId, child.getId())
            );
        }

        relations.add(new ParentChildRelation(parentId, child.getId(), role));
        childrenByParentId.computeIfAbsent(parentId, ignored -> new LinkedHashSet<>()).add(child.getId());
    }

    private SpouseNormalization normalizeSpouseRelations(Map<Long, FamilyMember> membersById,
                                                         List<SpouseRelationEntity> spouseRelationEntities,
                                                         IssueCollector issueCollector) {
        Map<String, SpouseRelation> relationsByPairKey = new LinkedHashMap<>();
        List<FamilyMember> orderedMembers = new ArrayList<>(membersById.values());
        orderedMembers.sort(memberComparator());

        for (SpouseRelationEntity entity : spouseRelationEntities) {
            if (entity == null) {
                continue;
            }
            Long leftId = entity.getLeftPerson() != null ? entity.getLeftPerson().getId() : null;
            Long rightId = entity.getRightPerson() != null ? entity.getRightPerson().getId() : null;
            addResolvedSpouseRelation(
                    leftId,
                    rightId,
                    entity.getRelationOrder(),
                    normalizeOptionalText(entity.getRelationLabel()),
                    false,
                    relationsByPairKey,
                    membersById,
                    issueCollector
            );
        }

        Map<Long, List<Long>> claimantsByTargetId = new LinkedHashMap<>();
        for (FamilyMember member : orderedMembers) {
            if (member == null || member.getId() == null || member.getSpouseId() == null) {
                continue;
            }
            if (Objects.equals(member.getId(), member.getSpouseId())) {
                issueCollector.add(
                        "ERROR",
                        "self_spouse_reference",
                        "Member cannot reference itself as spouse",
                        Arrays.asList(member.getId())
                );
                continue;
            }
            if (!membersById.containsKey(member.getSpouseId())) {
                issueCollector.add(
                        "ERROR",
                        "orphan_spouse_reference",
                        "Spouse reference does not exist in person dataset",
                        Arrays.asList(member.getId(), member.getSpouseId())
                );
                continue;
            }
            claimantsByTargetId.computeIfAbsent(member.getSpouseId(), ignored -> new ArrayList<>()).add(member.getId());
        }

        for (FamilyMember member : orderedMembers) {
            if (member == null || member.getId() == null || member.getSpouseId() == null) {
                continue;
            }
            Long spouseId = member.getSpouseId();
            FamilyMember spouse = membersById.get(spouseId);
            if (spouse == null) {
                continue;
            }

            boolean reciprocal = Objects.equals(spouse.getSpouseId(), member.getId());
            boolean inferred = spouse.getSpouseId() == null
                    && claimantsByTargetId.getOrDefault(spouseId, Collections.emptyList()).size() == 1
                    && Objects.equals(claimantsByTargetId.get(spouseId).get(0), member.getId());

            if (!reciprocal && !inferred) {
                issueCollector.add(
                        "WARNING",
                        "spouse_link_inconsistent",
                        "Spouse relation is one-way or points to another member",
                        Arrays.asList(member.getId(), spouseId)
                );
                continue;
            }

            addResolvedSpouseRelation(
                    member.getId(),
                    spouseId,
                    null,
                    null,
                    inferred,
                    relationsByPairKey,
                    membersById,
                    issueCollector
            );
        }

        List<SpouseRelation> relations = new ArrayList<>(relationsByPairKey.values());
        relations.sort(Comparator
                .comparing(SpouseRelation::getRelationOrder, Comparator.nullsLast(Integer::compareTo))
                .thenComparing(SpouseRelation::getLeftPersonId, Comparator.nullsLast(Long::compareTo))
                .thenComparing(SpouseRelation::getRightPersonId, Comparator.nullsLast(Long::compareTo)));

        Map<Long, List<Long>> spouseIdsByPersonId = new LinkedHashMap<>();
        Map<Long, List<SpouseRelation>> relationsByPersonId = new LinkedHashMap<>();
        for (SpouseRelation relation : relations) {
            addRelationToPersonIndex(relation.getLeftPersonId(), relation, spouseIdsByPersonId, relationsByPersonId);
            addRelationToPersonIndex(relation.getRightPersonId(), relation, spouseIdsByPersonId, relationsByPersonId);
        }

        for (Map.Entry<Long, List<Long>> entry : spouseIdsByPersonId.entrySet()) {
            entry.getValue().sort(spouseIdComparator(entry.getKey(), relationsByPersonId, membersById));
        }

        return new SpouseNormalization(spouseIdsByPersonId, relationsByPersonId, relations);
    }

    private void detectDuplicateMembers(Map<Long, FamilyMember> membersById, IssueCollector issueCollector) {
        Map<String, List<Long>> groups = new LinkedHashMap<>();
        for (FamilyMember member : membersById.values()) {
            if (member == null || member.getId() == null || member.getFullName() == null) {
                continue;
            }
            if (member.getDob() == null && member.getGeneration() == null) {
                continue;
            }
            String key = normalizeSearchText(member.getFullName())
                    + "|" + String.valueOf(member.getDob())
                    + "|" + String.valueOf(member.getGeneration())
                    + "|" + normalizeSimpleText(member.getGender())
                    + "|" + String.valueOf(member.getBranchId());
            groups.computeIfAbsent(key, ignored -> new ArrayList<>()).add(member.getId());
        }

        for (List<Long> ids : groups.values()) {
            if (ids.size() <= 1) {
                continue;
            }
            List<Long> sortedIds = new ArrayList<>(ids);
            Collections.sort(sortedIds);
            issueCollector.add(
                    "WARNING",
                    "possible_duplicate_member",
                    "Members share the same normalized identity key (name, dob, generation, gender, branch)",
                    sortedIds
            );
        }
    }

    private void detectLineageCycles(Map<Long, LinkedHashSet<Long>> childrenByParentId,
                                     IssueCollector issueCollector) {
        Map<Long, Integer> state = new HashMap<>();
        Deque<Long> path = new ArrayDeque<>();
        List<Long> orderedParents = new ArrayList<>(childrenByParentId.keySet());
        Collections.sort(orderedParents);
        for (Long parentId : orderedParents) {
            detectLineageCyclesFrom(parentId, childrenByParentId, state, path, issueCollector);
        }
    }

    private void detectLineageCyclesFrom(Long memberId,
                                         Map<Long, LinkedHashSet<Long>> childrenByParentId,
                                         Map<Long, Integer> state,
                                         Deque<Long> path,
                                         IssueCollector issueCollector) {
        if (memberId == null || state.containsKey(memberId)) {
            return;
        }

        state.put(memberId, 1);
        path.addLast(memberId);
        for (Long childId : childrenByParentId.getOrDefault(memberId, new LinkedHashSet<Long>())) {
            Integer childState = state.get(childId);
            if (childState != null && childState == 1) {
                issueCollector.add(
                        "ERROR",
                        "lineage_cycle",
                        "Detected lineage loop in parent-child relations",
                        extractCycle(path, childId)
                );
                continue;
            }
            if (childState == null) {
                detectLineageCyclesFrom(childId, childrenByParentId, state, path, issueCollector);
            }
        }
        path.removeLast();
        state.put(memberId, 2);
    }

    private List<Long> extractCycle(Deque<Long> path, Long startId) {
        List<Long> cycle = new ArrayList<>();
        boolean collecting = false;
        for (Long memberId : path) {
            if (Objects.equals(memberId, startId)) {
                collecting = true;
            }
            if (collecting) {
                cycle.add(memberId);
            }
        }
        if (!cycle.isEmpty()) {
            cycle.add(startId);
        }
        return cycle;
    }

    private BranchView buildBranchView(Dataset dataset, Long branchId) {
        Set<Long> scopedMemberIds = dataset.membersById.values().stream()
                .filter(member -> isInScope(member, branchId))
                .map(FamilyMember::getId)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));

        Map<Long, FamilyTreeNode> nodesByAnchorId = new LinkedHashMap<>();
        Map<Long, Long> anchorIdByMemberId = new LinkedHashMap<>();

        List<FamilyMember> scopedMembers = dataset.membersById.values().stream()
                .filter(member -> member != null && scopedMemberIds.contains(member.getId()))
                .sorted(memberComparator())
                .collect(Collectors.toList());

        for (FamilyMember member : scopedMembers) {
            if (anchorIdByMemberId.containsKey(member.getId())) {
                continue;
            }

            List<FamilyMember> componentMembers = collectSpouseComponent(member, dataset, scopedMemberIds);
            FamilyMember primary = choosePrimaryMember(componentMembers, scopedMemberIds);
            List<FamilyMember> spouseMembers = componentMembers.stream()
                    .filter(candidate -> candidate != null && !Objects.equals(candidate.getId(), primary.getId()))
                    .sorted(spouseMemberComparator(primary, dataset))
                    .collect(Collectors.toList());

            nodesByAnchorId.put(primary.getId(), new FamilyTreeNode(primary.getId(), primary, spouseMembers));
            for (FamilyMember componentMember : componentMembers) {
                if (componentMember != null && componentMember.getId() != null) {
                    anchorIdByMemberId.put(componentMember.getId(), primary.getId());
                }
            }
        }

        Map<Long, LinkedHashSet<Long>> childAnchorIdsByParentAnchorId = new LinkedHashMap<>();
        Set<Long> attachedChildAnchors = new LinkedHashSet<>();

        List<FamilyTreeNode> nodes = new ArrayList<>(nodesByAnchorId.values());
        nodes.sort(nodeComparator());
        for (FamilyTreeNode node : nodes) {
            Long parentAnchorId = resolveParentAnchorId(node, anchorIdByMemberId, scopedMemberIds);
            if (parentAnchorId == null || Objects.equals(parentAnchorId, node.getAnchorPersonId())) {
                continue;
            }
            if (wouldCreateAnchorCycle(parentAnchorId, node.getAnchorPersonId(), childAnchorIdsByParentAnchorId)) {
                continue;
            }
            childAnchorIdsByParentAnchorId
                    .computeIfAbsent(parentAnchorId, ignored -> new LinkedHashSet<>())
                    .add(node.getAnchorPersonId());
            attachedChildAnchors.add(node.getAnchorPersonId());
        }

        for (FamilyTreeNode node : nodes) {
            List<Long> childAnchorIds = new ArrayList<>(
                    childAnchorIdsByParentAnchorId.getOrDefault(node.getAnchorPersonId(), new LinkedHashSet<Long>())
            );
            childAnchorIds.sort(childIdComparator());
            node.setChildAnchorIds(childAnchorIds);
        }

        List<Long> rootAnchorIds = nodesByAnchorId.keySet().stream()
                .filter(anchorId -> !attachedChildAnchors.contains(anchorId))
                .sorted(anchorComparator(nodesByAnchorId))
                .collect(Collectors.toList());

        return new BranchView(nodesByAnchorId, anchorIdByMemberId, rootAnchorIds, scopedMemberIds);
    }

    private FamilyMember choosePrimaryMember(List<FamilyMember> members,
                                             Set<Long> scopedMemberIds) {
        return members.stream()
                .filter(Objects::nonNull)
                .min(Comparator
                        .comparingInt((FamilyMember member) -> -lineageScore(member, scopedMemberIds))
                        .thenComparing(member -> !"male".equals(member.getGender()))
                        .thenComparing(member -> member.getGeneration() == null ? Integer.MAX_VALUE : member.getGeneration())
                        .thenComparing(member -> member.getId() == null ? Long.MAX_VALUE : member.getId()))
                .orElseThrow(() -> new IllegalArgumentException("Unable to resolve tree node primary member"));
    }

    private int lineageScore(FamilyMember member, Set<Long> scopedMemberIds) {
        if (member == null) {
            return -1;
        }
        int score = 0;
        if (member.getFatherId() != null && scopedMemberIds.contains(member.getFatherId())) {
            score++;
        }
        if (member.getMotherId() != null && scopedMemberIds.contains(member.getMotherId())) {
            score++;
        }
        return score;
    }

    private Long resolveParentAnchorId(FamilyTreeNode node,
                                       Map<Long, Long> anchorIdByMemberId,
                                       Set<Long> scopedMemberIds) {
        LinkedHashSet<Long> candidateAnchorIds = new LinkedHashSet<>();
        collectParentAnchorIds(node.getPrimaryMember(), anchorIdByMemberId, candidateAnchorIds);
        for (FamilyMember spouseMember : node.getSpouseMembers()) {
            if (spouseMember != null && scopedMemberIds.contains(spouseMember.getId())) {
                collectParentAnchorIds(spouseMember, anchorIdByMemberId, candidateAnchorIds);
            }
        }
        candidateAnchorIds.remove(node.getAnchorPersonId());
        return candidateAnchorIds.isEmpty() ? null : candidateAnchorIds.iterator().next();
    }

    private void collectParentAnchorIds(FamilyMember member,
                                        Map<Long, Long> anchorIdByMemberId,
                                        LinkedHashSet<Long> candidateAnchorIds) {
        if (member == null) {
            return;
        }
        if (member.getFatherId() != null) {
            Long fatherAnchorId = anchorIdByMemberId.get(member.getFatherId());
            if (fatherAnchorId != null) {
                candidateAnchorIds.add(fatherAnchorId);
            }
        }
        if (member.getMotherId() != null) {
            Long motherAnchorId = anchorIdByMemberId.get(member.getMotherId());
            if (motherAnchorId != null) {
                candidateAnchorIds.add(motherAnchorId);
            }
        }
    }

    private boolean wouldCreateAnchorCycle(Long parentAnchorId,
                                           Long childAnchorId,
                                           Map<Long, LinkedHashSet<Long>> childAnchorIdsByParentAnchorId) {
        return isReachable(childAnchorId, parentAnchorId, childAnchorIdsByParentAnchorId, new LinkedHashSet<Long>());
    }

    private boolean isReachable(Long sourceAnchorId,
                                Long targetAnchorId,
                                Map<Long, LinkedHashSet<Long>> childAnchorIdsByParentAnchorId,
                                Set<Long> visited) {
        if (sourceAnchorId == null || targetAnchorId == null || !visited.add(sourceAnchorId)) {
            return false;
        }
        if (Objects.equals(sourceAnchorId, targetAnchorId)) {
            return true;
        }
        for (Long nextAnchorId : childAnchorIdsByParentAnchorId.getOrDefault(sourceAnchorId, new LinkedHashSet<Long>())) {
            if (isReachable(nextAnchorId, targetAnchorId, childAnchorIdsByParentAnchorId, visited)) {
                return true;
            }
        }
        return false;
    }

    private List<PersonDTO> buildRootDtos(BranchView view) {
        List<PersonDTO> roots = new ArrayList<>();
        for (Long rootAnchorId : view.rootAnchorIds) {
            PersonDTO root = buildTreeDto(rootAnchorId, view, new LinkedHashSet<Long>());
            if (root != null) {
                roots.add(root);
            }
        }
        return roots;
    }

    private PersonDTO buildTreeDto(Long anchorPersonId,
                                   BranchView view,
                                   Set<Long> path) {
        if (anchorPersonId == null || !path.add(anchorPersonId)) {
            return null;
        }

        try {
            FamilyTreeNode node = view.nodesByAnchorId.get(anchorPersonId);
            if (node == null || node.getPrimaryMember() == null) {
                return null;
            }

            PersonDTO dto = toBasePersonDto(node.getPrimaryMember());
            bindSpouses(dto, node.getSpouseMembers());

            List<PersonDTO> children = new ArrayList<>();
            for (Long childAnchorId : node.getChildAnchorIds()) {
                PersonDTO child = buildTreeDto(childAnchorId, view, path);
                if (child != null) {
                    children.add(child);
                }
            }
            dto.setChildren(children);
            dto.setChildrenIds(children.stream()
                    .map(PersonDTO::getId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList()));
            return dto;
        } finally {
            path.remove(anchorPersonId);
        }
    }

    private void flattenTree(List<PersonDTO> roots,
                             List<PersonDTO> out,
                             Set<Long> seen) {
        if (roots == null) {
            return;
        }
        for (PersonDTO root : roots) {
            flattenTree(root, out, seen);
        }
    }

    private void flattenTree(PersonDTO person,
                             List<PersonDTO> out,
                             Set<Long> seen) {
        if (person == null || person.getId() == null || !seen.add(person.getId())) {
            return;
        }
        out.add(person);
        for (PersonDTO child : person.getChildren()) {
            flattenTree(child, out, seen);
        }
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

    private PersonDTO findNodeInTree(PersonDTO person, Long personId) {
        if (person == null || personId == null) {
            return null;
        }
        if (Objects.equals(person.getId(), personId)) {
            return person;
        }
        for (PersonDTO child : person.getChildren()) {
            PersonDTO found = findNodeInTree(child, personId);
            if (found != null) {
                return found;
            }
        }
        return null;
    }

    private boolean matchesFilters(PersonDTO member,
                                   Integer generation,
                                   String normalizedName,
                                   String normalizedGender,
                                   String normalizedLifeStatus,
                                   LocalDate exactDob,
                                   Integer birthYearFrom,
                                   Integer birthYearTo) {
        if (member == null) {
            return false;
        }

        if (generation != null) {
            boolean generationMatched = Objects.equals(member.getGeneration(), generation)
                    || member.getSpouses().stream().anyMatch(spouse -> Objects.equals(spouse.getGeneration(), generation));
            if (!generationMatched) {
                return false;
            }
        }

        List<CandidateSnapshot> candidates = new ArrayList<>();
        candidates.add(new CandidateSnapshot(member.getFullName(), member.getGender(), member.getDob(), member.getDod()));
        member.getSpouses().forEach(spouse -> candidates.add(new CandidateSnapshot(
                spouse.getFullName(),
                spouse.getGender(),
                spouse.getDob(),
                spouse.getDod()
        )));

        if (normalizedName != null && !normalizedName.isEmpty()) {
            boolean nameMatched = candidates.stream()
                    .map(CandidateSnapshot::getFullName)
                    .map(this::normalizeSearchText)
                    .anyMatch(name -> name.contains(normalizedName));
            if (!nameMatched) {
                return false;
            }
        }

        if (normalizedGender != null && !normalizedGender.isEmpty()) {
            boolean genderMatched = candidates.stream()
                    .map(CandidateSnapshot::getGender)
                    .map(this::normalizeSimpleText)
                    .anyMatch(normalizedGender::equals);
            if (!genderMatched) {
                return false;
            }
        }

        if (normalizedLifeStatus != null && !normalizedLifeStatus.isEmpty()) {
            boolean lifeStatusMatched = candidates.stream().anyMatch(candidate -> {
                boolean deceased = candidate.getDod() != null;
                if ("alive".equals(normalizedLifeStatus)) {
                    return !deceased;
                }
                if ("deceased".equals(normalizedLifeStatus)) {
                    return deceased;
                }
                return true;
            });
            if (!lifeStatusMatched) {
                return false;
            }
        }

        if (exactDob != null) {
            boolean dobMatched = candidates.stream()
                    .map(CandidateSnapshot::getDob)
                    .filter(Objects::nonNull)
                    .anyMatch(exactDob::equals);
            if (!dobMatched) {
                return false;
            }
        }

        if (birthYearFrom != null) {
            boolean fromMatched = candidates.stream()
                    .map(CandidateSnapshot::getDob)
                    .filter(Objects::nonNull)
                    .map(LocalDate::getYear)
                    .anyMatch(year -> year >= birthYearFrom);
            if (!fromMatched) {
                return false;
            }
        }

        if (birthYearTo != null) {
            boolean toMatched = candidates.stream()
                    .map(CandidateSnapshot::getDob)
                    .filter(Objects::nonNull)
                    .map(LocalDate::getYear)
                    .anyMatch(year -> year <= birthYearTo);
            if (!toMatched) {
                return false;
            }
        }

        return true;
    }

    private PersonDTO toBasePersonDto(FamilyMember member) {
        PersonDTO dto = new PersonDTO();
        dto.setId(member.getId());
        dto.setUserId(member.getUserId());
        dto.setFullName(member.getFullName());
        dto.setGender(member.getGender());
        dto.setAvatar(member.getAvatar());
        dto.setDob(member.getDob());
        dto.setDod(member.getDod());
        dto.setDodDisplay(resolveDodDisplay(member.getDod(), member.getOtherNote()));
        dto.setGeneration(member.getGeneration());
        dto.setHometown(member.getHometown());
        dto.setCurrentResidence(member.getCurrentResidence());
        dto.setOccupation(member.getOccupation());
        dto.setOtherNote(stripDodDisplayMarker(member.getOtherNote()));
        dto.setFatherId(member.getFatherId());
        dto.setMotherId(member.getMotherId());
        dto.setBranch(member.getBranchId() == null ? null : String.valueOf(member.getBranchId()));
        dto.setBranchName(member.getBranchName());
        dto.setSpouses(new ArrayList<PersonDTO>());
        dto.setChildren(new ArrayList<PersonDTO>());
        dto.setChildrenIds(new ArrayList<Long>());
        dto.setMediaUrls(new ArrayList<String>());
        return dto;
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
            return DISPLAY_DATE_FORMAT.format(dod);
        }
        String extracted = extractDodDisplay(otherNote);
        return extracted == null ? "" : extracted;
    }

    private void bindParents(PersonDTO dto, Dataset dataset) {
        if (dto == null || dataset == null) {
            return;
        }
        if (dto.getFatherId() != null) {
            FamilyMember father = dataset.membersById.get(dto.getFatherId());
            if (father != null) {
                dto.setFatherFullName(father.getFullName());
            }
        }
        if (dto.getMotherId() != null) {
            FamilyMember mother = dataset.membersById.get(dto.getMotherId());
            if (mother != null) {
                dto.setMotherFullName(mother.getFullName());
            }
        }
    }

    private void bindMedia(PersonDTO dto) {
        if (dto == null || dto.getId() == null) {
            return;
        }
        personRepository.findByIdWithDetails(dto.getId()).ifPresent(entity -> {
            List<Long> mediaIds = entity.getMedias() == null
                    ? new ArrayList<>()
                    : entity.getMedias().stream()
                    .filter(Objects::nonNull)
                    .map(media -> media.getId())
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
            List<String> mediaUrls = entity.getMedias() == null
                    ? new ArrayList<>()
                    : entity.getMedias().stream()
                    .filter(Objects::nonNull)
                    .map(media -> media.getFileUrl())
                    .filter(Objects::nonNull)
                    .map(String::trim)
                    .filter(url -> !url.isEmpty())
                    .collect(Collectors.toList());
            dto.setMediaIds(mediaIds);
            dto.setMediaUrls(mediaUrls);
        });
    }

    private void bindSpouses(PersonDTO dto, List<FamilyMember> spouses) {
        if (dto == null) {
            return;
        }
        dto.setSpouses(new ArrayList<PersonDTO>());
        if (spouses == null || spouses.isEmpty()) {
            clearPrimarySpouseFields(dto);
            return;
        }

        List<PersonDTO> spouseDtos = spouses.stream()
                .filter(spouse -> spouse != null && spouse.getId() != null)
                .map(spouse -> toSpouseDto(spouse, dto))
                .collect(Collectors.toList());
        dto.setSpouses(spouseDtos);

        PersonDTO primarySpouse = spouseDtos.isEmpty() ? null : spouseDtos.get(0);
        if (primarySpouse == null || primarySpouse.getId() == null) {
            clearPrimarySpouseFields(dto);
            return;
        }

        dto.setSpouseId(primarySpouse.getId());
        dto.setSpouseFullName(primarySpouse.getFullName());
        dto.setSpouseGender(primarySpouse.getGender());
        dto.setSpouseGeneration(primarySpouse.getGeneration());
        dto.setSpouseBranchName(primarySpouse.getBranchName());
        dto.setSpouseAvatar(primarySpouse.getAvatar());
        dto.setSpouseDob(primarySpouse.getDob());
        dto.setSpouseDod(primarySpouse.getDod());
        dto.setSpouseDodDisplay(primarySpouse.getDodDisplay());
        dto.setSpouseHometown(primarySpouse.getHometown());
        dto.setSpouseCurrentResidence(primarySpouse.getCurrentResidence());
        dto.setSpouseOccupation(primarySpouse.getOccupation());
        dto.setSpouseOtherNote(primarySpouse.getOtherNote());
    }

    private void clearPrimarySpouseFields(PersonDTO dto) {
        if (dto == null) {
            return;
        }
        dto.setSpouseId(null);
        dto.setSpouseFullName(null);
        dto.setSpouseGender(null);
        dto.setSpouseGeneration(null);
        dto.setSpouseBranchName(null);
        dto.setSpouseAvatar(null);
        dto.setSpouseDob(null);
        dto.setSpouseDod(null);
        dto.setSpouseDodDisplay(null);
        dto.setSpouseHometown(null);
        dto.setSpouseCurrentResidence(null);
        dto.setSpouseOccupation(null);
        dto.setSpouseOtherNote(null);
    }

    private PersonDTO toSpouseDto(FamilyMember spouse, PersonDTO anchor) {
        PersonDTO dto = toBasePersonDto(spouse);
        dto.setChildren(new ArrayList<PersonDTO>());
        dto.setChildrenIds(new ArrayList<Long>());
        dto.setSpouses(new ArrayList<PersonDTO>());
        if (anchor != null && anchor.getId() != null) {
            dto.setSpouseId(anchor.getId());
            dto.setSpouseFullName(anchor.getFullName());
            dto.setSpouseGender(anchor.getGender());
            dto.setSpouseGeneration(anchor.getGeneration());
            dto.setSpouseBranchName(anchor.getBranchName());
            dto.setSpouseAvatar(anchor.getAvatar());
            dto.setSpouseDob(anchor.getDob());
            dto.setSpouseDod(anchor.getDod());
            dto.setSpouseDodDisplay(anchor.getDodDisplay());
            dto.setSpouseHometown(anchor.getHometown());
            dto.setSpouseCurrentResidence(anchor.getCurrentResidence());
            dto.setSpouseOccupation(anchor.getOccupation());
            dto.setSpouseOtherNote(anchor.getOtherNote());
        } else {
            clearPrimarySpouseFields(dto);
        }
        return dto;
    }

    private List<FamilyMember> resolveNormalizedSpouses(FamilyMember member, Dataset dataset) {
        if (member == null || member.getId() == null) {
            return new ArrayList<>();
        }
        return dataset.spouseIdsByPersonId.getOrDefault(member.getId(), Collections.emptyList())
                .stream()
                .map(dataset.membersById::get)
                .filter(Objects::nonNull)
                .sorted(spouseMemberComparator(member, dataset))
                .collect(Collectors.toList());
    }

    private List<FamilyMember> collectSpouseComponent(FamilyMember seed,
                                                      Dataset dataset,
                                                      Set<Long> scopedMemberIds) {
        if (seed == null || seed.getId() == null) {
            return new ArrayList<>();
        }
        LinkedHashSet<Long> componentIds = new LinkedHashSet<>();
        Deque<Long> queue = new ArrayDeque<>();
        queue.add(seed.getId());

        while (!queue.isEmpty()) {
            Long currentId = queue.removeFirst();
            if (currentId == null || !scopedMemberIds.contains(currentId) || !componentIds.add(currentId)) {
                continue;
            }
            for (Long spouseId : dataset.spouseIdsByPersonId.getOrDefault(currentId, Collections.emptyList())) {
                if (spouseId != null && scopedMemberIds.contains(spouseId) && !componentIds.contains(spouseId)) {
                    queue.addLast(spouseId);
                }
            }
        }

        if (componentIds.isEmpty()) {
            componentIds.add(seed.getId());
        }

        return componentIds.stream()
                .map(dataset.membersById::get)
                .filter(Objects::nonNull)
                .sorted(memberComparator())
                .collect(Collectors.toList());
    }

    private void addResolvedSpouseRelation(Long rawLeftId,
                                           Long rawRightId,
                                           Integer relationOrder,
                                           String relationLabel,
                                           boolean inferred,
                                           Map<String, SpouseRelation> relationsByPairKey,
                                           Map<Long, FamilyMember> membersById,
                                           IssueCollector issueCollector) {
        if (rawLeftId == null || rawRightId == null) {
            return;
        }
        if (Objects.equals(rawLeftId, rawRightId)) {
            issueCollector.add(
                    "ERROR",
                    "self_spouse_reference",
                    "Member cannot reference itself as spouse",
                    Arrays.asList(rawLeftId)
            );
            return;
        }
        if (!membersById.containsKey(rawLeftId) || !membersById.containsKey(rawRightId)) {
            issueCollector.add(
                    "ERROR",
                    "orphan_spouse_reference",
                    "Spouse reference does not exist in person dataset",
                    Arrays.asList(rawLeftId, rawRightId)
            );
            return;
        }

        Long leftId = Math.min(rawLeftId, rawRightId);
        Long rightId = Math.max(rawLeftId, rawRightId);
        String pairKey = spousePairKey(leftId, rightId);
        SpouseRelation existing = relationsByPairKey.get(pairKey);
        if (existing == null) {
            relationsByPairKey.put(pairKey, new SpouseRelation(leftId, rightId, relationOrder, relationLabel, inferred));
            return;
        }

        Integer mergedOrder = existing.getRelationOrder() != null ? existing.getRelationOrder() : relationOrder;
        String mergedLabel = existing.getRelationLabel() != null ? existing.getRelationLabel() : relationLabel;
        relationsByPairKey.put(pairKey, new SpouseRelation(
                leftId,
                rightId,
                mergedOrder,
                mergedLabel,
                existing.isInferred() && inferred
        ));
    }

    private void addRelationToPersonIndex(Long personId,
                                          SpouseRelation relation,
                                          Map<Long, List<Long>> spouseIdsByPersonId,
                                          Map<Long, List<SpouseRelation>> relationsByPersonId) {
        if (personId == null || relation == null) {
            return;
        }
        Long spouseId = Objects.equals(personId, relation.getLeftPersonId())
                ? relation.getRightPersonId()
                : relation.getLeftPersonId();
        if (spouseId == null) {
            return;
        }
        spouseIdsByPersonId.computeIfAbsent(personId, ignored -> new ArrayList<>());
        if (!spouseIdsByPersonId.get(personId).contains(spouseId)) {
            spouseIdsByPersonId.get(personId).add(spouseId);
        }
        relationsByPersonId.computeIfAbsent(personId, ignored -> new ArrayList<>()).add(relation);
    }

    private Comparator<FamilyMember> spouseMemberComparator(FamilyMember anchor, Dataset dataset) {
        return Comparator
                .comparing((FamilyMember spouse) -> spouseRelationOrder(anchor, spouse, dataset), Comparator.nullsLast(Integer::compareTo))
                .thenComparing(memberComparator());
    }

    private Comparator<Long> spouseIdComparator(Long anchorId,
                                                Map<Long, List<SpouseRelation>> relationsByPersonId,
                                                Map<Long, FamilyMember> membersById) {
        FamilyMember anchor = membersById.get(anchorId);
        return Comparator
                .comparing((Long spouseId) -> spouseRelationOrder(anchorId, spouseId, relationsByPersonId), Comparator.nullsLast(Integer::compareTo))
                .thenComparing(spouseId -> membersById.get(spouseId), Comparator.nullsLast(memberComparator()));
    }

    private Integer spouseRelationOrder(FamilyMember anchor, FamilyMember spouse, Dataset dataset) {
        if (anchor == null || spouse == null) {
            return null;
        }
        return spouseRelationOrder(anchor.getId(), spouse.getId(), dataset.spouseRelationsByPersonId);
    }

    private Integer spouseRelationOrder(Long anchorId,
                                        Long spouseId,
                                        Map<Long, List<SpouseRelation>> relationsByPersonId) {
        if (anchorId == null || spouseId == null) {
            return null;
        }
        return relationsByPersonId.getOrDefault(anchorId, Collections.emptyList()).stream()
                .filter(relation -> spousePairContains(relation, anchorId, spouseId))
                .map(SpouseRelation::getRelationOrder)
                .filter(Objects::nonNull)
                .findFirst()
                .orElse(null);
    }

    private boolean spousePairContains(SpouseRelation relation, Long leftId, Long rightId) {
        if (relation == null || leftId == null || rightId == null) {
            return false;
        }
        return (Objects.equals(relation.getLeftPersonId(), leftId) && Objects.equals(relation.getRightPersonId(), rightId))
                || (Objects.equals(relation.getLeftPersonId(), rightId) && Objects.equals(relation.getRightPersonId(), leftId));
    }

    private String spousePairKey(Long leftId, Long rightId) {
        return String.valueOf(leftId) + ":" + String.valueOf(rightId);
    }

    private boolean appliesToScope(FamilyTreeAuditIssue issue, Set<Long> scopedMemberIds) {
        if (issue == null) {
            return false;
        }
        if (issue.getMemberIds().isEmpty()) {
            return true;
        }
        for (Long memberId : issue.getMemberIds()) {
            if (scopedMemberIds.contains(memberId)) {
                return true;
            }
        }
        return false;
    }

    private boolean isInScope(FamilyMember member, Long branchId) {
        if (member == null) {
            return false;
        }
        if (branchId == null || branchId == 0L) {
            return member.getBranchId() != null;
        }
        return Objects.equals(member.getBranchId(), branchId);
    }

    private Comparator<FamilyMember> memberComparator() {
        return Comparator
                .comparing((FamilyMember member) -> branchOrder(member))
                .thenComparing(member -> member.getGeneration() == null ? Integer.MAX_VALUE : member.getGeneration())
                .thenComparing(FamilyMember::getDob, Comparator.nullsLast(LocalDate::compareTo))
                .thenComparing(member -> normalizeSearchText(member.getFullName()))
                .thenComparing(member -> member.getId() == null ? Long.MAX_VALUE : member.getId());
    }

    private Comparator<PersonDTO> personDtoComparator() {
        return Comparator
                .comparing((PersonDTO person) -> branchOrder(person.getBranchName()))
                .thenComparing(person -> person.getGeneration() == null ? Integer.MAX_VALUE : person.getGeneration())
                .thenComparing(PersonDTO::getDob, Comparator.nullsLast(LocalDate::compareTo))
                .thenComparing(person -> normalizeSearchText(person.getFullName()))
                .thenComparing(person -> person.getId() == null ? Long.MAX_VALUE : person.getId());
    }

    private Comparator<Long> anchorComparator(Map<Long, FamilyTreeNode> nodesByAnchorId) {
        return Comparator
                .comparing((Long anchorId) -> {
                    FamilyTreeNode node = nodesByAnchorId.get(anchorId);
                    return node != null ? branchOrder(node.getPrimaryMember()) : Integer.MAX_VALUE;
                })
                .thenComparing(anchorId -> {
                    FamilyTreeNode node = nodesByAnchorId.get(anchorId);
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null && primary.getGeneration() != null ? primary.getGeneration() : Integer.MAX_VALUE;
                })
                .thenComparing(anchorId -> {
                    FamilyTreeNode node = nodesByAnchorId.get(anchorId);
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null ? primary.getDob() : null;
                }, Comparator.nullsLast(LocalDate::compareTo))
                .thenComparing(anchorId -> {
                    FamilyTreeNode node = nodesByAnchorId.get(anchorId);
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null ? normalizeSearchText(primary.getFullName()) : "";
                })
                .thenComparing(anchorId -> anchorId == null ? Long.MAX_VALUE : anchorId);
    }

    private Comparator<FamilyTreeNode> nodeComparator() {
        return Comparator
                .comparing((FamilyTreeNode node) -> branchOrder(node != null ? node.getPrimaryMember() : null))
                .thenComparing(node -> {
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null && primary.getGeneration() != null ? primary.getGeneration() : Integer.MAX_VALUE;
                })
                .thenComparing(node -> {
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null ? primary.getDob() : null;
                }, Comparator.nullsLast(LocalDate::compareTo))
                .thenComparing(node -> {
                    FamilyMember primary = node != null ? node.getPrimaryMember() : null;
                    return primary != null ? normalizeSearchText(primary.getFullName()) : "";
                })
                .thenComparing(node -> node != null && node.getAnchorPersonId() != null ? node.getAnchorPersonId() : Long.MAX_VALUE);
    }

    private Comparator<Long> memberIdComparator(Map<Long, FamilyMember> membersById) {
        return Comparator.comparing(membersById::get, Comparator.nullsLast(memberComparator()));
    }

    private Comparator<FamilyMember> childMemberComparator() {
        return Comparator.comparing(member -> member.getId() == null ? Long.MAX_VALUE : member.getId());
    }

    private Comparator<Long> childIdComparator() {
        return Comparator.nullsLast(Long::compareTo);
    }

    private Comparator<FamilyTreeAuditIssue> issueComparator() {
        return Comparator
                .comparingInt((FamilyTreeAuditIssue issue) -> severityOrder(issue.getSeverity()))
                .thenComparing(FamilyTreeAuditIssue::getCode, Comparator.nullsLast(String::compareTo))
                .thenComparing(issue -> issue.getMemberIds().isEmpty() ? Long.MAX_VALUE : issue.getMemberIds().get(0));
    }

    private int severityOrder(String severity) {
        if ("ERROR".equalsIgnoreCase(severity)) {
            return 0;
        }
        if ("WARNING".equalsIgnoreCase(severity)) {
            return 1;
        }
        return 2;
    }

    private int branchOrder(FamilyMember member) {
        return branchOrder(member != null ? member.getBranchName() : null);
    }

    private int branchOrder(String branchName) {
        return FamilyTreeBranchUtils.branchOrder(branchName);
    }

    private String normalizeOptionalText(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim().replaceAll("\\s+", " ");
        return normalized.isEmpty() ? null : normalized;
    }

    private String normalizeSimpleText(String value) {
        String normalized = normalizeOptionalText(value);
        return normalized == null ? null : normalized.toLowerCase(Locale.ROOT);
    }

    private String normalizeSearchText(String value) {
        String normalized = normalizeOptionalText(value);
        if (normalized == null) {
            return "";
        }
        String folded = Normalizer.normalize(normalized, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D');
        return folded.toLowerCase(Locale.ROOT).trim();
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

    private static final class CandidateSnapshot {
        private final String fullName;
        private final String gender;
        private final LocalDate dob;
        private final LocalDate dod;

        private CandidateSnapshot(String fullName, String gender, LocalDate dob, LocalDate dod) {
            this.fullName = fullName;
            this.gender = gender;
            this.dob = dob;
            this.dod = dod;
        }

        private String getFullName() {
            return fullName;
        }

        private String getGender() {
            return gender;
        }

        private LocalDate getDob() {
            return dob;
        }

        private LocalDate getDod() {
            return dod;
        }
    }

    private static final class Dataset {
        private final Map<Long, FamilyMember> membersById;
        private final Map<Long, List<Long>> childIdsByParentId;
        private final Map<Long, List<Long>> spouseIdsByPersonId;
        private final Map<Long, List<SpouseRelation>> spouseRelationsByPersonId;
        private final List<ParentChildRelation> parentChildRelations;
        private final List<SpouseRelation> spouseRelations;
        private final List<FamilyTreeAuditIssue> issues;

        private Dataset(Map<Long, FamilyMember> membersById,
                        Map<Long, List<Long>> childIdsByParentId,
                        Map<Long, List<Long>> spouseIdsByPersonId,
                        Map<Long, List<SpouseRelation>> spouseRelationsByPersonId,
                        List<ParentChildRelation> parentChildRelations,
                        List<SpouseRelation> spouseRelations,
                        List<FamilyTreeAuditIssue> issues) {
            this.membersById = membersById;
            this.childIdsByParentId = childIdsByParentId;
            this.spouseIdsByPersonId = spouseIdsByPersonId;
            this.spouseRelationsByPersonId = spouseRelationsByPersonId;
            this.parentChildRelations = parentChildRelations;
            this.spouseRelations = spouseRelations;
            this.issues = issues;
        }
    }

    private static final class BranchView {
        private final Map<Long, FamilyTreeNode> nodesByAnchorId;
        private final Map<Long, Long> anchorIdByMemberId;
        private final List<Long> rootAnchorIds;
        private final Set<Long> scopedMemberIds;

        private BranchView(Map<Long, FamilyTreeNode> nodesByAnchorId,
                           Map<Long, Long> anchorIdByMemberId,
                           List<Long> rootAnchorIds,
                           Set<Long> scopedMemberIds) {
            this.nodesByAnchorId = nodesByAnchorId;
            this.anchorIdByMemberId = anchorIdByMemberId;
            this.rootAnchorIds = rootAnchorIds;
            this.scopedMemberIds = scopedMemberIds;
        }
    }

    private static final class SpouseNormalization {
        private final Map<Long, List<Long>> spouseIdsByPersonId;
        private final Map<Long, List<SpouseRelation>> relationsByPersonId;
        private final List<SpouseRelation> relations;

        private SpouseNormalization(Map<Long, List<Long>> spouseIdsByPersonId,
                                    Map<Long, List<SpouseRelation>> relationsByPersonId,
                                    List<SpouseRelation> relations) {
            this.spouseIdsByPersonId = spouseIdsByPersonId;
            this.relationsByPersonId = relationsByPersonId;
            this.relations = relations;
        }
    }

    private static final class IssueCollector {
        private final Map<String, FamilyTreeAuditIssue> issuesByKey = new LinkedHashMap<>();

        private void add(String severity, String code, String message, List<Long> memberIds) {
            List<Long> normalizedIds = memberIds == null ? new ArrayList<Long>() : memberIds.stream()
                    .filter(Objects::nonNull)
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList());
            String key = code + "|" + normalizedIds.toString() + "|" + message;
            issuesByKey.putIfAbsent(key, new FamilyTreeAuditIssue(severity, code, message, normalizedIds));
        }

        private List<FamilyTreeAuditIssue> toList() {
            return new ArrayList<>(issuesByKey.values());
        }
    }
}
