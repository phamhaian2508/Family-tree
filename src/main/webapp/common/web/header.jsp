<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.javaweb.security.utils.SecurityUtils" %>
<%@include file="/common/taglib.jsp" %>

<header class="gpo-header">
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/trang-chu">
                <span class="gpo-brand-badge" aria-hidden="true">Gia<br>phả</span>
                <span class="gpo-logo-text ms-3">
                    <strong>Họ Trần Đức</strong>
                    <small>Nhân Hữu - Nhân Thắng - Bắc Ninh</small>
                </span>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#webNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="webNavbar">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#coi-nguon">Cội nguồn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#gia-tri">Giá trị</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#so-do">Sơ đồ dòng họ</a>
                    </li>
                </ul>

                <div class="d-flex align-items-center gap-3">
                    <security:authorize access="isAnonymous()">
                        <a href="<c:url value='/login'/>" class="btn btn-outline-gpo btn-sm">Đăng nhập</a>
                        <a href="/dang-ky" class="btn btn-gpo btn-sm">Đăng ký</a>
                    </security:authorize>

                    <security:authorize access="isAuthenticated()">
                        <a href="/admin/home" class="btn btn-outline-gpo btn-sm">
                            <i class="fa-solid fa-user me-1"></i>
                            <%=SecurityUtils.getPrincipal().getUsername()%>
                        </a>
                        <a href="<c:url value='/logout'/>" class="btn btn-gpo btn-sm">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                        </a>
                    </security:authorize>
                </div>
            </div>
        </div>
    </nav>
</header>
