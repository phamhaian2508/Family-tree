<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<%
    String uri = request.getRequestURI();
    boolean homeActive = uri.contains("/admin/home");
    boolean treeActive = uri.contains("/admin/familytree");
    boolean familyTreeListActive = uri.contains("/admin/family-trees");
    boolean genealogyActive = familyTreeListActive || treeActive;
    boolean introductionActive = uri.contains("/admin/family-content/introduction");
    boolean contributionActive = uri.contains("/admin/family-content/contributions");
    boolean awardActive = uri.contains("/admin/family-content/awards");
    boolean academicActive = uri.contains("/admin/family-content/academics");
    boolean newsActive = uri.contains("/admin/family-content/news");
    boolean mediaActive = uri.contains("/admin/media");
    boolean familySectionActive = familyTreeListActive || uri.contains("/admin/family-content/") || treeActive || mediaActive;
    boolean liveActive = uri.contains("/admin/livestream");
    boolean userActive = uri.contains("/admin/user");
    boolean auditActive = uri.contains("/admin/security-audit");
%>

<style>
    .app-nav-group-title {
        margin: 14px 0 6px;
        padding: 0 16px;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: rgba(255, 255, 255, 0.54);
    }
    .app-nav-item-child {
        padding-left: 42px !important;
        padding-right: 16px !important;
        min-height: 48px !important;
        font-size: 13px;
        line-height: 1.35;
        align-items: center !important;
        gap: 12px !important;
    }
    .app-nav-item-child > span {
        display: block;
        line-height: 1.35;
        white-space: normal;
    }
</style>

<aside class="app-sidebar">
    <div class="app-sidebar-overlay" id="appSidebarOverlay"></div>

    <div class="app-brand">
        <div class="app-brand-shell">
            <img class="brand-dragon brand-dragon-left" src="<c:url value='/admin/assets/images/dragon-left.png'/>" alt="" aria-hidden="true">
            <div class="app-brand-main">
                <div class="brand-mark">Gia ph&#7843;</div>
                <div class="brand-copy">
                    <div class="brand-title"><c:out value="${currentFamilyTreeName}"/></div>
                </div>
            </div>
            <img class="brand-dragon brand-dragon-right" src="<c:url value='/admin/assets/images/dragon-right.png'/>" alt="" aria-hidden="true">
        </div>
    </div>

    <nav class="app-nav">
        <a class="app-nav-item <%= homeActive ? "active" : "" %>" href="/admin/home">
            <i class="fa fa-dashboard"></i>
            <span>Trang ch&#7911;</span>
        </a>

        <div class="app-nav-group app-nav-group-collapsible <%= familySectionActive ? "is-open" : "" %>" data-nav-group="family-tree">
            <button class="app-nav-item app-nav-item-toggle <%= familySectionActive ? "active" : "" %>" type="button" aria-expanded="<%= familySectionActive ? "true" : "false" %>">
                <span class="app-nav-item-main">
                    <i class="fa fa-sitemap"></i>
                    <span>Gia ph&#7843;</span>
                </span>
                <i class="fa fa-angle-down app-nav-caret"></i>
            </button>
            <div class="app-nav-submenu">
                <a class="app-nav-item app-nav-item-child <%= genealogyActive ? "active" : "" %>" href="/admin/family-trees">
                    <i class="fa fa-users"></i>
                    <span>C&#226;y gia ph&#7843;</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= introductionActive ? "active" : "" %>" href="/admin/family-content/introduction">
                    <i class="fa fa-info-circle"></i>
                    <span>Gi&#7899;i thi&#7879;u d&#242;ng h&#7885;</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= contributionActive ? "active" : "" %>" href="/admin/family-content/contributions">
                    <i class="fa fa-heart"></i>
                    <span>C&#244;ng &#273;&#7913;c h&#7857;ng n&#259;m</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= awardActive ? "active" : "" %>" href="/admin/family-content/awards">
                    <i class="fa fa-trophy"></i>
                    <span>Khen th&#432;&#7903;ng - Khuy&#7871;n h&#7885;c</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= academicActive ? "active" : "" %>" href="/admin/family-content/academics">
                    <i class="fa fa-graduation-cap"></i>
                    <span>H&#7885;c h&#224;m h&#7885;c v&#7883;</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= newsActive ? "active" : "" %>" href="/admin/family-content/news">
                    <i class="fa fa-newspaper-o"></i>
                    <span>Tin t&#7913;c</span>
                </a>
                <a class="app-nav-item app-nav-item-child <%= mediaActive ? "active" : "" %>" href="/admin/media">
                    <i class="fa fa-picture-o"></i>
                    <span>Th&#432; vi&#7879;n t&#432; li&#7879;u</span>
                </a>
            </div>
        </div>
        <a class="app-nav-item <%= liveActive ? "active" : "" %>" href="/admin/livestream">
            <i class="fa fa-video-camera"></i>
            <span>Ph&#225;t tr&#7921;c ti&#7871;p</span>
        </a>

        <security:authorize access="hasRole('MANAGER')">
            <a class="app-nav-item <%= userActive ? "active" : "" %>" href="/admin/user-list">
                <i class="fa fa-user"></i>
                <span>Qu&#7843;n l&#253; ng&#432;&#7901;i d&#249;ng</span>
            </a>
            <a class="app-nav-item <%= auditActive ? "active" : "" %>" href="/admin/security-audit">
                <i class="fa fa-shield"></i>
                <span>B&#7843;o m&#7853;t v&#224; ki&#7875;m to&#225;n</span>
            </a>
        </security:authorize>
    </nav>

    <div class="app-sidebar-footer">
        <span>T&#7897;c h&#7879; - T&#432; li&#7879;u - Th&#224;nh vi&#234;n</span>
    </div>
</aside>

<script>
    (function () {
        var storageKey = 'app-nav-group-family-tree-open';
        var group = document.querySelector('[data-nav-group="family-tree"]');
        if (!group) {
            return;
        }
        var toggle = group.querySelector('.app-nav-item-toggle');
        if (!toggle) {
            return;
        }

        var hasActivePage = group.classList.contains('is-open');
        var storedState = null;
        try {
            storedState = window.localStorage ? window.localStorage.getItem(storageKey) : null;
        } catch (e) {
            storedState = null;
        }

        if (storedState === 'true') {
            group.classList.add('is-open');
        } else if (storedState === 'false' && !hasActivePage) {
            group.classList.remove('is-open');
        }
        toggle.setAttribute('aria-expanded', group.classList.contains('is-open') ? 'true' : 'false');

        toggle.addEventListener('click', function () {
            var isOpen = group.classList.toggle('is-open');
            toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            try {
                if (window.localStorage) {
                    window.localStorage.setItem(storageKey, isOpen ? 'true' : 'false');
                }
            } catch (e) {
            }
        });
    })();
</script>
