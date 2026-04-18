package com.javaweb.repository;

import com.javaweb.entity.MediaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface MediaRepository extends JpaRepository<MediaEntity,Long> {
    @Query("select m from MediaEntity m " +
            "left join fetch m.album a " +
            "left join fetch m.person p " +
            "left join fetch m.branch b " +
            "left join fetch m.uploader u " +
            "order by m.createdDate desc, m.id desc")
    List<MediaEntity> findAllForAdminView();

    @Query("select m from MediaEntity m " +
            "left join fetch m.album a " +
            "left join fetch m.person p " +
            "left join fetch m.branch b " +
            "left join fetch m.uploader u " +
            "where m.familyTree.id = :familyTreeId " +
            "order by m.createdDate desc, m.id desc")
    List<MediaEntity> findAllForAdminViewByFamilyTreeId(@Param("familyTreeId") Long familyTreeId);

    Optional<MediaEntity> findFirstByFileUrlContaining(String fileUrlPart);
    Optional<MediaEntity> findFirstByFileUrlStartingWith(String fileUrlPrefix);
    long countByAlbumId(Long albumId);
    List<MediaEntity> findByAlbumId(Long albumId);
    List<MediaEntity> findByFamilyTree_Id(Long familyTreeId);
    long countByFamilyTree_Id(Long familyTreeId);

    @Modifying
    @Query("update MediaEntity m set m.album = null where m.album.id = :albumId")
    int detachAlbumFromMedia(@Param("albumId") Long albumId);

    long countByCreatedDateBetween(Date from, Date to);
    long countByFamilyTree_IdAndCreatedDateBetween(Long familyTreeId, Date from, Date to);

    void deleteByFamilyTree_Id(Long familyTreeId);
}
