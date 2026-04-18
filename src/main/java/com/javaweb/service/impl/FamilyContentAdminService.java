package com.javaweb.service.impl;

import com.javaweb.entity.AcademicProfileEntity;
import com.javaweb.entity.AwardRecordEntity;
import com.javaweb.entity.ContributionRecordEntity;
import com.javaweb.entity.FamilyIntroductionEntity;
import com.javaweb.entity.FamilyNewsEntity;
import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.repository.AcademicProfileRepository;
import com.javaweb.repository.AwardRecordRepository;
import com.javaweb.repository.ContributionRecordRepository;
import com.javaweb.repository.FamilyIntroductionRepository;
import com.javaweb.repository.FamilyNewsRepository;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class FamilyContentAdminService {
    private static final String DATE_PATTERN = "yyyy-MM-dd";

    private final FamilyContentScopeService familyContentScopeService;
    private final FamilyIntroductionRepository familyIntroductionRepository;
    private final ContributionRecordRepository contributionRecordRepository;
    private final AwardRecordRepository awardRecordRepository;
    private final AcademicProfileRepository academicProfileRepository;
    private final FamilyNewsRepository familyNewsRepository;

    public FamilyContentAdminService(FamilyContentScopeService familyContentScopeService,
                                     FamilyIntroductionRepository familyIntroductionRepository,
                                     ContributionRecordRepository contributionRecordRepository,
                                     AwardRecordRepository awardRecordRepository,
                                     AcademicProfileRepository academicProfileRepository,
                                     FamilyNewsRepository familyNewsRepository) {
        this.familyContentScopeService = familyContentScopeService;
        this.familyIntroductionRepository = familyIntroductionRepository;
        this.contributionRecordRepository = contributionRecordRepository;
        this.awardRecordRepository = awardRecordRepository;
        this.academicProfileRepository = academicProfileRepository;
        this.familyNewsRepository = familyNewsRepository;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listIntroductions(Long requestedFamilyTreeId) {
        Long familyTreeId = familyContentScopeService.resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            return new ArrayList<>();
        }
        List<FamilyIntroductionEntity> items = familyIntroductionRepository.findAllByFamilyTreeIdOrderByIdDesc(familyTreeId);
        return mapList(items, this::toIntroductionMap);
    }

    public Map<String, Object> saveIntroduction(Long requestedFamilyTreeId, Long id, Map<String, Object> payload) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        FamilyIntroductionEntity entity = id == null
                ? new FamilyIntroductionEntity()
                : familyIntroductionRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay bai gioi thieu can cap nhat"));
        entity.setFamilyTree(familyTree);
        entity.setTitle(requireText(payload, "title", "Tieu de bai gioi thieu khong duoc de trong"));
        entity.setCoverImage(trim(payload.get("coverImage")));
        entity.setContent(trim(payload.get("content")));
        entity.setGalleryImages(trim(payload.get("galleryImages")));
        entity.setVideoUrl(trim(payload.get("videoUrl")));
        entity.setVisible(parseBoolean(payload.get("visible"), true));
        return toIntroductionMap(familyIntroductionRepository.save(entity));
    }

    public void deleteIntroduction(Long requestedFamilyTreeId, Long id) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        FamilyIntroductionEntity entity = familyIntroductionRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay bai gioi thieu de xoa"));
        familyIntroductionRepository.delete(entity);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listContributions(Long requestedFamilyTreeId) {
        Long familyTreeId = familyContentScopeService.resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            return new ArrayList<>();
        }
        List<ContributionRecordEntity> items = contributionRecordRepository.findAllByFamilyTreeIdOrderByContributionYearDescIdDesc(familyTreeId);
        return mapList(items, this::toContributionMap);
    }

    public Map<String, Object> saveContribution(Long requestedFamilyTreeId, Long id, Map<String, Object> payload) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        ContributionRecordEntity entity = id == null
                ? new ContributionRecordEntity()
                : contributionRecordRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ban ghi cong duc can cap nhat"));
        entity.setFamilyTree(familyTree);
        entity.setContributionYear(requireInteger(payload, "contributionYear", "Nam cong duc khong duoc de trong"));
        entity.setContributorName(requireText(payload, "contributorName", "Ho ten nguoi dong gop khong duoc de trong"));
        entity.setBranchLabel(trim(payload.get("branchLabel")));
        entity.setContributionValue(trim(payload.get("contributionValue")));
        entity.setNote(trim(payload.get("note")));
        entity.setContributionDate(trim(payload.get("contributionDate")));
        entity.setAttachmentUrl(trim(payload.get("attachmentUrl")));
        return toContributionMap(contributionRecordRepository.save(entity));
    }

    public void deleteContribution(Long requestedFamilyTreeId, Long id) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        ContributionRecordEntity entity = contributionRecordRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ban ghi cong duc de xoa"));
        contributionRecordRepository.delete(entity);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listAwards(Long requestedFamilyTreeId) {
        Long familyTreeId = familyContentScopeService.resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            return new ArrayList<>();
        }
        List<AwardRecordEntity> items = awardRecordRepository.findAllByFamilyTreeIdOrderByAwardYearDescIdDesc(familyTreeId);
        return mapList(items, this::toAwardMap);
    }

    public Map<String, Object> saveAward(Long requestedFamilyTreeId, Long id, Map<String, Object> payload) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        AwardRecordEntity entity = id == null
                ? new AwardRecordEntity()
                : awardRecordRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ban ghi khen thuong can cap nhat"));
        entity.setFamilyTree(familyTree);
        entity.setFullName(requireText(payload, "fullName", "Ho ten khong duoc de trong"));
        entity.setAwardYear(requireInteger(payload, "awardYear", "Nam khen thuong khong duoc de trong"));
        entity.setAchievementTitle(trim(payload.get("achievementTitle")));
        entity.setEducationLevel(trim(payload.get("educationLevel")));
        entity.setSchoolName(trim(payload.get("schoolName")));
        entity.setRewardType(trim(payload.get("rewardType")));
        entity.setRewardValue(trim(payload.get("rewardValue")));
        entity.setCategoryName(trim(payload.get("categoryName")));
        entity.setNote(trim(payload.get("note")));
        entity.setProofImage(trim(payload.get("proofImage")));
        return toAwardMap(awardRecordRepository.save(entity));
    }

    public void deleteAward(Long requestedFamilyTreeId, Long id) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        AwardRecordEntity entity = awardRecordRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ban ghi khen thuong de xoa"));
        awardRecordRepository.delete(entity);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listAcademics(Long requestedFamilyTreeId) {
        Long familyTreeId = familyContentScopeService.resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            return new ArrayList<>();
        }
        List<AcademicProfileEntity> items = academicProfileRepository.findAllByFamilyTreeIdOrderByDegreeNameAscBirthYearAsc(familyTreeId);
        return mapList(items, this::toAcademicMap);
    }

    public Map<String, Object> saveAcademic(Long requestedFamilyTreeId, Long id, Map<String, Object> payload) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        AcademicProfileEntity entity = id == null
                ? new AcademicProfileEntity()
                : academicProfileRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ho so hoc ham hoc vi can cap nhat"));
        entity.setFamilyTree(familyTree);
        entity.setFullName(requireText(payload, "fullName", "Ho ten khong duoc de trong"));
        entity.setBirthYear(parseInteger(payload.get("birthYear")));
        entity.setBranchName(trim(payload.get("branchName")));
        entity.setDegreeName(trim(payload.get("degreeName")));
        entity.setAcademicRank(trim(payload.get("academicRank")));
        entity.setSpecialty(trim(payload.get("specialty")));
        entity.setWorkplace(trim(payload.get("workplace")));
        entity.setCurrentPosition(trim(payload.get("currentPosition")));
        entity.setHighlightAchievement(trim(payload.get("highlightAchievement")));
        entity.setPortraitUrl(trim(payload.get("portraitUrl")));
        entity.setNote(trim(payload.get("note")));
        return toAcademicMap(academicProfileRepository.save(entity));
    }

    public void deleteAcademic(Long requestedFamilyTreeId, Long id) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        AcademicProfileEntity entity = academicProfileRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay ho so hoc ham hoc vi de xoa"));
        academicProfileRepository.delete(entity);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listNews(Long requestedFamilyTreeId) {
        Long familyTreeId = familyContentScopeService.resolveFamilyTreeId(requestedFamilyTreeId);
        if (familyTreeId == null) {
            return new ArrayList<>();
        }
        List<FamilyNewsEntity> items = familyNewsRepository.findAllByFamilyTreeIdOrderByIdDesc(familyTreeId);
        return mapList(items, this::toNewsMap);
    }

    public Map<String, Object> saveNews(Long requestedFamilyTreeId, Long id, Map<String, Object> payload) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        FamilyNewsEntity entity = id == null
                ? new FamilyNewsEntity()
                : familyNewsRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay tin tuc can cap nhat"));
        entity.setFamilyTree(familyTree);
        entity.setTitle(requireText(payload, "title", "Tieu de tin tuc khong duoc de trong"));
        entity.setCoverImage(trim(payload.get("coverImage")));
        entity.setSummary(trim(payload.get("summary")));
        entity.setContent(trim(payload.get("content")));
        entity.setPublishedAt(trim(payload.get("publishedAt")));
        entity.setPublisherName(trim(payload.get("publisherName")));
        entity.setCategoryName(trim(payload.get("categoryName")));
        entity.setVisible(parseBoolean(payload.get("visible"), true));
        entity.setAttachmentUrls(trim(payload.get("attachmentUrls")));
        return toNewsMap(familyNewsRepository.save(entity));
    }

    public void deleteNews(Long requestedFamilyTreeId, Long id) {
        FamilyTreeEntity familyTree = familyContentScopeService.requireFamilyTree(requestedFamilyTreeId);
        FamilyNewsEntity entity = familyNewsRepository.findByIdAndFamilyTreeId(id, familyTree.getId())
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay tin tuc de xoa"));
        familyNewsRepository.delete(entity);
    }

    private Map<String, Object> toIntroductionMap(FamilyIntroductionEntity entity) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", entity.getId());
        map.put("title", defaultString(entity.getTitle()));
        map.put("coverImage", defaultString(entity.getCoverImage()));
        map.put("content", defaultString(entity.getContent()));
        map.put("galleryImages", defaultString(entity.getGalleryImages()));
        map.put("videoUrl", defaultString(entity.getVideoUrl()));
        map.put("visible", truthy(entity.getVisible()));
        map.put("updatedAt", formatDateTime(entity.getModifiedDate() != null ? entity.getModifiedDate() : entity.getCreatedDate()));
        return map;
    }

    private Map<String, Object> toContributionMap(ContributionRecordEntity entity) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", entity.getId());
        map.put("contributionYear", entity.getContributionYear());
        map.put("contributorName", defaultString(entity.getContributorName()));
        map.put("branchLabel", defaultString(entity.getBranchLabel()));
        map.put("contributionValue", defaultString(entity.getContributionValue()));
        map.put("note", defaultString(entity.getNote()));
        map.put("contributionDate", defaultString(entity.getContributionDate()));
        map.put("attachmentUrl", defaultString(entity.getAttachmentUrl()));
        return map;
    }

    private Map<String, Object> toAwardMap(AwardRecordEntity entity) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", entity.getId());
        map.put("fullName", defaultString(entity.getFullName()));
        map.put("awardYear", entity.getAwardYear());
        map.put("achievementTitle", defaultString(entity.getAchievementTitle()));
        map.put("educationLevel", defaultString(entity.getEducationLevel()));
        map.put("schoolName", defaultString(entity.getSchoolName()));
        map.put("rewardType", defaultString(entity.getRewardType()));
        map.put("rewardValue", defaultString(entity.getRewardValue()));
        map.put("categoryName", defaultString(entity.getCategoryName()));
        map.put("note", defaultString(entity.getNote()));
        map.put("proofImage", defaultString(entity.getProofImage()));
        return map;
    }

    private Map<String, Object> toAcademicMap(AcademicProfileEntity entity) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", entity.getId());
        map.put("fullName", defaultString(entity.getFullName()));
        map.put("birthYear", entity.getBirthYear());
        map.put("branchName", defaultString(entity.getBranchName()));
        map.put("degreeName", defaultString(entity.getDegreeName()));
        map.put("academicRank", defaultString(entity.getAcademicRank()));
        map.put("specialty", defaultString(entity.getSpecialty()));
        map.put("workplace", defaultString(entity.getWorkplace()));
        map.put("currentPosition", defaultString(entity.getCurrentPosition()));
        map.put("highlightAchievement", defaultString(entity.getHighlightAchievement()));
        map.put("portraitUrl", defaultString(entity.getPortraitUrl()));
        map.put("note", defaultString(entity.getNote()));
        return map;
    }

    private Map<String, Object> toNewsMap(FamilyNewsEntity entity) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", entity.getId());
        map.put("title", defaultString(entity.getTitle()));
        map.put("coverImage", defaultString(entity.getCoverImage()));
        map.put("summary", defaultString(entity.getSummary()));
        map.put("content", defaultString(entity.getContent()));
        map.put("publishedAt", defaultString(entity.getPublishedAt()));
        map.put("publisherName", defaultString(entity.getPublisherName()));
        map.put("categoryName", defaultString(entity.getCategoryName()));
        map.put("visible", truthy(entity.getVisible()));
        map.put("attachmentUrls", defaultString(entity.getAttachmentUrls()));
        return map;
    }

    private String requireText(Map<String, Object> payload, String key, String message) {
        String value = trim(payload.get(key));
        if (StringUtils.isBlank(value)) {
            throw new IllegalArgumentException(message);
        }
        return value;
    }

    private Integer requireInteger(Map<String, Object> payload, String key, String message) {
        Integer value = parseInteger(payload.get(key));
        if (value == null) {
            throw new IllegalArgumentException(message);
        }
        return value;
    }

    private String trim(Object value) {
        return value == null ? "" : String.valueOf(value).trim();
    }

    private Integer parseInteger(Object value) {
        String text = trim(value);
        if (StringUtils.isBlank(text)) {
            return null;
        }
        try {
            return Integer.valueOf(text);
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Gia tri so nguyen khong hop le: " + text);
        }
    }

    private Boolean parseBoolean(Object value, boolean defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        String text = trim(value).toLowerCase();
        if (StringUtils.isBlank(text)) {
            return defaultValue;
        }
        if ("true".equals(text) || "1".equals(text) || "yes".equals(text) || "on".equals(text)) {
            return Boolean.TRUE;
        }
        if ("false".equals(text) || "0".equals(text) || "no".equals(text) || "off".equals(text)) {
            return Boolean.FALSE;
        }
        return defaultValue;
    }

    private String formatDateTime(java.util.Date value) {
        if (value == null) {
            return "";
        }
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(value);
    }

    private boolean truthy(Boolean value) {
        return Boolean.TRUE.equals(value);
    }

    private String defaultString(String value) {
        return value == null ? "" : value;
    }

    private <T> List<Map<String, Object>> mapList(Collection<T> items, Mapper<T> mapper) {
        List<Map<String, Object>> mapped = new ArrayList<>();
        if (items == null) {
            return mapped;
        }
        for (T item : items) {
            mapped.add(mapper.map(item));
        }
        return mapped;
    }

    private interface Mapper<T> {
        Map<String, Object> map(T item);
    }
}
