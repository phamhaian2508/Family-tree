package com.javaweb.repository;

import com.javaweb.entity.PersonEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.Date;

public interface PersonRepository extends JpaRepository<PersonEntity,Long> {
    Optional<PersonEntity>
    findFirstByBranch_IdAndGenerationOrderByIdAsc(
            Long branchId,
            Integer generation
    );

    Optional<PersonEntity> findByIdAndSpouseIsNull(Long id);

    @Query("select p from PersonEntity p where p.father.id = :parentId or p.mother.id = :parentId order by p.id asc")
    List<PersonEntity> findChildrenByParentId(@Param("parentId") Long parentId);

    @Query("select count(p.id) from PersonEntity p where p.father.id = :parentId or p.mother.id = :parentId")
    long countChildrenByParentId(@Param("parentId") Long parentId);

    Optional<PersonEntity> findFirstByBranch_IdOrderByGenerationAscIdAsc(Long branchId);

    @Query("select p from PersonEntity p " +
            "left join p.father f " +
            "left join p.mother m " +
            "where p.branch.id = :branchId " +
            "and (f is null or f.branch.id <> :branchId) " +
            "and (m is null or m.branch.id <> :branchId) " +
            "order by p.generation asc, p.id asc")
    List<PersonEntity> findRootCandidatesByBranchId(@Param("branchId") Long branchId);

    @Query("select p from PersonEntity p where p.branch.id = :branchId and (p.father.id = :parentId or p.mother.id = :parentId) order by p.id asc")
    List<PersonEntity> findChildrenByParentIdAndBranchId(@Param("parentId") Long parentId, @Param("branchId") Long branchId);

    @Query("select distinct p from PersonEntity p " +
            "left join fetch p.branch " +
            "left join fetch p.spouse s " +
            "left join fetch s.branch " +
            "left join fetch p.father f " +
            "left join fetch f.branch " +
            "left join fetch p.mother m " +
            "left join fetch m.branch " +
            "where p.familyTree.id = :familyTreeId " +
            "order by p.generation asc, p.id asc")
    List<PersonEntity> findAllByFamilyTreeIdWithRelations(@Param("familyTreeId") Long familyTreeId);

    @Query("select distinct p from PersonEntity p " +
            "left join fetch p.branch " +
            "left join fetch p.spouse s " +
            "left join fetch s.branch " +
            "left join fetch p.father f " +
            "left join fetch f.branch " +
            "left join fetch p.mother m " +
            "left join fetch m.branch " +
            "where p.branch.id = :branchId " +
            "order by p.generation asc, p.id asc")
    List<PersonEntity> findAllByBranchIdWithRelations(@Param("branchId") Long branchId);

    @Query("select distinct p from PersonEntity p " +
            "left join fetch p.branch " +
            "left join fetch p.spouse s " +
            "left join fetch s.branch " +
            "left join fetch p.father f " +
            "left join fetch f.branch " +
            "left join fetch p.mother m " +
            "left join fetch m.branch " +
            "where p.branch is not null " +
            "order by p.generation asc, p.id asc")
    List<PersonEntity> findAllWithRelations();

    @Query("select distinct p from PersonEntity p " +
            "left join fetch p.branch " +
            "left join fetch p.spouse s " +
            "left join fetch s.branch " +
            "left join fetch p.father f " +
            "left join fetch f.branch " +
            "left join fetch p.mother m " +
            "left join fetch m.branch " +
            "left join fetch p.medias medias " +
            "where p.id = :personId")
    Optional<PersonEntity> findByIdWithDetails(@Param("personId") Long personId);

    @Query("select p from PersonEntity p left join fetch p.branch where p.createdDate is not null order by p.createdDate desc, p.id desc")
    List<PersonEntity> findRecentCreated(Pageable pageable);

    @Query("select p from PersonEntity p left join fetch p.branch where p.familyTree.id = :familyTreeId and p.createdDate is not null order by p.createdDate desc, p.id desc")
    List<PersonEntity> findRecentCreatedByFamilyTree(@Param("familyTreeId") Long familyTreeId, Pageable pageable);

    Optional<PersonEntity> findByUserId(Long userId);

    @Query("select p from PersonEntity p " +
            "where p.familyTree is null and p.branch is null " +
            "and p.generation is null and p.father is null and p.mother is null and p.spouse is null " +
            "and (:fullName is null or lower(p.fullName) like lower(concat('%', :fullName, '%'))) " +
            "and (:gender is null or lower(p.gender) = lower(:gender)) " +
            "and (:dob is null or p.dob = :dob) " +
            "order by p.id desc")
    List<PersonEntity> findAttachablePersons(@Param("fullName") String fullName,
                                             @Param("gender") String gender,
                                             @Param("dob") Date dob);

    Optional<PersonEntity> findByIdAndFatherIsNullAndMotherIsNullAndSpouseIsNull(Long id);

    long countByBranch_Id(Long branchId);
    long countByFamilyTree_Id(Long familyTreeId);

    long countByBranchIsNotNull();
    long countByFamilyTree_IdAndBranchIsNotNull(Long familyTreeId);

    long countByBranchIsNotNullAndCreatedDateBetween(Date from, Date to);
    long countByFamilyTree_IdAndBranchIsNotNullAndCreatedDateBetween(Long familyTreeId, Date from, Date to);

    long countByCreatedDateBetween(Date from, Date to);
    long countByFamilyTree_IdAndCreatedDateBetween(Long familyTreeId, Date from, Date to);

    @Query("select coalesce(max(p.generation), 0) from PersonEntity p where p.branch is not null")
    Integer findMaxGenerationByBranchIsNotNull();

    @Query("select coalesce(max(p.generation), 0) from PersonEntity p where p.familyTree.id = :familyTreeId and p.branch is not null")
    Integer findMaxGenerationByFamilyTreeIdAndBranchIsNotNull(@Param("familyTreeId") Long familyTreeId);

    void deleteByFamilyTree_Id(Long familyTreeId);
}
