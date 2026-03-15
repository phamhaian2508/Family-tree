<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="familyTreeUrl" value="/admin/familytree"/>
<c:url var="mediaUrl" value="/admin/media"/>
<c:url var="livestreamUrl" value="/admin/livestream"/>
<c:url var="guideUrl" value="/admin/guide"/>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
            </ul>
        </div>

        <div class="page-content dashboard-home dashboard-home-v2">
            <div class="dashboard-head">
                <h2 class="dashboard-title">Tổng quan</h2>
                <div class="dashboard-inline-breadcrumb">Trang chủ <span>/</span> Tổng quan</div>
            </div>

            <div class="row home-stats-row">
                <div class="col-xs-12 col-sm-6 col-lg-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <div class="overview-number"><c:out value="${empty totalBranches ? 0 : totalBranches}"/></div>
                            <div class="overview-label">Gia phả</div>
                            <span class="overview-icon"><i class="fa-solid fa-code-branch"></i></span>
                        </div>
                        <a class="overview-more" href="${familyTreeUrl}">Xem thêm <i class="fa-solid fa-circle-info"></i></a>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-lg-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <div class="overview-number overview-text">Hướng dẫn sử dụng</div>
                            <div class="overview-label">Thiết lập nhanh</div>
                            <span class="overview-icon"><i class="fa-solid fa-gear"></i></span>
                        </div>
                        <a class="overview-more" href="${guideUrl}">Xem thêm <i class="fa-solid fa-circle-info"></i></a>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-lg-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <div class="overview-number"><c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/></div>
                            <div class="overview-label">Thư viện</div>
                            <span class="overview-icon"><i class="fa-regular fa-newspaper"></i></span>
                        </div>
                        <a class="overview-more" href="${mediaUrl}">Xem thêm <i class="fa-solid fa-circle-info"></i></a>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-lg-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <div class="overview-number"><c:out value="${empty activeUsers ? 0 : activeUsers}"/></div>
                            <div class="overview-label">Thành viên hoạt động</div>
                            <span class="overview-icon"><i class="fa-regular fa-calendar"></i></span>
                        </div>
                        <a class="overview-more" href="${livestreamUrl}">Xem thêm <i class="fa-solid fa-circle-info"></i></a>
                    </div>
                </div>
            </div>

            <div class="row home-panels-row">
                <div class="col-xs-12 col-lg-8">
                    <div class="widget-box home-panel detail-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Thông tin dòng họ Trần Đức</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main family-info-main">
                                <p class="family-intro">
                                    Gia phả Họ Trần Đức - Nhân Hữu, Nhân Thắng, Bắc Ninh là nơi lưu giữ thông tin các thế hệ,
                                    kết nối con cháu và bảo tồn truyền thống dòng họ.
                                </p>

                                <div class="family-tags">
                                    <span class="family-tag"><i class="fa-solid fa-location-dot"></i> Quê quán: Nhân Hữu - Nhân Thắng, Bắc Ninh</span>
                                    <span class="family-tag"><i class="fa-solid fa-users"></i> Dòng họ: Trần Đức</span>
                                    <span class="family-tag"><i class="fa-solid fa-sitemap"></i> Chi họ hiện có: <c:out value="${empty totalBranches ? 0 : totalBranches}"/></span>
                                    <span class="family-tag"><i class="fa-solid fa-image"></i> Tư liệu lưu trữ: <c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/> tệp</span>
                                </div>

                                <div class="row family-kpi-row">
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">Tổng thành viên</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalMembers ? 0 : totalMembers}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">Nhánh gia đình</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalBranches ? 0 : totalBranches}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">Tệp tư liệu</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">Người dùng hoạt động</div>
                                            <div class="family-kpi-value"><c:out value="${empty activeUsers ? 0 : activeUsers}"/></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="family-priority">
                                    <h5>Ưu tiên cập nhật</h5>
                                    <ul>
                                        <li>Bổ sung ngày sinh, ngày mất và quê quán cho các thành viên còn thiếu.</li>
                                        <li>Chuẩn hóa quan hệ cha - mẹ - con để cây gia phả hiển thị chính xác.</li>
                                        <li>Tải thêm ảnh, tư liệu họ tộc để lưu giữ lâu dài.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-4">
                    <div class="widget-box home-panel event-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Sự kiện sắp diễn ra</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <c:choose>
                                    <c:when test="${not empty recentActivities}">
                                        <div class="event-empty">
                                            <c:out value="${recentActivities[0].action}"/>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="event-empty">Không có sự kiện nào sắp diễn ra.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="widget-box home-panel admin-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Ban quản trị</h4>
                            <span class="admin-count">1 Thành viên</span>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <table class="table table-bordered admin-table">
                                    <thead>
                                    <tr>
                                        <th>Họ và tên</th>
                                        <th>Email</th>
                                        <th>Chức vụ</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><security:authentication property="principal.username"/></td>
                                        <td>-</td>
                                        <td>
                                            <security:authorize access="hasRole('MANAGER')">
                                                <span class="role-badge">QTV</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and hasRole('EDITOR')">
                                                <span class="role-badge">EDITOR</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and !hasRole('EDITOR')">
                                                <span class="role-badge">USER</span>
                                            </security:authorize>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

