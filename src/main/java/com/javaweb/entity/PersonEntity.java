package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "person")
@Getter
@Setter
public class PersonEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_tree_id")
    private FamilyTreeEntity familyTree;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id")
    private BranchEntity branch;

    @Column(name = "user_id", unique = true)
    private Long userId;

    @Column(name = "fullname", nullable = false)
    private String fullName;

    @Column(name = "gender")
    private String gender;

    @Column(name = "avatar", columnDefinition = "LONGTEXT")
    private String avatar;

    @Temporal(TemporalType.DATE)
    @Column(name = "dob")
    private Date dob;

    @Temporal(TemporalType.DATE)
    @Column(name = "dod")
    private Date dod;

    @Column(name = "generation")
    private Integer generation;

    @Column(name = "hometown")
    private String hometown;

    @Column(name = "current_residence")
    private String currentResidence;

    @Column(name = "occupation")
    private String occupation;

    @Column(name = "other_note", columnDefinition = "TEXT")
    private String otherNote;

    // self reference: father/mother
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "father_id")
    private PersonEntity father;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mother_id")
    private PersonEntity mother;

    // để tiện: cha có nhiều con (reverse mapping)
    @OneToMany(mappedBy = "father", fetch = FetchType.LAZY)
    private List<PersonEntity> childrenByFather = new ArrayList<>();

    @OneToMany(mappedBy = "mother", fetch = FetchType.LAZY)
    private List<PersonEntity> childrenByMother = new ArrayList<>();

    // 1 Person - n Media
    @OneToMany(mappedBy = "person", fetch = FetchType.LAZY)
    private List<MediaEntity> medias = new ArrayList<>();

    // self reference: spouse
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "spouse_id")
    private PersonEntity spouse;
}
