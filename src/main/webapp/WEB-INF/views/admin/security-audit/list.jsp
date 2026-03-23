<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglib.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bảo mật &amp; Kiểm toán</title>
</head>
<body>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="<c:url value='/admin/home'/>">Trang chủ</a>
                </li>
                <li class="active">Bảo mật &amp; Kiểm toán</li>
            </ul>
        </div>

        <div class="page-content security-audit-page">
            <div class="audit-page-shell">
                <section class="audit-hero">
                    <div class="audit-hero-copy">
                        <p class="audit-hero-kicker">Bảo mật dữ liệu dòng họ</p>
                        <h3 class="audit-title">Bảo mật &amp; Kiểm toán gia phả</h3>
                        <p class="audit-subtitle">Theo dõi rủi ro, đăng nhập và biến động dữ liệu trong 7 ngày gần nhất theo cùng phong cách trang nghiêm, dễ đọc.</p>
                    </div>
                    <div class="audit-hero-meta">
                        <span class="audit-hero-chip">Nhật ký gần đây</span>
                        <span class="audit-hero-chip">Rủi ro rõ ràng</span>
                        <span class="audit-hero-chip">Theo dõi tập trung</span>
                    </div>
                </section>

                <div class="row audit-stats-row">
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-list-alt"></i></span>
                                    <div class="audit-stat-label">Tổng sự kiện</div>
                                    <div class="bigger-150"><strong>${dashboard.totalEvents7Days}</strong></div>
                                    <div class="audit-stat-note">Ghi nhận trong 7 ngày</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-shield"></i></span>
                                    <div class="audit-stat-label">Sự kiện bảo mật</div>
                                    <div class="bigger-150"><strong>${dashboard.securityEvents7Days}</strong></div>
                                    <div class="audit-stat-note">Liên quan truy cập và bảo vệ</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-database"></i></span>
                                    <div class="audit-stat-label">Thay đổi dữ liệu</div>
                                    <div class="bigger-150"><strong>${dashboard.dataChangeEvents7Days}</strong></div>
                                    <div class="audit-stat-note">Các cập nhật trong hệ thống</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-exclamation-triangle"></i></span>
                                    <div class="audit-stat-label">Nguy cơ cao</div>
                                    <div class="bigger-150 text-danger"><strong>${dashboard.highRiskEvents7Days}</strong></div>
                                    <div class="audit-stat-note">Cần theo dõi sớm</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-check-circle"></i></span>
                                    <div class="audit-stat-label">Đăng nhập đúng</div>
                                    <div class="bigger-150 text-success"><strong>${dashboard.loginSuccess7Days}</strong></div>
                                    <div class="audit-stat-note">Phiên truy cập hợp lệ</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <div class="widget-box audit-stat-card">
                            <div class="widget-body">
                                <div class="widget-main">
                                    <span class="audit-stat-icon"><i class="fa fa-pie-chart"></i></span>
                                    <div class="audit-stat-label">Tỷ lệ an toàn</div>
                                    <div class="bigger-150"><strong><fmt:formatNumber value="${dashboard.successRate}" maxFractionDigits="1"/>%</strong></div>
                                    <div class="audit-stat-note">Đăng nhập thành công</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row audit-panel-row">
                    <div class="col-md-4">
                        <div class="widget-box audit-log-panel">
                            <div class="widget-header">
                                <h4 class="widget-title">Thất bại đăng nhập 7 ngày</h4>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main">
                                    <p class="audit-panel-intro">Số lần đăng nhập thất bại được ghi nhận theo từng ngày để theo dõi bất thường.</p>
                                    <ul class="audit-failed-series">
                                        <c:forEach var="day" items="${dashboard.dayLabels}" varStatus="st">
                                            <li>
                                                <span class="audit-day-label"><c:out value="${day}"/></span>
                                                <span class="audit-day-value"><c:out value="${dashboard.failedLoginSeries[st.index]}"/></span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="widget-box audit-log-panel">
                            <div class="widget-header">
                                <h4 class="widget-title">Bộ lọc nhật ký</h4>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main">
                                    <p class="audit-panel-intro">Lọc nhanh theo tài khoản, hành động, mô tả hoặc mức độ rủi ro để tập trung vào bản ghi cần xem.</p>
                                    <div class="audit-filter-grid">
                                        <input id="auditSearchInput" type="text" class="form-control" placeholder="Tìm theo tài khoản, hành động, mô tả..."/>
                                        <select id="auditRiskFilter" class="form-control">
                                            <option value="">Tất cả mức độ</option>
                                            <option value="HIGH">Nguy cơ cao</option>
                                            <option value="MEDIUM">Nguy cơ trung bình</option>
                                            <option value="LOW">Nguy cơ thấp</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <div class="widget-box audit-log-panel audit-table-panel">
                            <div class="widget-header">
                                <h4 class="widget-title">Nhật ký gần đây</h4>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <div class="audit-table-wrap">
                                        <table class="table table-striped table-bordered table-hover audit-log-table">
                                            <thead>
                                            <tr>
                                                <th>Thời gian</th>
                                                <th>Tài khoản</th>
                                                <th>Họ tên</th>
                                                <th>Hành động</th>
                                                <th>Mức độ</th>
                                                <th>Mô tả</th>
                                            </tr>
                                            </thead>
                                            <tbody id="auditLogBody">
                                            <c:forEach var="log" items="${dashboard.recentLogs}">
                                                <tr class="audit-log-row"
                                                    data-risk="${log.riskLevel}"
                                                    data-search="<c:out value='${log.userName}'/> <c:out value='${log.fullName}'/> <c:out value='${log.actionLabel}'/> <c:out value='${log.description}'/>">
                                                    <td><fmt:formatDate value="${log.timestamp}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                                    <td><c:out value="${log.userName}"/></td>
                                                    <td><c:out value="${log.fullName}"/></td>
                                                    <td><c:out value="${log.actionLabel}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${log.riskLevel == 'HIGH'}">
                                                                <span class="audit-risk-badge risk-high">Cao</span>
                                                            </c:when>
                                                            <c:when test="${log.riskLevel == 'MEDIUM'}">
                                                                <span class="audit-risk-badge risk-medium">Trung bình</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="audit-risk-badge risk-low">Thấp</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${log.description}"/></td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty dashboard.recentLogs}">
                                                <tr>
                                                    <td colspan="6" class="text-center">Chưa có dữ liệu log</td>
                                                </tr>
                                            </c:if>
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
    </div>
</div>

<script>
    (function () {
        var searchInput = document.getElementById('auditSearchInput');
        var riskFilter = document.getElementById('auditRiskFilter');
        var rows = document.querySelectorAll('.audit-log-row');

        if (!searchInput || !riskFilter || !rows.length) return;

        function normalizeText(value) {
            return (value || '').toLowerCase();
        }

        function filterRows() {
            var keyword = normalizeText(searchInput.value);
            var risk = normalizeText(riskFilter.value);

            rows.forEach(function (row) {
                var rowText = normalizeText(row.getAttribute('data-search'));
                var rowRisk = normalizeText(row.getAttribute('data-risk'));
                var matchKeyword = !keyword || rowText.indexOf(keyword) !== -1;
                var matchRisk = !risk || rowRisk === risk;
                row.style.display = (matchKeyword && matchRisk) ? '' : 'none';
            });
        }

        searchInput.addEventListener('input', filterRows);
        riskFilter.addEventListener('change', filterRows);
    })();
</script>
</body>
</html>
