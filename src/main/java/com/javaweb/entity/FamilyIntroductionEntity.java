package com.javaweb.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "family_introduction")
@Getter
@Setter
public class FamilyIntroductionEntity extends BaseEntity implements FamilyTreeScopedEntity {

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id", nullable = false)
    private FamilyTreeEntity familyTree;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "cover_image", columnDefinition = "LONGTEXT")
    private String coverImage;

    @Column(name = "content", columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "gallery_images", columnDefinition = "LONGTEXT")
    private String galleryImages;

    @Column(name = "video_url", length = 500)
    private String videoUrl;

    @Column(name = "visible", nullable = false)
    private Boolean visible = Boolean.TRUE;
}
