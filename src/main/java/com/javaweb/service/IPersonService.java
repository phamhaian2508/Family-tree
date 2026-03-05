package com.javaweb.service;

import com.javaweb.model.dto.PersonDTO;

import java.time.LocalDate;
import java.util.List;

public interface IPersonService {
    void createPerson(PersonDTO personDTO);
    long countPersons();
    PersonDTO findPersonById(Long personId);
    PersonDTO findRootPersonByBranchId(Long branchId);
    List<PersonDTO> findRootPersonsByBranchId(Long branchId);
    List<PersonDTO> findAttachablePersonsByBranchId(Long branchId, String fullName, String gender, LocalDate dob);
    PersonDTO addSpouse(Long personId, PersonDTO spouseDTO);
    PersonDTO addChild(Long personId, PersonDTO childDTO);
    PersonDTO updatePerson(Long personId, PersonDTO personDTO);
    void deletePerson(Long personId);
}
