package com.javaweb.api.admin;

import com.javaweb.entity.*;
import com.javaweb.repository.*;
import com.javaweb.service.impl.FamilyContentScopeService;
import com.javaweb.utils.InputSanitizationUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@RestController
@RequestMapping("/api/family-content")
@Transactional
public class FamilyContentAPI {
    private final FamilyContentScopeService familyContentScopeService;
    private final FamilyIntroductionRepository familyIntroductionRepository;
    private final ContributionRecordRepository contributionRecordRepository;
    private final AwardRecordRepository awardRecordRepository;
    private final AcademicProfileRepository academicProfileRepository;
    private final FamilyNewsRepository familyNewsRepository;

    public FamilyContentAPI(FamilyContentScopeService familyContentScopeService,
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

    @GetMapping("/introduction")
    public ResponseEntity<FamilyIntroductionEntity> getIntroduction() {
        Long familyTreeId = familyContentScopeService.requireCurrentFamilyTreeId();
        FamilyIntroductionEntity entity = familyIntroductionRepository.findFirstByFamilyTreeIdOrderByIdDesc(familyTreeId)
                .orElseGet(FamilyIntroductionEntity::new);
        return ResponseEntity.ok(entity);
    }

    @PutMapping("/introduction")
    public ResponseEntity<FamilyIntroductionEntity> saveIntroduction(@RequestBody FamilyIntroductionEntity payload) {
        Long familyTreeId = familyContentScopeService.requireCurrentFamilyTreeId();
        FamilyIntroductionEntity entity = familyIntroductionRepository.findFirstByFamilyTreeIdOrderByIdDesc(familyTreeId)
                .orElseGet(FamilyIntroductionEntity::new);
        familyContentScopeService.attachCurrentFamilyTree(entity);
        copyIntroduction(entity, payload);
        return ResponseEntity.ok(familyIntroductionRepository.save(entity));
    }

    @GetMapping("/contributions")
    public ResponseEntity<List<ContributionRecordEntity>> getContributions() {
        return ResponseEntity.ok(contributionRecordRepository.findAllByFamilyTreeIdOrderByContributionYearDescIdDesc(
                familyContentScopeService.requireCurrentFamilyTreeId()));
    }

    @PostMapping("/contributions")
    public ResponseEntity<ContributionRecordEntity> createContribution(@RequestBody ContributionRecordEntity payload) {
        ContributionRecordEntity entity = new ContributionRecordEntity();
        familyContentScopeService.attachCurrentFamilyTree(entity);
        copyContribution(entity, payload);
        return ResponseEntity.ok(contributionRecordRepository.save(entity));
    }

    @PutMapping("/contributions/{id}")
    public ResponseEntity<ContributionRecordEntity> updateContribution(@PathVariable Long id, @RequestBody ContributionRecordEntity payload) {
        ContributionRecordEntity entity = familyContentScopeService.requireOwned(
                contributionRecordRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ban ghi cong duc")));
        copyContribution(entity, payload);
        return ResponseEntity.ok(contributionRecordRepository.save(entity));
    }

    @DeleteMapping("/contributions/{id}")
    public ResponseEntity<?> deleteContribution(@PathVariable Long id) {
        ContributionRecordEntity entity = familyContentScopeService.requireOwned(
                contributionRecordRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ban ghi cong duc")));
        contributionRecordRepository.delete(entity);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/awards")
    public ResponseEntity<List<AwardRecordEntity>> getAwards() {
        return ResponseEntity.ok(awardRecordRepository.findAllByFamilyTreeIdOrderByAwardYearDescIdDesc(
                familyContentScopeService.requireCurrentFamilyTreeId()));
    }

    @PostMapping("/awards")
    public ResponseEntity<AwardRecordEntity> createAward(@RequestBody AwardRecordEntity payload) {
        AwardRecordEntity entity = new AwardRecordEntity();
        familyContentScopeService.attachCurrentFamilyTree(entity);
        copyAward(entity, payload);
        return ResponseEntity.ok(awardRecordRepository.save(entity));
    }

    @PutMapping("/awards/{id}")
    public ResponseEntity<AwardRecordEntity> updateAward(@PathVariable Long id, @RequestBody AwardRecordEntity payload) {
        AwardRecordEntity entity = familyContentScopeService.requireOwned(
                awardRecordRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ban ghi khen thuong")));
        copyAward(entity, payload);
        return ResponseEntity.ok(awardRecordRepository.save(entity));
    }

    @DeleteMapping("/awards/{id}")
    public ResponseEntity<?> deleteAward(@PathVariable Long id) {
        AwardRecordEntity entity = familyContentScopeService.requireOwned(
                awardRecordRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ban ghi khen thuong")));
        awardRecordRepository.delete(entity);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/academics")
    public ResponseEntity<List<AcademicProfileEntity>> getAcademics() {
        return ResponseEntity.ok(academicProfileRepository.findAllByFamilyTreeIdOrderByDegreeNameAscBirthYearAsc(
                familyContentScopeService.requireCurrentFamilyTreeId()));
    }

    @PostMapping("/academics")
    public ResponseEntity<AcademicProfileEntity> createAcademic(@RequestBody AcademicProfileEntity payload) {
        AcademicProfileEntity entity = new AcademicProfileEntity();
        familyContentScopeService.attachCurrentFamilyTree(entity);
        copyAcademic(entity, payload);
        return ResponseEntity.ok(academicProfileRepository.save(entity));
    }

    @PutMapping("/academics/{id}")
    public ResponseEntity<AcademicProfileEntity> updateAcademic(@PathVariable Long id, @RequestBody AcademicProfileEntity payload) {
        AcademicProfileEntity entity = familyContentScopeService.requireOwned(
                academicProfileRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ho so hoc ham hoc vi")));
        copyAcademic(entity, payload);
        return ResponseEntity.ok(academicProfileRepository.save(entity));
    }

    @DeleteMapping("/academics/{id}")
    public ResponseEntity<?> deleteAcademic(@PathVariable Long id) {
        AcademicProfileEntity entity = familyContentScopeService.requireOwned(
                academicProfileRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay ho so hoc ham hoc vi")));
        academicProfileRepository.delete(entity);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/news")
    public ResponseEntity<List<FamilyNewsEntity>> getNews() {
        return ResponseEntity.ok(familyNewsRepository.findAllByFamilyTreeIdOrderByIdDesc(
                familyContentScopeService.requireCurrentFamilyTreeId()));
    }

    @PostMapping("/news")
    public ResponseEntity<FamilyNewsEntity> createNews(@RequestBody FamilyNewsEntity payload) {
        FamilyNewsEntity entity = new FamilyNewsEntity();
        familyContentScopeService.attachCurrentFamilyTree(entity);
        copyNews(entity, payload);
        return ResponseEntity.ok(familyNewsRepository.save(entity));
    }

    @PutMapping("/news/{id}")
    public ResponseEntity<FamilyNewsEntity> updateNews(@PathVariable Long id, @RequestBody FamilyNewsEntity payload) {
        FamilyNewsEntity entity = familyContentScopeService.requireOwned(
                familyNewsRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay tin tuc")));
        copyNews(entity, payload);
        return ResponseEntity.ok(familyNewsRepository.save(entity));
    }

    @DeleteMapping("/news/{id}")
    public ResponseEntity<?> deleteNews(@PathVariable Long id) {
        FamilyNewsEntity entity = familyContentScopeService.requireOwned(
                familyNewsRepository.findById(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Khong tim thay tin tuc")));
        familyNewsRepository.delete(entity);
        return ResponseEntity.ok().build();
    }

    private void copyIntroduction(FamilyIntroductionEntity target, FamilyIntroductionEntity source) {
        target.setTitle(InputSanitizationUtils.requirePlainText(source.getTitle(), 255, "Tieu de bai gioi thieu khong duoc de trong"));
        target.setCoverImage(InputSanitizationUtils.normalizeUrl(source.getCoverImage(), 1000));
        target.setContent(InputSanitizationUtils.normalizeMultilineText(source.getContent(), 8000));
        target.setGalleryImages(InputSanitizationUtils.normalizeMultiUrlText(source.getGalleryImages(), 4000, 20));
        target.setVideoUrl(InputSanitizationUtils.normalizeUrl(source.getVideoUrl(), 1000));
        target.setVisible(source.getVisible() == null ? Boolean.TRUE : source.getVisible());
    }

    private void copyContribution(ContributionRecordEntity target, ContributionRecordEntity source) {
        target.setContributionYear(normalizeOptionalYear(source.getContributionYear(), "Nam cong duc khong hop le"));
        target.setContributorName(InputSanitizationUtils.requirePlainText(source.getContributorName(), 150, "Ho ten nguoi dong gop khong duoc de trong"));
        target.setBranchLabel(InputSanitizationUtils.normalizePlainText(source.getBranchLabel(), 150));
        target.setContributionValue(InputSanitizationUtils.normalizePlainText(source.getContributionValue(), 150));
        target.setNote(InputSanitizationUtils.normalizeMultilineText(source.getNote(), 2000));
        target.setContributionDate(InputSanitizationUtils.normalizePlainText(source.getContributionDate(), 50));
        target.setAttachmentUrl(InputSanitizationUtils.normalizeUrl(source.getAttachmentUrl(), 1000));
    }

    private void copyAward(AwardRecordEntity target, AwardRecordEntity source) {
        target.setFullName(InputSanitizationUtils.requirePlainText(source.getFullName(), 150, "Ho ten khong duoc de trong"));
        target.setAwardYear(normalizeYear(source.getAwardYear(), "Nam khen thuong khong hop le"));
        target.setAchievementTitle(InputSanitizationUtils.normalizePlainText(source.getAchievementTitle(), 255));
        target.setEducationLevel(InputSanitizationUtils.normalizePlainText(source.getEducationLevel(), 150));
        target.setSchoolName(InputSanitizationUtils.normalizePlainText(source.getSchoolName(), 255));
        target.setRewardType(InputSanitizationUtils.normalizePlainText(source.getRewardType(), 150));
        target.setRewardValue(InputSanitizationUtils.normalizePlainText(source.getRewardValue(), 150));
        target.setCategoryName(InputSanitizationUtils.normalizePlainText(source.getCategoryName(), 150));
        target.setNote(InputSanitizationUtils.normalizeMultilineText(source.getNote(), 2000));
        target.setProofImage(InputSanitizationUtils.normalizeUrl(source.getProofImage(), 1000));
    }

    private void copyAcademic(AcademicProfileEntity target, AcademicProfileEntity source) {
        target.setFullName(InputSanitizationUtils.requirePlainText(source.getFullName(), 150, "Ho ten khong duoc de trong"));
        target.setBirthYear(normalizeOptionalYear(source.getBirthYear(), "Nam sinh khong hop le"));
        target.setBranchName(InputSanitizationUtils.normalizePlainText(source.getBranchName(), 150));
        target.setDegreeName(InputSanitizationUtils.normalizePlainText(source.getDegreeName(), 150));
        target.setAcademicRank(InputSanitizationUtils.normalizePlainText(source.getAcademicRank(), 150));
        target.setSpecialty(InputSanitizationUtils.normalizePlainText(source.getSpecialty(), 150));
        target.setWorkplace(InputSanitizationUtils.normalizePlainText(source.getWorkplace(), 255));
        target.setCurrentPosition(InputSanitizationUtils.normalizePlainText(source.getCurrentPosition(), 255));
        target.setHighlightAchievement(InputSanitizationUtils.normalizeMultilineText(source.getHighlightAchievement(), 2000));
        target.setPortraitUrl(InputSanitizationUtils.normalizeUrl(source.getPortraitUrl(), 1000));
        target.setNote(InputSanitizationUtils.normalizeMultilineText(source.getNote(), 2000));
    }

    private void copyNews(FamilyNewsEntity target, FamilyNewsEntity source) {
        target.setTitle(InputSanitizationUtils.requirePlainText(source.getTitle(), 255, "Tieu de tin tuc khong duoc de trong"));
        target.setCoverImage(InputSanitizationUtils.normalizeUrl(source.getCoverImage(), 1000));
        target.setSummary(InputSanitizationUtils.normalizeMultilineText(source.getSummary(), 2000));
        target.setContent(InputSanitizationUtils.normalizeMultilineText(source.getContent(), 8000));
        target.setPublishedAt(InputSanitizationUtils.normalizePlainText(source.getPublishedAt(), 50));
        target.setPublisherName(InputSanitizationUtils.normalizePlainText(source.getPublisherName(), 150));
        target.setCategoryName(InputSanitizationUtils.normalizePlainText(source.getCategoryName(), 150));
        target.setVisible(source.getVisible() == null ? Boolean.TRUE : source.getVisible());
        target.setAttachmentUrls(InputSanitizationUtils.normalizeMultiUrlText(source.getAttachmentUrls(), 4000, 20));
    }

    private Integer normalizeYear(Integer value, String message) {
        if (value == null || value < 1800 || value > 3000) {
            throw new IllegalArgumentException(message);
        }
        return value;
    }

    private Integer normalizeOptionalYear(Integer value, String message) {
        if (value == null) {
            return null;
        }
        return normalizeYear(value, message);
    }
}
