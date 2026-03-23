<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<%@ page import="com.javaweb.security.utils.SecurityUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>

<header class="app-topbar">
    <div class="app-topbar-left">
        <button class="app-topbar-toggle" id="appSidebarToggle" type="button" aria-label="Mở menu">
            <i class="fa fa-bars"></i>
        </button>
        <div class="app-topbar-intro">
            <strong class="app-topbar-title">Gia phả họ Trần Đức</strong>
            <span class="app-topbar-kicker">Uống nước nhớ nguồn</span>
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
                <span class="name"><%=StringEscapeUtils.escapeHtml(SecurityUtils.getPrincipal().getFullName())%></span>
                <i class="fa fa-caret-down"></i>
            </a>
            <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
                <li>
                    <a href="/admin/profile-<%=SecurityUtils.getPrincipal().getUsername()%>">
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
                    <a href="<c:url value='/logout'/>">
                        <i class="ace-icon fa fa-power-off"></i>
                        Thoát
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>
