<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<%@ page import="com.javaweb.security.utils.SecurityUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Locale" %>

<header class="app-topbar">
    <%
        String profileFullName = StringEscapeUtils.escapeHtml(SecurityUtils.getPrincipal().getFullName());
        String profileUsername;
        try {
            profileUsername = URLEncoder.encode(SecurityUtils.getPrincipal().getUsername(), "UTF-8");
        } catch (Exception ex) {
            profileUsername = SecurityUtils.getPrincipal().getUsername();
        }

        String familyTreeName = (String) pageContext.findAttribute("currentFamilyTreeName");
        familyTreeName = familyTreeName == null ? "" : familyTreeName.trim();

        String topbarTitle;
        if (familyTreeName.isEmpty() || "Chua chon gia pha".equalsIgnoreCase(familyTreeName)) {
            topbarTitle = "Gia phả dòng họ";
        } else {
            String lowerFamilyTreeName = familyTreeName.toLowerCase(Locale.ROOT);
            if (lowerFamilyTreeName.startsWith("gia phả") || lowerFamilyTreeName.startsWith("gia pha")) {
                topbarTitle = familyTreeName;
            } else if (lowerFamilyTreeName.startsWith("họ ") || lowerFamilyTreeName.startsWith("ho ")) {
                topbarTitle = "Gia phả " + familyTreeName;
            } else {
                topbarTitle = "Gia phả họ " + familyTreeName;
            }
        }

        String topbarKicker = "Uống nước nhớ nguồn";
    %>
    <div class="app-topbar-left">
        <button class="app-topbar-toggle" id="appSidebarToggle" type="button" aria-label="Mở menu">
            <i class="fa fa-bars"></i>
        </button>
        <div class="app-topbar-intro">
            <strong class="app-topbar-title"><%= StringEscapeUtils.escapeHtml(topbarTitle) %></strong>
            <span class="app-topbar-kicker"><%= StringEscapeUtils.escapeHtml(topbarKicker) %></span>
        </div>
    </div>

    <div class="app-topbar-right">
        <a href="#" class="app-topbar-bell" aria-label="Thông báo">
            <i class="fa fa-bell-o"></i>
            <span class="dot"></span>
        </a>

        <div class="dropdown app-topbar-user">
            <a data-toggle="dropdown" href="#" class="dropdown-toggle app-topbar-user-link">
                <span class="avatar"><i class="fa fa-user"></i></span>
                <span class="name"><%= profileFullName %></span>
                <i class="fa fa-caret-down"></i>
            </a>
            <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
                <li>
                    <a href="/admin/profile-<%= profileUsername %>">
                        <i class="ace-icon fa fa-user"></i>
                        Thông tin tài khoản
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/admin/profile-password'/>">
                        <i class="ace-icon fa fa-key"></i>
                        Đổi mật khẩu
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <form action="<c:url value='/logout'/>" method="post" style="margin:0;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" style="background:none;border:none;width:100%;text-align:left;padding:6px 14px;">
                            <i class="ace-icon fa fa-power-off"></i>
                            Thoát
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</header>
