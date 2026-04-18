package com.javaweb.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "family_news")
@Getter
@Setter
public class FamilyNewsEntity extends BaseEntity implements FamilyTreeScopedEntity {

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id", nullable = false)
    private FamilyTreeEntity familyTree;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "cover_image", columnDefinition = "LONGTEXT")
    private String coverImage;

    @Column(name = "summary", columnDefinition = "TEXT")
    private String summary;

    @Column(name = "content", columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "published_at", length = 50)
    private String publishedAt;

    @Column(name = "publisher_name")
    private String publisherName;

    @Column(name = "category_name")
    private String categoryName;

    @Column(name = "visible", nullable = false)
    private Boolean visible = Boolean.TRUE;

    @Column(name = "attachment_urls", columnDefinition = "LONGTEXT")
    private String attachmentUrls;
}
