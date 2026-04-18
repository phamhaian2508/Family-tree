package com.javaweb.service.impl;

import com.javaweb.converter.BranchConverter;
import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.model.dto.BranchDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.FamilyTreeRepository;
import com.javaweb.service.IBranchService;
import com.javaweb.utils.FamilyTreeBranchUtils;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BranchService implements IBranchService {

    private final BranchRepository branchRepository;
    private final FamilyTreeRepository familyTreeRepository;
    private final FamilyTreeContextService familyTreeContextService;

    private final BranchConverter branchConverter;

    public BranchService(BranchRepository branchRepository,
                         FamilyTreeRepository familyTreeRepository,
                         FamilyTreeContextService familyTreeContextService,
                         BranchConverter branchConverter) {
        this.branchRepository = branchRepository;
        this.familyTreeRepository = familyTreeRepository;
        this.familyTreeContextService = familyTreeContextService;
        this.branchConverter = branchConverter;
    }

    @Override
    public BranchDTO createBranch(BranchDTO branchDTO) {
        Long familyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(branchDTO != null ? branchDTO.getFamilyTreeId() : null);
        FamilyTreeEntity familyTree = familyTreeId == null ? null : familyTreeRepository.findById(familyTreeId).orElse(null);
        if (familyTree == null) {
            throw new IllegalArgumentException("Khong tim thay cay gia pha dang chon");
        }
        BranchEntity branchEntity = branchConverter.convertToEntity(branchDTO);
        branchEntity.setFamilyTree(familyTree);
        BranchDTO dto = branchConverter.convertToDto(branchRepository.save(branchEntity));
        dto.setFamilyTreeId(familyTree.getId());
        return dto;
    }

    @Override
    public List<BranchDTO> findAllBranches() {
        Long familyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        if (familyTreeId == null) {
            return java.util.Collections.emptyList();
        }
        return branchRepository.findAllByFamilyTree_IdOrderByIdAsc(familyTreeId)
                .stream()
                .map(branch -> {
                    BranchDTO dto = branchConverter.convertToDto(branch);
                    dto.setFamilyTreeId(branch.getFamilyTree() != null ? branch.getFamilyTree().getId() : null);
                    return dto;
                })
                .sorted(Comparator
                        .comparing((BranchDTO branch) -> FamilyTreeBranchUtils.branchOrder(branch.getName()))
                        .thenComparing(branch -> {
                            String name = branch.getName();
                            return name == null ? "" : name.trim().toLowerCase();
                        })
                        .thenComparing(branch -> branch.getId() == null ? Long.MAX_VALUE : branch.getId()))
                .collect(Collectors.toList());
    }
}
