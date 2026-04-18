package com.javaweb.controller.admin;

import com.javaweb.model.dto.FamilyTreeDTO;
import com.javaweb.service.IFamilyTreeService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@ControllerAdvice(basePackages = "com.javaweb.controller.admin")
public class AdminFamilyTreeAdvice {
    private final FamilyTreeContextService familyTreeContextService;
    private final IFamilyTreeService familyTreeService;

    public AdminFamilyTreeAdvice(FamilyTreeContextService familyTreeContextService, IFamilyTreeService familyTreeService) {
        this.familyTreeContextService = familyTreeContextService;
        this.familyTreeService = familyTreeService;
    }

    @ModelAttribute("currentFamilyTreeId")
    public Long currentFamilyTreeId(HttpServletRequest request) {
        return familyTreeContextService.resolveCurrentFamilyTreeId(readFamilyTreeId(request));
    }

    @ModelAttribute("currentFamilyTreeName")
    public String currentFamilyTreeName(HttpServletRequest request) {
        FamilyTreeDTO current = currentFamilyTree(request);
        return current != null ? current.getName() : "Chua chon gia pha";
    }

    @ModelAttribute("currentFamilyTreeDescription")
    public String currentFamilyTreeDescription(HttpServletRequest request) {
        FamilyTreeDTO current = currentFamilyTree(request);
        return current != null ? current.getDescription() : "";
    }

    private FamilyTreeDTO currentFamilyTree(HttpServletRequest request) {
        Long familyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(readFamilyTreeId(request));
        if (familyTreeId == null) {
            return null;
        }
        List<FamilyTreeDTO> familyTrees = familyTreeService.findAll();
        for (FamilyTreeDTO familyTree : familyTrees) {
            if (familyTree != null && familyTree.getId() != null && familyTree.getId().equals(familyTreeId)) {
                return familyTree;
            }
        }
        return null;
    }

    private Long readFamilyTreeId(HttpServletRequest request) {
        if (request == null) {
            return null;
        }
        String value = request.getParameter("familyTreeId");
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }
}
