package com.javaweb.service.impl;

import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.repository.FamilyTreeRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Optional;

@Service
public class FamilyTreeContextService {
    public static final String SESSION_KEY = "ACTIVE_FAMILY_TREE_ID";

    private final FamilyTreeRepository familyTreeRepository;

    public FamilyTreeContextService(FamilyTreeRepository familyTreeRepository) {
        this.familyTreeRepository = familyTreeRepository;
    }

    public Long resolveCurrentFamilyTreeId(Long requestedFamilyTreeId) {
        HttpSession session = getSession();
        Long effectiveId = normalizeExistingId(requestedFamilyTreeId);
        if (effectiveId != null) {
            if (session != null) {
                session.setAttribute(SESSION_KEY, effectiveId);
            }
            return effectiveId;
        }

        if (session != null) {
            Object sessionValue = session.getAttribute(SESSION_KEY);
            if (sessionValue instanceof Long) {
                effectiveId = normalizeExistingId((Long) sessionValue);
                if (effectiveId != null) {
                    return effectiveId;
                }
            }
        }

        effectiveId = familyTreeRepository.findFirstByOrderByIdAsc()
                .map(FamilyTreeEntity::getId)
                .orElse(null);
        if (session != null && effectiveId != null) {
            session.setAttribute(SESSION_KEY, effectiveId);
        }
        return effectiveId;
    }

    public Long getCurrentFamilyTreeId() {
        return resolveCurrentFamilyTreeId(null);
    }

    public FamilyTreeEntity getCurrentFamilyTreeEntity() {
        Long id = getCurrentFamilyTreeId();
        return id == null ? null : familyTreeRepository.findById(id).orElse(null);
    }

    public void clearIfMatches(Long familyTreeId) {
        if (familyTreeId == null) {
            return;
        }
        HttpSession session = getSession();
        if (session == null) {
            return;
        }
        Object sessionValue = session.getAttribute(SESSION_KEY);
        if (sessionValue instanceof Long && familyTreeId.equals(sessionValue)) {
            session.removeAttribute(SESSION_KEY);
        }
    }

    private Long normalizeExistingId(Long familyTreeId) {
        if (familyTreeId == null || familyTreeId <= 0) {
            return null;
        }
        Optional<FamilyTreeEntity> familyTree = familyTreeRepository.findById(familyTreeId);
        return familyTree.map(FamilyTreeEntity::getId).orElse(null);
    }

    private HttpSession getSession() {
        HttpServletRequest request = getRequest();
        return request == null ? null : request.getSession(true);
    }

    private HttpServletRequest getRequest() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attributes == null ? null : attributes.getRequest();
    }
}
