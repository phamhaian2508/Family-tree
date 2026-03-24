package com.javaweb.controller.admin;

import com.javaweb.entity.PersonEntity;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.MediaRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.UserRepository;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller(value = "homeControllerOfAdmin")
public class HomeController {

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private MediaRepository mediaRepository;

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value = "/admin/home", method = RequestMethod.GET)
    public ModelAndView homePage() {
        ModelAndView mav = new ModelAndView("admin/home");

        long totalMembers = personRepository.countByBranchIsNotNull();
        long totalBranches = branchRepository.count();
        long totalMediaFiles = mediaRepository.count();
        long activeUsers = userRepository.countByStatusNot(0);

        Date currentMonthStart = atStartOfMonth(LocalDate.now());
        Date previousMonthStart = atStartOfMonth(LocalDate.now().minusMonths(1));
        Date nextMonthStart = atStartOfMonth(LocalDate.now().plusMonths(1));

        long membersCurrentMonth = personRepository.countByBranchIsNotNullAndCreatedDateBetween(currentMonthStart, nextMonthStart);
        long membersPreviousMonth = personRepository.countByBranchIsNotNullAndCreatedDateBetween(previousMonthStart, currentMonthStart);

        long branchesCurrentMonth = branchRepository.countByCreatedDateBetween(currentMonthStart, nextMonthStart);
        long branchesPreviousMonth = branchRepository.countByCreatedDateBetween(previousMonthStart, currentMonthStart);

        long mediaCurrentMonth = mediaRepository.countByCreatedDateBetween(currentMonthStart, nextMonthStart);
        long mediaPreviousMonth = mediaRepository.countByCreatedDateBetween(previousMonthStart, currentMonthStart);

        long usersCurrentMonth = userRepository.countByCreatedDateBetween(currentMonthStart, nextMonthStart);
        long usersPreviousMonth = userRepository.countByCreatedDateBetween(previousMonthStart, currentMonthStart);

        mav.addObject("totalMembers", totalMembers);
        mav.addObject("totalBranches", totalBranches);
        mav.addObject("totalMediaFiles", totalMediaFiles);
        mav.addObject("activeUsers", activeUsers);

        mav.addObject("membersGrowth", formatGrowth(membersCurrentMonth, membersPreviousMonth));
        mav.addObject("branchesGrowth", formatGrowth(branchesCurrentMonth, branchesPreviousMonth));
        mav.addObject("mediaGrowth", formatGrowth(mediaCurrentMonth, mediaPreviousMonth));
        mav.addObject("activeUsersGrowth", formatGrowth(usersCurrentMonth, usersPreviousMonth));

        mav.addObject("monthlyStats", buildMonthlyStats(7));
        mav.addObject("recentActivities", buildRecentActivities(4));

        return mav;
    }

    private List<MonthlyStat> buildMonthlyStats(int months) {
        List<MonthlyStat> result = new ArrayList<>();
        LocalDate now = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yyyy");
        for (int i = months - 1; i >= 0; i--) {
            LocalDate month = now.minusMonths(i);
            Date from = atStartOfMonth(month);
            Date to = atStartOfMonth(month.plusMonths(1));
            long newMembers = personRepository.countByBranchIsNotNullAndCreatedDateBetween(from, to);
            long uploadedMedia = mediaRepository.countByCreatedDateBetween(from, to);
            result.add(new MonthlyStat(month.format(formatter), newMembers, uploadedMedia));
        }
        return result;
    }

    // Home activity now focuses on genealogy actions only (new people added)
    private List<HomeActivity> buildRecentActivities(int limit) {
        List<HomeActivity> result = new ArrayList<>();
        List<PersonEntity> recentPersons = personRepository.findRecentCreated(PageRequest.of(0, limit));
        for (PersonEntity person : recentPersons) {
            String actor = "Gia phả";
            String branchName = person.getBranch() != null ? person.getBranch().getName() : "Chưa có chi";
            String personName = StringUtils.defaultIfBlank(person.getFullName(), "Thành viên mới");
            String action = "Thêm mới thành viên: " + personName + " (Chi: " + branchName + ")";
            String timeAgo = toRelativeTime(person.getCreatedDate());
            result.add(new HomeActivity(actor, timeAgo, action));
        }
        return result;
    }

    private String toRelativeTime(Date time) {
        if (time == null) {
            return "vừa xong";
        }
        long diffMillis = Math.max(0L, System.currentTimeMillis() - time.getTime());
        long minutes = diffMillis / (60 * 1000);
        if (minutes < 1) return "vừa xong";
        if (minutes < 60) return minutes + " phút trước";
        long hours = minutes / 60;
        if (hours < 24) return hours + " giờ trước";
        long days = hours / 24;
        return days + " ngày trước";
    }

    private Date atStartOfMonth(LocalDate date) {
        return Date.from(date.withDayOfMonth(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    private String formatGrowth(long current, long previous) {
        if (previous <= 0) {
            return current > 0 ? "+100%" : "0%";
        }
        double percent = ((current - previous) * 100.0) / previous;
        long rounded = Math.round(percent);
        return (rounded >= 0 ? "+" : "") + rounded + "%";
    }

    public static class MonthlyStat {
        private final String monthLabel;
        private final long newMembers;
        private final long uploadedMedia;

        public MonthlyStat(String monthLabel, long newMembers, long uploadedMedia) {
            this.monthLabel = monthLabel;
            this.newMembers = newMembers;
            this.uploadedMedia = uploadedMedia;
        }

        public String getMonthLabel() {
            return monthLabel;
        }

        public long getNewMembers() {
            return newMembers;
        }

        public long getUploadedMedia() {
            return uploadedMedia;
        }
    }

    public static class HomeActivity {
        private final String actor;
        private final String timeAgo;
        private final String action;

        public HomeActivity(String actor, String timeAgo, String action) {
            this.actor = actor;
            this.timeAgo = timeAgo;
            this.action = action;
        }

        public String getActor() {
            return actor;
        }

        public String getTimeAgo() {
            return timeAgo;
        }

        public String getAction() {
            return action;
        }
    }
}
