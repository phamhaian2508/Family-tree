package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "spouse_relation")
@Getter
@Setter
public class SpouseRelationEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id")
    private FamilyTreeEntity familyTree;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "left_person_id", nullable = false)
    private PersonEntity leftPerson;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "right_person_id", nullable = false)
    private PersonEntity rightPerson;

    @Column(name = "relation_order")
    private Integer relationOrder;

    @Column(name = "relation_label")
    private String relationLabel;
}
