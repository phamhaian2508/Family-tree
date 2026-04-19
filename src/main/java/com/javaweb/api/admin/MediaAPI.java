package com.javaweb.api.admin;

import com.javaweb.model.dto.MediaDTO;
import com.javaweb.model.dto.MediaAlbumDTO;
import com.javaweb.service.IMediaService;
import com.javaweb.service.impl.FamilyTreeContextService;
import com.javaweb.utils.InputSanitizationUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/media")
public class MediaAPI {

    @Autowired
    private IMediaService mediaService;

    @Autowired
    private FamilyTreeContextService familyTreeContextService;

    @Value("${media.upload.dir:uploads/media}")
    private String mediaUploadDir;

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> uploadMedia(@RequestParam("files") List<MultipartFile> files,
                                         @RequestParam(value = "displayNames", required = false) List<String> displayNames,
                                         @RequestParam(value = "visibilityScopes", required = false) List<String> visibilityScopes,
                                         @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
                                         @RequestParam(value = "personId", required = false) Long personId,
                                         @RequestParam(value = "branchId", required = false) Long branchId,
                                         @RequestParam(value = "albumId", required = false) Long albumId) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
            List<MediaDTO> uploaded = mediaService.uploadMediaFiles(files, normalizeDisplayNames(displayNames), normalizeScopes(visibilityScopes), personId, branchId, albumId);
            return ResponseEntity.ok(uploaded);
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/albums")
    public ResponseEntity<?> getAlbums(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        List<MediaAlbumDTO> albums = mediaService.findAllAlbumsForAdminView();
        return ResponseEntity.ok(albums);
    }

    @PostMapping("/albums")
    public ResponseEntity<?> createAlbum(@RequestParam("name") String name,
                                         @RequestParam(value = "description", required = false) String description,
                                         @RequestParam(value = "accessScope", required = false) String accessScope,
                                         @RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
                                         @RequestParam(value = "personId", required = false) Long personId,
                                         @RequestParam(value = "branchId", required = false) Long branchId) {
        try {
            familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
            MediaAlbumDTO created = mediaService.createAlbum(name, description, accessScope, personId, branchId);
            return ResponseEntity.ok(created);
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @DeleteMapping("/albums/{id}")
    public ResponseEntity<?> deleteAlbum(@PathVariable("id") Long id) {
        try {
            mediaService.deleteAlbum(id);
            return ResponseEntity.ok().build();
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteMedia(@PathVariable("id") Long id) {
        try {
            mediaService.deleteMedia(id);
            return ResponseEntity.ok().build();
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/{id}/download")
    public ResponseEntity<?> downloadMedia(@PathVariable("id") Long id) {
        try {
            MediaDTO media = mediaService.findMediaById(id);
            String fileUrl = media.getFileUrl();
            if (StringUtils.isBlank(fileUrl)) {
                return ResponseEntity.badRequest().body("Media has empty url");
            }
            int idx = fileUrl.indexOf("/file/");
            if (idx < 0) {
                return ResponseEntity.badRequest().body("Invalid media url");
            }
            String pathPart = fileUrl.substring(idx + "/file/".length());
            int q = pathPart.indexOf('?');
            String storedFileName = q >= 0 ? pathPart.substring(0, q) : pathPart;
            if (StringUtils.isBlank(storedFileName)) {
                return ResponseEntity.badRequest().body("Invalid stored filename");
            }

            Path uploadRoot = Paths.get(mediaUploadDir).toAbsolutePath().normalize();
            Path filePath = uploadRoot.resolve(storedFileName).normalize();
            if (!filePath.startsWith(uploadRoot) || !Files.exists(filePath) || !Files.isRegularFile(filePath)) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new UrlResource(filePath.toUri());
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = resolveContentTypeByExtension(storedFileName);
            }
            String downloadName = InputSanitizationUtils.sanitizeContentDispositionFilename(
                    StringUtils.isNotBlank(media.getFileName()) ? media.getFileName() : storedFileName,
                    storedFileName);
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header("X-Content-Type-Options", "nosniff")
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + downloadName + "\"")
                    .body(resource);
        } catch (IOException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("message", "Cannot read file"));
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    @GetMapping("/file/{fileName:.+}")
    public ResponseEntity<?> getMediaFile(@PathVariable("fileName") String fileName) {
        if (StringUtils.isBlank(fileName)
                || fileName.contains("..")
                || fileName.contains("/")
                || fileName.contains("\\")) {
            return ResponseEntity.badRequest().body("Invalid file name");
        }
        try {
            mediaService.validateCurrentUserCanAccessStoredFile(fileName);
        } catch (AccessDeniedException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        }

        Path uploadRoot = Paths.get(mediaUploadDir).toAbsolutePath().normalize();
        Path filePath = uploadRoot.resolve(fileName).normalize();
        if (!filePath.startsWith(uploadRoot) || !Files.exists(filePath) || !Files.isRegularFile(filePath)) {
            return ResponseEntity.notFound().build();
        }

        try {
            Resource resource = new UrlResource(filePath.toUri());
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = resolveContentTypeByExtension(fileName);
            }
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header("X-Content-Type-Options", "nosniff")
                    .header(HttpHeaders.CACHE_CONTROL, "public, max-age=604800")
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + InputSanitizationUtils.sanitizeContentDispositionFilename(fileName, fileName) + "\"")
                    .body(resource);
        } catch (IOException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("message", "Cannot read file"));
        }
    }

    private String resolveContentTypeByExtension(String fileName) {
        String lower = fileName == null ? "" : fileName.toLowerCase();
        if (lower.endsWith(".mp4")) return "video/mp4";
        if (lower.endsWith(".mov")) return "video/quicktime";
        if (lower.endsWith(".webm")) return "video/webm";
        if (lower.endsWith(".mkv")) return "video/x-matroska";
        if (lower.endsWith(".avi")) return "video/x-msvideo";
        if (lower.endsWith(".mp3")) return "audio/mpeg";
        if (lower.endsWith(".wav")) return "audio/wav";
        if (lower.endsWith(".m4a")) return "audio/mp4";
        if (lower.endsWith(".ogg")) return "audio/ogg";
        if (lower.endsWith(".flac")) return "audio/flac";
        if (lower.endsWith(".png")) return "image/png";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".gif")) return "image/gif";
        return MediaType.APPLICATION_OCTET_STREAM_VALUE;
    }

    private List<String> normalizeDisplayNames(List<String> displayNames) {
        if (displayNames == null) {
            return null;
        }
        List<String> normalized = new ArrayList<>();
        for (String item : displayNames) {
            normalized.add(item == null ? null : item.trim());
        }
        return normalized;
    }

    private List<String> normalizeScopes(List<String> scopes) {
        if (scopes == null) {
            return null;
        }
        List<String> normalized = new ArrayList<>();
        for (String item : scopes) {
            normalized.add(item == null ? null : item.trim().toUpperCase());
        }
        return normalized;
    }
}
