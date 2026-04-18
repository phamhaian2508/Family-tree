package com.javaweb.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "award_record")
@Getter
@Setter
public class AwardRecordEntity extends BaseEntity implements FamilyTreeScopedEntity {

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id", nullable = false)
    private FamilyTreeEntity familyTree;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "award_year")
    private Integer awardYear;

    @Column(name = "achievement_title")
    private String achievementTitle;

    @Column(name = "education_level")
    private String educationLevel;

    @Column(name = "school_name")
    private String schoolName;

    @Column(name = "reward_type")
    private String rewardType;

    @Column(name = "reward_value")
    private String rewardValue;

    @Column(name = "category_name")
    private String categoryName;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Column(name = "proof_image", columnDefinition = "LONGTEXT")
    private String proofImage;
}
