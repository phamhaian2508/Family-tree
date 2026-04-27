package com.javaweb.service;

import com.javaweb.model.dto.FamilyTreeMemberListItemDTO;
import com.javaweb.model.dto.PersonDTO;

import java.time.LocalDate;
import java.util.List;

public interface IPersonService {
    PersonDTO createPerson(PersonDTO personDTO);
    long countPersons();
    PersonDTO findPersonById(Long personId);
    List<PersonDTO> findRootPersonsByBranchId(Long branchId);
    List<PersonDTO> findMembersByBranchWithFilters(Long branchId,
                                                   Integer generation,
                                                   String fullName,
                                                   String gender,
                                                   String lifeStatus,
                                                   Integer birthYearFrom,
                                                   Integer birthYearTo,
                                                   Long focusPersonId);
    List<PersonDTO> findAttachablePersonsByBranchId(Long branchId, String fullName, String gender, LocalDate dob);
    PersonDTO addSpouse(Long personId, PersonDTO spouseDTO);
    PersonDTO addChild(Long personId, PersonDTO childDTO);
    PersonDTO updatePerson(Long personId, PersonDTO personDTO);
    void deletePerson(Long personId);
    List<FamilyTreeMemberListItemDTO> findMemberDirectory(Long familyTreeId);
}
