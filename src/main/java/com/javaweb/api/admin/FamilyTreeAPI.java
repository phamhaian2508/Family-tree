package com.javaweb.api.admin;

import com.javaweb.model.dto.FamilyTreeDTO;
import com.javaweb.service.IFamilyTreeService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/family-trees")
public class FamilyTreeAPI {
    private final IFamilyTreeService familyTreeService;
    private final FamilyTreeContextService familyTreeContextService;

    public FamilyTreeAPI(IFamilyTreeService familyTreeService, FamilyTreeContextService familyTreeContextService) {
        this.familyTreeService = familyTreeService;
        this.familyTreeContextService = familyTreeContextService;
    }

    @GetMapping
    public ResponseEntity<List<FamilyTreeDTO>> getAll(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return ResponseEntity.ok(familyTreeService.findAll());
    }

    @PostMapping
    public ResponseEntity<FamilyTreeDTO> create(@RequestBody FamilyTreeDTO familyTreeDTO) {
        return ResponseEntity.ok(familyTreeService.create(familyTreeDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FamilyTreeDTO> update(@PathVariable("id") Long id, @RequestBody FamilyTreeDTO familyTreeDTO) {
        return ResponseEntity.ok(familyTreeService.update(id, familyTreeDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable("id") Long id) {
        familyTreeService.delete(id);
        return ResponseEntity.ok().build();
    }
}
