package com.javaweb.controller.admin;

import com.javaweb.repository.PersonRepository;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "FamilytreeControllerOfAdmin")
public class FamilytreeController {
    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private FamilyTreeContextService familyTreeContextService;

    @RequestMapping(value = "/admin/familytree", method = RequestMethod.GET)
    public ModelAndView familytreePage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        Long currentFamilyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        ModelAndView mav = new ModelAndView("admin/family-tree/familytree");
        long totalMembers = currentFamilyTreeId == null ? 0 : personRepository.countByFamilyTree_IdAndBranchIsNotNull(currentFamilyTreeId);
        Integer maxGeneration = currentFamilyTreeId == null ? 0 : personRepository.findMaxGenerationByFamilyTreeIdAndBranchIsNotNull(currentFamilyTreeId);
        int totalGenerations = (maxGeneration == null || maxGeneration <= 0) ? 1 : maxGeneration;
        mav.addObject("totalMembers", totalMembers);
        mav.addObject("totalGenerations", totalGenerations);
        return mav;
    }
}
