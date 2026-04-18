package com.javaweb.repository;

import com.javaweb.entity.AcademicProfileEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AcademicProfileRepository extends JpaRepository<AcademicProfileEntity, Long> {
    List<AcademicProfileEntity> findAllByFamilyTreeIdOrderByDegreeNameAscBirthYearAsc(Long familyTreeId);
    Optional<AcademicProfileEntity> findByIdAndFamilyTreeId(Long id, Long familyTreeId);
}
