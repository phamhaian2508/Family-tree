package com.javaweb.repository;

import com.javaweb.entity.FamilyTreeEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FamilyTreeRepository extends JpaRepository<FamilyTreeEntity, Long> {
    Optional<FamilyTreeEntity> findFirstByOrderByIdAsc();
}
