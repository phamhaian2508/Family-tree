package com.javaweb.repository;

import com.javaweb.entity.ContributionRecordEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ContributionRecordRepository extends JpaRepository<ContributionRecordEntity, Long> {
    List<ContributionRecordEntity> findAllByFamilyTreeIdOrderByContributionYearDescIdDesc(Long familyTreeId);
    Optional<ContributionRecordEntity> findByIdAndFamilyTreeId(Long id, Long familyTreeId);
    long countByContributionYear(Integer contributionYear);
}
