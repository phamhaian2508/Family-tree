package com.javaweb.api.admin;

import com.javaweb.model.dto.BranchDTO;
import com.javaweb.service.IBranchService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/branch")
public class BranchAPI {
    private final IBranchService iBranchService;
    private final FamilyTreeContextService familyTreeContextService;

    public BranchAPI(IBranchService iBranchService, FamilyTreeContextService familyTreeContextService) {
        this.iBranchService = iBranchService;
        this.familyTreeContextService = familyTreeContextService;
    }

    @GetMapping
    public ResponseEntity<List<BranchDTO>> getBranches(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return ResponseEntity.ok(iBranchService.findAllBranches());
    }

    @PostMapping
    public ResponseEntity<BranchDTO> createBranch(@RequestBody BranchDTO branchDTO) {
        familyTreeContextService.resolveCurrentFamilyTreeId(branchDTO != null ? branchDTO.getFamilyTreeId() : null);
        return ResponseEntity.ok(iBranchService.createBranch(branchDTO));
    }
}
