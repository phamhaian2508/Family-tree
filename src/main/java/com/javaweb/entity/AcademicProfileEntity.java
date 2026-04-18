package com.javaweb.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "academic_profile")
@Getter
@Setter
public class AcademicProfileEntity extends BaseEntity implements FamilyTreeScopedEntity {

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id", nullable = false)
    private FamilyTreeEntity familyTree;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "birth_year")
    private Integer birthYear;

    @Column(name = "branch_name")
    private String branchName;

    @Column(name = "degree_name")
    private String degreeName;

    @Column(name = "academic_rank")
    private String academicRank;

    @Column(name = "specialty")
    private String specialty;

    @Column(name = "workplace")
    private String workplace;

    @Column(name = "current_position")
    private String currentPosition;

    @Column(name = "highlight_achievement", columnDefinition = "TEXT")
    private String highlightAchievement;

    @Column(name = "portrait_url", columnDefinition = "LONGTEXT")
    private String portraitUrl;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;
}
