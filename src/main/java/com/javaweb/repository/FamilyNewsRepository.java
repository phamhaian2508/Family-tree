package com.javaweb.repository;

import com.javaweb.entity.FamilyNewsEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FamilyNewsRepository extends JpaRepository<FamilyNewsEntity, Long> {
    List<FamilyNewsEntity> findAllByFamilyTreeIdOrderByIdDesc(Long familyTreeId);
    Optional<FamilyNewsEntity> findByIdAndFamilyTreeId(Long id, Long familyTreeId);
}
