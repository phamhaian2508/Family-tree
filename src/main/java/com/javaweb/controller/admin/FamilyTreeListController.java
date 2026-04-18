package com.javaweb.controller.admin;

import com.javaweb.service.IFamilyTreeService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FamilyTreeListController {
    private final IFamilyTreeService familyTreeService;
    private final FamilyTreeContextService familyTreeContextService;

    public FamilyTreeListController(IFamilyTreeService familyTreeService, FamilyTreeContextService familyTreeContextService) {
        this.familyTreeService = familyTreeService;
        this.familyTreeContextService = familyTreeContextService;
    }

    @GetMapping("/admin/family-trees")
    public ModelAndView familyTreeListPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        ModelAndView mav = new ModelAndView("admin/family-tree/list");
        mav.addObject("familyTreeList", familyTreeService.findAll());
        return mav;
    }
}
