package com.javaweb.service.impl;

import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.entity.FamilyTreeScopedEntity;
import com.javaweb.repository.FamilyTreeRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
public class FamilyContentScopeService {
    private final FamilyTreeContextService familyTreeContextService;
    private final FamilyTreeRepository familyTreeRepository;

    public FamilyContentScopeService(FamilyTreeContextService familyTreeContextService, FamilyTreeRepository familyTreeRepository) {
        this.familyTreeContextService = familyTreeContextService;
        this.familyTreeRepository = familyTreeRepository;
    }

    public Long requireCurrentFamilyTreeId() {
        Long familyTreeId = familyTreeContextService.getCurrentFamilyTreeId();
        if (familyTreeId == null || familyTreeId <= 0) {
            throw new ResponseStatusException(BAD_REQUEST, "Chua chon cay gia pha");
        }
        return familyTreeId;
    }

    public Long resolveFamilyTreeId(Long requestedFamilyTreeId) {
        Long familyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null || familyTreeId <= 0) {
            return null;
        }
        return familyTreeId;
    }

    public FamilyTreeEntity requireCurrentFamilyTree() {
        Long familyTreeId = requireCurrentFamilyTreeId();
        return familyTreeRepository.findById(familyTreeId)
                .orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay cay gia pha"));
    }

    public FamilyTreeEntity requireFamilyTree(Long requestedFamilyTreeId) {
        Long familyTreeId = resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            throw new ResponseStatusException(BAD_REQUEST, "Chua chon cay gia pha");
        }
        return familyTreeRepository.findById(familyTreeId)
                .orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay cay gia pha"));
    }

    public <T extends FamilyTreeScopedEntity> T attachCurrentFamilyTree(T entity) {
        entity.setFamilyTree(requireCurrentFamilyTree());
        return entity;
    }

    public <T extends FamilyTreeScopedEntity> T requireOwned(T entity) {
        Long familyTreeId = requireCurrentFamilyTreeId();
        if (entity == null || entity.getFamilyTree() == null || entity.getFamilyTree().getId() == null) {
            throw new ResponseStatusException(NOT_FOUND, "Khong tim thay du lieu");
        }
        if (!familyTreeId.equals(entity.getFamilyTree().getId())) {
            throw new ResponseStatusException(NOT_FOUND, "Du lieu khong thuoc cay gia pha hien tai");
        }
        return entity;
    }
}
