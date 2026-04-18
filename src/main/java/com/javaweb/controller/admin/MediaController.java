package com.javaweb.controller.admin;

import com.javaweb.service.IMediaService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "MediaControllerOfAdmin")
public class MediaController {

    @Autowired
    private IMediaService mediaService;

    @Autowired
    private FamilyTreeContextService familyTreeContextService;

    @GetMapping("/admin/media")
    public ModelAndView mediaPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        ModelAndView mav = new ModelAndView("admin/media/media");
        mav.addObject("albumList", mediaService.findAllAlbumsForAdminView());
        mav.addObject("mediaList", mediaService.findAllMediaForAdminView());
        mav.addObject("branchMap", mediaService.getBranchMap());
        mav.addObject("userMap", mediaService.getUserMap());
        mav.addObject("personMap", mediaService.getPersonMap());
        return mav;
    }
}
