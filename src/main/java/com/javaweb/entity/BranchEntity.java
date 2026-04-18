package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "branch")
@Getter
@Setter
public class BranchEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id")
    private FamilyTreeEntity familyTree;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // 1 Branch - n Person
    @OneToMany(mappedBy = "branch", fetch = FetchType.LAZY)
    private List<PersonEntity> persons = new ArrayList<>();

    // 1 Branch - n Media
    @OneToMany(mappedBy = "branch", fetch = FetchType.LAZY)
    private List<MediaEntity> medias = new ArrayList<>();

    // 1 Branch - n Livestream
    @OneToMany(mappedBy = "branch", fetch = FetchType.LAZY)
    private List<LivestreamEntity> livestreams = new ArrayList<>();
}
