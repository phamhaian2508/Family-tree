package com.javaweb.api.admin;

import com.javaweb.entity.*;
import com.javaweb.repository.*;
import com.javaweb.service.impl.FamilyContentScopeService;
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
        target.setTitle(source.getTitle());
        target.setCoverImage(source.getCoverImage());
        target.setContent(source.getContent());
        target.setGalleryImages(source.getGalleryImages());
        target.setVideoUrl(source.getVideoUrl());
        target.setVisible(source.getVisible() == null ? Boolean.TRUE : source.getVisible());
    }

    private void copyContribution(ContributionRecordEntity target, ContributionRecordEntity source) {
        target.setContributionYear(source.getContributionYear());
        target.setContributorName(source.getContributorName());
        target.setBranchLabel(source.getBranchLabel());
        target.setContributionValue(source.getContributionValue());
        target.setNote(source.getNote());
        target.setContributionDate(source.getContributionDate());
        target.setAttachmentUrl(source.getAttachmentUrl());
    }

    private void copyAward(AwardRecordEntity target, AwardRecordEntity source) {
        target.setFullName(source.getFullName());
        target.setAwardYear(source.getAwardYear());
        target.setAchievementTitle(source.getAchievementTitle());
        target.setEducationLevel(source.getEducationLevel());
        target.setSchoolName(source.getSchoolName());
        target.setRewardType(source.getRewardType());
        target.setRewardValue(source.getRewardValue());
        target.setCategoryName(source.getCategoryName());
        target.setNote(source.getNote());
        target.setProofImage(source.getProofImage());
    }

    private void copyAcademic(AcademicProfileEntity target, AcademicProfileEntity source) {
        target.setFullName(source.getFullName());
        target.setBirthYear(source.getBirthYear());
        target.setBranchName(source.getBranchName());
        target.setDegreeName(source.getDegreeName());
        target.setAcademicRank(source.getAcademicRank());
        target.setSpecialty(source.getSpecialty());
        target.setWorkplace(source.getWorkplace());
        target.setCurrentPosition(source.getCurrentPosition());
        target.setHighlightAchievement(source.getHighlightAchievement());
        target.setPortraitUrl(source.getPortraitUrl());
        target.setNote(source.getNote());
    }

    private void copyNews(FamilyNewsEntity target, FamilyNewsEntity source) {
        target.setTitle(source.getTitle());
        target.setCoverImage(source.getCoverImage());
        target.setSummary(source.getSummary());
        target.setContent(source.getContent());
        target.setPublishedAt(source.getPublishedAt());
        target.setPublisherName(source.getPublisherName());
        target.setCategoryName(source.getCategoryName());
        target.setVisible(source.getVisible() == null ? Boolean.TRUE : source.getVisible());
        target.setAttachmentUrls(source.getAttachmentUrls());
    }
}
