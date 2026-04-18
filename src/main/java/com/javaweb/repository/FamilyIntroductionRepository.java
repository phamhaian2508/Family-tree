package com.javaweb.repository;

import com.javaweb.entity.FamilyIntroductionEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FamilyIntroductionRepository extends JpaRepository<FamilyIntroductionEntity, Long> {
    Optional<FamilyIntroductionEntity> findFirstByFamilyTreeIdOrderByIdDesc(Long familyTreeId);
    List<FamilyIntroductionEntity> findAllByFamilyTreeIdOrderByIdDesc(Long familyTreeId);
    Optional<FamilyIntroductionEntity> findByIdAndFamilyTreeId(Long id, Long familyTreeId);
}
