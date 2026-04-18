<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<%
    String currentFullName = com.javaweb.security.utils.SecurityUtils.getPrincipal() != null
            ? org.apache.commons.lang.StringEscapeUtils.escapeHtml(
                    com.javaweb.security.utils.SecurityUtils.getPrincipal().getFullName())
            : "";
%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="familyTreeUrl" value="/admin/familytree"/>
<c:url var="familyTreeListUrl" value="/admin/family-trees"/>
<c:url var="contributionsUrl" value="/admin/family-content/contributions"/>
<c:url var="newsUrl" value="/admin/family-content/news"/>
<c:url var="mediaUrl" value="/admin/media"/>
<c:url var="guideUrl" value="/admin/guide"/>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa fa-home home-icon"></i>
                    <a href="${homeUrl}">Trang ch&#7911;</a>
                </li>
            </ul>
        </div>

        <div class="page-content dashboard-home dashboard-home-v2">
            <div class="family-heritage-banner">
                <div class="family-heritage-banner__content">
                    <div class="family-heritage-banner__title">Kh&ocirc;ng gian qu&#7843;n l&yacute; gia ph&#7843;</div>
                    <div class="family-heritage-banner__subtitle">Theo d&otilde;i th&agrave;nh vi&ecirc;n, t&#432; li&#7879;u v&agrave; nh&#7919;ng c&#7853;p nh&#7853;t quan tr&#7885;ng c&#7911;a d&ograve;ng h&#7885; Tr&#7847;n &#272;&#7913;c.</div>
                </div>
                <a class="family-heritage-banner__action" href="${guideUrl}">Xem h&#432;&#7899;ng d&#7851;n s&#7917; d&#7909;ng</a>
            </div>

            <div class="dashboard-head">
                <h2 class="dashboard-title">T&#7893;ng quan d&ograve;ng h&#7885;</h2>
            </div>

            <div class="row home-stats-row">
                <div class="col-xs-12 col-md-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">C&ocirc;ng &#273;&#7913;c</span>
                            <div class="overview-number"><c:out value="${empty annualContributions ? 0 : annualContributions}"/></div>
                            <div class="overview-label">C&ocirc;ng &#273;&#7913;c h&agrave;ng n&#259;m</div>
                        </div>
                        <a class="overview-more" href="${contributionsUrl}">Xem c&ocirc;ng &#273;&#7913;c</a>
                    </div>
                </div>

                <div class="col-xs-12 col-md-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">Gia ph&#7843;</span>
                            <div class="overview-number"><c:out value="${empty totalFamilyTrees ? 0 : totalFamilyTrees}"/></div>
                            <div class="overview-label">T&#7893;ng s&#7889; gia ph&#7843;</div>
                        </div>
                        <a class="overview-more" href="${familyTreeListUrl}">Xem gia ph&#7843;</a>
                    </div>
                </div>

                <div class="col-xs-12 col-md-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">Tin</span>
                            <div class="overview-number"><c:out value="${empty totalNews ? 0 : totalNews}"/></div>
                            <div class="overview-label">Tin t&#7913;c</div>
                        </div>
                        <a class="overview-more" href="${newsUrl}">Xem tin t&#7913;c</a>
                    </div>
                </div>

                <div class="col-xs-12 col-md-3">
                    <div class="widget-box overview-card">
                        <div class="overview-card-body">
                            <span class="overview-seal">T&#432; li&#7879;u</span>
                            <div class="overview-number"><c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/></div>
                            <div class="overview-label">Th&#432; vi&#7879;n t&#432; li&#7879;u</div>
                        </div>
                        <a class="overview-more" href="${mediaUrl}">Xem t&#432; li&#7879;u</a>
                    </div>
                </div>
            </div>

            <div class="row home-panels-row">
                <div class="col-xs-12 col-lg-8">
                    <div class="widget-box home-panel detail-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Th&ocirc;ng tin d&ograve;ng h&#7885; Tr&#7847;n &#272;&#7913;c</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main family-info-main">
                                <p class="family-intro">
                                    Gia ph&#7843; h&#7885; Tr&#7847;n &#272;&#7913;c t&#7841;i Nh&acirc;n H&#7919;u, Nh&acirc;n Th&#7855;ng, B&#7855;c Ninh l&agrave; n&#417;i l&#432;u gi&#7919; th&ocirc;ng tin nhi&#7873;u th&#7871; h&#7879;,
                                    k&#7871;t n&#7889;i con ch&aacute;u trong h&#7885; v&agrave; b&#7843;o t&#7891;n n&#7871;p nh&agrave; qua t&#7915;ng &#273;&#7901;i.
                                </p>

                                <div class="family-tags">
                                    <span class="family-tag">Qu&ecirc; qu&aacute;n: Nh&acirc;n H&#7919;u - Nh&acirc;n Th&#7855;ng, B&#7855;c Ninh</span>
                                    <span class="family-tag">D&ograve;ng h&#7885;: Tr&#7847;n &#272;&#7913;c</span>
                                    <span class="family-tag">T&#7893;ng s&#7889; gia ph&#7843;: <c:out value="${empty totalFamilyTrees ? 0 : totalFamilyTrees}"/></span>
                                    <span class="family-tag">Tin t&#7913;c &#273;&atilde; &#273;&#259;ng: <c:out value="${empty totalNews ? 0 : totalNews}"/></span>
                                </div>

                                <div class="row family-kpi-row">
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">T&#7893;ng th&agrave;nh vi&ecirc;n</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalMembers ? 0 : totalMembers}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">T&#7893;ng gia ph&#7843;</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalFamilyTrees ? 0 : totalFamilyTrees}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">Tin t&#7913;c</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalNews ? 0 : totalNews}"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6 col-sm-3">
                                        <div class="family-kpi-card">
                                            <div class="family-kpi-label">T&#7879;p t&#432; li&#7879;u</div>
                                            <div class="family-kpi-value"><c:out value="${empty totalMediaFiles ? 0 : totalMediaFiles}"/></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="family-priority">
                                    <h5>&#272;i&#7873;u n&ecirc;n b&#7893; sung trong gia ph&#7843;</h5>
                                    <ul>
                                        <li>B&#7893; sung ng&agrave;y sinh, ng&agrave;y m&#7845;t v&agrave; qu&ecirc; qu&aacute;n cho c&aacute;c th&agrave;nh vi&ecirc;n c&ograve;n thi&#7871;u th&ocirc;ng tin.</li>
                                        <li>Chu&#7849;n h&oacute;a quan h&#7879; cha, m&#7865;, con &#273;&#7875; c&acirc;y gia ph&#7843; hi&#7875;n th&#7883; ch&iacute;nh x&aacute;c v&agrave; d&#7877; tra c&#7913;u.</li>
                                        <li>&#272;&#432;a th&ecirc;m &#7843;nh th&#7901;, s&#7855;c phong, t&#432; li&#7879;u h&#7885; t&#7897;c &#273;&#7875; l&#432;u gi&#7919; l&acirc;u d&agrave;i cho c&aacute;c th&#7871; h&#7879; sau.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-4">
                    <div class="widget-box home-panel event-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Tin ghi ch&eacute;p g&#7847;n &#273;&acirc;y</h4>
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
                                        <div class="event-empty">Ch&#432;a c&oacute; ghi ch&eacute;p m&#7899;i. C&oacute; th&#7875; b&#7855;t &#273;&#7847;u b&#7857;ng vi&#7879;c c&#7853;p nh&#7853;t th&ocirc;ng tin t&#7893; ti&ecirc;n v&agrave; con ch&aacute;u trong h&#7885;.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="widget-box home-panel admin-panel">
                        <div class="widget-header family-section-header">
                            <h4 class="widget-title">Ng&#432;&#7901;i g&igrave;n gi&#7919; gia ph&#7843;</h4>
                            <span class="admin-count">1 ng&#432;&#7901;i ph&#7909; tr&aacute;ch</span>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <table class="table table-bordered admin-table">
                                    <thead>
                                    <tr>
                                        <th>H&#7885; v&agrave; t&ecirc;n</th>
                                        <th>T&agrave;i kho&#7843;n</th>
                                        <th>Vai tr&ograve;</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><%= currentFullName %></td>
                                        <td><security:authentication property="principal.username"/></td>
                                        <td>
                                            <security:authorize access="hasRole('MANAGER')">
                                                <span class="role-badge">Tr&#432;&#7903;ng qu&#7843;n ph&#7843;</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and hasRole('EDITOR')">
                                                <span class="role-badge">Bi&ecirc;n t&#7853;p ph&#7843;</span>
                                            </security:authorize>
                                            <security:authorize access="!hasRole('MANAGER') and !hasRole('EDITOR')">
                                                <span class="role-badge">Th&agrave;nh vi&ecirc;n h&#7885; t&#7897;c</span>
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
