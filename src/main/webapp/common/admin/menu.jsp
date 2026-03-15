<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<%
    String uri = request.getRequestURI();
    boolean homeActive = uri.contains("/admin/home");
    boolean familyActive = uri.contains("/admin/familytree");
    boolean mediaActive = uri.contains("/admin/media");
    boolean liveActive = uri.contains("/admin/livestream");
    boolean userActive = uri.contains("/admin/user");
    boolean auditActive = uri.contains("/admin/security-audit");
%>

<aside class="app-sidebar">
    <div class="app-sidebar-overlay" id="appSidebarOverlay"></div>
    <div class="app-brand">
        <div class="brand-icon"><i class="fa fa-sitemap"></i></div>
        <div class="brand-text">Gia phả họ Trần Đức</div>
    </div>

    <nav class="app-nav">
        <a class="app-nav-item <%= homeActive ? "active" : "" %>" href="/admin/home">
            <i class="fa fa-dashboard"></i>
            <span>Trang chủ</span>
        </a>
        <a class="app-nav-item <%= familyActive ? "active" : "" %>" href="/admin/familytree">
            <i class="fa fa-sitemap"></i>
            <span>Cây gia phả</span>
        </a>
        <a class="app-nav-item <%= mediaActive ? "active" : "" %>" href="/admin/media">
            <i class="fa fa-picture-o"></i>
            <span>Thư viện</span>
        </a>
        <a class="app-nav-item <%= liveActive ? "active" : "" %>" href="/admin/livestream">
            <i class="fa fa-video-camera"></i>
            <span>Phát trực tiếp</span>
        </a>

        <security:authorize access="hasRole('MANAGER')">
            <a class="app-nav-item <%= userActive ? "active" : "" %>" href="/admin/user-list">
                <i class="fa fa-user"></i>
                <span>Quản lý người dùng</span>
            </a>
            <a class="app-nav-item <%= auditActive ? "active" : "" %>" href="/admin/security-audit">
                <i class="fa fa-shield"></i>
                <span>Bảo mật &amp; Kiểm toán</span>
            </a>
        </security:authorize>
    </nav>

</aside>

