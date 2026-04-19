package com.javaweb.service.impl;

import com.javaweb.constant.SystemConstant;
import com.javaweb.converter.UserConverter;
import com.javaweb.entity.PersonEntity;
import com.javaweb.model.dto.PasswordDTO;
import com.javaweb.model.dto.UserDTO;
import com.javaweb.entity.RoleEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.exception.MyException;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.RoleRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.service.IUserService;
import com.javaweb.utils.InputSanitizationUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class UserService implements IUserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserConverter userConverter;

    @Autowired
    private PersonRepository personRepository;

    @Override
    public UserDTO findOneByUserNameAndStatus(String name, int status) {
        return userConverter.convertToDto(userRepository.findOneByUserNameAndStatus(name, status));
    }

    @Override
    public List<UserDTO> getUsers(String searchValue, Pageable pageable) {
        Page<UserEntity> users = null;
        if (StringUtils.isNotBlank(searchValue)) {
            users = userRepository.findByUserNameContainingIgnoreCaseOrFullNameContainingIgnoreCaseAndStatusNot(searchValue, searchValue, 0, pageable);
        } else {
            users = userRepository.findByStatusNot(0, pageable);
        }
        List<UserEntity> newsEntities = users.getContent();
        List<UserDTO> result = new ArrayList<>();
        for (UserEntity userEntity : newsEntities) {
            UserDTO userDTO = userConverter.convertToDto(userEntity);
            userDTO.setRoleCode(userEntity.getRoles().get(0).getCode());
            result.add(userDTO);
        }
        return result;
    }



    @Override
    public List<UserDTO> getAllUsers(Pageable pageable) {
        List<UserEntity> userEntities = userRepository.getAllUsers(pageable);
        List<UserDTO> results = new ArrayList<>();
        for (UserEntity userEntity : userEntities) {
            UserDTO userDTO = userConverter.convertToDto(userEntity);
            userDTO.setRoleCode(userEntity.getRoles().get(0).getCode());
            results.add(userDTO);
        }
        return results;
    }

    @Override
    public Map<Long, String> getStaffs() {
        Map<Long, String> listStaffs = new HashMap<>();
        List<UserEntity> staffs = userRepository.findByStatusAndRoles_Code(1, "STAFF");
        for(UserEntity it : staffs){
            listStaffs.put(it.getId(), it.getFullName());
        }
        return listStaffs;
    }

    @Override
    public int countTotalItems() {
        return userRepository.countTotalItem();
    }



    @Override
    public int getTotalItems(String searchValue) {
        int totalItem = 0;
        if (StringUtils.isNotBlank(searchValue)) {
            totalItem = (int) userRepository.countByUserNameContainingIgnoreCaseOrFullNameContainingIgnoreCaseAndStatusNot(searchValue, searchValue, 0);
        } else {
            totalItem = (int) userRepository.countByStatusNot(0);
        }
        return totalItem;
    }

    @Override
    public UserDTO findOneByUserName(String userName) {
        UserEntity userEntity = userRepository.findOneByUserName(userName);
        UserDTO userDTO = userConverter.convertToDto(userEntity);
        return userDTO;
    }

    @Override
    public UserDTO findUserById(long id) {
        UserEntity entity = userRepository.findById(id).get();
        List<RoleEntity> roles = entity.getRoles();
        UserDTO dto = userConverter.convertToDto(entity);
        roles.forEach(item -> {
            dto.setRoleCode(item.getCode());
        });
        return dto;
    }

    @Override
    @Transactional
    public UserDTO insert(UserDTO newUser) {
        if (!isCurrentUserManager()) {
            throw new AccessDeniedException("access_denied");
        }
        if (newUser == null) {
            throw new IllegalArgumentException("user_payload_invalid");
        }
        String normalizedUserName = InputSanitizationUtils.normalizeUsername(newUser.getUserName());
        if (userRepository.findOneByUserName(normalizedUserName) != null) {
            throw new IllegalArgumentException("username_invalid");
        }
        RoleEntity role = roleRepository.findOneByCode(newUser.getRoleCode());
        if (role == null) {
            throw new IllegalArgumentException("role_invalid");
        }
        UserEntity userEntity = userConverter.convertToEntity(newUser);
        // Prevent clients from forcing update existing row via crafted id.
        userEntity.setId(null);
        userEntity.setUserName(normalizedUserName);
        userEntity.setFullName(sanitizeFullName(newUser.getFullName()));
        userEntity.setRoles(Stream.of(role).collect(Collectors.toList()));
        userEntity.setStatus(1);
        userEntity.setPassword(passwordEncoder.encode(SystemConstant.PASSWORD_DEFAULT));
        UserEntity savedUser = userRepository.save(userEntity);
        ensureUserMappedToPerson(savedUser, null, null, null);
        return userConverter.convertToDto(savedUser);
    }

    @Override
    @Transactional
    public UserDTO register(String fullName, String userName, String gender, LocalDate dob, String email, String phone, String password, String confirmPassword) throws MyException {
        if (StringUtils.isBlank(fullName) || StringUtils.isBlank(userName) || StringUtils.isBlank(password)
                || StringUtils.isBlank(confirmPassword) || dob == null) {
            throw new MyException("register_required_fields");
        }
        String normalizedFullName = sanitizeRegisterFullName(fullName);
        String normalizedUserName;
        try {
            normalizedUserName = InputSanitizationUtils.normalizeUsername(userName);
        } catch (IllegalArgumentException ex) {
            throw new MyException("username_invalid");
        }
        if (!password.equals(confirmPassword)) {
            throw new MyException("register_confirm_password_not_match");
        }
        if (userRepository.findOneByUserName(normalizedUserName) != null) {
            throw new MyException("register_username_existed");
        }
        String normalizedEmail;
        try {
            normalizedEmail = InputSanitizationUtils.normalizeEmail(email);
        } catch (IllegalArgumentException ex) {
            throw new MyException("email_invalid");
        }
        if (normalizedEmail != null && userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new MyException("register_email_existed");
        }
        String normalizedGender = StringUtils.trimToEmpty(gender).toLowerCase();
        if (!"male".equals(normalizedGender) && !"female".equals(normalizedGender) && !"other".equals(normalizedGender)) {
            throw new MyException("register_gender_invalid");
        }
        RoleEntity role = roleRepository.findAll().stream()
                .filter(item -> item.getCode() != null)
                .filter(item -> {
                    String normalized = item.getCode().trim().toUpperCase();
                    return SystemConstant.USER_ROLE.equals(normalized) || "USER".equals(normalized);
                })
                .findFirst()
                .orElse(null);
        if (role == null) {
            throw new MyException("register_role_not_found");
        }
        UserEntity userEntity = new UserEntity();
        userEntity.setUserName(normalizedUserName);
        userEntity.setFullName(normalizedFullName);
        userEntity.setEmail(normalizedEmail);
        try {
            userEntity.setPhone(InputSanitizationUtils.normalizePhone(phone));
        } catch (IllegalArgumentException ex) {
            throw new MyException("phone_invalid");
        }
        userEntity.setStatus(1);
        userEntity.setPassword(passwordEncoder.encode(password));
        userEntity.setRoles(Stream.of(role).collect(Collectors.toList()));
        UserEntity savedUser = userRepository.save(userEntity);
        ensureUserMappedToPerson(savedUser, normalizedFullName, normalizedGender, dob);
        return userConverter.convertToDto(savedUser);
    }

    @Override
    @Transactional
    public UserDTO update(Long id, UserDTO updateUser) {
        if (!isCurrentUserManager()) {
            throw new AccessDeniedException("access_denied");
        }
        if (updateUser == null) {
            throw new IllegalArgumentException("user_payload_invalid");
        }
        RoleEntity role = roleRepository.findOneByCode(updateUser.getRoleCode());
        if (role == null) {
            throw new IllegalArgumentException("role_invalid");
        }
        UserEntity oldUser = findUserByIdOrThrow(id);
        UserEntity userEntity = userConverter.convertToEntity(updateUser);
        // Force update target to path id, ignore any id from client payload.
        userEntity.setId(oldUser.getId());
        userEntity.setUserName(oldUser.getUserName());
        userEntity.setFullName(sanitizeFullName(updateUser.getFullName()));
        userEntity.setStatus(oldUser.getStatus());
        userEntity.setEmail(oldUser.getEmail());
        userEntity.setPhone(oldUser.getPhone());
        userEntity.setRoles(Stream.of(role).collect(Collectors.toList()));
        userEntity.setPassword(oldUser.getPassword());
        UserEntity savedUser = userRepository.save(userEntity);
        ensureUserMappedToPerson(savedUser, null, null, null);
        return userConverter.convertToDto(savedUser);
    }

    @Override
    @Transactional
    public void updatePassword(long id, PasswordDTO passwordDTO) throws MyException {
        UserEntity currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            throw new MyException("access_denied");
        }
        // Change-password endpoint is strictly for self-service only.
        if (!currentUser.getId().equals(id)) {
            throw new MyException("access_denied");
        }
        if (passwordDTO == null
                || StringUtils.isBlank(passwordDTO.getOldPassword())
                || StringUtils.isBlank(passwordDTO.getNewPassword())
                || StringUtils.isBlank(passwordDTO.getConfirmPassword())) {
            throw new MyException(SystemConstant.CHANGE_PASSWORD_FAIL);
        }
        UserEntity user = userRepository.findById(id).orElse(null);
        if (user == null) {
            throw new MyException("user_not_found");
        }
        if (passwordEncoder.matches(passwordDTO.getOldPassword(), user.getPassword())
                && passwordDTO.getNewPassword().equals(passwordDTO.getConfirmPassword())) {
            if (!isStrongPassword(passwordDTO.getNewPassword())) {
                throw new MyException("change_password_weak");
            }
            if (passwordEncoder.matches(passwordDTO.getNewPassword(), user.getPassword())) {
                throw new MyException("change_password_same_old");
            }
            user.setPassword(passwordEncoder.encode(passwordDTO.getNewPassword()));
            userRepository.save(user);
        } else {
            throw new MyException(SystemConstant.CHANGE_PASSWORD_FAIL);
        }
    }

    @Override
    @Transactional
    public UserDTO resetPassword(long id) {
        if (!isCurrentUserManager()) {
            throw new AccessDeniedException("access_denied");
        }
        UserEntity userEntity = findUserByIdOrThrow(id);
        userEntity.setPassword(passwordEncoder.encode(SystemConstant.PASSWORD_DEFAULT));
        return userConverter.convertToDto(userRepository.save(userEntity));
    }

    @Override
    @Transactional
    public UserDTO updateProfileOfUser(String username, UserDTO updateUser) {
        if (updateUser == null) {
            throw new IllegalArgumentException("user_payload_invalid");
        }
        UserEntity currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            throw new AccessDeniedException("access_denied");
        }
        boolean isManager = isCurrentUserManager();
        if (!isManager && !StringUtils.equals(currentUser.getUserName(), username)) {
            throw new AccessDeniedException("access_denied");
        }
        UserEntity oldUser = userRepository.findOneByUserName(username);
        if (oldUser == null) {
            throw new IllegalArgumentException("user_not_found");
        }
        oldUser.setFullName(sanitizeFullName(updateUser.getFullName()));
        return userConverter.convertToDto(userRepository.save(oldUser));
    }

    @Override
    @Transactional
    public void delete(long[] ids) {
        if (!isCurrentUserManager()) {
            throw new AccessDeniedException("access_denied");
        }
        for (Long item : ids) {
            UserEntity userEntity = findUserByIdOrThrow(item);
            userEntity.setStatus(0);
            userRepository.save(userEntity);
        }
    }

    private UserEntity findUserByIdOrThrow(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("user_not_found"));
    }

    private String sanitizeRegisterFullName(String fullName) throws MyException {
        try {
            return sanitizeFullName(fullName);
        } catch (IllegalArgumentException ex) {
            throw new MyException("register_fullname_invalid");
        }
    }

    private String sanitizeFullName(String fullName) {
        String normalized = InputSanitizationUtils.normalizePlainText(fullName, 100).replaceAll("\\s+", " ");
        if (StringUtils.isBlank(normalized)) {
            throw new IllegalArgumentException("full_name_invalid");
        }
        if (normalized.contains("<") || normalized.contains(">")) {
            throw new IllegalArgumentException("full_name_invalid");
        }
        return normalized;
    }

    private boolean isStrongPassword(String password) {
        if (StringUtils.isBlank(password)) {
            return false;
        }
        if (password.length() < 8 || password.length() > 72) {
            return false;
        }
        boolean hasLetter = password.matches(".*[A-Za-z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        return hasLetter && hasDigit;
    }

    private UserEntity getCurrentAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null
                || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            return null;
        }
        return userRepository.findOneByUserName(authentication.getName());
    }

    private boolean isCurrentUserManager() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getAuthorities() == null) {
            return false;
        }
        return authentication.getAuthorities().stream()
                .anyMatch(item -> "ROLE_MANAGER".equalsIgnoreCase(item.getAuthority()));
    }

    private void ensureUserMappedToPerson(UserEntity user, String personFullName, String personGender, LocalDate personDob) {
        if (user == null || user.getId() == null) {
            return;
        }
        Optional<PersonEntity> existed = personRepository.findByUserId(user.getId());
        if (existed.isPresent()) {
            return;
        }

        PersonEntity person = new PersonEntity();
        person.setUserId(user.getId());
        person.setFullName(StringUtils.isNotBlank(personFullName)
                ? personFullName.trim()
                : (user.getFullName() != null && !user.getFullName().trim().isEmpty()
                    ? user.getFullName().trim()
                    : user.getUserName()));
        if (StringUtils.isNotBlank(personGender)) {
            person.setGender(personGender.trim().toLowerCase());
        }
        if (personDob != null) {
            person.setDob(java.sql.Date.valueOf(personDob));
        }
        personRepository.save(person);
    }
}
