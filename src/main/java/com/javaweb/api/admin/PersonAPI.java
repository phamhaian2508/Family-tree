package com.javaweb.api.admin;

import com.javaweb.model.dto.PersonDTO;
import com.javaweb.service.IPersonService;
import org.springframework.beans.factory.annotation.Autowired;
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
    @Autowired
    IPersonService iPersonService;
    @PostMapping
    public ResponseEntity<?> createPerson(@RequestBody PersonDTO personDTO) {
        try {
            iPersonService.createPerson(personDTO);
            return ResponseEntity.ok(personDTO);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/count")
    public ResponseEntity<Long> countPersons() {
        return ResponseEntity.ok(iPersonService.countPersons());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPersonById(@PathVariable("id") Long personId) {
        try {
            return ResponseEntity.ok(iPersonService.findPersonById(personId));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/available")
    public ResponseEntity<List<PersonDTO>> findAvailablePersons(
            @RequestParam(value = "branchId") Long branchId,
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam(value = "dob", required = false) String dob
    ) {
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

    @GetMapping("/root")
    public ResponseEntity<PersonDTO> getRootPerson(
            @RequestParam(value = "branchId", defaultValue = "1") Long branchId
    ) {
        PersonDTO root = iPersonService.findRootPersonByBranchId(branchId);
        return ResponseEntity.ok(root);
    }

    @GetMapping("/roots")
    public ResponseEntity<List<PersonDTO>> getRootPersons(
            @RequestParam(value = "branchId", defaultValue = "1") Long branchId
    ) {
        return ResponseEntity.ok(iPersonService.findRootPersonsByBranchId(branchId));
    }

    @PostMapping("/{id}/spouse")
    public ResponseEntity<?> addSpouse(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO spouseDTO
    ) {
        try {
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
            return ResponseEntity.ok(iPersonService.updatePerson(personId, personDTO));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePerson(@PathVariable("id") Long personId) {
        try {
            iPersonService.deletePerson(personId);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }
}
