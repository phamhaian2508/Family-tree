package com.javaweb.repository;

import com.javaweb.entity.SpouseRelationEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SpouseRelationRepository extends JpaRepository<SpouseRelationEntity, Long> {
    List<SpouseRelationEntity> findAllByOrderByRelationOrderAscIdAsc();
    List<SpouseRelationEntity> findAllByFamilyTree_IdOrderByRelationOrderAscIdAsc(Long familyTreeId);
    void deleteByFamilyTree_Id(Long familyTreeId);
}
