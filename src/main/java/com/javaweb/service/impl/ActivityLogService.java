package com.javaweb.service.impl;

import com.javaweb.entity.ActivityLogEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.model.dto.ActivityLogDTO;
import com.javaweb.model.dto.SecurityAuditDashboardDTO;
import com.javaweb.repository.ActivityLogRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.service.IActivityLogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityLogService implements IActivityLogService {

    private static final String LOGIN_SUCCESS = "LOGIN_SUCCESS";
    private static final String LOGIN_FAILED = "LOGIN_FAILED";
    private static final String LOGOUT = "LOGOUT";
    private static final String ACCESS_DENIED = "ACCESS_DENIED";

    @Autowired
    private ActivityLogRepository activityLogRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public void logLoginSuccess(String username, HttpServletRequest request) {
        saveLog(username, LOGIN_SUCCESS, buildDescription("Đăng nhập thành công", request));
    }

    @Override
    @Transactional
    public void logLoginFailed(String username, HttpServletRequest request) {
        saveLog(username, LOGIN_FAILED, buildDescription("Đăng nhập thất bại", request));
    }

    @Override
    @Transactional
    public void logLogout(String username, HttpServletRequest request) {
        saveLog(username, LOGOUT, buildDescription("Đăng xuất", request));
    }

    @Override
    @Transactional
    public void logCustomAction(String username, String action, String summary, HttpServletRequest request) {
        if (StringUtils.isBlank(action) || StringUtils.isBlank(summary)) {
            return;
        }
        saveLog(username, action.trim(), buildDescription(summary.trim(), request));
    }

    @Override
    @Transactional
    public void logAccessDenied(String username, HttpServletRequest request, String resource) {
        String safeResource = StringUtils.defaultIfBlank(resource, "/unknown");
        saveLog(username, ACCESS_DENIED, buildDescription("Bị từ chối truy cập tài nguyên " + safeResource, request));
    }

    @Override
    public SecurityAuditDashboardDTO getDashboardData() {
        SecurityAuditDashboardDTO dto = new SecurityAuditDashboardDTO();

        Date now = new Date();
        Date sevenDaysAgo = atStartOfDay(addDays(now, -6));
        List<String> securityActions = Arrays.asList(
                LOGIN_SUCCESS, LOGIN_FAILED, LOGOUT, ACCESS_DENIED
        );
        List<String> dataChangeActions = Arrays.asList(
                "FAMILY_TREE_CHANGE",
                "FAMILY_TREE_CHANGE_FAILED",
                "MEDIA_CHANGE",
                "MEDIA_CHANGE_FAILED",
                "BRANCH_CHANGE",
                "BRANCH_CHANGE_FAILED",
                "USER_ACCOUNT_CHANGE",
                "USER_ACCOUNT_CHANGE_FAILED",
                "USER_PASSWORD_CHANGE",
                "USER_PASSWORD_CHANGE_FAILED",
                "USER_PASSWORD_RESET",
                "USER_PASSWORD_RESET_FAILED",
                "LIVESTREAM_CONTROL",
                "LIVESTREAM_CONTROL_FAILED"
        );
        List<String> highRiskActions = Arrays.asList(
                LOGIN_FAILED,
                ACCESS_DENIED,
                "USER_PASSWORD_RESET",
                "USER_PASSWORD_RESET_FAILED",
                "USER_PASSWORD_CHANGE_FAILED",
                "USER_ACCOUNT_CHANGE_FAILED",
                "FAMILY_TREE_CHANGE_FAILED",
                "MEDIA_CHANGE_FAILED",
                "BRANCH_CHANGE_FAILED",
                "LIVESTREAM_CONTROL_FAILED"
        );

        long total = activityLogRepository.countByTimestampAfter(sevenDaysAgo);
        long loginSuccess = activityLogRepository.countByActionAndTimestampAfter(LOGIN_SUCCESS, sevenDaysAgo);
        long loginFailed = activityLogRepository.countByActionAndTimestampAfter(LOGIN_FAILED, sevenDaysAgo);
        long logout = activityLogRepository.countByActionAndTimestampAfter(LOGOUT, sevenDaysAgo);
        long securityEvents = activityLogRepository.countByActionInAndTimestampAfter(securityActions, sevenDaysAgo);
        long dataChangeEvents = activityLogRepository.countByActionInAndTimestampAfter(dataChangeActions, sevenDaysAgo);
        long highRiskEvents = activityLogRepository.countByActionInAndTimestampAfter(highRiskActions, sevenDaysAgo);

        dto.setTotalEvents7Days(total);
        dto.setSecurityEvents7Days(securityEvents);
        dto.setDataChangeEvents7Days(dataChangeEvents);
        dto.setHighRiskEvents7Days(highRiskEvents);
        dto.setLoginSuccess7Days(loginSuccess);
        dto.setLoginFailed7Days(loginFailed);
        dto.setLogout7Days(logout);
        dto.setSuccessRate((loginSuccess + loginFailed) == 0 ? 0D
                : (loginSuccess * 100D / (loginSuccess + loginFailed)));

        buildFailedLoginSeries(dto, sevenDaysAgo, now);
        buildRecentLogs(dto);

        return dto;
    }

    private void buildRecentLogs(SecurityAuditDashboardDTO dto) {
        List<ActivityLogEntity> entities = activityLogRepository.findRecentWithUser(PageRequest.of(0, 200));
        List<ActivityLogDTO> logs = new ArrayList<>();
        for (ActivityLogEntity entity : entities) {
            ActivityLogDTO item = new ActivityLogDTO();
            if (entity.getUser() != null) {
                item.setUserName(entity.getUser().getUserName());
                item.setFullName(entity.getUser().getFullName());
            }
            item.setAction(entity.getAction());
            item.setActionLabel(mapActionLabel(entity.getAction()));
            item.setRiskLevel(mapRiskLevel(entity.getAction()));
            item.setDescription(entity.getDescription());
            item.setTimestamp(entity.getTimestamp());
            logs.add(item);
        }
        dto.setRecentLogs(logs);
    }

    private void buildFailedLoginSeries(SecurityAuditDashboardDTO dto, Date from, Date to) {
        List<ActivityLogEntity> logs = activityLogRepository
                .findByActionAndTimestampBetweenOrderByTimestampAsc(LOGIN_FAILED, from, to);

        Map<String, Long> failedByDay = new LinkedHashMap<>();
        SimpleDateFormat keyFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat labelFormat = new SimpleDateFormat("dd/MM");

        Calendar cursor = Calendar.getInstance();
        cursor.setTime(from);
        for (int i = 0; i < 7; i++) {
            Date current = cursor.getTime();
            String key = keyFormat.format(current);
            failedByDay.put(key, 0L);
            dto.getDayLabels().add(labelFormat.format(current));
            cursor.add(Calendar.DATE, 1);
        }

        for (ActivityLogEntity log : logs) {
            if (log.getTimestamp() == null) {
                continue;
            }
            String key = keyFormat.format(log.getTimestamp());
            if (failedByDay.containsKey(key)) {
                failedByDay.put(key, failedByDay.get(key) + 1);
            }
        }
        dto.setFailedLoginSeries(new ArrayList<>(failedByDay.values()));
    }

    private void saveLog(String username, String action, String description) {
        if (StringUtils.isBlank(username)) {
            return;
        }
        UserEntity user = userRepository.findOneByUserName(username.trim());
        if (user == null) {
            return;
        }
        ActivityLogEntity log = new ActivityLogEntity();
        log.setUser(user);
        log.setAction(action);
        log.setDescription(description);
        log.setTimestamp(new Date());
        activityLogRepository.save(log);
    }

    private String buildDescription(String prefix, HttpServletRequest request) {
        String ip = getClientIp(request);
        String agent = request != null ? request.getHeader("User-Agent") : null;
        String shortAgent = StringUtils.abbreviate(StringUtils.defaultString(agent), 120);
        return prefix + " | IP: " + ip + " | Agent: " + shortAgent;
    }

    private String getClientIp(HttpServletRequest request) {
        if (request == null) {
            return "unknown";
        }
        String forwarded = request.getHeader("X-Forwarded-For");
        if (StringUtils.isNotBlank(forwarded)) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (StringUtils.isNotBlank(realIp)) {
            return realIp.trim();
        }
        return StringUtils.defaultIfBlank(request.getRemoteAddr(), "unknown");
    }

    private Date addDays(Date source, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(source);
        calendar.add(Calendar.DATE, days);
        return calendar.getTime();
    }

    private Date atStartOfDay(Date source) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(source);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    private String mapActionLabel(String action) {
        if (StringUtils.isBlank(action)) {
            return "Khác";
        }
        switch (action) {
            case LOGIN_SUCCESS:
                return "Đăng nhập thành công";
            case LOGIN_FAILED:
                return "Đăng nhập thất bại";
            case LOGOUT:
                return "Đăng xuất";
            case ACCESS_DENIED:
                return "Bị từ chối truy cập";
            case "FAMILY_TREE_CHANGE":
                return "Cập nhật gia phả";
            case "FAMILY_TREE_CHANGE_FAILED":
                return "Cập nhật gia phả thất bại";
            case "MEDIA_CHANGE":
                return "Cập nhật media";
            case "MEDIA_CHANGE_FAILED":
                return "Cập nhật media thất bại";
            case "BRANCH_CHANGE":
                return "Cập nhật chi nhánh";
            case "BRANCH_CHANGE_FAILED":
                return "Cập nhật chi nhánh thất bại";
            case "USER_ACCOUNT_CHANGE":
                return "Cập nhật tài khoản";
            case "USER_ACCOUNT_CHANGE_FAILED":
                return "Cập nhật tài khoản thất bại";
            case "USER_PASSWORD_CHANGE":
                return "Đổi mật khẩu";
            case "USER_PASSWORD_CHANGE_FAILED":
                return "Đổi mật khẩu thất bại";
            case "USER_PASSWORD_RESET":
                return "Đặt lại mật khẩu";
            case "USER_PASSWORD_RESET_FAILED":
                return "Đặt lại mật khẩu thất bại";
            case "LIVESTREAM_CONTROL":
                return "Tác động livestream";
            case "LIVESTREAM_CONTROL_FAILED":
                return "Tác động livestream thất bại";
            case "ADMIN_PAGE_VIEW":
                return "Truy cập trang nhạy cảm";
            default:
                return action;
        }
    }

    private String mapRiskLevel(String action) {
        if (StringUtils.isBlank(action)) {
            return "LOW";
        }
        if (LOGIN_FAILED.equals(action)
                || ACCESS_DENIED.equals(action)
                || action.endsWith("_FAILED")
                || "USER_PASSWORD_RESET".equals(action)) {
            return "HIGH";
        }
        if ("USER_PASSWORD_CHANGE".equals(action)
                || "USER_ACCOUNT_CHANGE".equals(action)
                || "LIVESTREAM_CONTROL".equals(action)) {
            return "MEDIUM";
        }
        return "LOW";
    }
}


