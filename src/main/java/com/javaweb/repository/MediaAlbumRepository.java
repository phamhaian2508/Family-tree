package com.javaweb.repository;

import com.javaweb.entity.MediaAlbumEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MediaAlbumRepository extends JpaRepository<MediaAlbumEntity, Long> {

    @Query("select distinct a from MediaAlbumEntity a " +
            "left join fetch a.person p " +
            "left join fetch a.branch b " +
            "left join fetch a.uploader u " +
            "order by a.createdDate desc, a.id desc")
    List<MediaAlbumEntity> findAllForAdminView();

    @Query("select distinct a from MediaAlbumEntity a " +
            "left join fetch a.person p " +
            "left join fetch a.branch b " +
            "left join fetch a.uploader u " +
            "where a.familyTree.id = :familyTreeId " +
            "order by a.createdDate desc, a.id desc")
    List<MediaAlbumEntity> findAllForAdminViewByFamilyTreeId(@Param("familyTreeId") Long familyTreeId);

    long countByFamilyTree_Id(Long familyTreeId);

    void deleteByFamilyTree_Id(Long familyTreeId);
}
