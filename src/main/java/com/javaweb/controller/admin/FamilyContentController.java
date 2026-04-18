package com.javaweb.controller.admin;

import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FamilyContentController {
    private final FamilyTreeContextService familyTreeContextService;

    public FamilyContentController(FamilyTreeContextService familyTreeContextService) {
        this.familyTreeContextService = familyTreeContextService;
    }

    @GetMapping("/admin/family-content/introduction")
    public ModelAndView introductionPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return new ModelAndView("admin/family-tree/introduction");
    }

    @GetMapping("/admin/family-content/contributions")
    public ModelAndView contributionsPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return new ModelAndView("admin/family-tree/contributions");
    }

    @GetMapping("/admin/family-content/awards")
    public ModelAndView awardsPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return new ModelAndView("admin/family-tree/awards");
    }

    @GetMapping("/admin/family-content/academics")
    public ModelAndView academicsPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return new ModelAndView("admin/family-tree/academics");
    }

    @GetMapping("/admin/family-content/news")
    public ModelAndView newsPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return new ModelAndView("admin/family-tree/news");
    }
}
