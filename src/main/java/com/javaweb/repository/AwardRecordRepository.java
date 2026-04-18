package com.javaweb.repository;

import com.javaweb.entity.AwardRecordEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AwardRecordRepository extends JpaRepository<AwardRecordEntity, Long> {
    List<AwardRecordEntity> findAllByFamilyTreeIdOrderByAwardYearDescIdDesc(Long familyTreeId);
    Optional<AwardRecordEntity> findByIdAndFamilyTreeId(Long id, Long familyTreeId);
}
