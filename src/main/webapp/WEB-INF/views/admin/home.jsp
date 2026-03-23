<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="familyTreeUrl" value="/admin/familytree"/>
<c:url var="mediaUrl" value="/admin/media"/>
<c:url var="guideUrl" value="/admin/guide"/>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa fa-home home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
            </ul>
        </div>

        <div class="page-content dashboard-home dashboard-home-v2">
            <div class="family-heritage-banner">
                <div class="family-heritage-banner__content">
                    <div class="family-heritage-banner__title">Không gian quản lý gia phả</div>
                    <div class="family-heritage-banner__subtitle">Theo dõi thành viên, tư liệu và những cập nhật quan trọng của dòng họ Trần Đức.</div>
                </div>
                <a class="family-heritage-banner__action" href="${guideUrl}">Xem hướng dẫn sử dụng</a>
            </div>

            <div class="dashboard-head">
                <h2 class="dashboard-title">Tổng quan dòng họ</h2>
            </div>

            <div class="row home-stats-row">
                <div class="col-xs-12 col-md-4">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">Tộc</span>
                            <div class="overview-number"><c:out value="${empty totalMembers ? 0 : totalMembers}"/></div>
                            <div class="overview-label">Tổng số thành viên</div>
                        </div>
                        <a class="overview-more" href="${familyTreeUrl}">Xem cây gia phả</a>
                    </div>
                </div>

                <div class="col-xs-12 col-md-4">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">Chi</span>
                            <div class="overview-number"><c:out value="${empty totalBranches ? 0 : totalBranches}"/></div>
                            <div class="overview-label">Số nhánh gia tộc hiện có</div>
                        </div>
                        <a class="overview-more" href="${familyTreeUrl}">Xem phân nhánh</a>
                    </div>
                </div>

                <div class="col-xs-12 col-md-4">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">Tư liệu</span>
                            <div class="overview-number"><c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/></div>
                            <div class="overview-label">Thư viện tư liệu</div>
                        </div>
                        <a class="overview-more" href="${mediaUrl}">Xem tư liệu</a>
                    </div>
                </div>
            </div>

            <div class="row home-panels-row">
                <div class="col-xs-12 col-lg-8">
                    <div class="widget-box home-panel detail-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Thông tin dòng họ Trần Đức</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main family-info-main">
                                <p class="family-intro">
                                    Gia phả họ Trần Đức tại Nhân Hữu, Nhân Thắng, Bắc Ninh là nơi lưu giữ thông tin nhiều thế hệ,
                                    kết nối con cháu trong họ và bảo tồn nếp nhà qua từng đời.
                                </p>

                                <div class="family-tags">
                                    <span class="family-tag">Quê quán: Nhân Hữu - Nhân Thắng, Bắc Ninh</span>
                                    <span class="family-tag">Dòng họ: Trần Đức</span>
                                    <span class="family-tag">Chi họ hiện có: <c:out value="${empty totalBranches ? 0 : totalBranches}"/></span>
                                    <span class="family-tag">Tư liệu lưu trữ: <c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/> tệp</span>
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
                                            <div class="family-kpi-label">Người cập nhật</div>
                                            <div class="family-kpi-value"><c:out value="${empty activeUsers ? 0 : activeUsers}"/></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="family-priority">
                                    <h5>Điều nên bổ sung trong gia phả</h5>
                                    <ul>
                                        <li>Bổ sung ngày sinh, ngày mất và quê quán cho các thành viên còn thiếu thông tin.</li>
                                        <li>Chuẩn hóa quan hệ cha, mẹ, con để cây gia phả hiển thị chính xác và dễ tra cứu.</li>
                                        <li>Đưa thêm ảnh thờ, sắc phong, tư liệu họ tộc để lưu giữ lâu dài cho các thế hệ sau.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-4">
                    <div class="widget-box home-panel event-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Tin ghi chép gần đây</h4>
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
                                        <div class="event-empty">Chưa có ghi chép mới. Có thể bắt đầu bằng việc cập nhật thông tin tổ tiên và con cháu trong họ.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="widget-box home-panel admin-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Người gìn giữ gia phả</h4>
                            <span class="admin-count">1 người phụ trách</span>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <table class="table table-bordered admin-table">
                                    <thead>
                                    <tr>
                                        <th>Họ và tên</th>
                                        <th>Tài khoản</th>
                                        <th>Vai trò</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><%=org.apache.commons.lang.StringEscapeUtils.escapeHtml(com.javaweb.security.utils.SecurityUtils.getPrincipal().getFullName())%></td>
                                        <td><security:authentication property="principal.username"/></td>
                                        <td>
                                            <security:authorize access="hasRole('MANAGER')">
                                                <span class="role-badge">Trưởng quản phả</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and hasRole('EDITOR')">
                                                <span class="role-badge">Biên tập phả</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and !hasRole('EDITOR')">
                                                <span class="role-badge">Thành viên họ tộc</span>
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
