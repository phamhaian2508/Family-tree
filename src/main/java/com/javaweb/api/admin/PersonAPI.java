package com.javaweb.api.admin;

import com.javaweb.familytree.dto.FamilyTreeAuditReport;
import com.javaweb.familytree.service.FamilyTreeReadService;
import com.javaweb.model.dto.PersonDTO;
import com.javaweb.service.IPersonService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.time.LocalDate;

@RestController
@RequestMapping("/api/person")
public class PersonAPI {
    private final IPersonService iPersonService;
    private final FamilyTreeReadService familyTreeReadService;
    private final FamilyTreeContextService familyTreeContextService;

    public PersonAPI(IPersonService iPersonService,
                     FamilyTreeReadService familyTreeReadService,
                     FamilyTreeContextService familyTreeContextService) {
        this.iPersonService = iPersonService;
        this.familyTreeReadService = familyTreeReadService;
        this.familyTreeContextService = familyTreeContextService;
    }
    @PostMapping
    public ResponseEntity<?> createPerson(@RequestBody PersonDTO personDTO) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(personDTO != null ? personDTO.getFamilyTreeId() : null);
            return ResponseEntity.ok(iPersonService.createPerson(personDTO));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/count")
    public ResponseEntity<Long> countPersons(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return ResponseEntity.ok(iPersonService.countPersons());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPersonById(@PathVariable("id") Long personId,
                                           @RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
            return ResponseEntity.ok(familyTreeReadService.findPersonById(personId));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/available")
    public ResponseEntity<List<PersonDTO>> findAvailablePersons(
            @RequestParam(value = "branchId") Long branchId,
            @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam(value = "dob", required = false) String dob
    ) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        LocalDate dobValue = null;
        try {
            if (dob != null && !dob.trim().isEmpty()) {
                dobValue = LocalDate.parse(dob.trim());
            }
        } catch (Exception ex) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(iPersonService.findAttachablePersonsByBranchId(branchId, fullName, gender, dobValue));
    }

    @GetMapping("/roots")
    public ResponseEntity<List<PersonDTO>> getRootPersons(
            @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
            @RequestParam(value = "branchId", defaultValue = "0") Long branchId
    ) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return ResponseEntity.ok(familyTreeReadService.findRootPersonsByBranchId(branchId));
    }

    @GetMapping("/members")
    public ResponseEntity<List<PersonDTO>> getMembersByFilters(
            @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
            @RequestParam(value = "branchId", defaultValue = "0") Long branchId,
            @RequestParam(value = "generation", required = false) Integer generation,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam(value = "lifeStatus", required = false) String lifeStatus,
            @RequestParam(value = "dob", required = false) String dob,
            @RequestParam(value = "birthYearFrom", required = false) Integer birthYearFrom,
            @RequestParam(value = "birthYearTo", required = false) Integer birthYearTo,
            @RequestParam(value = "focusPersonId", required = false) Long focusPersonId
    ) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        LocalDate dobValue = null;
        try {
            if (dob != null && !dob.trim().isEmpty()) {
                dobValue = LocalDate.parse(dob.trim());
            }
        } catch (Exception ex) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(familyTreeReadService.findMembersByBranchWithFilters(
                branchId, generation, name, gender, lifeStatus, dobValue, birthYearFrom, birthYearTo, focusPersonId
        ));
    }

    @GetMapping("/audit")
    public ResponseEntity<FamilyTreeAuditReport> auditFamilyTree(
            @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
            @RequestParam(value = "branchId", defaultValue = "0") Long branchId
    ) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        return ResponseEntity.ok(familyTreeReadService.audit(branchId));
    }

    @PostMapping("/{id}/spouse")
    public ResponseEntity<?> addSpouse(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO spouseDTO
    ) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(spouseDTO != null ? spouseDTO.getFamilyTreeId() : null);
            return ResponseEntity.ok(iPersonService.addSpouse(personId, spouseDTO));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @PostMapping("/{id}/child")
    public ResponseEntity<?> addChild(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO childDTO
    ) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(childDTO != null ? childDTO.getFamilyTreeId() : null);
            return ResponseEntity.ok(iPersonService.addChild(personId, childDTO));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePerson(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO personDTO
    ) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(personDTO != null ? personDTO.getFamilyTreeId() : null);
            return ResponseEntity.ok(iPersonService.updatePerson(personId, personDTO));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePerson(@PathVariable("id") Long personId,
                                          @RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
            iPersonService.deletePerson(personId);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }
}
