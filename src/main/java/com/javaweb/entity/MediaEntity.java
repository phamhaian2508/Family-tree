package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "media")
@Getter
@Setter
public class MediaEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id")
    private FamilyTreeEntity familyTree;

    @Column(name = "file_url", nullable = false, length = 500)
    private String fileUrl;

    @Column(name = "media_type", length = 50)
    private String mediaType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "album_id")
    private MediaAlbumEntity album;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "person_id")
    private PersonEntity person;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id")
    private BranchEntity branch;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "uploader_id")
    private UserEntity uploader;
}
