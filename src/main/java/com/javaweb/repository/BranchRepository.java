package com.javaweb.repository;

import com.javaweb.entity.BranchEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface BranchRepository extends JpaRepository<BranchEntity,Long> {
    Optional<BranchEntity> findFirstByOrderByIdAsc();
    Optional<BranchEntity> findFirstByFamilyTree_IdOrderByIdAsc(Long familyTreeId);
    Optional<BranchEntity> findByIdAndFamilyTree_Id(Long id, Long familyTreeId);
    List<BranchEntity> findAllByFamilyTree_IdOrderByIdAsc(Long familyTreeId);
    long countByFamilyTree_Id(Long familyTreeId);
    long countByFamilyTree_IdAndCreatedDateBetween(Long familyTreeId, Date from, Date to);
    long countByCreatedDateBetween(Date from, Date to);
    void deleteByFamilyTree_Id(Long familyTreeId);
}
