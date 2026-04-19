package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.entity.MediaEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.model.dto.FamilyTreeDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.FamilyTreeRepository;
import com.javaweb.repository.MediaAlbumRepository;
import com.javaweb.repository.MediaRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.SpouseRelationRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.security.utils.SecurityUtils;
import com.javaweb.service.IFamilyTreeService;
import com.javaweb.utils.InputSanitizationUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class FamilyTreeService implements IFamilyTreeService {
    @Value("${media.upload.dir:uploads/media}")
    private String mediaUploadDir;

    private final FamilyTreeRepository familyTreeRepository;
    private final BranchRepository branchRepository;
    private final PersonRepository personRepository;
    private final MediaRepository mediaRepository;
    private final MediaAlbumRepository mediaAlbumRepository;
    private final SpouseRelationRepository spouseRelationRepository;
    private final UserRepository userRepository;
    private final FamilyTreeContextService familyTreeContextService;

    public FamilyTreeService(FamilyTreeRepository familyTreeRepository,
                             BranchRepository branchRepository,
                             PersonRepository personRepository,
                             MediaRepository mediaRepository,
                             MediaAlbumRepository mediaAlbumRepository,
                             SpouseRelationRepository spouseRelationRepository,
                             UserRepository userRepository,
                             FamilyTreeContextService familyTreeContextService) {
        this.familyTreeRepository = familyTreeRepository;
        this.branchRepository = branchRepository;
        this.personRepository = personRepository;
        this.mediaRepository = mediaRepository;
        this.mediaAlbumRepository = mediaAlbumRepository;
        this.spouseRelationRepository = spouseRelationRepository;
        this.userRepository = userRepository;
        this.familyTreeContextService = familyTreeContextService;
    }

    @Override
    @Transactional(readOnly = true)
    public List<FamilyTreeDTO> findAll() {
        return familyTreeRepository.findAll().stream()
                .sorted((left, right) -> Long.compare(left.getId(), right.getId()))
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public FamilyTreeDTO findById(Long id) {
        FamilyTreeEntity entity = familyTreeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cây gia phả id=" + id));
        return toDto(entity);
    }

    @Override
    @Transactional
    public FamilyTreeDTO create(FamilyTreeDTO familyTreeDTO) {
        validate(familyTreeDTO);
        FamilyTreeEntity entity = new FamilyTreeEntity();
        apply(entity, familyTreeDTO);
        entity.setOwner(resolveCurrentUser());
        FamilyTreeEntity saved = familyTreeRepository.save(entity);

        BranchEntity mainBranch = new BranchEntity();
        mainBranch.setFamilyTree(saved);
        mainBranch.setName("Chính");
        mainBranch.setDescription("Chi gốc mặc định của " + saved.getName());
        branchRepository.save(mainBranch);

        return toDto(saved);
    }

    @Override
    @Transactional
    public FamilyTreeDTO update(Long id, FamilyTreeDTO familyTreeDTO) {
        validate(familyTreeDTO);
        FamilyTreeEntity entity = familyTreeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cây gia phả id=" + id));
        apply(entity, familyTreeDTO);
        return toDto(familyTreeRepository.save(entity));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        FamilyTreeEntity entity = familyTreeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cây gia phả id=" + id));
        long totalMembers = personRepository.countByFamilyTree_Id(id);
        if (totalMembers > 0) {
            throw new IllegalArgumentException("Chỉ được xóa cây gia phả khi số thành viên bằng 0");
        }

        List<MediaEntity> mediaItems = mediaRepository.findByFamilyTree_Id(id);
        for (MediaEntity media : mediaItems) {
            deletePhysicalFile(media != null ? media.getFileUrl() : null);
        }

        mediaRepository.deleteByFamilyTree_Id(id);
        mediaAlbumRepository.deleteByFamilyTree_Id(id);
        spouseRelationRepository.deleteByFamilyTree_Id(id);
        personRepository.deleteByFamilyTree_Id(id);
        branchRepository.deleteByFamilyTree_Id(id);
        familyTreeRepository.delete(entity);
        familyTreeContextService.clearIfMatches(id);
    }

    private FamilyTreeDTO toDto(FamilyTreeEntity entity) {
        FamilyTreeDTO dto = new FamilyTreeDTO();
        dto.setId(entity.getId());
        dto.setCreatedBy(entity.getCreatedBy());
        dto.setCreatedDate(entity.getCreatedDate());
        dto.setModifiedBy(entity.getModifiedBy());
        dto.setModifiedDate(entity.getModifiedDate());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setCoverImage(entity.getCoverImage());
        dto.setOwnerUserId(entity.getOwner() != null ? entity.getOwner().getId() : null);
        dto.setTotalBranches(branchRepository.countByFamilyTree_Id(entity.getId()));
        dto.setTotalMembers(personRepository.countByFamilyTree_Id(entity.getId()));
        dto.setTotalAlbums(mediaAlbumRepository.countByFamilyTree_Id(entity.getId()));
        return dto;
    }

    private void apply(FamilyTreeEntity entity, FamilyTreeDTO dto) {
        entity.setName(InputSanitizationUtils.requirePlainText(dto.getName(), 150, "Ten gia pha khong duoc de trong"));
        entity.setDescription(InputSanitizationUtils.normalizeMultilineText(dto.getDescription(), 1000));
        entity.setCoverImage(InputSanitizationUtils.normalizeUrl(dto.getCoverImage(), 1000));
    }

    private void validate(FamilyTreeDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Du lieu cay gia pha khong hop le");
        }
        InputSanitizationUtils.requirePlainText(dto.getName(), 150, "Ten gia pha khong duoc de trong");
        InputSanitizationUtils.normalizeMultilineText(dto.getDescription(), 1000);
        InputSanitizationUtils.normalizeUrl(dto.getCoverImage(), 1000);
    }

    private UserEntity resolveCurrentUser() {
        if (SecurityUtils.getPrincipal() == null) {
            return null;
        }
        String username = SecurityUtils.getPrincipal().getUsername();
        return userRepository.findOneByUserName(username);
    }

    private void deletePhysicalFile(String fileUrl) {
        if (StringUtils.isBlank(fileUrl)) {
            return;
        }
        String prefix = "/api/media/file/";
        if (!fileUrl.startsWith(prefix)) {
            return;
        }
        String value = fileUrl.substring(prefix.length());
        int queryIndex = value.indexOf('?');
        String storedFileName = queryIndex >= 0 ? value.substring(0, queryIndex) : value;
        if (StringUtils.isBlank(storedFileName)) {
            return;
        }
        Path target = Paths.get(mediaUploadDir).toAbsolutePath().normalize().resolve(storedFileName).normalize();
        try {
            Files.deleteIfExists(target);
        } catch (Exception ignored) {
        }
    }
}
