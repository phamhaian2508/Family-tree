package com.javaweb.model.dto;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PersonDTO extends AbstractDTO<PersonDTO> {
    private String fullName;
    private LocalDate dob; // Ngày sinh
    private LocalDate dod; // Ngày mất
    private Integer generation;
    private String branch;
    private String branchName;
    private String gender;
    private String avatar;
    private String hometown;
    private String currentResidence;
    private String occupation;
    private String otherNote;
    private Long userId;
    private Long existingPersonId;
    private Long fatherId;
    private Long motherId;
    private Long spouseId;
    private String spouseFullName;
    private String spouseGender;
    private Integer spouseGeneration;
    private String spouseBranchName;
    private String spouseAvatar;
    private LocalDate spouseDob;
    private LocalDate spouseDod;
    private String spouseHometown;
    private String spouseCurrentResidence;
    private String spouseOccupation;
    private String spouseOtherNote;
    private List<PersonDTO> children = new ArrayList<>();
    private List<Long> mediaIds;
    private List<Long> childrenIds;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public LocalDate getDod() {
        return dod;
    }

    public void setDod(LocalDate dod) {
        this.dod = dod;
    }

    public Integer getGeneration() {
        return generation;
    }

    public void setGeneration(Integer generation) {
        this.generation = generation;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getHometown() {
        return hometown;
    }

    public void setHometown(String hometown) {
        this.hometown = hometown;
    }

    public String getCurrentResidence() {
        return currentResidence;
    }

    public void setCurrentResidence(String currentResidence) {
        this.currentResidence = currentResidence;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getOtherNote() {
        return otherNote;
    }

    public void setOtherNote(String otherNote) {
        this.otherNote = otherNote;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getExistingPersonId() {
        return existingPersonId;
    }

    public void setExistingPersonId(Long existingPersonId) {
        this.existingPersonId = existingPersonId;
    }

    public Long getFatherId() {
        return fatherId;
    }

    public void setFatherId(Long fatherId) {
        this.fatherId = fatherId;
    }

    public Long getMotherId() {
        return motherId;
    }

    public void setMotherId(Long motherId) {
        this.motherId = motherId;
    }

    public Long getSpouseId() {
        return spouseId;
    }

    public void setSpouseId(Long spouseId) {
        this.spouseId = spouseId;
    }

    public String getSpouseFullName() {
        return spouseFullName;
    }

    public void setSpouseFullName(String spouseFullName) {
        this.spouseFullName = spouseFullName;
    }

    public String getSpouseGender() {
        return spouseGender;
    }

    public void setSpouseGender(String spouseGender) {
        this.spouseGender = spouseGender;
    }

    public Integer getSpouseGeneration() {
        return spouseGeneration;
    }

    public void setSpouseGeneration(Integer spouseGeneration) {
        this.spouseGeneration = spouseGeneration;
    }

    public String getSpouseBranchName() {
        return spouseBranchName;
    }

    public void setSpouseBranchName(String spouseBranchName) {
        this.spouseBranchName = spouseBranchName;
    }

    public String getSpouseAvatar() {
        return spouseAvatar;
    }

    public void setSpouseAvatar(String spouseAvatar) {
        this.spouseAvatar = spouseAvatar;
    }

    public LocalDate getSpouseDob() {
        return spouseDob;
    }

    public void setSpouseDob(LocalDate spouseDob) {
        this.spouseDob = spouseDob;
    }

    public LocalDate getSpouseDod() {
        return spouseDod;
    }

    public void setSpouseDod(LocalDate spouseDod) {
        this.spouseDod = spouseDod;
    }

    public String getSpouseHometown() {
        return spouseHometown;
    }

    public void setSpouseHometown(String spouseHometown) {
        this.spouseHometown = spouseHometown;
    }

    public String getSpouseCurrentResidence() {
        return spouseCurrentResidence;
    }

    public void setSpouseCurrentResidence(String spouseCurrentResidence) {
        this.spouseCurrentResidence = spouseCurrentResidence;
    }

    public String getSpouseOccupation() {
        return spouseOccupation;
    }

    public void setSpouseOccupation(String spouseOccupation) {
        this.spouseOccupation = spouseOccupation;
    }

    public String getSpouseOtherNote() {
        return spouseOtherNote;
    }

    public void setSpouseOtherNote(String spouseOtherNote) {
        this.spouseOtherNote = spouseOtherNote;
    }

    public List<PersonDTO> getChildren() {
        return children;
    }

    public void setChildren(List<PersonDTO> children) {
        this.children = children;
    }

    public List<Long> getMediaIds() {
        return mediaIds;
    }

    public void setMediaIds(List<Long> mediaIds) {
        this.mediaIds = mediaIds;
    }

    public List<Long> getChildrenIds() {
        return childrenIds;
    }

    public void setChildrenIds(List<Long> childrenIds) {
        this.childrenIds = childrenIds;
    }
}
