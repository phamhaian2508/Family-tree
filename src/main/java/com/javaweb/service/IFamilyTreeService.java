package com.javaweb.service;

import com.javaweb.model.dto.FamilyTreeDTO;

import java.util.List;

public interface IFamilyTreeService {
    List<FamilyTreeDTO> findAll();
    FamilyTreeDTO findById(Long id);
    FamilyTreeDTO create(FamilyTreeDTO familyTreeDTO);
    FamilyTreeDTO update(Long id, FamilyTreeDTO familyTreeDTO);
    void delete(Long id);
}
