package com.javaweb.model.dto;

public class FamilyTreeDTO extends AbstractDTO<FamilyTreeDTO> {
    private String name;
    private String description;
    private String coverImage;
    private Long ownerUserId;
    private long totalBranches;
    private long totalMembers;
    private long totalAlbums;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public Long getOwnerUserId() {
        return ownerUserId;
    }

    public void setOwnerUserId(Long ownerUserId) {
        this.ownerUserId = ownerUserId;
    }

    public long getTotalBranches() {
        return totalBranches;
    }

    public void setTotalBranches(long totalBranches) {
        this.totalBranches = totalBranches;
    }

    public long getTotalMembers() {
        return totalMembers;
    }

    public void setTotalMembers(long totalMembers) {
        this.totalMembers = totalMembers;
    }

    public long getTotalAlbums() {
        return totalAlbums;
    }

    public void setTotalAlbums(long totalAlbums) {
        this.totalAlbums = totalAlbums;
    }
}
