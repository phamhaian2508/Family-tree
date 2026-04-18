package com.javaweb.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "contribution_record")
@Getter
@Setter
public class ContributionRecordEntity extends BaseEntity implements FamilyTreeScopedEntity {

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id", nullable = false)
    private FamilyTreeEntity familyTree;

    @Column(name = "contribution_year")
    private Integer contributionYear;

    @Column(name = "contributor_name", nullable = false)
    private String contributorName;

    @Column(name = "branch_label")
    private String branchLabel;

    @Column(name = "contribution_value")
    private String contributionValue;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Column(name = "contribution_date", length = 50)
    private String contributionDate;

    @Column(name = "attachment_url", columnDefinition = "LONGTEXT")
    private String attachmentUrl;
}
