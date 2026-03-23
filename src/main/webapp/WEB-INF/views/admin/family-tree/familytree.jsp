<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="guideUrl" value="/admin/guide"/>
<title>Cây gia phả</title>
<!-- Icons (Bootstrap Icons) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

<link rel="stylesheet" href="assets/css/family-tree-page.css" />
<style>
    /* Vo chong dung sat nhau trong cung mot nhanh */
    #ftApp #treeRoot .box-person {
        --spouse-gap: 8px !important;
    }
    #ftApp #treeRoot .box-person.has-spouse {
        min-width: calc((var(--node-width) * 2) + var(--spouse-gap)) !important;
    }

    /* Anh em tach nhanh ro hon */
    #ftApp #treeRoot .ul-person {
        column-gap: 0 !important;
    }
    #ftApp #treeRoot .li-person {
        z-index: 1;
        padding-left: 18px !important;
        padding-right: 18px !important;
    }
    #ftApp #treeRoot .box-person {
        z-index: 1;
    }
    #ftApp #treeRoot .li-person.menu-open {
        z-index: 9998 !important;
    }
    #ftApp #treeRoot .li-person.menu-open .box-person {
        z-index: 9999 !important;
    }
    #ftApp #treeRoot .person-node.menu-open {
        z-index: 10000 !important;
    }
    #ftApp #treeRoot .tree-action-menu {
        z-index: 10001 !important;
    }


    /* Tang do ro cua net noi nhanh */
    #ftApp #treeRoot .li-person::before,
    #ftApp #treeRoot .li-person::after {
        border-top-color: #d0d0d0 !important;
        border-top-width: 8px !important;
    }
    #ftApp #treeRoot .li-person::after,
    #ftApp #treeRoot .ul-person .ul-person::before {
        border-left-color: #d0d0d0 !important;
        border-left-width: 8px !important;
    }
    #ftApp #treeRoot .li-person:last-child::before {
        border-right-color: #d0d0d0 !important;
        border-right-width: 8px !important;
        border-radius: 0 !important;
    }
    #ftApp #treeRoot .li-person:first-child::after {
        border-radius: 0 !important;
    }

    /* Ket qua loc/tim kiem: hien thi roi, khong ve duong noi quan he */
    #ftApp #treeRoot .ul-person.ft-filter-results {
        padding-top: 0;
        width: 100%;
        min-width: 100%;
        justify-content: flex-start;
        flex-wrap: wrap;
        gap: 14px;
    }
    #ftApp #treeRoot .ul-person.ft-filter-results > .li-person {
        padding: 0 !important;
    }
    #ftApp #treeRoot .ul-person.ft-filter-results > .li-person::before,
    #ftApp #treeRoot .ul-person.ft-filter-results > .li-person::after,
    #ftApp #treeRoot .ul-person.ft-filter-results::before {
        content: none !important;
        border: 0 !important;
        display: none !important;
    }

    #ftApp #treeRoot .box-person.has-spouse::before,
    #ftApp #treeRoot .box-person.has-spouse::after {
        content: none !important;
        display: none !important;
    }

    /* Lam o loc ten de thay ro hon */
    #ftApp #advancedFilterBar #ftFilterName {
        width: 280px !important;
        min-height: 40px;
        font-size: 14px;
        font-weight: 600;
        border: 2px solid #94a3b8;
        border-radius: 10px;
        padding: 8px 12px;
        background: #ffffff;
    }
    #ftApp #advancedFilterBar #ftFilterName::placeholder {
        color: #64748b;
        font-weight: 500;
    }
    #ftApp #advancedFilterBar #ftFilterName:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        outline: none;
    }
    #ftApp #advancedFilterBar {
        display: grid !important;
        grid-template-columns: 1.5fr 1fr auto;
        align-items: end;
        gap: 10px !important;
        min-width: min(760px, 100%);
    }
    #ftApp #advancedFilterBar .ft-filter-field {
        min-width: 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    #ftApp #advancedFilterBar .ft-filter-label {
        font-size: 13px;
        font-weight: 700;
        color: #475569;
        line-height: 1.2;
        white-space: nowrap;
        margin: 0;
    }
    #ftApp #advancedFilterBar .ft-filter-action {
        align-self: end;
    }
    #ftApp #advancedFilterBar .form-control {
        width: 100% !important;
        height: 40px;
        border: 2px solid #cbd5e1;
        border-radius: 10px;
        padding: 8px 12px;
        font-size: 14px;
        background: #fff;
    }
    #ftApp #advancedFilterBar .form-control:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }
    #ftApp #advancedFilterBar #ftFilterReset {
        height: 40px;
        min-width: 92px;
        border-radius: 10px;
        border: 1px solid #15803d;
        background: #16a34a;
        font-weight: 600;
        color: #ffffff;
    }
    #ftApp #advancedFilterBar #ftFilterReset:hover {
        background: #15803d;
        border-color: #166534;
        color: #ffffff;
    }
    #ftApp #treeQuickStats {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }
    #ftApp .ft-stat-chip {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 36px;
        padding: 6px 12px;
        border-radius: 999px;
        border: 1px solid #cbd5e1;
        background: #f8fafc;
        color: #334155;
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
    }
    #ftApp #legend {
        display: none !important;
    }

    @media (max-width: 991px) {
        #ftApp #treeRoot .box-person {
            --spouse-gap: 6px !important;
        }
        #ftApp #treeRoot .ul-person {
            column-gap: 0 !important;
        }
        #ftApp #treeRoot .li-person {
            padding-left: 10px !important;
            padding-right: 10px !important;
        }
        #ftApp #advancedFilterBar {
            grid-template-columns: 1fr;
            min-width: 100%;
        }
        #ftApp #advancedFilterBar #ftFilterReset {
            width: 100%;
        }
        #ftApp #advancedFilterBar .ft-filter-field {
            flex-direction: column;
            align-items: stretch;
            gap: 4px;
        }
        #ftApp #treeQuickStats {
            width: 100%;
            justify-content: stretch;
        }
        #ftApp .ft-stat-chip {
            flex: 1 1 0;
        }
        #ftApp #advancedFilterBar #ftFilterName {
            width: 100% !important;
            min-width: 220px;
        }
    }

    /* ===== Heritage redesign overrides ===== */
    #ftApp {
        background: transparent !important;
        color: #35241a;
        font-family: "Segoe UI", Tahoma, sans-serif;
    }
    #ftApp .container-fluid {
        padding-left: 0 !important;
        padding-right: 0 !important;
    }
    #ftApp .btn {
        border-radius: 6px !important;
        border: 1px solid rgba(120, 73, 42, 0.2) !important;
        background: #f7efdd !important;
        color: #6d231f !important;
        min-height: 42px;
        font-weight: 700;
        box-shadow: none !important;
    }
    #ftApp .btn:hover {
        background: #efe0bf !important;
        color: #561816 !important;
    }
    #ftApp .btn-dark {
        background: #8c241f !important;
        border-color: #8c241f !important;
        color: #fff3d2 !important;
    }
    #ftApp .btn-dark:hover {
        background: #741917 !important;
        border-color: #741917 !important;
    }
    #ftApp .form-control,
    #ftApp .form-select {
        min-height: 42px;
        border: 1px solid rgba(137, 96, 60, 0.22) !important;
        border-radius: 6px !important;
        background: rgba(255, 250, 240, 0.96) !important;
        color: #3b291e !important;
        box-shadow: none !important;
    }
    #ftApp .form-control:focus,
    #ftApp .form-select:focus {
        border-color: rgba(140, 36, 31, 0.38) !important;
        box-shadow: 0 0 0 3px rgba(140, 36, 31, 0.08) !important;
    }
    #ftApp .dropdown-menu {
        border: 1px solid rgba(120, 73, 42, 0.18) !important;
        border-radius: 8px !important;
        background: #f8f0df url("/web/images/paper-texture.png") !important;
        background-size: 240px !important;
        box-shadow: 0 12px 28px rgba(73, 37, 18, 0.12) !important;
    }
    #ftApp .dropdown-item {
        border-radius: 5px !important;
        color: #593f2e !important;
        font-weight: 600;
    }
    #ftApp .dropdown-item:hover {
        background: rgba(140, 36, 31, 0.08) !important;
        color: #6c1717 !important;
    }
    #ftApp .ft-page-banner {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 14px;
        margin-bottom: 12px;
        padding: 14px 18px;
        border: 1px solid rgba(122, 74, 42, 0.14);
        border-radius: 8px;
        background:
            linear-gradient(180deg, rgba(255, 248, 229, 0.96), rgba(244, 228, 191, 0.96)),
            url("/web/images/hero-paper-bg.png");
        background-size: auto, 360px;
        box-shadow: inset 0 0 0 1px rgba(183, 143, 61, 0.08);
        position: relative;
        overflow: hidden;
    }
    #ftApp .ft-page-banner::before {
        content: "";
        position: absolute;
        inset: 0;
        background:
            radial-gradient(circle at 10% 35%, rgba(143, 32, 32, 0.05), transparent 16%),
            radial-gradient(circle at 88% 40%, rgba(180, 136, 47, 0.08), transparent 16%);
        pointer-events: none;
    }
    #ftApp .ft-page-banner-copy,
    #ftApp .ft-page-banner-actions {
        position: relative;
        z-index: 1;
    }
    #ftApp .ft-page-banner-kicker {
        color: #8a3b22;
        font-size: 12px;
        letter-spacing: 0.12em;
        text-transform: uppercase;
        font-weight: 700;
    }
    #ftApp .ft-page-banner-title {
        margin: 2px 0 4px;
        color: #6a201d;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 28px;
        line-height: 1.18;
        font-weight: 700;
    }
    #ftApp .ft-page-banner-text {
        max-width: 680px;
        margin: 0;
        color: #5e4738;
        font-size: 14px;
        line-height: 1.5;
    }
    #ftApp .ft-page-banner-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        justify-content: flex-end;
    }
    #ftApp .ft-filter-strip {
        margin-bottom: 12px;
        padding: 12px 14px;
        border: 1px solid rgba(122, 74, 42, 0.14);
        border-radius: 8px;
        background:
            linear-gradient(180deg, rgba(255, 250, 238, 0.96), rgba(244, 230, 199, 0.98)),
            url("/web/images/paper-texture.png");
        background-size: auto, 280px;
        box-shadow: 0 8px 20px rgba(73, 37, 18, 0.06);
    }
    #ftApp .ft-filter-grid {
        display: grid !important;
        grid-template-columns: repeat(5, minmax(0, 1fr));
        gap: 10px !important;
        align-items: end;
        min-width: 100% !important;
    }
    #ftApp .ft-filter-field {
        min-width: 0;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }
    #ftApp .ft-filter-field.ft-view-mode-field {
        display: none !important;
    }
    #ftApp .ft-filter-field-search {
        grid-column: span 2;
    }
    #ftApp .ft-filter-label {
        margin: 0;
        color: #704f37 !important;
        font-size: 13px;
        font-weight: 700;
    }
    #ftApp .ft-filter-dropdown .btn {
        width: 100%;
        justify-content: space-between;
        min-height: 40px;
    }
    #ftApp .ft-filter-grid .form-control,
    #ftApp .ft-filter-grid .form-select,
    #ftApp .ft-filter-grid .btn {
        min-height: 40px;
    }
    #ftApp .ft-filter-grid .form-control,
    #ftApp .ft-filter-grid .form-select {
        font-size: 14px;
    }
    #ftApp .ft-quick-strip {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px solid rgba(177, 144, 88, 0.22);
    }
    #ftApp .ft-quick-stats,
    #ftApp .ft-tree-controls {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px;
    }
    #ftApp .ft-stat-chip,
    #ftApp .ft-meta-chip {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 34px;
        padding: 6px 12px;
        border-radius: 999px;
        border: 1px solid rgba(167, 119, 49, 0.24);
        background: rgba(247, 238, 214, 0.95);
        color: #6c211e;
        font-size: 13px;
        font-weight: 700;
    }
    #ftApp .ft-canvas-shell {
        border: 1px solid rgba(122, 74, 42, 0.14);
        border-radius: 8px;
        overflow: hidden;
        background:
            linear-gradient(180deg, rgba(255, 251, 243, 0.96), rgba(244, 229, 194, 0.98)),
            url("/web/images/paper-texture.png");
        background-size: auto, 300px;
        box-shadow: 0 10px 22px rgba(73, 37, 18, 0.06);
    }
    #ftApp .ft-canvas-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        padding: 12px 16px;
        background: #84221e;
        border-bottom: 1px solid rgba(230, 198, 132, 0.22);
        box-shadow: inset 0 0 0 1px rgba(230, 198, 132, 0.1);
    }
    #ftApp .ft-canvas-title {
        color: #fae8bc;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 22px;
        font-weight: 700;
        line-height: 1.2;
    }
    #ftApp .ft-canvas-note {
        margin-top: 2px;
        max-width: 720px;
        color: rgba(255, 241, 207, 0.84);
        font-size: 13px;
        line-height: 1.45;
    }
    #ftApp .ft-canvas-meta {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }
    #ftApp .ft-canvas {
        height: calc(100vh - 218px) !important;
        min-height: 620px;
        background:
            linear-gradient(180deg, rgba(255, 250, 241, 0.88), rgba(238, 220, 178, 0.74)),
            url("/web/images/hero-paper-bg.png") !important;
        background-size: auto, 480px !important;
        border: 0 !important;
        border-radius: 0 !important;
        box-shadow: none !important;
    }
    #ftApp .ft-scroll {
        padding: 22px 28px 44px !important;
        overflow: hidden !important;
        position: relative;
    }
    #ftApp .ft-tree-scale {
        position: relative;
        min-width: max-content;
        min-height: max-content;
    }
    #ftApp .ft-legend {
        left: 18px;
        bottom: 18px;
        background: rgba(249, 241, 222, 0.95) !important;
        border: 1px solid rgba(167, 119, 49, 0.2) !important;
        color: #5d4232;
        box-shadow: 0 8px 18px rgba(73, 37, 18, 0.08) !important;
        border-radius: 8px !important;
    }
    #ftApp .ft-legend-line {
        display: inline-block;
        width: 22px;
        border-top: 2px solid #8b5a36;
    }
    #ftApp .dot {
        border: 1px solid rgba(120, 73, 42, 0.22);
    }
    #ftApp .bg-male { background: #b58c52 !important; }
    #ftApp .bg-female { background: #8c241f !important; }
    #ftApp .bg-other { background: #6b4c35 !important; }
    #ftApp #treeRoot {
        --connector-color: #8b5a36 !important;
        --connector-width: 4px !important;
        --connector-height: 72px !important;
    }
    #ftApp #treeRoot .li-person::before,
    #ftApp #treeRoot .li-person::after {
        border-top-color: #8b5a36 !important;
        border-top-width: 4px !important;
    }
    #ftApp #treeRoot .li-person::after,
    #ftApp #treeRoot .ul-person .ul-person::before,
    #ftApp #treeRoot .li-person:last-child::before {
        border-left-color: #8b5a36 !important;
        border-left-width: 4px !important;
        border-right-color: #8b5a36 !important;
        border-right-width: 4px !important;
    }
    #ftApp #treeRoot .box-person {
        --node-width: 206px;
        --spouse-gap: 20px;
        min-height: 248px;
        padding-right: calc(var(--node-width) + var(--spouse-gap));
    }
    #ftApp #treeRoot .box-person.no-spouse {
        padding-right: 0;
    }
    #ftApp #treeRoot .box-person.has-spouse {
        min-width: calc((var(--node-width) * 2) + var(--spouse-gap));
    }
    #ftApp #treeRoot .box-person.has-spouse::before {
        content: "" !important;
        width: 10px;
        height: 10px;
        background: #8c241f;
        border: 2px solid #f7efdd;
        box-shadow: 0 0 0 1px rgba(140, 36, 31, 0.2);
    }
    #ftApp #treeRoot .box-person.has-spouse::after {
        content: "" !important;
        border-top: 3px solid #8c241f !important;
        box-shadow: none !important;
    }
    #ftApp #treeRoot .person-node {
        width: var(--node-width);
        min-height: 224px;
        border-radius: 6px !important;
        border: 1px solid rgba(120, 73, 42, 0.18) !important;
        padding: 10px 10px 12px !important;
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)),
            url("/web/images/paper-texture.png") !important;
        background-size: auto, 240px !important;
        box-shadow: 0 8px 20px rgba(73, 37, 18, 0.08) !important;
        position: relative;
        overflow: visible;
        transition: transform 0.16s ease, box-shadow 0.16s ease, border-color 0.16s ease;
    }
    #ftApp #treeRoot .person-node::before,
    #ftApp #treeRoot .person-node::after {
        content: "";
        position: absolute;
        width: 22px;
        height: 22px;
        pointer-events: none;
        border-color: rgba(180, 136, 47, 0.44);
    }
    #ftApp #treeRoot .person-node::before {
        top: 6px;
        left: 6px;
        border-top: 1px solid rgba(180, 136, 47, 0.44);
        border-left: 1px solid rgba(180, 136, 47, 0.44);
    }
    #ftApp #treeRoot .person-node::after {
        right: 6px;
        bottom: 6px;
        border-right: 1px solid rgba(180, 136, 47, 0.44);
        border-bottom: 1px solid rgba(180, 136, 47, 0.44);
    }
    #ftApp #treeRoot .person-node:hover {
        transform: translateY(-2px);
        border-color: rgba(140, 36, 31, 0.34) !important;
        box-shadow: 0 12px 28px rgba(73, 37, 18, 0.12) !important;
    }
    #ftApp #treeRoot .person-node.male,
    #ftApp #treeRoot .person-node.female,
    #ftApp #treeRoot .person-node.other {
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)),
            url("/web/images/paper-texture.png") !important;
    }
    #ftApp #treeRoot .person-node.female {
        border-color: rgba(140, 36, 31, 0.22) !important;
    }
    #ftApp #treeRoot .person-node.male {
        border-color: rgba(181, 140, 82, 0.26) !important;
    }
    #ftApp #treeRoot .person-node.person-role-founder {
        background:
            linear-gradient(180deg, rgba(255, 245, 213, 1), rgba(238, 214, 162, 0.98)),
            url("/web/images/paper-texture.png") !important;
        border-color: rgba(140, 36, 31, 0.28) !important;
    }
    #ftApp #treeRoot .person-node.person-role-lineage-head {
        border-color: rgba(151, 97, 43, 0.34) !important;
    }
    #ftApp #treeRoot .person-node.person-role-notable {
        box-shadow: 0 10px 24px rgba(140, 36, 31, 0.08) !important;
    }
    #ftApp #treeRoot .person-node.person-role-deceased .avatar-tree {
        filter: grayscale(0.18);
    }
    #ftApp #treeRoot .avatar-tree {
        width: 104px !important;
        height: 96px !important;
        margin-top: 14px !important;
        border-radius: 6px !important;
        border: 2px solid rgba(255, 244, 214, 0.9);
        box-shadow: 0 4px 10px rgba(73, 37, 18, 0.12);
        pointer-events: none;
    }
    #ftApp #treeRoot .ft-node-headline {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        min-height: 22px;
        padding: 0 2px;
    }
    #ftApp #treeRoot .ft-node-role,
    #ftApp #treeRoot .ft-node-gender,
    #ftApp #treeRoot .ft-node-status {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 22px;
        padding: 2px 8px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    #ftApp #treeRoot .ft-node-role {
        background: rgba(140, 36, 31, 0.08);
        color: #7b221f;
        border: 1px solid rgba(140, 36, 31, 0.12);
    }
    #ftApp #treeRoot .ft-node-gender {
        background: rgba(181, 140, 82, 0.14);
        color: #6a4b33;
        border: 1px solid rgba(181, 140, 82, 0.16);
    }
    #ftApp #treeRoot .ft-node-status {
        margin-top: 6px;
        background: rgba(76, 50, 38, 0.08);
        color: #4c3226;
        border: 1px solid rgba(76, 50, 38, 0.1);
    }
    #ftApp #treeRoot .person-text {
        margin-top: 6px !important;
        padding: 0 4px;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    #ftApp #treeRoot .name-phado {
        color: #46271d;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 20px !important;
        line-height: 1.35 !important;
        font-weight: 700;
        letter-spacing: 0.01em;
        text-shadow: 0 0 0 rgba(0, 0, 0, 0.01);
    }
    #ftApp #treeRoot .person-dates {
        margin-top: 6px;
        color: #654c3c;
        font-size: 14px !important;
        line-height: 1.55 !important;
        font-weight: 500;
        text-shadow: 0 0 0 rgba(0, 0, 0, 0.01);
    }
    #ftApp #treeRoot .person-date-line .date-label {
        color: #6f231f;
    }
    #ftApp #treeRoot .btn-setting-custom {
        opacity: 0;
        transform: translateY(-2px);
        transition: opacity 0.14s ease, transform 0.14s ease;
    }
    #ftApp #treeRoot .person-node:hover .btn-setting-custom,
    #ftApp #treeRoot .person-node.menu-open .btn-setting-custom {
        opacity: 1;
        transform: translateY(0);
    }
    #ftApp #treeRoot .btn-setting-custom .btn {
        width: 30px;
        height: 24px;
        min-height: 24px;
        padding: 0;
        border-radius: 0 6px 0 6px !important;
        background: rgba(99, 29, 26, 0.92) !important;
        color: #f8e7b8 !important;
        border: 0 !important;
    }
    #ftApp #treeRoot .tree-action-menu {
        min-width: 210px;
        border-radius: 6px;
        border: 1px solid rgba(120, 73, 42, 0.16);
        background: #f8f0df url("/web/images/paper-texture.png") !important;
        background-size: 220px !important;
        box-shadow: 0 14px 30px rgba(73, 37, 18, 0.16);
    }
    #ftApp #treeRoot .tree-action-menu .dropdown-item {
        padding: 9px 12px;
        font-size: 14px;
    }
    #ftApp .ft-branch-toggle-wrap {
        display: flex;
        justify-content: center;
        margin: 6px 0 2px;
    }
    #ftApp .ft-branch-subtree {
        overflow: hidden;
        transform-origin: top center;
        transition: max-height 190ms ease, opacity 190ms ease;
        opacity: 1;
    }
    #ftApp .ft-branch-subtree.is-collapsed {
        max-height: 0 !important;
        opacity: 0;
        pointer-events: none;
    }
    #ftApp .ft-branch-toggle {
        border: 1px solid rgba(167, 119, 49, 0.2);
        border-radius: 999px;
        background: rgba(249, 239, 214, 0.95);
        color: #6a201d;
        font-size: 12px;
        font-weight: 700;
        padding: 5px 12px;
    }
    #ftApp .ft-branch-toggle:hover {
        background: rgba(245, 231, 196, 1);
    }
    #ftApp #treeRoot .ft-overflow-label,
    #ftApp #treeRoot .ft-overflow-generation {
        background: rgba(249, 239, 214, 0.98);
        border: 1px solid rgba(167, 119, 49, 0.2);
        color: #7a221e;
        font-size: 12px;
    }
    #ftApp .ft-focus-hit {
        animation: ftNodeFocusPulse 2.4s ease;
    }
    @keyframes ftNodeFocusPulse {
        0% { box-shadow: 0 0 0 0 rgba(140, 36, 31, 0.26); }
        40% { box-shadow: 0 0 0 12px rgba(140, 36, 31, 0.06); }
        100% { box-shadow: 0 0 0 0 rgba(140, 36, 31, 0); }
    }
    #ftApp .ft-empty {
        color: #6a201d;
        font-size: 18px;
    }
    #ftApp .modal-content,
    #ftApp .offcanvas {
        border-radius: 8px !important;
        background: #f8f0df url("/web/images/paper-texture.png") !important;
        background-size: 260px !important;
        border: 1px solid rgba(120, 73, 42, 0.16);
        box-shadow: 0 18px 40px rgba(73, 37, 18, 0.16) !important;
    }
    #ftApp .modal-header,
    #ftApp .modal-footer,
    #ftApp .offcanvas-header {
        background: transparent !important;
        border-color: rgba(167, 119, 49, 0.16) !important;
    }
    #ftApp .modal-title,
    #ftApp .offcanvas-title {
        color: #6a201d;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 24px;
    }
    #ftApp .btn-close {
        background: rgba(255, 248, 229, 0.92) !important;
        border-color: rgba(120, 73, 42, 0.18) !important;
    }
    #ftApp .ft-detail-shell {
        display: flex;
        flex-direction: column;
        gap: 18px;
    }
    #ftApp .ft-detail-hero {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 16px;
        border: 1px solid rgba(167, 119, 49, 0.14);
        border-radius: 6px;
        background: rgba(255, 249, 233, 0.88);
    }
    #ftApp .ft-detail-avatar {
        width: 96px;
        height: 96px;
        border-radius: 6px;
        object-fit: cover;
        border: 2px solid rgba(255, 244, 214, 0.9);
    }
    #ftApp .ft-detail-role {
        color: #8a3b22;
        font-size: 14px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }
    #ftApp .ft-detail-name {
        margin: 4px 0 6px;
        color: #4a281b;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 30px;
        line-height: 1.3;
    }
    #ftApp .ft-detail-subline {
        color: #6a5140;
        font-size: 16px;
    }
    #ftApp .ft-detail-tags {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
        margin-top: 10px;
    }
    #ftApp .ft-detail-pill {
        display: inline-flex;
        align-items: center;
        min-height: 30px;
        padding: 6px 12px;
        border-radius: 999px;
        border: 1px solid rgba(167, 119, 49, 0.22);
        background: rgba(249, 239, 214, 0.95);
        color: #6a201d;
        font-size: 14px;
        font-weight: 700;
        margin: 2px 6px 2px 0;
    }
    #ftApp .ft-detail-empty {
        color: #7a6452;
        font-size: 15px;
    }
    #ftApp .ft-detail-media-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
        gap: 12px;
        margin-top: 8px;
    }
    #ftApp .ft-detail-media-item {
        display: block;
        border-radius: 6px;
        overflow: hidden;
        border: 1px solid rgba(167, 119, 49, 0.16);
        background: rgba(255, 250, 238, 0.92);
    }
    #ftApp .ft-detail-media-item img {
        width: 100%;
        height: 108px;
        object-fit: cover;
        display: block;
    }
    #ftApp.ft-view-minimal #treeRoot .avatar-tree,
    #ftApp.ft-view-minimal #treeRoot .person-dates,
    #ftApp.ft-view-minimal #treeRoot .ft-node-status,
    #ftApp.ft-view-minimal #treeRoot .ft-node-role {
        display: none !important;
    }
    #ftApp.ft-view-minimal #treeRoot .person-node {
        min-height: 126px !important;
        padding-top: 14px !important;
    }
    #ftApp.ft-view-minimal #treeRoot .person-text {
        margin-top: 16px !important;
    }
    #ftApp.ft-view-print .ft-filter-strip,
    #ftApp.ft-view-print .ft-page-banner,
    #ftApp.ft-view-print .ft-canvas-head,
    #ftApp.ft-view-print .btn-setting-custom,
    #ftApp.ft-view-print .ft-legend {
        display: none !important;
    }
    #ftApp.ft-view-print .ft-canvas {
        height: auto !important;
        min-height: 0 !important;
        background: #fffdf8 !important;
    }
    @media (max-width: 1200px) {
        #ftApp .ft-filter-grid {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }
    }
    @media (max-width: 991px) {
        #ftApp .ft-page-banner,
        #ftApp .ft-quick-strip,
        #ftApp .ft-canvas-head {
            flex-direction: column;
            align-items: flex-start;
        }
        #ftApp .ft-page-banner-title {
            font-size: 24px;
        }
        #ftApp .ft-filter-grid {
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }
        #ftApp .ft-filter-field-search {
            grid-column: span 3;
        }
        #ftApp .ft-canvas {
            height: calc(100vh - 200px) !important;
            min-height: 560px;
        }
        #ftApp #treeRoot .box-person {
            --node-width: 168px;
            --spouse-gap: 16px;
        }
        #ftApp #treeRoot .person-node {
            min-height: 210px;
        }
        #ftApp #treeRoot .name-phado {
            font-size: 18px !important;
        }
        #ftApp #treeRoot .person-dates {
            font-size: 13px !important;
        }
    }
    @media (max-width: 767px) {
        #ftApp .ft-filter-grid {
            grid-template-columns: 1fr;
        }
        #ftApp .ft-filter-field-search {
            grid-column: auto;
        }
        #ftApp .ft-page-banner,
        #ftApp .ft-filter-strip {
            padding: 12px;
        }
        #ftApp .ft-page-banner-title {
            font-size: 22px;
        }
        #ftApp .ft-page-banner-text,
        #ftApp .ft-canvas-note {
            font-size: 13px;
        }
        #ftApp .ft-canvas {
            min-height: 480px;
            height: calc(100vh - 170px) !important;
        }
        #ftApp .ft-scroll {
            padding: 16px 12px 28px !important;
        }
        #ftApp #treeRoot .box-person {
            --node-width: 166px;
            --spouse-gap: 12px;
        }
        #ftApp #treeRoot .person-node {
            min-height: 198px;
        }
        #ftApp #treeRoot .avatar-tree {
            width: 90px !important;
            height: 82px !important;
        }
        #ftApp #treeRoot .name-phado {
            font-size: 17px !important;
        }
        #ftApp #treeRoot .person-dates {
            font-size: 13px !important;
        }
        #ftApp .modal-dialog {
            padding: 0 !important;
            margin: 0 !important;
            min-height: 100% !important;
        }
        #ftApp .modal-content {
            min-height: 100vh;
            max-height: none !important;
            border-radius: 0 !important;
        }
        #ftApp .ft-detail-hero {
            flex-direction: column;
            align-items: flex-start;
        }
        #ftApp .ft-detail-name {
            font-size: 24px;
        }
    }
    @media print {
        body.admin-modern .app-sidebar,
        body.admin-modern .app-topbar,
        body.admin-modern .app-footer,
        #ftApp .ft-page-banner,
        #ftApp .ft-filter-strip,
        #ftApp .ft-canvas-head,
        #ftApp .btn-setting-custom,
        #ftApp .ft-legend {
            display: none !important;
        }
        body.admin-modern .main-content,
        body.admin-modern .main-content-inner {
            margin: 0 !important;
            padding: 0 !important;
            background: #fff !important;
        }
        #ftApp .ft-canvas-shell,
        #ftApp .ft-canvas {
            border: 0 !important;
            box-shadow: none !important;
            background: #fff !important;
            height: auto !important;
            min-height: 0 !important;
        }
        #ftApp .ft-scroll {
            overflow: visible !important;
            height: auto !important;
            padding: 0 !important;
        }
        #ftApp .ft-tree-scale {
            transform: none !important;
        }
    }
</style>

<% boolean canManageMember = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
                <li class="active">Cây gia phả</li>
            </ul>
        </div>
        <div class="page-content family-tree-page">
<div id="ftApp" class="bg-light">
    <div class="container-fluid">
        <div class="ft-page-banner">
            <div class="ft-page-banner-copy">
                <div class="ft-page-banner-kicker">Sơ đồ huyết thống</div>
                <h2 class="ft-page-banner-title">Theo dõi nhiều thế hệ trong dòng họ</h2>
                <p class="ft-page-banner-text">Tra cứu quan hệ, chi họ và thế hệ để nhìn rõ mạch nối giữa các nhánh gia phả.</p>
            </div>
            <div class="ft-page-banner-actions">
                <a href="${guideUrl}" class="btn btn-light ft-hero-guide-btn">
                    <i class="fa fa-book"></i>
                    Xem hướng dẫn sử dụng
                </a>
                <% if (canManageMember) { %>
                    <button id="btnCreateFirst" class="btn btn-dark d-flex align-items-center gap-2">
                        <i class="fa fa-user-plus"></i>
                        Thêm thành viên
                    </button>
                <% } %>
            </div>
        </div>

        <div class="ft-filter-strip">
            <div id="advancedFilterBar" class="ft-filter-grid">
                <div class="ft-filter-field ft-filter-field-search">
                    <label for="ftFilterName" class="ft-filter-label">Tìm theo họ tên</label>
                    <input id="ftFilterName" class="form-control input-sm" placeholder="Nhập tên người cần tra cứu..." />
                </div>

                <div class="ft-filter-field">
                    <label class="ft-filter-label">Chi họ / nhánh họ</label>
                    <div id="branchDropdown" class="dropdown ft-filter-dropdown">
                        <button type="button" class="btn btn-sm btn-light dropdown-toggle">
                            <i class="fa fa-sitemap"></i>
                            <span id="activeBranchLabel">Toàn bộ</span>
                        </button>
                        <ul id="branchMenu" class="dropdown-menu"></ul>
                    </div>
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterGeneration" class="ft-filter-label">Thế hệ</label>
                    <select id="ftFilterGeneration" class="form-control form-select">
                        <option value="">Tất cả thế hệ</option>
                    </select>
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterGender" class="ft-filter-label">Giới tính</label>
                    <select id="ftFilterGender" class="form-control form-select">
                        <option value="">Tất cả</option>
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterLifeStatus" class="ft-filter-label">Tình trạng</label>
                    <select id="ftFilterLifeStatus" class="form-control form-select">
                        <option value="">Còn sống và đã mất</option>
                        <option value="alive">Còn sống</option>
                        <option value="deceased">Đã mất</option>
                    </select>
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterDob" class="ft-filter-label">Ngày sinh</label>
                    <input id="ftFilterDob" type="date" class="form-control input-sm" aria-label="Lọc theo ngày sinh" />
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterBirthYear" class="ft-filter-label">Năm sinh</label>
                    <input id="ftFilterBirthYear" type="number" min="1" max="9999" class="form-control input-sm" placeholder="Ví dụ 1942" />
                </div>

                <div class="ft-filter-field">
                    <label for="ftFilterDeathYear" class="ft-filter-label">Năm mất</label>
                    <input id="ftFilterDeathYear" type="number" min="1" max="9999" class="form-control input-sm" placeholder="Ví dụ 2020" />
                </div>

                <div class="ft-filter-field ft-view-mode-field">
                    <label for="ftViewMode" class="ft-filter-label">Chế độ xem</label>
                    <select id="ftViewMode" class="form-control form-select">
                        <option value="full">Đầy đủ</option>
                        <option value="minimal">Tối giản</option>
                        <option value="print">In ấn</option>
                    </select>
                </div>

                <div class="ft-filter-field ft-filter-action">
                    <button id="ftFilterReset" class="btn btn-sm btn-light" type="button">
                        <i class="fa fa-refresh"></i>
                        Làm mới
                    </button>
                </div>
            </div>

            <div class="ft-quick-strip">
                <div id="treeQuickStats" class="ft-quick-stats">
                    <span id="ftStatGenerations" class="ft-stat-chip">0 thế hệ</span>
                    <span id="ftStatMembers" class="ft-stat-chip">0 thành viên</span>
                </div>

                <div class="ft-tree-controls">
                    <button id="ftZoomOut" type="button" class="btn btn-sm btn-light"><i class="fa fa-search-minus"></i> Thu nhỏ</button>
                    <button id="ftZoomIn" type="button" class="btn btn-sm btn-light"><i class="fa fa-search-plus"></i> Phóng to</button>
                    <button id="ftCenterRoot" type="button" class="btn btn-sm btn-light"><i class="fa fa-bullseye"></i> Về trung tâm</button>
                    <button id="ftCollapseAll" type="button" class="btn btn-sm btn-light"><i class="fa fa-compress"></i> Thu gọn nhánh</button>
                    <button id="ftExpandAll" type="button" class="btn btn-sm btn-light"><i class="fa fa-expand"></i> Mở rộng nhánh</button>
                </div>
            </div>
        </div>

        <div class="ft-canvas-shell">
            <div class="ft-canvas-head">
                <div>
                    <div class="ft-canvas-title">Sơ đồ huyết thống</div>
                    <div class="ft-canvas-note">Thủy tổ ở trên cùng, các đời tiếp nối theo tầng.</div>
                </div>
                <div class="ft-canvas-meta">
                    <span class="ft-meta-chip">Quan hệ vợ chồng nằm ngang</span>
                    <span class="ft-meta-chip">Cha mẹ - con cái theo trục dọc</span>
                </div>
            </div>

            <div class="ft-canvas">
                <div id="contentArea" class="ft-scroll">
                    <div id="scaleWrap" class="ft-tree-scale">
                        <div class="d-flex justify-content-center">
                            <div id="treeRoot"></div>
                        </div>
                    </div>
                </div>

                <div id="legend" class="ft-legend">
                    <span class="text-uppercase text-secondary fw-bold" style="font-size: 11px; letter-spacing: .12em;">Chú giải</span>
                    <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-male"></span> Nam</span>
                    <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-female"></span> Nữ</span>
                    <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-other"></span> Khác</span>
                    <span style="width:1px;height:16px;background:#c9b78e;"></span>
                    <span class="d-inline-flex align-items-center gap-2">
                        <span class="ft-legend-line"></span> Huyết thống
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Member Modal -->
    <div class="modal" id="memberModal" aria-hidden="true">
        <div class="modal-backdrop" data-close="memberModal"></div>
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 id="modalTitle" class="modal-title fw-semibold">Tạo thành viên</h5>
                    <button type="button" class="btn-close" data-close="memberModal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                            <input id="mFullname" class="form-control" placeholder="Nhập họ và tên..." />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Cách thêm thành viên</label>
                            <div class="d-flex gap-3">
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mSourceMode" value="new" checked> Tạo thành viên mới
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mSourceMode" value="existing"> Chọn từ danh sách có sẵn
                                </label>
                            </div>
                        </div>
                        <div class="col-12" id="mExistingWrap" style="display:none;">
                            <label class="form-label fw-semibold">Thành viên có sẵn</label>
                            <input id="mExistingFilter" class="form-control" placeholder="Tìm theo tên thành viên..." />
                            <div style="height:8px"></div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <select id="mExistingGenderFilter" class="form-select">
                                        <option value="">-- Lọc giới tính --</option>
                                        <option value="male">Nam</option>
                                        <option value="female">Nữ</option>
                                        <option value="other">Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <input type="date" id="mExistingDobFilter" class="form-control" />
                                </div>
                            </div>
                            <div style="height:8px"></div>
                            <select id="mExistingPerson" class="form-select">
                                <option value="">-- Chọn thành viên --</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Ngày sinh</label>
                            <input type="date" id="mDob" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Ngày mất (nếu có)</label>
                            <input type="date" id="mDod" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Đời (Thế hệ)</label>
                            <input id="mGeneration" type="number" min="1" max="50" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Chi / Nhánh</label>
                            <input id="mBranchName" class="form-control" value="Tự động: Chính" readonly />
                            <input id="mBranch" type="hidden" value="" />
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Giới tính</label>
                            <div class="d-flex gap-2">
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gMale" value="male"> Nam
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gFemale" value="female"> Nữ
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gOther" value="other"> Khác
                                </label>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Ảnh đại diện</label>
                            <input id="mAvatar" type="hidden" />
                            <input id="mAvatarFile" type="file" accept="image/*" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Quê quán</label>
                            <input id="mHometown" class="form-control" placeholder="Nhập quê quán" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nơi ở hiện tại (mộ phần)</label>
                            <input id="mCurrentResidence" class="form-control" placeholder="Nhập nơi ở hiện tại hoặc mộ phần" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nghề nghiệp</label>
                            <input id="mOccupation" class="form-control" placeholder="Nhập nghề nghiệp" />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Ghi chú khác</label>
                            <textarea id="mOtherNote" class="form-control" rows="3" placeholder="Nhập ghi chú khác"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button class="btn btn-link text-secondary" data-close="memberModal">Hủy</button>
                    <button id="btnSaveMember" class="btn btn-dark"><i class="bi bi-plus-lg"></i> Lưu thành viên</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal action-modal" id="actionMemberModal" aria-hidden="true">
        <div class="modal-backdrop" data-close="actionMemberModal"></div>
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="head-left">
                        <span class="head-icon" id="actionModalIcon"><i class="bi bi-person-plus"></i></span>
                        <h5 id="actionModalTitle" class="modal-title fw-semibold">Thêm thành viên</h5>
                    </div>
                    <button type="button" class="btn-close" data-close="actionMemberModal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">HỌ VÀ TÊN <span class="text-danger">*</span></label>
                            <input id="aFullname" class="form-control" placeholder="Nhập họ và tên..." />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">CÁCH THÊM THÀNH VIÊN</label>
                            <div class="d-flex gap-3">
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="aSourceMode" value="new" checked> Tạo thành viên mới
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="aSourceMode" value="existing"> Chọn từ danh sách có sẵn
                                </label>
                            </div>
                        </div>
                        <div class="col-12" id="aExistingWrap" style="display:none;">
                            <label class="form-label fw-semibold">THÀNH VIÊN CÓ SẴN</label>
                            <input id="aExistingFilter" class="form-control" placeholder="Tìm theo tên thành viên..." />
                            <div style="height:8px"></div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <select id="aExistingGenderFilter" class="form-select">
                                        <option value="">-- Lọc giới tính --</option>
                                        <option value="male">Nam</option>
                                        <option value="female">Nữ</option>
                                        <option value="other">Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <input type="date" id="aExistingDobFilter" class="form-control" />
                                </div>
                            </div>
                            <div style="height:8px"></div>
                            <select id="aExistingPerson" class="form-select">
                                <option value="">-- Chọn thành viên --</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NGÀY SINH</label>
                            <input type="date" id="aDob" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NGÀY MẤT (NẾU CÓ)</label>
                            <input type="date" id="aDod" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">ĐỜI (THẾ HỆ)</label>
                            <input id="aGeneration" type="number" min="1" max="50" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">CHI / NHÁNH</label>
                            <input id="aBranchName" class="form-control" value="Tự động theo quan hệ gia phả" readonly />
                            <input id="aBranch" type="hidden" value="" />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">GIỚI TÍNH</label>
                            <div class="gender-grid" id="actionGenderGrid">
                                <button type="button" class="gender-choice" data-gender="male">
                                    <i class="bi bi-gender-male"></i><span>Nam</span>
                                </button>
                                <button type="button" class="gender-choice" data-gender="female">
                                    <i class="bi bi-gender-female"></i><span>Nữ</span>
                                </button>
                                <button type="button" class="gender-choice" data-gender="other">
                                    <i class="bi bi-gender-ambiguous"></i><span>Khác</span>
                                </button>
                            </div>
                            <input type="hidden" id="aGender" />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">ẢNH ĐẠI DIỆN</label>
                            <input id="aAvatar" type="hidden" />
                            <input id="aAvatarFile" type="file" accept="image/*" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">QUÊ QUÁN</label>
                            <input id="aHometown" class="form-control" placeholder="Nhập quê quán" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NƠI Ở HIỆN TẠI (MỘ PHẦN)</label>
                            <input id="aCurrentResidence" class="form-control" placeholder="Nhập nơi ở hiện tại hoặc mộ phần" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NGHỀ NGHIỆP</label>
                            <input id="aOccupation" class="form-control" placeholder="Nhập nghề nghiệp" />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">GHI CHÚ KHÁC</label>
                            <textarea id="aOtherNote" class="form-control" rows="3" placeholder="Nhập ghi chú khác"></textarea>
                        </div>
                    </div>
                </div>
                <div class="action-footer">
                    <button class="btn btn-link text-secondary" data-close="actionMemberModal">Hủy</button>
                    <button id="btnSaveActionMember" class="btn btn-save-strong">
                        <i class="bi bi-plus-lg"></i> Lưu thành viên
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal ft-confirm-modal" id="ftConfirmModal" aria-hidden="true">
        <div class="modal-backdrop" id="ftConfirmBackdrop"></div>
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-semibold">Xác nhận thao tác</h5>
                    <button type="button" class="btn-close" id="ftConfirmClose" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p id="ftConfirmMessage" class="mb-0"></p>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" id="ftConfirmCancel" class="btn btn-link text-secondary">Hủy</button>
                    <button type="button" id="ftConfirmOk" class="btn btn-dark">Đồng ý</button>
                </div>
            </div>
        </div>
    </div>

    <div id="ftToastWrap" class="ft-toast-wrap" aria-live="polite" aria-atomic="true"></div>

    <!-- Detail Member Modal -->
    <div class="modal" id="detailMemberModal" aria-hidden="true">
        <div class="modal-backdrop" data-close="detailMemberModal"></div>
        <div class="modal-dialog" style="max-width: 760px;">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-semibold">Chi tiết thành viên</h5>
                    <button type="button" class="btn-close" data-close="detailMemberModal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="detailMemberBody"></div>
                <div class="modal-footer bg-light" id="detailMemberActions"></div>
            </div>
        </div>
    </div>

    <script>
        // Nếu muốn truyền branchId từ server side:
        // const BRANCH_ID = "<%= request.getAttribute("branchId") %>";
        let BRANCH_ID = 0;
        const HOME_TOTAL_MEMBERS = Number('${empty totalMembers ? 0 : totalMembers}');
        const canManageMember = <%= canManageMember %>;

        // Dropdown minimal toggle (không phụ thuộc BS5)
        (function () {
            const dd = document.getElementById('branchDropdown');
            if (!dd) return;
            const btn = dd.querySelector('.dropdown-toggle');
            const menu = dd.querySelector('.dropdown-menu');
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                menu.classList.toggle('show');
            });
            document.addEventListener('click', function () {
                menu.classList.remove('show');
            });
        })();

        let BRANCH_CACHE = [];
        let CURRENT_TREE_ROOTS = [];
        const ROOT_PERSON_CACHE = {};
        let CURRENT_NAME_FILTER = '';
        let CURRENT_DOB_FILTER = '';
        let CURRENT_GENERATION_FILTER = null;
        let CURRENT_GENDER_FILTER = '';
        let CURRENT_LIFE_STATUS_FILTER = '';
        let CURRENT_BIRTH_YEAR_FROM = null;
        let CURRENT_BIRTH_YEAR_TO = null;
        let CURRENT_DEATH_YEAR = null;
        let CURRENT_VIEW_MODE = 'full';
        let CURRENT_FOCUS_PERSON_ID = null;
        let CURRENT_TREE_MODE = 'default';
        let CURRENT_DESCENDANT_ROOT_ID = null;
        let FT_SUPPRESS_CLICK_UNTIL = 0;
        let ACTIVE_BRANCH_NAME = '';
        let FT_RENDER_PENDING = false;
        let FT_FILTER_RENDER_SEQ = 0;
        let FT_FILTER_DEBOUNCE = null;
        const COLLAPSED_NODE_IDS = new Set();
        const SERVER_TOTAL_GENERATIONS = Number('${empty totalGenerations ? 1 : totalGenerations}');
        const FT_VIEWPORT = {
            initialized: false,
            scale: 1,
            panX: 0,
            panY: 0,
            skipPanClampOnce: false
        };
        const EXISTING_PERSON_CACHE = {
            m: [],
            a: []
        };

        function normalizeBranchKey(name) {
            const normalized = normalizeSearchText(name).trim();
            if (!normalized) return '';
            if (normalized === 'chinh' || normalized === 'main') return 'main';
            const match = normalized.match(/\d+/);
            return match ? match[0] : normalized;
        }

        function isMainBranchName(name) {
            return normalizeBranchKey(name) === 'main';
        }

        function getDefaultFormBranchId(branches) {
            const source = Array.isArray(branches) && branches.length ? branches : BRANCH_CACHE;
            const mainBranch = source.find(function (branch) {
                return Number(branch && branch.id || 0) > 0 && isMainBranchName(branch && branch.name);
            });
            if (mainBranch && Number(mainBranch.id || 0) > 0) {
                return Number(mainBranch.id);
            }
            if (Number(BRANCH_ID || 0) > 0) {
                return Number(BRANCH_ID);
            }
            const firstRealBranch = source.find(function (branch) {
                return Number(branch && branch.id || 0) > 0;
            });
            return firstRealBranch ? Number(firstRealBranch.id) : 0;
        }

        function getTreeBranchQueryId() {
            const normalized = Number(BRANCH_ID || 0);
            return Number.isFinite(normalized) ? normalized : 0;
        }

        function requestTreeRender() {
            if (FT_RENDER_PENDING) return;
            FT_RENDER_PENDING = true;
            requestAnimationFrame(function () {
                FT_RENDER_PENDING = false;
                applyGenerationFilterAndRender();
            });
        }

        function findPersonByIdInTree(person, personId) {
            if (!person) return null;
            if (Number(person.id) === Number(personId)) return person;
            const children = Array.isArray(person.children) ? person.children : [];
            for (let i = 0; i < children.length; i += 1) {
                const found = findPersonByIdInTree(children[i], personId);
                if (found) return found;
            }
            return null;
        }

        function findPersonByIdInRoots(personId) {
            if (!Array.isArray(CURRENT_TREE_ROOTS)) return null;
            for (let i = 0; i < CURRENT_TREE_ROOTS.length; i += 1) {
                const found = findPersonByIdInTree(CURRENT_TREE_ROOTS[i], personId);
                if (found) return found;
            }
            return null;
        }

        function findAnchorNodeByMemberIdInTree(person, personId) {
            if (!person) return null;
            const spouseMatched = getPersonSpouses(person).some(function (spouse) {
                return Number(spouse && spouse.id || 0) === Number(personId);
            });
            if (Number(person.id) === Number(personId) || spouseMatched) {
                return person;
            }
            const children = Array.isArray(person.children) ? person.children : [];
            for (let i = 0; i < children.length; i += 1) {
                const found = findAnchorNodeByMemberIdInTree(children[i], personId);
                if (found) return found;
            }
            return null;
        }

        function findAnchorNodeByMemberIdInRoots(personId) {
            if (!Array.isArray(CURRENT_TREE_ROOTS)) return null;
            for (let i = 0; i < CURRENT_TREE_ROOTS.length; i += 1) {
                const found = findAnchorNodeByMemberIdInTree(CURRENT_TREE_ROOTS[i], personId);
                if (found) return found;
            }
            return null;
        }

        function setBranchFormOptions(branches) {
            const defaultBranchId = getDefaultFormBranchId(branches);
            const hiddenBranchIds = ['mBranch', 'aBranch'];
            hiddenBranchIds.forEach(function (inputId) {
                const inputEl = document.getElementById(inputId);
                if (!inputEl) return;
                if (inputEl.value == null || inputEl.value === '') {
                    inputEl.value = defaultBranchId > 0 ? String(defaultBranchId) : '';
                }
            });
        }

        function renderBranchMenu(branches, preferredBranchId) {
            const branchMenu = document.getElementById('branchMenu');
            const activeBranchLabel = document.getElementById('activeBranchLabel');
            if (!branchMenu || !activeBranchLabel) return;
            const allBranches = Array.isArray(branches) ? branches : [];
            BRANCH_CACHE = [{ id: 0, name: 'Toàn bộ' }];
            allBranches.forEach(function (item) {
                const id = Number(item && item.id || 0);
                if (!id) return;
                if (!BRANCH_CACHE.some(function (x) { return Number(x.id) === id; })) {
                    BRANCH_CACHE.push(item);
                }
            });

            branchMenu.innerHTML = BRANCH_CACHE.map(function (branch) {
                const id = Number(branch.id);
                const name = id === 0 ? 'Toàn bộ' : (branch.name || ('Chi ' + id));
                return '<li><button type="button" class="dropdown-item" data-branch-id="' + id + '">' + escapeHtml(name) + '</button></li>';
            }).join('');

            const targetBranchId = preferredBranchId != null ? Number(preferredBranchId) : Number(BRANCH_ID);
            let currentBranch = BRANCH_CACHE.find(function (branch) {
                return Number(branch.id) === targetBranchId;
            });
            if (!currentBranch) {
                currentBranch = BRANCH_CACHE[0];
            }

            if (currentBranch) {
                BRANCH_ID = Number(currentBranch.id);
                ACTIVE_BRANCH_NAME = String(currentBranch.name || '');
                activeBranchLabel.textContent = Number(currentBranch.id) === 0
                    ? 'Toàn bộ'
                    : (currentBranch.name || ('Chi ' + currentBranch.id));
                const formBranchId = getDefaultFormBranchId(allBranches);
                const mBranch = document.getElementById('mBranch');
                const aBranch = document.getElementById('aBranch');
                if (mBranch) mBranch.value = formBranchId > 0 ? String(formBranchId) : '';
                if (aBranch) aBranch.value = formBranchId > 0 ? String(formBranchId) : '';
            }

            if (branchMenu.dataset.boundMenuClick !== 'true') {
                branchMenu.dataset.boundMenuClick = 'true';
                branchMenu.addEventListener('click', function (e) {
                    const target = e.target.closest('[data-branch-id]');
                    if (!target) return;
                    const nextBranchId = Number(target.getAttribute('data-branch-id'));
                    const selected = BRANCH_CACHE.find(function (branch) {
                        return Number(branch.id) === nextBranchId;
                    });
                    if (!selected) return;

                    BRANCH_ID = nextBranchId;
                    ACTIVE_BRANCH_NAME = String(selected.name || '');
                    activeBranchLabel.textContent = nextBranchId === 0
                        ? 'Toàn bộ'
                        : (selected.name || ('Chi ' + selected.id));
                    CURRENT_FOCUS_PERSON_ID = null;
                    COLLAPSED_NODE_IDS.clear();
                    const formBranchId = getDefaultFormBranchId(allBranches);
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = formBranchId > 0 ? String(formBranchId) : '';
                    if (aBranch) aBranch.value = formBranchId > 0 ? String(formBranchId) : '';
                    branchMenu.classList.remove('show');
                    clearRootPersonCache();
                    loadRootPersons({ center: true, centerBranchId: nextBranchId });
                });
            }
        }

        function getMaxGeneration(person) {
            if (!person) return 1;
            const ownGen = getEffectiveGeneration(person);
            let maxGen = ownGen;
            getPersonSpouses(person).forEach(function (spouse) {
                const spouseGenParsed = Number(spouse && spouse.generation);
                const spouseGen = Number.isFinite(spouseGenParsed) && spouseGenParsed > 0 ? spouseGenParsed : ownGen;
                maxGen = Math.max(maxGen, spouseGen);
            });
            const children = Array.isArray(person.children) ? person.children : [];
            children.forEach(function (child) {
                maxGen = Math.max(maxGen, getMaxGeneration(child));
            });
            return maxGen;
        }

        function getMaxGenerationFromRoots(roots) {
            if (!Array.isArray(roots) || roots.length === 0) return 1;
            return roots.reduce(function (maxGen, root) {
                return Math.max(maxGen, getMaxGeneration(root));
            }, 1);
        }

        function getMaxGenerationFromMembers(members) {
            if (!Array.isArray(members) || members.length === 0) return 1;
            return members.reduce(function (maxGen, person) {
                const ownGen = getEffectiveGeneration(person);
                let nextMax = Math.max(maxGen, ownGen);
                getPersonSpouses(person).forEach(function (spouse) {
                    const spouseGenParsed = Number(spouse && spouse.generation);
                    const spouseGen = Number.isFinite(spouseGenParsed) && spouseGenParsed > 0 ? spouseGenParsed : ownGen;
                    nextMax = Math.max(nextMax, spouseGen);
                });
                return nextMax;
            }, 1);
        }

        function updateTopStats(generationCount, memberCount) {
            const generationsEl = document.getElementById('ftStatGenerations');
            const membersEl = document.getElementById('ftStatMembers');
            if (generationsEl) {
                const gen = Math.max(0, Number(generationCount || 0));
                generationsEl.textContent = gen + ' thế hệ';
            }
            if (membersEl) {
                const mem = Math.max(0, Number(memberCount || 0));
                membersEl.textContent = mem + ' thành viên';
            }
        }

        function syncGenerationFilterOptions(maxGeneration) {
            const selectEl = document.getElementById('ftFilterGeneration');
            if (!selectEl) return;
            const normalizedMax = Math.max(1, Number(maxGeneration || 0), SERVER_TOTAL_GENERATIONS || 1);
            const currentValue = String(selectEl.value || '');
            let options = '<option value="">Tất cả thế hệ</option>';
            for (let generation = 1; generation <= normalizedMax; generation += 1) {
                options += '<option value="' + generation + '">Đời ' + generation + '</option>';
            }
            selectEl.innerHTML = options;
            if (currentValue && selectEl.querySelector('option[value="' + currentValue + '"]')) {
                selectEl.value = currentValue;
            }
        }

        function getRenderedMemberCount() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return 0;
            return treeRoot.querySelectorAll('.person-node').length;
        }

        async function loadBranches(preferredBranchId) {
            try {
                const res = await fetch('/api/branch');
                if (!res.ok) return;
                const branches = await res.json();
                if (!Array.isArray(branches) || branches.length === 0) return;
                const mainBranch = branches.find(function (branch) {
                    return isMainBranchName(branch && branch.name);
                }) || branches[0];
                const formBranchId = getDefaultFormBranchId(branches);
                if (mainBranch) {
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = formBranchId > 0 ? String(formBranchId) : '';
                    if (aBranch) aBranch.value = formBranchId > 0 ? String(formBranchId) : '';
                }
                setBranchFormOptions(branches);
                renderBranchMenu(branches, preferredBranchId);
            } catch (err) {
                console.error('Load branches failed:', err);
            }
        }

        function getRootCacheKey(branchId) {
            const normalized = Number(branchId || 0);
            return String(Number.isFinite(normalized) ? normalized : 0);
        }

        function clearRootPersonCache(branchId) {
            if (branchId == null) {
                Object.keys(ROOT_PERSON_CACHE).forEach(function (key) {
                    delete ROOT_PERSON_CACHE[key];
                });
                return;
            }
            delete ROOT_PERSON_CACHE[getRootCacheKey(branchId)];
        }

        function getSourceMode(groupName, fallback) {
            const checked = document.querySelector('input[name="' + groupName + '"]:checked');
            return checked ? checked.value : fallback;
        }

        function normalizeSearchText(value) {
            return String(value || '')
                .replace(/[đĐ]/g, 'd')
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '');
        }

        function getExpectedSpouseGender(person) {
            const normalized = String(person && person.gender ? person.gender : '').toLowerCase();
            if (normalized === 'male') return 'female';
            if (normalized === 'female') return 'male';
            return '';
        }

        function getGenderActionLabel(gender) {
            return gender === 'male' ? 'chong' : 'vo';
        }

        function getBirthYearFromDateString(dateStr) {
            if (!dateStr || typeof dateStr !== 'string') return null;
            const parts = dateStr.split('-');
            if (parts.length !== 3) return null;
            const year = Number(parts[0]);
            return Number.isFinite(year) ? year : null;
        }

        function getDeathYearFromDateString(dateStr) {
            return getBirthYearFromDateString(dateStr);
        }

        function normalizeDateFilterValue(value) {
            const raw = String(value || '').trim();
            if (!raw) return '';
            const isoMatch = raw.match(/^(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})$/);
            if (isoMatch) {
                const y = Number(isoMatch[1]);
                const m = Number(isoMatch[2]);
                const d = Number(isoMatch[3]);
                if (!Number.isFinite(y) || !Number.isFinite(m) || !Number.isFinite(d)) return '';
                if (m < 1 || m > 12 || d < 1 || d > 31) return '';
                return String(y).padStart(4, '0') + '-' + String(m).padStart(2, '0') + '-' + String(d).padStart(2, '0');
            }
            const dmyMatch = raw.match(/^(\d{1,2})[-\/](\d{1,2})[-\/](\d{4})$/);
            if (dmyMatch) {
                const d = Number(dmyMatch[1]);
                const m = Number(dmyMatch[2]);
                const y = Number(dmyMatch[3]);
                if (!Number.isFinite(y) || !Number.isFinite(m) || !Number.isFinite(d)) return '';
                if (m < 1 || m > 12 || d < 1 || d > 31) return '';
                return String(y).padStart(4, '0') + '-' + String(m).padStart(2, '0') + '-' + String(d).padStart(2, '0');
            }
            return '';
        }

        function getEffectiveGeneration(person) {
            const parsed = Number(person && person.generation);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : 1;
        }

        function getPersonSpouses(person) {
            if (!person) return [];
            if (Array.isArray(person.spouses) && person.spouses.length > 0) {
                return person.spouses.filter(function (spouse) {
                    return spouse && Number(spouse.id || 0) > 0;
                });
            }
            if (person.spouseId) {
                return [{
                    id: person.spouseId,
                    fullName: person.spouseFullName,
                    gender: person.spouseGender,
                    generation: person.spouseGeneration,
                    branchName: person.spouseBranchName || person.branchName,
                    avatar: person.spouseAvatar,
                    dob: person.spouseDob,
                    dod: person.spouseDod,
                    hometown: person.spouseHometown,
                    currentResidence: person.spouseCurrentResidence,
                    occupation: person.spouseOccupation,
                    otherNote: person.spouseOtherNote,
                    spouseId: person.id
                }];
            }
            return [];
        }

        function hasAnySpouse(person) {
            return getPersonSpouses(person).length > 0;
        }

        function getRawGeneration(person) {
            const parsed = Number(person && person.generation);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
        }

        function getRawSpouseGeneration(person) {
            const firstSpouse = getPersonSpouses(person)[0];
            const parsed = Number(firstSpouse && firstSpouse.generation);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
        }

        function getSpouseEffectiveGeneration(person) {
            const firstSpouse = getPersonSpouses(person)[0];
            const spouseParsed = Number(firstSpouse && firstSpouse.generation);
            if (Number.isFinite(spouseParsed) && spouseParsed > 0) return spouseParsed;
            return getEffectiveGeneration(person);
        }

        function collectMembersFromTree(person, out, seen) {
            if (!person || !out || !seen) return;
            const personId = Number(person.id || 0);
            if (personId > 0 && seen.has(personId)) return;
            if (personId > 0) seen.add(personId);
            out.push(person);
            const children = Array.isArray(person.children) ? person.children : [];
            children.forEach(function (child) {
                collectMembersFromTree(child, out, seen);
            });
        }

        function memberMatchesAdvancedFilters(person) {
            if (!person) return false;
            const personGeneration = getRawGeneration(person);
            const spouseGenerations = getPersonSpouses(person)
                .map(function (spouse) { return getRawGeneration(spouse); })
                .filter(function (generation) { return generation != null; });
            if (CURRENT_GENERATION_FILTER != null) {
                const generationMatched = personGeneration === CURRENT_GENERATION_FILTER
                    || spouseGenerations.indexOf(CURRENT_GENERATION_FILTER) >= 0;
                if (!generationMatched) return false;
            }

            const candidates = [];
            candidates.push({
                fullName: person.fullName || '',
                dob: person.dob || '',
                gender: person.gender || '',
                dod: person.dod || ''
            });
            getPersonSpouses(person).forEach(function (spouse) {
                candidates.push({
                    fullName: spouse.fullName || '',
                    dob: spouse.dob || '',
                    gender: spouse.gender || '',
                    dod: spouse.dod || ''
                });
            });

            const normalizedNameFilter = normalizeSearchText(CURRENT_NAME_FILTER).trim();
            if (normalizedNameFilter) {
                const nameMatched = candidates.some(function (c) {
                    return normalizeSearchText(c.fullName).indexOf(normalizedNameFilter) >= 0;
                });
                if (!nameMatched) return false;
            }

            if (CURRENT_DOB_FILTER) {
                const dobMatched = candidates.some(function (c) {
                    return String(c.dob || '').trim() === CURRENT_DOB_FILTER;
                });
                if (!dobMatched) {
                    return false;
                }
            }

            if (CURRENT_GENDER_FILTER) {
                const genderMatched = candidates.some(function (c) {
                    return String(c.gender || '').toLowerCase() === CURRENT_GENDER_FILTER;
                });
                if (!genderMatched) return false;
            }

            if (CURRENT_LIFE_STATUS_FILTER) {
                const lifeStatusMatched = candidates.some(function (c) {
                    const hasDod = !!c.dod;
                    if (CURRENT_LIFE_STATUS_FILTER === 'alive') return !hasDod;
                    if (CURRENT_LIFE_STATUS_FILTER === 'deceased') return hasDod;
                    return true;
                });
                if (!lifeStatusMatched) return false;
            }

            if (CURRENT_BIRTH_YEAR_FROM != null) {
                const matchedFromYear = candidates.some(function (c) {
                    const birthYear = getBirthYearFromDateString(c.dob || '');
                    return birthYear != null && birthYear >= CURRENT_BIRTH_YEAR_FROM;
                });
                if (!matchedFromYear) return false;
            }
            if (CURRENT_BIRTH_YEAR_TO != null) {
                const matchedToYear = candidates.some(function (c) {
                    const birthYear = getBirthYearFromDateString(c.dob || '');
                    return birthYear != null && birthYear <= CURRENT_BIRTH_YEAR_TO;
                });
                if (!matchedToYear) return false;
            }

            if (CURRENT_DEATH_YEAR != null) {
                const deathYearMatched = candidates.some(function (c) {
                    const deathYear = getDeathYearFromDateString(c.dod || '');
                    return deathYear != null && deathYear === CURRENT_DEATH_YEAR;
                });
                if (!deathYearMatched) return false;
            }

            return true;
        }

        function hasAdvancedFilter() {
            return !!(CURRENT_NAME_FILTER
                || CURRENT_DOB_FILTER
                || CURRENT_GENERATION_FILTER != null
                || CURRENT_GENDER_FILTER
                || CURRENT_LIFE_STATUS_FILTER
                || CURRENT_BIRTH_YEAR_FROM != null
                || CURRENT_BIRTH_YEAR_TO != null
                || CURRENT_DEATH_YEAR != null);
        }

        function hasAnyActiveFilter() {
            return hasAdvancedFilter();
        }

        function dedupeMembersForList(members) {
            const sorted = (members || []).slice().sort(function (a, b) {
                return Number(a.id || 0) - Number(b.id || 0);
            });
            const consumed = new Set();
            const result = [];
            sorted.forEach(function (person) {
                const id = Number(person.id || 0);
                if (!id || consumed.has(id)) return;
                result.push(person);
                consumed.add(id);
                getPersonSpouses(person).forEach(function (spouse) {
                    const spouseId = Number(spouse && spouse.id || 0);
                    if (spouseId) consumed.add(spouseId);
                });
            });
            return result;
        }

        function collectScopedMembers(roots) {
            const scoped = [];
            const seen = new Set();
            (Array.isArray(roots) ? roots : []).forEach(function (root) {
                collectMembersFromTree(root, scoped, seen);
            });
            return scoped;
        }

        function computeVisibleStatsFromMembers(members) {
            const memberIds = new Set();
            let maxGeneration = 0;
            (Array.isArray(members) ? members : []).forEach(function (person) {
                if (!person) return;
                const id = Number(person.id || 0);
                if (id > 0) memberIds.add(id);
                getPersonSpouses(person).forEach(function (spouse) {
                    const spouseId = Number(spouse && spouse.id || 0);
                    if (spouseId > 0) memberIds.add(spouseId);
                    const spouseGen = Number(spouse && spouse.generation);
                    if (Number.isFinite(spouseGen) && spouseGen > 0) {
                        maxGeneration = Math.max(maxGeneration, spouseGen);
                    }
                });

                const ownGen = getRawGeneration(person);
                if (ownGen != null) maxGeneration = Math.max(maxGeneration, ownGen);
            });

            const generationCount = maxGeneration > 0
                ? maxGeneration
                : (memberIds.size > 0 ? 1 : 0);
            return {
                generations: generationCount,
                members: memberIds.size
            };
        }

        function getTreeHeightLimitForRoot(root) {
            if (!root) return 1;
            const rootGeneration = getEffectiveGeneration(root);
            const maxGeneration = getMaxGeneration(root);
            return Math.max(1, maxGeneration - rootGeneration + 1);
        }

        function shouldRenderChildNode(parent, child, nextDepth, maxDepth) {
            if (!child) return false;
            if (nextDepth > maxDepth) return false;

            const parentRawGeneration = getRawGeneration(parent);
            const childRawGeneration = getRawGeneration(child);
            if (parentRawGeneration != null && childRawGeneration != null && childRawGeneration <= parentRawGeneration) {
                return false;
            }

            return true;
        }

        function getCurrentRenderRoots() {
            let renderRoots = Array.isArray(CURRENT_TREE_ROOTS) ? CURRENT_TREE_ROOTS : [];
            if (CURRENT_DESCENDANT_ROOT_ID != null) {
                const descendantRoot = findAnchorNodeByMemberIdInRoots(CURRENT_DESCENDANT_ROOT_ID);
                if (descendantRoot) {
                    return [descendantRoot];
                }
                CURRENT_DESCENDANT_ROOT_ID = null;
            }
            if (CURRENT_FOCUS_PERSON_ID != null) {
                const focused = findAnchorNodeByMemberIdInRoots(CURRENT_FOCUS_PERSON_ID);
                if (focused) {
                    renderRoots = [focused];
                }
            }
            return renderRoots;
        }

        function memberHasRenderableDescendants(person) {
            if (!person) return false;
            const children = Array.isArray(person.children) ? person.children : [];
            if (!children.length) return false;
            const maxDepth = getTreeHeightLimitForRoot(person);
            return children.some(function (child) {
                return shouldRenderChildNode(person, child, 2, maxDepth);
            });
        }

        function clearTreeSearchState(options) {
            const opts = options || {};
            const preserveViewMode = opts.preserveViewMode === true;
            const nameInput = document.getElementById('ftFilterName');
            const dobInput = document.getElementById('ftFilterDob');
            const generationInput = document.getElementById('ftFilterGeneration');
            const genderInput = document.getElementById('ftFilterGender');
            const lifeStatusInput = document.getElementById('ftFilterLifeStatus');
            const birthYearInput = document.getElementById('ftFilterBirthYear');
            const deathYearInput = document.getElementById('ftFilterDeathYear');
            const viewModeInput = document.getElementById('ftViewMode');

            if (nameInput) nameInput.value = '';
            if (dobInput) dobInput.value = '';
            if (generationInput) generationInput.value = '';
            if (genderInput) genderInput.value = '';
            if (lifeStatusInput) lifeStatusInput.value = '';
            if (birthYearInput) birthYearInput.value = '';
            if (deathYearInput) deathYearInput.value = '';
            if (viewModeInput && !preserveViewMode) viewModeInput.value = 'full';

            CURRENT_NAME_FILTER = '';
            CURRENT_DOB_FILTER = '';
            CURRENT_GENERATION_FILTER = null;
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;
            CURRENT_DEATH_YEAR = null;
            if (!preserveViewMode) {
                CURRENT_VIEW_MODE = 'full';
                applyTreeViewMode();
            }
            if (FT_FILTER_DEBOUNCE) {
                clearTimeout(FT_FILTER_DEBOUNCE);
                FT_FILTER_DEBOUNCE = null;
            }
        }

        function openDescendantSubtree(person) {
            const personId = Number(person && person.id || 0);
            if (personId <= 0) return;
            const scopedPerson = findAnchorNodeByMemberIdInRoots(personId) || person;
            if (!memberHasRenderableDescendants(scopedPerson)) {
                showToast('Thành viên này chưa có dữ liệu hậu duệ', 'info');
                return;
            }
            clearTreeSearchState({ preserveViewMode: true });
            CURRENT_TREE_MODE = 'descendants';
            CURRENT_DESCENDANT_ROOT_ID = personId;
            CURRENT_FOCUS_PERSON_ID = personId;
            COLLAPSED_NODE_IDS.clear();
            requestTreeRender();
        }

        function filterExistingPersons(persons, keyword, gender, dob) {
            const normalizedKeyword = normalizeSearchText(keyword).trim();
            const normalizedGender = normalizeSearchText(gender).trim();
            const normalizedDob = String(dob || '').trim();
            return (Array.isArray(persons) ? persons : []).filter(function (item) {
                const fullName = normalizeSearchText(item && item.fullName ? item.fullName : '');
                const genderText = normalizeSearchText(item && item.gender ? item.gender : '');
                const dobText = String(item && item.dob ? item.dob : '');
                const matchedKeyword = !normalizedKeyword
                    || fullName.indexOf(normalizedKeyword) >= 0;
                const matchedGender = !normalizedGender || genderText === normalizedGender;
                const matchedDob = !normalizedDob || dobText === normalizedDob;
                return matchedKeyword && matchedGender && matchedDob;
            });
        }

        function setExistingPersonOptions(selectId, persons, keyword, gender, dob) {
            const selectEl = document.getElementById(selectId);
            if (!selectEl) return;
            const filtered = filterExistingPersons(persons, keyword, gender, dob);
            const currentValue = selectEl.value;
            const options = filtered.map(function (item) {
                const label = (item.fullName || 'Chưa có tên');
                return '<option value="' + Number(item.id) + '">' + escapeHtml(label) + '</option>';
            }).join('');
            selectEl.innerHTML = '<option value="">-- Chọn thành viên --</option>' + options
                + (filtered.length === 0 ? '<option value="" disabled>Không có kết quả phù hợp</option>' : '');
            if (currentValue && filtered.some(function (item) { return String(item.id) === String(currentValue); })) {
                selectEl.value = currentValue;
            }
        }

        function renderExistingPersons(kind) {
            const selectId = kind === 'm' ? 'mExistingPerson' : 'aExistingPerson';
            const inputId = kind === 'm' ? 'mExistingFilter' : 'aExistingFilter';
            const genderId = kind === 'm' ? 'mExistingGenderFilter' : 'aExistingGenderFilter';
            const dobId = kind === 'm' ? 'mExistingDobFilter' : 'aExistingDobFilter';
            const keyword = (document.getElementById(inputId)?.value || '').trim();
            const gender = (document.getElementById(genderId)?.value || '').trim();
            const dob = (document.getElementById(dobId)?.value || '').trim();
            setExistingPersonOptions(selectId, EXISTING_PERSON_CACHE[kind], keyword, gender, dob);
        }

        function findExistingPersonById(kind, personId) {
            const list = EXISTING_PERSON_CACHE[kind] || [];
            return list.find(function (item) {
                return String(item.id) === String(personId);
            }) || null;
        }

        function setMemberGender(gender) {
            const normalized = String(gender || '').toLowerCase();
            const male = document.getElementById('gMale');
            const female = document.getElementById('gFemale');
            const other = document.getElementById('gOther');
            if (!male || !female || !other) return;
            male.checked = normalized === 'male';
            female.checked = normalized === 'female';
            other.checked = normalized === 'other';
        }

        function fillMemberFormFromExisting(person) {
            if (!person) return;
            if (person.fullName) {
                document.getElementById('mFullname').value = person.fullName;
            }
            if (person.dob) {
                document.getElementById('mDob').value = person.dob;
            }
            if (person.gender) {
                setMemberGender(person.gender);
            }
            if (person.avatar) {
                document.getElementById('mAvatar').value = person.avatar;
            }
            if (person.generation != null) {
                document.getElementById('mGeneration').value = String(person.generation);
            }
            if (person.hometown) {
                document.getElementById('mHometown').value = person.hometown;
            }
            if (person.currentResidence) {
                document.getElementById('mCurrentResidence').value = person.currentResidence;
            }
            if (person.occupation) {
                document.getElementById('mOccupation').value = person.occupation;
            }
            if (person.otherNote) {
                document.getElementById('mOtherNote').value = person.otherNote;
            }
        }

        async function refreshExistingPersonCache(kind, branchId) {
            // Fetch full source list by branch, then apply all filters locally to avoid missing results.
            const items = await loadAvailablePersonsByBranch(branchId, null, null, null);
            EXISTING_PERSON_CACHE[kind] = items;
            renderExistingPersons(kind);
        }

        async function loadAvailablePersonsByBranch(branchId, fullName, gender, dob) {
            try {
                let url = '/api/person/available?branchId=' + encodeURIComponent(branchId);
                if (fullName) {
                    url += '&fullName=' + encodeURIComponent(fullName);
                }
                if (gender) {
                    url += '&gender=' + encodeURIComponent(gender);
                }
                if (dob) {
                    url += '&dob=' + encodeURIComponent(dob);
                }
                const res = await fetch(url);
                if (!res.ok) {
                    return [];
                }
                const data = await res.json();
                return Array.isArray(data) ? data : [];
            } catch (err) {
                console.error('Load available persons failed:', err);
                return [];
            }
        }

        function toggleMemberSourceMode(mode) {
            const wrap = document.getElementById('mExistingWrap');
            const isExisting = mode === 'existing';
            if (wrap) {
                wrap.style.display = isExisting ? '' : 'none';
            }
            const fullName = document.getElementById('mFullname');
            if (fullName) {
                fullName.disabled = isExisting;
            }
            if (isExisting) {
                renderExistingPersons('m');
            }
        }

        function toggleActionSourceMode(mode, editing) {
            const wrap = document.getElementById('aExistingWrap');
            const isExisting = mode === 'existing' && !editing;
            if (wrap) {
                wrap.style.display = isExisting ? '' : 'none';
            }
            const fullName = document.getElementById('aFullname');
            if (fullName) {
                fullName.disabled = isExisting;
            }
            if (isExisting) {
                renderExistingPersons('a');
            }
        }

        // Modal / Offcanvas minimal open-close helpers (để family-tree.js gọi cũng được)
        window.ftUi = {
            openModal(id){ document.getElementById(id)?.classList.add('show'); },
            closeModal(id){ document.getElementById(id)?.classList.remove('show'); },
            openDrawer(id){ document.getElementById(id)?.classList.add('show'); },
            closeDrawer(id){ document.getElementById(id)?.classList.remove('show'); },
        };

        function showToast(message, type) {
            const wrap = document.getElementById('ftToastWrap');
            if (!wrap) return;
            const toast = document.createElement('div');
            toast.className = 'ft-toast ' + (type || 'info');
            toast.textContent = message || '';
            wrap.appendChild(toast);
            setTimeout(function () {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity .18s ease';
                setTimeout(function () { toast.remove(); }, 180);
            }, 2500);
        }

        function askConfirm(message) {
            return new Promise(function (resolve) {
                const modal = document.getElementById('ftConfirmModal');
                const msgEl = document.getElementById('ftConfirmMessage');
                const okBtn = document.getElementById('ftConfirmOk');
                const cancelBtn = document.getElementById('ftConfirmCancel');
                const closeBtn = document.getElementById('ftConfirmClose');
                const backdrop = document.getElementById('ftConfirmBackdrop');
                if (!modal || !msgEl || !okBtn || !cancelBtn || !closeBtn || !backdrop) {
                    resolve(false);
                    return;
                }

                msgEl.textContent = message || 'Ban co chac chan khong?';
                modal.classList.add('show');

                let done = false;
                const cleanup = function (answer) {
                    if (done) return;
                    done = true;
                    modal.classList.remove('show');
                    okBtn.removeEventListener('click', onOk);
                    cancelBtn.removeEventListener('click', onCancel);
                    closeBtn.removeEventListener('click', onCancel);
                    backdrop.removeEventListener('click', onCancel);
                    resolve(answer);
                };
                const onOk = function () { cleanup(true); };
                const onCancel = function () { cleanup(false); };

                okBtn.addEventListener('click', onOk);
                cancelBtn.addEventListener('click', onCancel);
                closeBtn.addEventListener('click', onCancel);
                backdrop.addEventListener('click', onCancel);
            });
        }

        // close handlers
        document.addEventListener('click', function (e) {
            const closeId = e.target?.getAttribute?.('data-close');
            if (closeId) {
                const el = document.getElementById(closeId);
                el?.classList.remove('show');
            }
        });
        document.addEventListener('keydown', function(e){
            if (e.key === 'Escape') {
                document.getElementById('memberModal')?.classList.remove('show');
                document.getElementById('actionMemberModal')?.classList.remove('show');
                document.getElementById('ftConfirmModal')?.classList.remove('show');
                document.getElementById('detailMemberModal')?.classList.remove('show');
                document.getElementById('branchMenu')?.classList.remove('show');
            }
        });

        // Tạo thành viên đầu tiên
        (function () {
            const btn = document.getElementById('btnCreateFirst');
            if (!btn) return;
            // Default hidden; will be toggled after loading root person state.
            btn.style.setProperty('display', 'none', 'important');

            window.ftSetCreateFirstVisible = function (visible) {
                btn.style.setProperty('display', visible ? 'inline-flex' : 'none', 'important');
            };

            window.ftRefreshCreateFirstVisibility = async function (fallbackVisible, knownRoots) {
                try {
                    if (Array.isArray(knownRoots)) {
                        const hasKnownRoot = knownRoots.some(function (item) { return item && item.id; });
                        window.ftSetCreateFirstVisible(!hasKnownRoot);
                        return;
                    }
                    const rootRes = await fetch('/api/person/roots?branchId=' + encodeURIComponent(getTreeBranchQueryId()));
                    if (!rootRes.ok) {
                        window.ftSetCreateFirstVisible(!!fallbackVisible);
                        return;
                    }
                    const roots = await rootRes.json();
                    const hasRoot = Array.isArray(roots) && roots.some(function (item) { return item && item.id; });
                    window.ftSetCreateFirstVisible(!hasRoot);
                } catch (e) {
                    window.ftSetCreateFirstVisible(!!fallbackVisible);
                }
            };

            btn.addEventListener('click', function () {
                // Mở modal
                if (window.ftUi && typeof window.ftUi.openModal === 'function') {
                    window.ftUi.openModal('memberModal');
                }

                // Set tiêu đề (đúng id là modalTitle)
                const title = document.getElementById('modalTitle');
                if (title) title.textContent = 'Tạo thành viên đầu tiên';

                // Reset fields
                const setVal = (id, v) => {
                    const el = document.getElementById(id);
                    if (el) el.value = v;
                };

                setVal('mFullname', '');
                setVal('mDob', '');
                setVal('mDod', '');
                setVal('mGeneration', '1');
                setVal('mBranch', String(BRANCH_ID));
                setVal('mBranchName', 'Tự động: Chính');
                setVal('mAvatar', '');
                setVal('mAvatarFile', '');
                setVal('mHometown', '');
                setVal('mCurrentResidence', '');
                setVal('mOccupation', '');
                setVal('mOtherNote', '');
                setVal('mExistingPerson', '');
                setVal('mExistingFilter', '');
                setVal('mExistingGenderFilter', '');
                setVal('mExistingDobFilter', '');

                // Default giới tính
                const gMale = document.getElementById('gMale');
                if (gMale) gMale.checked = true;
                const sourceNew = document.querySelector('input[name="mSourceMode"][value="new"]');
                if (sourceNew) sourceNew.checked = true;
                toggleMemberSourceMode('new');

                // Focus
                const fullname = document.getElementById('mFullname');
                if (fullname) fullname.focus();

                refreshExistingPersonCache('m', BRANCH_ID);
            });
        })();

        // Lưu thành viên đầu tiên
        document.getElementById("btnSaveMember").addEventListener("click", async (e) => {
            e.preventDefault();
            const sourceMode = getSourceMode('mSourceMode', 'new');
            const selectedExistingId = document.getElementById('mExistingPerson').value;
            const fullName = document.getElementById("mFullname").value.trim();
            const dob = document.getElementById("mDob").value || null;   // "YYYY-MM-DD"
            const dod = document.getElementById("mDod").value || null;   // "YYYY-MM-DD"
            const generation = document.getElementById("mGeneration").value;
            const avatar = document.getElementById("mAvatar").value.trim() || null;

            const genderEl = document.querySelector('input[name="mGender"]:checked');
            const gender = genderEl ? genderEl.value : null;

            const payload = {
                fullName,
                dob,          // LocalDate nhận chuỗi yyyy-MM-dd OK
                dod,
                generation: generation ? parseInt(generation, 10) : 1,
                gender,
                avatar,
                hometown: document.getElementById('mHometown').value.trim() || null,
                currentResidence: document.getElementById('mCurrentResidence').value.trim() || null,
                occupation: document.getElementById('mOccupation').value.trim() || null,
                otherNote: document.getElementById('mOtherNote').value.trim() || null,
                fatherId: null,
                motherId: null,
                spouseId: null,
                mediaIds: [],
                childrenIds: []
            };

            // Validate tối thiểu
            if (sourceMode === 'new' && !payload.fullName) {
                showToast("Vui lòng nhập họ và tên", 'error');
                return;
            }
            if (sourceMode === 'existing' && !selectedExistingId) {
                showToast("Vui lòng chọn thành viên trong danh sách", 'error');
                return;
            }
            if (sourceMode === 'existing') {
                payload.existingPersonId = Number(selectedExistingId);
                payload.fullName = "existing-person";
            }
            const generationError = validateGeneration(payload.generation);
            if (generationError) {
                showToast(generationError, 'error');
                return;
            }
            const dateError = validateLifeDates(payload.dob, payload.dod);
            if (dateError) {
                showToast(dateError, 'error');
                return;
            }

            try {
                const res = await fetch("/api/person", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(payload)
                });

                if (!res.ok) {
                    const errText = await res.text();
                    console.error("Create person failed:", errText);
                    showToast(errText || "Lưu thất bại", 'error');
                    return;
                }

                const data = await res.json();
                console.log("Saved:", data);
                showToast("Lưu thành công", 'success');
                if (window.ftUi && typeof window.ftUi.closeModal === 'function') {
                    window.ftUi.closeModal('memberModal');
                }
                await loadBranches(BRANCH_ID);
                clearRootPersonCache();
                await loadRootPersons({ forceReload: true });
            } catch (err) {
                console.error(err);
                showToast("Có lỗi kết nối server", 'error');
            }
        });

        document.querySelectorAll('input[name="mSourceMode"]').forEach(function (el) {
            el.addEventListener('change', function () {
                const mode = getSourceMode('mSourceMode', 'new');
                toggleMemberSourceMode(mode);
            });
        });

        document.getElementById('mExistingFilter').addEventListener('input', function () {
            renderExistingPersons('m');
        });

        document.getElementById('mExistingGenderFilter').addEventListener('change', function () {
            renderExistingPersons('m');
        });

        document.getElementById('mExistingDobFilter').addEventListener('change', function () {
            renderExistingPersons('m');
        });

        document.getElementById('mExistingPerson').addEventListener('change', function () {
            const selected = findExistingPersonById('m', this.value);
            if (selected) {
                fillMemberFormFromExisting(selected);
            }
        });

        const actionState = {
            mode: null,
            person: null
        };

        function fillActionFormFromExisting(person) {
            if (!person) return;
            if (actionState.mode === 'add-spouse') {
                const expectedGender = getExpectedSpouseGender(actionState.person);
                const normalized = String(person.gender || '').toLowerCase();
                if (expectedGender && normalized !== expectedGender) {
                    showToast('Chi duoc chon thanh vien ' + (expectedGender === 'male' ? 'nam' : 'nu') + ' de them ' + getGenderActionLabel(expectedGender), 'error');
                    document.getElementById('aExistingPerson').value = '';
                    return;
                }
            }
            if (person.fullName) {
                document.getElementById('aFullname').value = person.fullName;
            }
            if (person.dob) {
                document.getElementById('aDob').value = person.dob;
            }
            if (person.gender) {
                setActionGender(person.gender);
            }
            if (person.avatar) {
                document.getElementById('aAvatar').value = person.avatar;
            }
            if (person.generation != null) {
                document.getElementById('aGeneration').value = String(person.generation);
            }
            if (person.hometown) {
                document.getElementById('aHometown').value = person.hometown;
            }
            if (person.currentResidence) {
                document.getElementById('aCurrentResidence').value = person.currentResidence;
            }
            if (person.occupation) {
                document.getElementById('aOccupation').value = person.occupation;
            }
            if (person.otherNote) {
                document.getElementById('aOtherNote').value = person.otherNote;
            }
        }

        function setActionGender(gender) {
            const target = gender || '';
            document.getElementById('aGender').value = target;
            document.querySelectorAll('#actionGenderGrid .gender-choice').forEach(function (btn) {
                btn.classList.toggle('active', btn.getAttribute('data-gender') === target);
            });
        }

        function setActionGenderMode(mode) {
            const spouseMode = mode === 'add-spouse';
            const expectedGender = spouseMode ? getExpectedSpouseGender(actionState.person) : '';
            document.querySelectorAll('#actionGenderGrid .gender-choice').forEach(function (btn) {
                const value = btn.getAttribute('data-gender');
                const disabled = spouseMode && expectedGender && value !== expectedGender;
                btn.disabled = disabled;
                btn.style.opacity = disabled ? '0.45' : '1';
                btn.style.pointerEvents = disabled ? 'none' : '';
            });
            if (spouseMode && expectedGender) {
                setActionGender(expectedGender);
            }
        }

        function openActionMemberModal(mode, person) {
            actionState.mode = mode;
            actionState.person = person || null;

            const titleEl = document.getElementById('actionModalTitle');
            const iconEl = document.getElementById('actionModalIcon');
            const saveBtn = document.getElementById('btnSaveActionMember');

            const fullName = person?.fullName || '';
            const generation = Number(person?.generation || 1);
            const expectedSpouseGender = getExpectedSpouseGender(person);

            let title = 'Thêm thành viên';
            let icon = 'bi-person-plus';
            let defaultGen = generation;
            let defaultGender = '';

            if (mode === 'add-spouse') {
                title = 'Thêm ' + (expectedSpouseGender === 'male' ? 'chồng' : 'vợ') + ' - ' + fullName;
                icon = 'bi-person-plus';
                defaultGen = generation;
                defaultGender = expectedSpouseGender || '';
            } else if (mode === 'add-child') {
                title = 'Thêm con - ' + fullName;
                icon = 'bi-person-plus';
                defaultGen = generation + 1;
            } else if (mode === 'edit-member') {
                title = 'Sửa thông tin - ' + fullName;
                icon = 'bi-pencil';
                defaultGen = generation;
                defaultGender = person?.gender || '';
            }

            titleEl.textContent = title;
            iconEl.innerHTML = '<i class="bi ' + icon + '"></i>';
            saveBtn.innerHTML = mode === 'edit-member'
                ? '<i class="bi bi-check2"></i> Lưu cập nhật'
                : '<i class="bi bi-plus-lg"></i> Lưu thành viên';
            saveBtn.disabled = false;

            document.getElementById('aFullname').value = mode === 'edit-member' ? fullName : '';
            document.getElementById('aDob').value = mode === 'edit-member' ? (person?.dob || '') : '';
            document.getElementById('aDod').value = mode === 'edit-member' ? (person?.dod || '') : '';
            document.getElementById('aGeneration').value = String(defaultGen);
            document.getElementById('aBranch').value = String(getDefaultFormBranchId());
            if (mode === 'add-child') {
                document.getElementById('aBranchName').value = 'Tự động: cùng chi với cha/mẹ trong cây gia phả';
            } else if (mode === 'add-spouse') {
                document.getElementById('aBranchName').value = 'Tự động: cùng chi với thành viên hiện tại';
            } else {
                document.getElementById('aBranchName').value = 'Tự động theo quan hệ gia phả';
            }
            document.getElementById('aAvatar').value = mode === 'edit-member' ? (person?.avatar || '') : '';
            document.getElementById('aAvatarFile').value = '';
            document.getElementById('aHometown').value = mode === 'edit-member' ? (person?.hometown || '') : '';
            document.getElementById('aCurrentResidence').value = mode === 'edit-member' ? (person?.currentResidence || '') : '';
            document.getElementById('aOccupation').value = mode === 'edit-member' ? (person?.occupation || '') : '';
            document.getElementById('aOtherNote').value = mode === 'edit-member' ? (person?.otherNote || '') : '';
            document.getElementById('aExistingPerson').value = '';
            document.getElementById('aExistingFilter').value = '';
            document.getElementById('aExistingGenderFilter').value = mode === 'add-spouse' ? defaultGender : '';
            document.getElementById('aExistingDobFilter').value = '';
            setActionGender(defaultGender);
            setActionGenderMode(mode);
            const sourceNew = document.querySelector('input[name="aSourceMode"][value="new"]');
            if (sourceNew) sourceNew.checked = true;
            toggleActionSourceMode('new', mode === 'edit-member');
            if (mode !== 'edit-member') {
                refreshExistingPersonCache('a', BRANCH_ID);
            }

            window.ftUi.openModal('actionMemberModal');
        }

        document.getElementById('actionGenderGrid').addEventListener('click', function (e) {
            const choice = e.target.closest('.gender-choice');
            if (!choice) return;
            setActionGender(choice.getAttribute('data-gender'));
        });

        document.querySelectorAll('input[name="aSourceMode"]').forEach(function (el) {
            el.addEventListener('change', function () {
                const mode = getSourceMode('aSourceMode', 'new');
                const editing = actionState.mode === 'edit-member';
                toggleActionSourceMode(mode, editing);
            });
        });

        document.getElementById('aExistingFilter').addEventListener('input', function () {
            renderExistingPersons('a');
        });

        document.getElementById('aExistingGenderFilter').addEventListener('change', function () {
            renderExistingPersons('a');
        });

        document.getElementById('aExistingDobFilter').addEventListener('change', function () {
            renderExistingPersons('a');
        });

        document.getElementById('aExistingPerson').addEventListener('change', function () {
            const selected = findExistingPersonById('a', this.value);
            if (selected) {
                fillActionFormFromExisting(selected);
            }
        });

        document.getElementById('btnSaveActionMember').addEventListener('click', async function (e) {
            e.preventDefault();
            const mode = actionState.mode;
            const personId = actionState.person?.id;
            const sourceMode = getSourceMode('aSourceMode', 'new');
            const selectedExistingId = document.getElementById('aExistingPerson').value;
            const fullName = document.getElementById('aFullname').value.trim();
            if (sourceMode === 'new' && !fullName) {
                showToast('Vui lòng nhập họ và tên', 'error');
                return;
            }
            if (sourceMode === 'existing' && mode !== 'edit-member' && !selectedExistingId) {
                showToast('Vui lòng chọn thành viên trong danh sách', 'error');
                return;
            }

            const payload = {
                fullName: fullName,
                dob: document.getElementById('aDob').value || null,
                dod: document.getElementById('aDod').value || null,
                generation: Number(document.getElementById('aGeneration').value || 1),
                gender: document.getElementById('aGender').value || null,
                avatar: document.getElementById('aAvatar').value.trim() || null,
                hometown: document.getElementById('aHometown').value.trim() || null,
                currentResidence: document.getElementById('aCurrentResidence').value.trim() || null,
                occupation: document.getElementById('aOccupation').value.trim() || null,
                otherNote: document.getElementById('aOtherNote').value.trim() || null
            };
            if (sourceMode === 'existing' && mode !== 'edit-member') {
                payload.existingPersonId = Number(selectedExistingId);
                payload.fullName = 'existing-person';
            }
            const generationError = validateGeneration(payload.generation);
            if (generationError) {
                showToast(generationError, 'error');
                return;
            }
            const dateError = validateLifeDates(payload.dob, payload.dod);
            if (dateError) {
                showToast(dateError, 'error');
                return;
            }
            const expectedSpouseGender = mode === 'add-spouse' ? getExpectedSpouseGender(actionState.person) : '';
            if (mode === 'add-spouse' && expectedSpouseGender && payload.gender && payload.gender.toLowerCase() !== expectedSpouseGender) {
                showToast('Chi duoc phep them ' + getGenderActionLabel(expectedSpouseGender) + ' co gioi tinh ' + (expectedSpouseGender === 'male' ? 'nam' : 'nu'), 'error');
                return;
            }

            if (mode === 'add-spouse') {
                try {
                    const res = await fetch('/api/person/' + personId + '/spouse', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Add spouse failed:', errText);
                        showToast(errText || 'Thêm vợ/chồng thất bại', 'error');
                        return;
                    }
                    showToast('Thêm ' + (expectedSpouseGender === 'male' ? 'chồng' : 'vợ') + ' thành công', 'success');
                    window.ftUi.closeModal('actionMemberModal');
                    await loadBranches(BRANCH_ID);
                    clearRootPersonCache();
                    await loadRootPersons({ forceReload: true });
                    return;
                } catch (err) {
                    console.error(err);
                    showToast('Có lỗi kết nối server', 'error');
                    return;
                }
            }

            if (mode === 'add-child') {
                if (!canAddChildInBranch(actionState.person?.branchName)) {
                    showToast('Chi duoc phep them con cho thanh vien o chi goc hoac chi 1, 2', 'error');
                    return;
                }
                try {
                    const res = await fetch('/api/person/' + personId + '/child', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Add child failed:', errText);
                        showToast(errText || 'Thêm con thất bại', 'error');
                        return;
                    }
                    showToast('Thêm con thành công', 'success');
                    window.ftUi.closeModal('actionMemberModal');
                    await loadBranches(BRANCH_ID);
                    clearRootPersonCache();
                    await loadRootPersons({ forceReload: true });
                    return;
                } catch (err) {
                    console.error(err);
                    showToast('Có lỗi kết nối server', 'error');
                    return;
                }
            }

            if (mode === 'edit-member') {
                try {
                    const res = await fetch('/api/person/' + personId, {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Update person failed:', errText);
                        showToast(errText || 'Cập nhật thất bại', 'error');
                        return;
                    }
                    showToast('Cập nhật thành công', 'success');
                    window.ftUi.closeModal('actionMemberModal');
                    clearRootPersonCache();
                    await loadRootPersons({ forceReload: true });
                    return;
                } catch (err) {
                    console.error(err);
                    showToast('Có lỗi kết nối server', 'error');
                    return;
                }
            }
            window.ftUi.closeModal('actionMemberModal');
        });

        function formatDate(dateStr) {
            if (!dateStr) return '';
            const parts = dateStr.split('-');
            if (parts.length !== 3) return dateStr;
            return parts[2] + '/' + parts[1] + '/' + parts[0];
        }

        function escapeHtml(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function getGenderLabel(gender) {
            const normalized = String(gender || '').toLowerCase();
            if (normalized === 'male') return 'Nam';
            if (normalized === 'female') return 'Nữ';
            if (normalized === 'other') return 'Khác';
            return '--';
        }

        function formatOptionalText(value) {
            const text = String(value || '').trim();
            return text ? escapeHtml(text) : '--';
        }

        function canAddChildInBranch(branchName) {
            const key = normalizeBranchKey(branchName);
            return key === 'main' || key === '1' || key === '2';
        }

        function buildDefaultAvatarDataUri(gender) {
            const normalizedGender = String(gender || '').toLowerCase();
            const accent = normalizedGender === 'female' ? '#8c3b2f' : '#94662f';
            const lineColor = normalizedGender === 'female' ? '#6f2a20' : '#6c4a25';
            const shoulderPath = normalizedGender === 'female'
                ? '<path d="M42 101c4-12 13-20 26-23 13 3 22 11 26 23" fill="none" stroke="' + lineColor + '" stroke-width="5.2" stroke-linecap="round"/>'
                : '<path d="M39 103c5-14 16-22 29-25 13 3 24 11 29 25" fill="none" stroke="' + lineColor + '" stroke-width="5.6" stroke-linecap="round"/>';
            const hairMark = normalizedGender === 'female'
                ? '<path d="M52 52c2-10 9-16 16-16s14 6 16 16" fill="none" stroke="' + accent + '" stroke-width="4" stroke-linecap="round"/>'
                : '<path d="M54 46c4-4 9-6 14-6s10 2 14 6" fill="none" stroke="' + accent + '" stroke-width="3.6" stroke-linecap="round"/>';
            const svg = ''
                + '<svg xmlns="http://www.w3.org/2000/svg" width="136" height="136" viewBox="0 0 136 136">'
                + '<defs>'
                + '  <linearGradient id="paperBg" x1="0" y1="0" x2="0" y2="1">'
                + '    <stop offset="0%" stop-color="#fbf3de"/>'
                + '    <stop offset="100%" stop-color="#e9d3a4"/>'
                + '  </linearGradient>'
                + '  <linearGradient id="medallionBg" x1="0" y1="0" x2="1" y2="1">'
                + '    <stop offset="0%" stop-color="#f8ecd0"/>'
                + '    <stop offset="100%" stop-color="#ead4a3"/>'
                + '  </linearGradient>'
                + '</defs>'
                + '<rect x="0" y="0" width="136" height="136" rx="16" fill="url(#paperBg)"/>'
                + '<circle cx="68" cy="68" r="47" fill="url(#medallionBg)" stroke="' + accent + '" stroke-width="2.6"/>'
                + '<circle cx="68" cy="68" r="40" fill="none" stroke="rgba(255,248,227,0.75)" stroke-width="1.4"/>'
                + '<path d="M24 26h18" stroke="rgba(148,102,47,0.22)" stroke-width="1.6" stroke-linecap="round"/>'
                + '<path d="M94 110h18" stroke="rgba(148,102,47,0.22)" stroke-width="1.6" stroke-linecap="round"/>'
                + '<path d="M68 44c-9 0-16 7-16 16 0 9 7 16 16 16s16-7 16-16c0-9-7-16-16-16z" fill="none" stroke="' + lineColor + '" stroke-width="4.8"/>'
                + shoulderPath
                + hairMark
                + '<circle cx="43" cy="31" r="2.2" fill="rgba(140,59,47,0.12)"/>'
                + '<circle cx="102" cy="42" r="1.8" fill="rgba(148,102,47,0.12)"/>'
                + '<circle cx="35" cy="92" r="2.1" fill="rgba(148,102,47,0.10)"/>'
                + '<circle cx="97" cy="98" r="2.4" fill="rgba(140,59,47,0.10)"/>'
                + '</svg>';
            return 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(svg);
        }

        function sanitizeAvatarUrl(url, gender) {
            const normalizedGender = String(gender || '').toLowerCase();
            const fallback = buildDefaultAvatarDataUri(normalizedGender);
            const value = String(url || '').trim();
            if (!value) return fallback;
            const lower = value.toLowerCase();
            if (lower.startsWith('http://') || lower.startsWith('https://') || lower.startsWith('/')) return value;
            if (lower.startsWith('data:image/')) return value;
            return fallback;
        }

        function validateLifeDates(dob, dod) {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const parseDate = function (isoText) {
                if (!isoText) return null;
                const parsed = new Date(isoText + 'T00:00:00');
                return Number.isNaN(parsed.getTime()) ? null : parsed;
            };
            const dobDate = parseDate(dob);
            const dodDate = parseDate(dod);
            if (dob && !dobDate) return 'Ngay sinh khong hop le';
            if (dod && !dodDate) return 'Ngay mat khong hop le';
            if (dobDate && dobDate > today) return 'Ngay sinh khong duoc lon hon ngay hien tai';
            if (dodDate && dodDate > today) return 'Ngay mat khong duoc lon hon ngay hien tai';
            if (dobDate && dodDate && dodDate < dobDate) return 'Ngay mat khong duoc nho hon ngay sinh';
            return '';
        }

        function validateGeneration(generation) {
            if (generation == null) return '';
            if (Number.isNaN(generation)) return 'Doi khong hop le';
            if (generation < 1 || generation > 50) return 'Doi phai trong khoang 1-50';
            return '';
        }

        async function loadPersonDetailById(personId) {
            const res = await fetch('/api/person/' + encodeURIComponent(personId));
            if (!res.ok) {
                throw new Error(await res.text() || 'Không tải được thông tin thành viên');
            }
            return await res.json();
        }

        function renderDetailMemberModal(person) {
            const body = document.getElementById('detailMemberBody');
            const actions = document.getElementById('detailMemberActions');
            if (!body || !actions || !person) return;

            const children = Array.isArray(person.children) ? person.children : [];
            const spouses = Array.isArray(person.spouses) ? person.spouses : [];
            const mediaUrls = Array.isArray(person.mediaUrls) ? person.mediaUrls : [];
            const childrenText = children.length > 0
                ? children.map(function (child) {
                    const childName = escapeHtml(child.fullName || 'Chưa có tên');
                    const childGen = child.generation != null ? ('Đời ' + child.generation) : '';
                    return '<span class="ft-detail-pill">' + childName + (childGen ? ' (' + childGen + ')' : '') + '</span>';
                }).join(' ')
                : '<span class="ft-detail-empty">Chưa có thông tin</span>';
            const spousesText = spouses.length > 0
                ? spouses.map(function (spouse) {
                    const spouseName = escapeHtml(spouse.fullName || 'Chưa có tên');
                    const spouseMeta = spouse.generation != null ? ('Đời ' + spouse.generation) : '';
                    return '<span class="ft-detail-pill">' + spouseName + (spouseMeta ? ' (' + spouseMeta + ')' : '') + '</span>';
                }).join(' ')
                : '<span class="ft-detail-empty">Chưa có thông tin</span>';
            const mediaHtml = mediaUrls.length > 0
                ? '<div class="ft-detail-media-grid">' + mediaUrls.slice(0, 8).map(function (url, index) {
                    const safeUrl = escapeHtml(url);
                    return '<a class="ft-detail-media-item" href="' + safeUrl + '" target="_blank" rel="noopener noreferrer">'
                        + '<img src="' + safeUrl + '" alt="Tư liệu ' + (index + 1) + '" />'
                        + '</a>';
                }).join('') + '</div>'
                : '<div class="ft-detail-empty">Chưa có tư liệu đính kèm</div>';
            const avatar = sanitizeAvatarUrl(person.avatar, person.gender);
            const roleLabel = getNodeRoleLabel(person, { isRoot: !person.fatherId && !person.motherId });

            body.innerHTML = ''
                + '<div class="ft-detail-shell">'
                + '  <div class="ft-detail-hero">'
                + '      <div class="ft-detail-avatar-wrap"><img class="ft-detail-avatar" src="' + escapeHtml(avatar) + '" alt="' + escapeHtml(person.fullName || 'Thành viên') + '"></div>'
                + '      <div class="ft-detail-hero-copy">'
                + '          <div class="ft-detail-role">' + escapeHtml(roleLabel) + '</div>'
                + '          <h3 class="ft-detail-name">' + formatOptionalText(person.fullName) + '</h3>'
                + '          <div class="ft-detail-subline">' + formatOptionalText(formatDate(person.dob || '')) + ' - ' + formatOptionalText(formatDate(person.dod || '')) + '</div>'
                + '          <div class="ft-detail-tags">'
                + '              <span class="ft-detail-pill">Giới tính: ' + getGenderLabel(person.gender) + '</span>'
                + '              <span class="ft-detail-pill">Đời: ' + formatOptionalText(person.generation) + '</span>'
                + '              <span class="ft-detail-pill">Chi họ: ' + formatOptionalText(person.branchName) + '</span>'
                + '          </div>'
                + '      </div>'
                + '  </div>'
                + '  <div class="row g-3">'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Cha</div><div>' + formatOptionalText(person.fatherFullName) + '</div></div>'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Mẹ</div><div>' + formatOptionalText(person.motherFullName) + '</div></div>'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Quê quán</div><div>' + formatOptionalText(person.hometown) + '</div></div>'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Nơi ở hiện tại</div><div>' + formatOptionalText(person.currentResidence) + '</div></div>'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Nghề nghiệp</div><div>' + formatOptionalText(person.occupation) + '</div></div>'
                + '    <div class="col-md-6"><div class="form-label fw-semibold">Phối ngẫu</div><div>' + spousesText + '</div></div>'
                + '    <div class="col-12"><div class="form-label fw-semibold">Con</div><div>' + childrenText + '</div></div>'
                + '    <div class="col-12"><div class="form-label fw-semibold">Ghi chú</div><div>' + formatOptionalText(person.otherNote) + '</div></div>'
                + '    <div class="col-12"><div class="form-label fw-semibold">Tư liệu đính kèm</div>' + mediaHtml + '</div>'
                + '</div>';

            if (!canManageMember) {
                actions.innerHTML = ''
                    + '<button type="button" class="btn btn-link text-secondary" data-close="detailMemberModal">Đóng</button>';
                return;
            }

            const canAddSpouse = (String(person.gender || '').toLowerCase() === 'male'
                || String(person.gender || '').toLowerCase() === 'female')
                && !hasAnySpouse(person);
            const canAddChild = canAddChildInBranch(person.branchName);
            actions.innerHTML = ''
                + '<button type="button" class="btn btn-link text-secondary" data-close="detailMemberModal">Đóng</button>'
                + '<button type="button" class="btn btn-outline-secondary" id="detailEditMemberBtn"><i class="bi bi-pencil"></i> Sửa thông tin</button>'
                + (canAddChild
                    ? '<button type="button" class="btn btn-outline-secondary" id="detailAddChildBtn"><i class="bi bi-person-plus"></i> Thêm con</button>'
                    : '')
                + (canAddSpouse
                    ? '<button type="button" class="btn btn-outline-secondary" id="detailAddSpouseBtn"><i class="bi bi-heart"></i> Thêm vợ</button>'
                    : '')
                + '<button type="button" class="btn btn-dark" id="detailDeleteMemberBtn"><i class="bi bi-trash"></i> Xóa</button>';
            document.getElementById('detailEditMemberBtn')?.addEventListener('click', function () {
                window.ftUi.closeModal('detailMemberModal');
                openActionMemberModal('edit-member', person);
            });
            if (canAddChild) {
                document.getElementById('detailAddChildBtn')?.addEventListener('click', function () {
                    window.ftUi.closeModal('detailMemberModal');
                    openActionMemberModal('add-child', person);
                });
            }
            document.getElementById('detailAddSpouseBtn')?.addEventListener('click', function () {
                window.ftUi.closeModal('detailMemberModal');
                openActionMemberModal('add-spouse', person);
            });
            document.getElementById('detailDeleteMemberBtn')?.addEventListener('click', async function () {
                window.ftUi.closeModal('detailMemberModal');
                await deleteMember(person);
            });
        }

        async function openDetailMemberModal(personId) {
            if (!personId) return;
            try {
                const detail = await loadPersonDetailById(personId);
                renderDetailMemberModal(detail);
                window.ftUi.openModal('detailMemberModal');
            } catch (err) {
                console.error(err);
                showToast(err && err.message ? err.message : 'Không tải được thông tin thành viên', 'error');
            }
        }

        async function deleteMember(person) {
            if (!person || !person.id) return;
            const fullName = person.fullName || 'thành viên này';
            const okToDelete = await askConfirm('Bạn chắc chắn muốn xóa ' + fullName + '?');
            if (!okToDelete) return;

            try {
                const res = await fetch('/api/person/' + person.id, {
                    method: 'DELETE'
                });

                if (!res.ok) {
                    const errText = (await res.text()) || 'Xóa thất bại!';
                    showToast(errText, 'error');
                    return;
                }

                showToast('Xử lý xóa thành công', 'success');
                await loadBranches(BRANCH_ID);
                clearRootPersonCache();
                await loadRootPersons({ forceReload: true });
            } catch (err) {
                console.error('Delete person failed:', err);
                showToast('Có lỗi kết nối server', 'error');
            }
        }

        function getNodeRoleKey(person, options) {
            const opts = options || {};
            const note = normalizeSearchText(person && person.otherNote ? person.otherNote : '');
            const isFounder = !!opts.isRoot || (!person.fatherId && !person.motherId && getEffectiveGeneration(person) <= 1);
            if (isFounder) return 'founder';
            if (note.indexOf('truong ho') >= 0 || note.indexOf('truong chi') >= 0 || note.indexOf('truong toc') >= 0) {
                return 'lineage-head';
            }
            if (note.indexOf('co cong') >= 0 || note.indexOf('tieu bieu') >= 0 || note.indexOf('nhan vat') >= 0) {
                return 'notable';
            }
            if (person.dod) {
                return 'deceased';
            }
            return 'standard';
        }

        function getNodeRoleLabel(person, options) {
            const roleKey = getNodeRoleKey(person, options);
            if (roleKey === 'founder') return 'Thủy tổ';
            if (roleKey === 'lineage-head') return 'Trưởng chi';
            if (roleKey === 'notable') return 'Nhân vật tiêu biểu';
            if (roleKey === 'deceased') return 'Tiên tổ đã khuất';
            return 'Thành viên gia phả';
        }

        function centerTreeOnPerson(personId) {
            const contentArea = document.getElementById('contentArea');
            const treeRoot = document.getElementById('treeRoot');
            if (!contentArea || !treeRoot || !FT_VIEWPORT.initialized || !personId) return;
            const targetNode = treeRoot.querySelector('.person-node[data-id="' + String(personId) + '"]');
            if (!targetNode) return;
            const areaRect = contentArea.getBoundingClientRect();
            const nodeRect = targetNode.getBoundingClientRect();
            FT_VIEWPORT.panX += (areaRect.left + areaRect.width / 2) - (nodeRect.left + nodeRect.width / 2);
            FT_VIEWPORT.panY += (areaRect.top + areaRect.height / 2) - (nodeRect.top + nodeRect.height / 2);
            if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
            treeRoot.querySelectorAll('.ft-focus-hit').forEach(function (node) {
                node.classList.remove('ft-focus-hit');
            });
            targetNode.classList.add('ft-focus-hit');
            setTimeout(function () {
                targetNode.classList.remove('ft-focus-hit');
            }, 2600);
        }

        function buildTreeMenu(person, opts) {
            const isSpouse = !!(opts && opts.isSpouse);
            const isRoot = !!(opts && opts.isRoot);
            const rawGender = String(person.gender || 'other').toLowerCase();
            const gender = (rawGender === 'male' || rawGender === 'female' || rawGender === 'other') ? rawGender : 'other';
            const hasSpouse = hasAnySpouse(person);
            const branchName = person.branchName || '';
            const personId = Number(person.id || 0);

            let items = '';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="center-person" data-person-id="' + personId + '"><i class="fa fa-bullseye"></i> Đưa ra giữa cây</a></li>';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="view-descendants" data-person-id="' + personId + '"><i class="fa fa-sitemap"></i> Xem hậu duệ</a></li>';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="back-root" data-person-id="' + personId + '"><i class="fas fa-long-arrow-alt-left"></i> Trở về gốc</a></li>';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="copy-data" data-person-id="' + personId + '"><i class="fas fa-clone"></i> Sao chép dữ liệu</a></li>';

            if (canManageMember) {
                if (!isSpouse && !hasSpouse && (gender === 'male' || gender === 'female')) {
                    const spouseActionLabel = gender === 'male' ? 'Thêm vợ' : 'Thêm chồng';
                    items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="add-spouse" data-person-id="' + personId + '"><i class="fa-solid fa-square-plus"></i> ' + spouseActionLabel + '</a></li>';
                }
                if (canAddChildInBranch(branchName)) {
                    items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="add-child" data-person-id="' + personId + '"><i class="fa-solid fa-square-plus"></i> Thêm con</a></li>';
                }
                items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="edit-member" data-person-id="' + personId + '"><i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa</a></li>';
                items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="delete-member" data-person-id="' + personId + '"><i class="fa-solid fa-trash-can"></i> Xóa</a></li>';
            }
            return items;
        }

        function buildPersonCard(person, options) {
            const opts = options || {};
            const isSpouse = !!opts.isSpouse;
            const isRoot = !!opts.isRoot;
            const embeddedHtml = typeof opts.embeddedHtml === 'string' ? opts.embeddedHtml : '';
            const personId = Number(person.id || 0);
            const rawGender = String(person.gender || 'other').toLowerCase();
            const gender = (rawGender === 'male' || rawGender === 'female' || rawGender === 'other') ? rawGender : 'other';
            const generation = getEffectiveGeneration(person);
            const fullName = person.fullName || 'Chưa có tên';
            const avatar = sanitizeAvatarUrl(person.avatar, gender);
            const dobRaw = String(person.dob || '').trim();
            const dodRaw = String(person.dod || '').trim();
            const dobText = dobRaw ? escapeHtml(formatDate(dobRaw)) : '';
            const dodText = dodRaw ? escapeHtml(formatDate(dodRaw)) : '';
            const dateLines = [];
            if (dobText) {
                dateLines.push('<div class="person-date-line"><span class="date-label">Sinh:</span> ' + dobText + '</div>');
            }
            if (dodText) {
                dateLines.push('<div class="person-date-line"><span class="date-label">Mất:</span> ' + dodText + '</div>');
            }
            const datesHtml = dateLines.length > 0
                ? ('<div class="person-dates">' + dateLines.join('') + '</div>')
                : '';
            const fallbackAvatar = buildDefaultAvatarDataUri(gender);
            const branchId = String(person.branch || '');
            const menuId = 'tree_action_' + personId + (isSpouse ? '_s' : '_m');
            const cssGender = gender === 'female' ? 'female' : (gender === 'other' ? 'other' : 'male');
            const className = isSpouse ? 'person-spouse spouse-block' : 'person-familly position-relative child-block';
            const showManageMenu = canManageMember;
            const showGenerationBadge = false;
            const spouseIdAttr = isSpouse ? (' data-spouse-id="' + personId + '"') : '';
            const roleKey = getNodeRoleKey(person, { isRoot: isRoot });
            const roleLabel = getNodeRoleLabel(person, { isRoot: isRoot });
            const statusBadge = person.dod ? '<span class="ft-node-status">Đã mất</span>' : '';
            const genderBadge = gender === 'female' ? 'Nữ' : (gender === 'male' ? 'Nam' : 'Khác');

            return '' +
                '<div class="' + cssGender + ' person-node person-role-' + roleKey + ' ' + className + '"' + spouseIdAttr + ' data-id="' + personId + '" data-branch-id="' + escapeHtml(branchId) + '" data-role-key="' + roleKey + '">' +
                    (showGenerationBadge ? ('<span class="rounded bg-white fw-bold generation-number">' + generation + '</span>') : '') +
                    (showManageMenu
                        ? '<div class="dropdown btn-setting-custom">' +
                            '<button class="btn btn-sm btn-dark btn-setting-custom tree-menu-toggle" type="button" data-menu-id="' + menuId + '"><i class="fa fa-ellipsis-h"></i></button>' +
                            '<ul class="dropdown-menu fs-13 transform-none tree-action-menu" id="' + menuId + '">' + buildTreeMenu(person, { isSpouse: isSpouse, isRoot: isRoot }) + '</ul>' +
                          '</div>'
                        : '') +
                    '<div class="ft-node-headline">' +
                        '<span class="ft-node-role">' + escapeHtml(roleLabel) + '</span>' +
                        '<span class="ft-node-gender">' + escapeHtml(genderBadge) + '</span>' +
                    '</div>' +
                    '<img src="' + escapeHtml(avatar) + '" class="rounded mb-2 mt-3 avatar-tree" alt="' + escapeHtml(fullName) + '" onerror="this.src=\'' + fallbackAvatar + '\'">' +
                    '<div class="person-text">' +
                        '<div data-id="' + personId + '" class="name-phado">' + escapeHtml(fullName) + '</div>' +
                        datesHtml +
                        statusBadge +
                    '</div>' +
                    embeddedHtml +
                '</div>';
        }

        function buildMemberPairHtml(person, options) {
            const opts = options || {};
            const embeddedHtml = getPersonSpouses(person).map(function (spouse) {
                return buildPersonCard(spouse, { isSpouse: true, isRoot: false });
            }).join('');

            return buildPersonCard(person, {
                isSpouse: false,
                isRoot: !!opts.isRoot,
                embeddedHtml: embeddedHtml
            });
        }

        function collectOverflowMembers(children, result) {
            (Array.isArray(children) ? children : []).forEach(function (child) {
                if (!child) return;
                result.push(child);
                if (Array.isArray(child.children) && child.children.length > 0) {
                    collectOverflowMembers(child.children, result);
                }
            });
        }

        function renderOverflowLane(children) {
            const overflowMembers = [];
            collectOverflowMembers(children, overflowMembers);
            if (overflowMembers.length === 0) return '';

            return '<div class="ft-overflow-lane" data-overflow-count="' + overflowMembers.length + '">' +
                '<div class="ft-overflow-label">Tiếp theo</div>' +
                '<div class="ft-overflow-items">' +
                overflowMembers.map(function (member) {
                    return '<div class="ft-overflow-item">' +
                        '<div class="ft-overflow-generation">Đời ' + getEffectiveGeneration(member) + '</div>' +
                        '<div class="box-person ' + (hasAnySpouse(member) ? 'has-spouse' : 'no-spouse') + '">' +
                        buildMemberPairHtml(member) +
                        '</div>' +
                        '</div>';
                }).join('') +
                '</div>' +
                '</div>';
        }

        function renderTreeNode(person, opts) {
            const options = opts || {};
            const depth = Number(options.depth || 1);
            const maxDepth = Number(options.maxDepth || Number.MAX_SAFE_INTEGER);
            const children = Array.isArray(person.children) ? person.children : [];
            const personId = Number(person && person.id || 0);
            const isCollapsed = personId > 0 && COLLAPSED_NODE_IDS.has(personId);
            let childrenHtml = '';
            let overflowHtml = '';
            if (children.length > 0) {
                const allowedChildren = children.filter(function (child) {
                    return shouldRenderChildNode(person, child, depth + 1, maxDepth);
                });
                if (depth >= maxDepth) {
                    overflowHtml = renderOverflowLane(allowedChildren);
                } else if (allowedChildren.length > 0) {
                childrenHtml = '<ul class="ul-person" style="display:flex;justify-content:center;">'
                    + allowedChildren.map(function (child) {
                        return renderTreeNode(child, {
                            isRoot: false,
                            depth: depth + 1,
                            maxDepth: maxDepth
                        });
                    }).join('')
                    + '</ul>';
                }
            }

            const branchContentHtml = overflowHtml + childrenHtml;
            const branchSubtreeHtml = children.length > 0
                ? ('<div class="ft-branch-subtree' + (isCollapsed ? ' is-collapsed' : '') + '" data-branch-owner-id="' + personId + '"' + (isCollapsed ? ' aria-hidden="true" style="max-height:0px;"' : ' aria-hidden="false"') + '>' + branchContentHtml + '</div>')
                : '';

            return '' +
                '<li class="li-person' + (overflowHtml ? ' ft-depth-capped' : '') + '" data-tree-node-id="' + personId + '">' +
                    '<div class="' + (overflowHtml ? 'ft-depth-cap-row' : '') + '">' +
                        '<div class="box-person ' + (hasAnySpouse(person) ? 'has-spouse' : 'no-spouse') + '">' +
                            buildMemberPairHtml(person, {
                                isRoot: !!options.isRoot
                            }) +
                        '</div>' +
                    '</div>' +
                    (children.length > 0
                        ? '<div class="ft-branch-toggle-wrap"><button type="button" class="ft-branch-toggle" data-tree-toggle-id="' + personId + '" aria-expanded="' + (!isCollapsed) + '">' + (isCollapsed ? 'Mở nhánh con' : 'Thu gọn nhánh') + '</button></div>'
                        : '') +
                    branchSubtreeHtml +
                '</li>';
        }

        function renderForest(roots) {
            if (!Array.isArray(roots) || roots.length === 0) return '';
            return '<ul class="ul-person ft-forest-roots">' + roots.map(function (root) {
                return renderTreeNode(root, {
                    isRoot: true,
                    depth: 1,
                    maxDepth: getTreeHeightLimitForRoot(root)
                });
            }).join('') + '</ul>';
        }

        function renderGenerationOnly(members) {
            if (!members || members.length === 0) {
                return '' +
                    '<div class="ft-empty">' +
                    '<div class="fw-semibold">Không có thành viên phù hợp</div>' +
                    '</div>';
            }

            const rows = members.map(function (person) {
                return '<li class="li-person"><div class="box-person ' + (hasAnySpouse(person) ? 'has-spouse' : 'no-spouse') + '">' +
                    buildMemberPairHtml(person) +
                    '</div></li>';
            }).join('');

            return '<ul class="ul-person ft-filter-results">' + rows + '</ul>';
        }

        function centerTreeView(centerBranchId) {
            const contentArea = document.getElementById('contentArea');
            const treeRoot = document.getElementById('treeRoot');
            if (!contentArea || !treeRoot) return;

            let targetNode = null;
            if (centerBranchId != null) {
                targetNode = treeRoot.querySelector('.person-node[data-branch-id="' + String(centerBranchId) + '"]');
            }
            if (!targetNode) {
                targetNode = treeRoot.querySelector('.person-node');
            }
            if (!targetNode) return;
            if (!FT_VIEWPORT.initialized) return;
            const areaRect = contentArea.getBoundingClientRect();
            const nodeRect = targetNode.getBoundingClientRect();
            const deltaX = (areaRect.left + areaRect.width / 2) - (nodeRect.left + nodeRect.width / 2);
            const deltaY = (areaRect.top + areaRect.height / 2) - (nodeRect.top + nodeRect.height / 2);
            if (Math.abs(deltaX) < 1 && Math.abs(deltaY) < 1) {
                return false;
            }
            FT_VIEWPORT.panX += deltaX;
            FT_VIEWPORT.panY += deltaY;
            if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
            return true;
        }

        function resetTreeViewport() {
            if (!FT_VIEWPORT.initialized) return;
            FT_VIEWPORT.scale = 1;
            FT_VIEWPORT.panX = 0;
            FT_VIEWPORT.panY = 0;
            if (typeof FT_VIEWPORT.applyNow === 'function') {
                FT_VIEWPORT.applyNow();
            } else if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
        }

        function getTreeNodeElement(personId) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || !personId) return null;
            return treeRoot.querySelector('.person-node[data-id="' + String(personId) + '"]');
        }

        function getBranchToggleElement(personId) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || !personId) return null;
            return treeRoot.querySelector('.ft-branch-toggle[data-tree-toggle-id="' + String(personId) + '"]');
        }

        function getBranchSubtreeElement(personId) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || !personId) return null;
            return treeRoot.querySelector('.ft-branch-subtree[data-branch-owner-id="' + String(personId) + '"]');
        }

        function updateBranchToggleLabel(button, isCollapsed) {
            if (!button) return;
            button.textContent = isCollapsed ? 'Mở nhánh con' : 'Thu gọn nhánh';
            button.setAttribute('aria-expanded', String(!isCollapsed));
        }

        function keepAnchorNodeVisible(anchorNode) {
            const contentArea = document.getElementById('contentArea');
            if (!contentArea || !anchorNode || !FT_VIEWPORT.initialized) return;
            const areaRect = contentArea.getBoundingClientRect();
            const nodeRect = anchorNode.getBoundingClientRect();
            const marginX = Math.max(24, Math.min(72, areaRect.width * 0.08));
            const marginY = Math.max(24, Math.min(72, areaRect.height * 0.1));
            let deltaX = 0;
            let deltaY = 0;

            if (nodeRect.left < areaRect.left + marginX) {
                deltaX = (areaRect.left + marginX) - nodeRect.left;
            } else if (nodeRect.right > areaRect.right - marginX) {
                deltaX = (areaRect.right - marginX) - nodeRect.right;
            }

            if (nodeRect.top < areaRect.top + marginY) {
                deltaY = (areaRect.top + marginY) - nodeRect.top;
            } else if (nodeRect.bottom > areaRect.bottom - marginY) {
                deltaY = (areaRect.bottom - marginY) - nodeRect.bottom;
            }

            if (!deltaX && !deltaY) return;
            FT_VIEWPORT.panX += deltaX;
            FT_VIEWPORT.panY += deltaY;
            FT_VIEWPORT.skipPanClampOnce = true;
            if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
        }

        function preserveAnchorAfterLayout(anchorPersonId, beforeRect) {
            if (!anchorPersonId || !beforeRect || !FT_VIEWPORT.initialized) return;
            requestAnimationFrame(function () {
                const anchorNode = getTreeNodeElement(anchorPersonId);
                if (!anchorNode) return;
                const afterRect = anchorNode.getBoundingClientRect();
                FT_VIEWPORT.panX += beforeRect.left - afterRect.left;
                FT_VIEWPORT.panY += beforeRect.top - afterRect.top;
                FT_VIEWPORT.skipPanClampOnce = true;
                if (typeof FT_VIEWPORT.apply === 'function') {
                    FT_VIEWPORT.apply();
                }
                requestAnimationFrame(function () {
                    keepAnchorNodeVisible(anchorNode);
                });
            });
        }

        function setDomBranchCollapsedState(personId, shouldCollapse, options) {
            const opts = options || {};
            const subtree = getBranchSubtreeElement(personId);
            const toggle = getBranchToggleElement(personId);
            if (!subtree || !toggle) return;

            const anchorNode = getTreeNodeElement(opts.anchorPersonId || personId);
            const beforeRect = anchorNode ? anchorNode.getBoundingClientRect() : null;
            const durationMs = 190;
            subtree.style.transitionDuration = durationMs + 'ms';
            updateBranchToggleLabel(toggle, shouldCollapse);

            if (shouldCollapse) {
                COLLAPSED_NODE_IDS.add(Number(personId));
                const currentHeight = subtree.scrollHeight;
                subtree.style.maxHeight = currentHeight + 'px';
                subtree.setAttribute('aria-hidden', 'true');
                subtree.offsetHeight;
                subtree.classList.add('is-collapsed');
                subtree.style.maxHeight = '0px';
                preserveAnchorAfterLayout(opts.anchorPersonId || personId, beforeRect);
                return;
            }

            COLLAPSED_NODE_IDS.delete(Number(personId));
            subtree.classList.remove('is-collapsed');
            subtree.setAttribute('aria-hidden', 'false');
            subtree.style.maxHeight = '0px';
            subtree.offsetHeight;
            const expandedHeight = subtree.scrollHeight;
            subtree.style.maxHeight = expandedHeight + 'px';
            preserveAnchorAfterLayout(opts.anchorPersonId || personId, beforeRect);
            window.setTimeout(function () {
                if (!subtree.classList.contains('is-collapsed')) {
                    subtree.style.maxHeight = 'none';
                }
            }, durationMs + 30);
        }

        function setMultipleBranchesCollapsedState(personIds, shouldCollapse, anchorPersonId) {
            const ids = Array.isArray(personIds) ? personIds : [];
            if (ids.length === 0) return;
            const anchorNode = getTreeNodeElement(anchorPersonId || ids[0]);
            const beforeRect = anchorNode ? anchorNode.getBoundingClientRect() : null;

            ids.forEach(function (personId) {
                const subtree = getBranchSubtreeElement(personId);
                const toggle = getBranchToggleElement(personId);
                if (!subtree || !toggle) return;
                updateBranchToggleLabel(toggle, shouldCollapse);
                subtree.style.transitionDuration = '190ms';
                if (shouldCollapse) {
                    COLLAPSED_NODE_IDS.add(Number(personId));
                    const currentHeight = subtree.scrollHeight;
                    subtree.style.maxHeight = currentHeight + 'px';
                    subtree.setAttribute('aria-hidden', 'true');
                    subtree.offsetHeight;
                    subtree.classList.add('is-collapsed');
                    subtree.style.maxHeight = '0px';
                } else {
                    COLLAPSED_NODE_IDS.delete(Number(personId));
                    subtree.classList.remove('is-collapsed');
                    subtree.setAttribute('aria-hidden', 'false');
                    subtree.style.maxHeight = '0px';
                    subtree.offsetHeight;
                    subtree.style.maxHeight = subtree.scrollHeight + 'px';
                    window.setTimeout(function () {
                        if (!subtree.classList.contains('is-collapsed')) {
                            subtree.style.maxHeight = 'none';
                        }
                    }, 220);
                }
            });

            preserveAnchorAfterLayout(anchorPersonId || ids[0], beforeRect);
        }

        async function resetFiltersAndBackToRoot() {
            const nameInput = document.getElementById('ftFilterName');
            const dobInput = document.getElementById('ftFilterDob');
            const generationInput = document.getElementById('ftFilterGeneration');
            const genderInput = document.getElementById('ftFilterGender');
            const lifeStatusInput = document.getElementById('ftFilterLifeStatus');
            const birthYearInput = document.getElementById('ftFilterBirthYear');
            const deathYearInput = document.getElementById('ftFilterDeathYear');
            const viewModeInput = document.getElementById('ftViewMode');
            if (nameInput) nameInput.value = '';
            if (dobInput) dobInput.value = '';
            if (generationInput) generationInput.value = '';
            if (genderInput) genderInput.value = '';
            if (lifeStatusInput) lifeStatusInput.value = '';
            if (birthYearInput) birthYearInput.value = '';
            if (deathYearInput) deathYearInput.value = '';
            if (viewModeInput) viewModeInput.value = 'full';

            CURRENT_TREE_MODE = 'default';
            CURRENT_FOCUS_PERSON_ID = null;
            CURRENT_DESCENDANT_ROOT_ID = null;
            CURRENT_NAME_FILTER = '';
            CURRENT_DOB_FILTER = '';
            CURRENT_GENERATION_FILTER = null;
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;
            CURRENT_DEATH_YEAR = null;
            CURRENT_VIEW_MODE = 'full';
            COLLAPSED_NODE_IDS.clear();

            if (FT_FILTER_DEBOUNCE) {
                clearTimeout(FT_FILTER_DEBOUNCE);
                FT_FILTER_DEBOUNCE = null;
            }

            applyTreeViewMode();
            resetTreeViewport();
            await loadRootPersons({ forceReload: false, center: true, centerBranchId: BRANCH_ID });
        }

        async function fetchRootsByBranchId(branchId) {
            const res = await fetch('/api/person/roots?branchId=' + encodeURIComponent(branchId));
            if (!res.ok) return [];
            const data = await res.json();
            return Array.isArray(data) ? data : [];
        }

        function mergeRootLists(rootLists) {
            const merged = [];
            const seen = new Set();
            (rootLists || []).forEach(function (list) {
                (Array.isArray(list) ? list : []).forEach(function (item) {
                    const id = Number(item && item.id || 0);
                    if (!id || seen.has(id)) return;
                    seen.add(id);
                    merged.push(item);
                });
            });
            return merged;
        }

        async function applyGenerationFilterAndRender() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;
            const app = document.getElementById('ftApp');
            if (!Array.isArray(CURRENT_TREE_ROOTS) || CURRENT_TREE_ROOTS.length === 0) {
                treeRoot.innerHTML = '';
                if (app) app.classList.remove('ft-heavy');
                updateTopStats(0, 0);
                return;
            }

            const renderRoots = getCurrentRenderRoots();

            const scopedMembers = collectScopedMembers(renderRoots);
            let visibleMembers = scopedMembers;

            if (hasAdvancedFilter()) {
                visibleMembers = scopedMembers.filter(memberMatchesAdvancedFilters);
            }
            if (hasAnyActiveFilter()) {
                visibleMembers = dedupeMembersForList(visibleMembers);
            }

            FT_FILTER_RENDER_SEQ += 1;
            if (!hasAnyActiveFilter()) {
                treeRoot.innerHTML = renderForest(renderRoots);
            } else {
                treeRoot.innerHTML = renderGenerationOnly(visibleMembers);
            }
            if (app) {
                const nodes = treeRoot.querySelectorAll('.person-node').length;
                app.classList.toggle('ft-heavy', nodes > 140);
            }
            const baseStats = computeVisibleStatsFromMembers(hasAnyActiveFilter() ? visibleMembers : scopedMembers);
            syncGenerationFilterOptions(baseStats.generations);
            updateTopStats(baseStats.generations, baseStats.members);
            if ((hasAnyActiveFilter() || CURRENT_FOCUS_PERSON_ID != null || CURRENT_DESCENDANT_ROOT_ID != null) && visibleMembers.length > 0) {
                const targetId = hasAnyActiveFilter()
                    ? Number(visibleMembers[0] && visibleMembers[0].id || 0)
                    : Number((CURRENT_DESCENDANT_ROOT_ID != null ? CURRENT_DESCENDANT_ROOT_ID : CURRENT_FOCUS_PERSON_ID) || 0);
                if (targetId > 0) {
                    requestAnimationFrame(function () {
                        centerTreeOnPerson(targetId);
                    });
                }
            }
        }

        async function loadRootPersons(options) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;
            const opts = options || {};
            const forceReload = !!opts.forceReload;
            const centerAfterRender = !!opts.center;
            const centerBranchId = opts.centerBranchId != null ? Number(opts.centerBranchId) : null;

            try {
                const treeBranchId = getTreeBranchQueryId();
                const cacheKey = getRootCacheKey(treeBranchId);
                let roots = forceReload ? null : ROOT_PERSON_CACHE[cacheKey];
                if (!Array.isArray(roots)) {
                    roots = await fetchRootsByBranchId(treeBranchId);
                    if (treeBranchId === 0 && (!Array.isArray(roots) || roots.length === 0)) {
                        const branchRes = await fetch('/api/branch');
                        if (branchRes.ok) {
                            const branches = await branchRes.json();
                            const ids = (Array.isArray(branches) ? branches : [])
                                .map(function (b) { return Number(b && b.id || 0); })
                                .filter(function (id) { return id > 0; });
                            const allLists = [];
                            for (let i = 0; i < ids.length; i += 1) {
                                const list = await fetchRootsByBranchId(ids[i]);
                                if (list.length) allLists.push(list);
                            }
                            roots = mergeRootLists(allLists);
                        }
                    }
                    ROOT_PERSON_CACHE[cacheKey] = roots;
                }

                const validRoots = Array.isArray(roots)
                    ? roots.filter(function (item) { return item && item.id; })
                    : [];
                if (validRoots.length === 0) {
                    CURRENT_TREE_ROOTS = [];
                    CURRENT_FOCUS_PERSON_ID = null;
                    CURRENT_DESCENDANT_ROOT_ID = null;
                    treeRoot.innerHTML = '';
                    updateTopStats(0, 0);
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true, []);
                    }
                    return;
                }
                CURRENT_TREE_ROOTS = validRoots;
                syncGenerationFilterOptions(getMaxGenerationFromRoots(validRoots));
                if (CURRENT_DESCENDANT_ROOT_ID != null && !findAnchorNodeByMemberIdInRoots(CURRENT_DESCENDANT_ROOT_ID)) {
                    CURRENT_DESCENDANT_ROOT_ID = null;
                }
                if (CURRENT_FOCUS_PERSON_ID != null && !findAnchorNodeByMemberIdInRoots(CURRENT_FOCUS_PERSON_ID)) {
                    CURRENT_FOCUS_PERSON_ID = null;
                    CURRENT_DESCENDANT_ROOT_ID = null;
                }
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(false, validRoots);
                }
                applyGenerationFilterAndRender();
                if (centerAfterRender) {
                    if (FT_VIEWPORT.initialized) {
                        FT_VIEWPORT.scale = 1;
                        FT_VIEWPORT.panX = 0;
                        FT_VIEWPORT.panY = 0;
                        if (typeof FT_VIEWPORT.apply === 'function') {
                            FT_VIEWPORT.apply();
                        }
                    }
                    requestAnimationFrame(function () {
                        centerTreeView(centerBranchId);
                    });
                }
            } catch (err) {
                console.error('Load root person failed:', err);
                CURRENT_TREE_ROOTS = [];
                CURRENT_DESCENDANT_ROOT_ID = null;
                treeRoot.innerHTML = '';
                updateTopStats(0, 0);
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(true, []);
                }
            }
        }

        function setupPersonCardActions() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || treeRoot.dataset.actionsBound === 'true') return;
            treeRoot.dataset.actionsBound = 'true';

            function closeAllTreeMenus() {
                treeRoot.querySelectorAll('.tree-action-menu.show').forEach(function (menu) {
                    menu.classList.remove('show');
                });
                treeRoot.querySelectorAll('.menu-open').forEach(function (node) {
                    node.classList.remove('menu-open');
                });
            }

            treeRoot.addEventListener('click', async function (e) {
                if (Date.now() < FT_SUPPRESS_CLICK_UNTIL) {
                    return;
                }
                const branchToggle = e.target.closest('[data-tree-toggle-id]');
                if (branchToggle) {
                    e.preventDefault();
                    e.stopPropagation();
                    const togglePersonId = Number(branchToggle.getAttribute('data-tree-toggle-id') || 0);
                    if (togglePersonId > 0) {
                        setDomBranchCollapsedState(togglePersonId, !COLLAPSED_NODE_IDS.has(togglePersonId), {
                            anchorPersonId: togglePersonId
                        });
                    }
                    return;
                }
                const toggle = e.target.closest('.tree-menu-toggle');
                if (toggle) {
                    e.stopPropagation();
                    const menuId = toggle.getAttribute('data-menu-id');
                    const menu = menuId ? document.getElementById(menuId) : null;
                    if (!menu) return;
                    const willOpen = !menu.classList.contains('show');
                    closeAllTreeMenus();
                    if (willOpen) {
                        menu.classList.add('show');
                        const ownerNode = menu.closest('.person-node');
                        const ownerLi = menu.closest('.li-person');
                        if (ownerNode) ownerNode.classList.add('menu-open');
                        if (ownerLi) ownerLi.classList.add('menu-open');
                    }
                    return;
                }

                const actionEl = e.target.closest('[data-tree-action]');
                if (actionEl) {
                    e.stopPropagation();
                    closeAllTreeMenus();
                    const action = String(actionEl.getAttribute('data-tree-action') || '');
                    const personId = Number(actionEl.getAttribute('data-person-id') || 0);
                    let person = findPersonByIdInRoots(personId);
                    if (!person && action !== 'back-root' && personId > 0) {
                        try {
                            person = await loadPersonDetailById(personId);
                        } catch (err) {
                            console.error('Load person detail for action failed:', err);
                            showToast('Không tải được thông tin thành viên', 'error');
                            return;
                        }
                    }
                    if (!person && action !== 'back-root') return;

                    if (action === 'add-root') {
                        const createBtn = document.getElementById('btnCreateFirst');
                        if (createBtn) createBtn.click();
                        return;
                    }
                    if (action === 'center-person') {
                        centerTreeOnPerson(personId);
                        return;
                    }
                    if (action === 'view-descendants') {
                        openDescendantSubtree(person);
                        return;
                    }
                    if (action === 'back-root') {
                        resetFiltersAndBackToRoot()
                            .catch(function (err) {
                                console.error('Back root reload failed:', err);
                                requestTreeRender();
                            });
                        return;
                    }
                    if (action === 'copy-data') {
                        const copyData = [
                            'Họ tên: ' + (person.fullName || ''),
                            'Giới tính: ' + (person.gender || ''),
                            'Ngày sinh: ' + formatDate(person.dob),
                            'Ngày mất: ' + formatDate(person.dod),
                            'Chi: ' + (person.branchName || '')
                        ].join('\n');
                        if (navigator.clipboard && navigator.clipboard.writeText) {
                            navigator.clipboard.writeText(copyData).then(function () {
                                showToast('Đã sao chép dữ liệu', 'success');
                            }).catch(function () {
                                showToast('Không thể sao chép dữ liệu', 'error');
                            });
                        } else {
                            showToast('Trình duyệt không hỗ trợ sao chép', 'error');
                        }
                        return;
                    }
                    if (!canManageMember) return;
                    if (action === 'add-child') {
                        openActionMemberModal('add-child', person);
                        return;
                    }
                    if (action === 'add-spouse') {
                        openActionMemberModal('add-spouse', person);
                        return;
                    }
                    if (action === 'edit-member') {
                        openActionMemberModal('edit-member', person);
                        return;
                    }
                    if (action === 'delete-member') {
                        deleteMember(person);
                    }
                    return;
                }

                closeAllTreeMenus();
                const card = e.target.closest('.person-node');
                if (!card) return;
                e.stopPropagation();
                const personId = Number(card.getAttribute('data-id') || 0);
                if (personId > 0) openDetailMemberModal(personId);
            });

            document.addEventListener('click', function () {
                closeAllTreeMenus();
            });
        }

        function initZoomControls() {
            const contentArea = document.getElementById('contentArea');
            const scaleWrap = document.getElementById('scaleWrap');
            const app = document.getElementById('ftApp');
            if (!contentArea || !scaleWrap) return;
            scaleWrap.style.transformOrigin = '0 0';
            scaleWrap.style.willChange = 'auto';

            FT_VIEWPORT.scale = FT_VIEWPORT.initialized ? FT_VIEWPORT.scale : 1;
            FT_VIEWPORT.panX = FT_VIEWPORT.initialized ? FT_VIEWPORT.panX : 0;
            FT_VIEWPORT.panY = FT_VIEWPORT.initialized ? FT_VIEWPORT.panY : 0;

            const minScale = window.innerWidth <= 767 ? 0.36 : 0.22;
            const maxScale = window.innerWidth <= 767 ? 1.04 : 1.12;
            let viewportRaf = 0;
            let interactionTimer = 0;
            const getPanBounds = function (scaleValue) {
                const treeRoot = document.getElementById('treeRoot');
                const scale = Number.isFinite(scaleValue) ? scaleValue : FT_VIEWPORT.scale || 1;
                const viewportWidth = contentArea.clientWidth || 0;
                const viewportHeight = contentArea.clientHeight || 0;
                const treeWidth = treeRoot ? Math.max(treeRoot.scrollWidth || 0, treeRoot.offsetWidth || 0) : 0;
                const treeHeight = treeRoot ? Math.max(treeRoot.scrollHeight || 0, treeRoot.offsetHeight || 0) : 0;
                const scaledWidth = Math.max(treeWidth * scale, 0);
                const scaledHeight = Math.max(treeHeight * scale, 0);
                const bufferX = Math.max(120, viewportWidth * 0.28);
                const bufferTop = Math.max(40, viewportHeight * 0.08);
                const bufferBottom = Math.max(120, viewportHeight * 0.22);
                let minX;
                let maxX;
                let minY;
                let maxY;

                if (scaledWidth <= viewportWidth) {
                    const centeredX = (viewportWidth - scaledWidth) / 2;
                    minX = centeredX - bufferX;
                    maxX = centeredX + bufferX;
                } else {
                    minX = viewportWidth - scaledWidth - bufferX;
                    maxX = bufferX;
                }

                if (scaledHeight <= viewportHeight) {
                    const centeredY = Math.max(bufferTop, (viewportHeight - scaledHeight) / 2);
                    minY = centeredY - bufferBottom;
                    maxY = centeredY + bufferTop;
                } else {
                    minY = viewportHeight - scaledHeight - bufferBottom;
                    maxY = bufferTop;
                }

                return {
                    minX: Number.isFinite(minX) ? minX : -bufferX,
                    maxX: Number.isFinite(maxX) ? maxX : bufferX,
                    minY: Number.isFinite(minY) ? minY : -bufferBottom,
                    maxY: Number.isFinite(maxY) ? maxY : bufferTop
                };
            };
            const clampScale = function (value) {
                if (!Number.isFinite(value)) return FT_VIEWPORT.scale || 1;
                return Math.min(maxScale, Math.max(minScale, value));
            };
            const clampPan = function (value, axis, scaleValue) {
                if (!Number.isFinite(value)) return 0;
                const bounds = getPanBounds(scaleValue);
                if (axis === 'y') {
                    return Math.min(bounds.maxY, Math.max(bounds.minY, value));
                }
                return Math.min(bounds.maxX, Math.max(bounds.minX, value));
            };

            const setInteractingState = function () {
                if (!app) return;
                app.classList.add('ft-interacting');
                scaleWrap.style.willChange = 'transform';
                if (interactionTimer) clearTimeout(interactionTimer);
                interactionTimer = setTimeout(function () {
                    app.classList.remove('ft-interacting');
                    scaleWrap.style.willChange = 'auto';
                }, 160);
            };

            const applyViewportNow = function () {
                viewportRaf = 0;
                FT_VIEWPORT.scale = clampScale(FT_VIEWPORT.scale);
                const skipPanClampOnce = FT_VIEWPORT.skipPanClampOnce === true;
                FT_VIEWPORT.skipPanClampOnce = false;
                if (!skipPanClampOnce) {
                    FT_VIEWPORT.panX = clampPan(FT_VIEWPORT.panX, 'x', FT_VIEWPORT.scale);
                    FT_VIEWPORT.panY = clampPan(FT_VIEWPORT.panY, 'y', FT_VIEWPORT.scale);
                }
                scaleWrap.style.transform = 'translate(' + FT_VIEWPORT.panX + 'px,' + FT_VIEWPORT.panY + 'px) scale(' + FT_VIEWPORT.scale + ')';
            };

            FT_VIEWPORT.apply = function () {
                if (viewportRaf) return;
                viewportRaf = requestAnimationFrame(applyViewportNow);
            };
            FT_VIEWPORT.applyNow = applyViewportNow;

            const zoomAtPoint = function (nextScale, clientX, clientY) {
                const clamped = clampScale(nextScale);
                const areaRect = contentArea.getBoundingClientRect();
                const localX = clientX - areaRect.left;
                const localY = clientY - areaRect.top;
                const worldX = (localX - FT_VIEWPORT.panX) / FT_VIEWPORT.scale;
                const worldY = (localY - FT_VIEWPORT.panY) / FT_VIEWPORT.scale;
                FT_VIEWPORT.scale = clamped;
                FT_VIEWPORT.panX = clampPan(localX - worldX * FT_VIEWPORT.scale, 'x', FT_VIEWPORT.scale);
                FT_VIEWPORT.panY = clampPan(localY - worldY * FT_VIEWPORT.scale, 'y', FT_VIEWPORT.scale);
                setInteractingState();
                FT_VIEWPORT.apply();
            };

            let pendingPanDx = 0;
            let pendingPanDy = 0;
            let panRaf = 0;
            const flushPan = function () {
                panRaf = 0;
                if (!pendingPanDx && !pendingPanDy) return;
                FT_VIEWPORT.panX += pendingPanDx;
                FT_VIEWPORT.panY += pendingPanDy;
                pendingPanDx = 0;
                pendingPanDy = 0;
                FT_VIEWPORT.apply();
            };
            const schedulePan = function (dx, dy) {
                pendingPanDx += dx;
                pendingPanDy += dy;
                setInteractingState();
                if (!panRaf) {
                    panRaf = requestAnimationFrame(flushPan);
                }
            };

            if (FT_VIEWPORT.initialized && contentArea.dataset.ftPanZoomBound === 'true') {
                FT_VIEWPORT.apply();
                return;
            }

            contentArea.dataset.ftPanZoomBound = 'true';
            FT_VIEWPORT.initialized = true;
            FT_VIEWPORT.apply();

            contentArea.addEventListener('wheel', function (e) {
                e.preventDefault();
                const wheelSensitivity = e.ctrlKey ? 0.0032 : 0.0024;
                let factor = Math.exp(-e.deltaY * wheelSensitivity);
                factor = Math.min(1.22, Math.max(0.82, factor));
                if (FT_VIEWPORT.scale < 0.18 && factor > 1) {
                    factor = Math.pow(factor, 1.25);
                }
                zoomAtPoint(FT_VIEWPORT.scale * factor, e.clientX, e.clientY);
            }, { passive: false });
            contentArea.addEventListener('dragstart', function (e) {
                e.preventDefault();
            });

            let pinchState = null;
            let touchPanState = null;
            function distance(t1, t2) {
                const dx = t1.clientX - t2.clientX;
                const dy = t1.clientY - t2.clientY;
                return Math.sqrt(dx * dx + dy * dy);
            }
            contentArea.addEventListener('touchstart', function (e) {
                if (e.touches.length === 2) {
                    pinchState = {
                        dist: distance(e.touches[0], e.touches[1]),
                        centerX: (e.touches[0].clientX + e.touches[1].clientX) / 2,
                        centerY: (e.touches[0].clientY + e.touches[1].clientY) / 2
                    };
                    touchPanState = null;
                } else if (e.touches.length === 1) {
                    touchPanState = {
                        lastX: e.touches[0].clientX,
                        lastY: e.touches[0].clientY,
                        moved: false
                    };
                }
            }, { passive: true });

            contentArea.addEventListener('touchmove', function (e) {
                if (e.touches.length === 2 && pinchState) {
                    e.preventDefault();
                    const newDist = distance(e.touches[0], e.touches[1]);
                    if (newDist <= 0) return;
                    const ratio = newDist / pinchState.dist;
                    let smoothRatio = Math.pow(ratio, 1.04);
                    smoothRatio = Math.min(1.2, Math.max(0.84, smoothRatio));
                    pinchState.dist = newDist;
                    pinchState.centerX = (e.touches[0].clientX + e.touches[1].clientX) / 2;
                    pinchState.centerY = (e.touches[0].clientY + e.touches[1].clientY) / 2;
                    zoomAtPoint(FT_VIEWPORT.scale * smoothRatio, pinchState.centerX, pinchState.centerY);
                    return;
                }
                if (e.touches.length === 1 && touchPanState && !pinchState) {
                    e.preventDefault();
                    const touch = e.touches[0];
                    const dx = (touch.clientX - touchPanState.lastX) * 1.25;
                    const dy = (touch.clientY - touchPanState.lastY) * 1.25;
                    if (Math.abs(dx) > 0.4 || Math.abs(dy) > 0.4) {
                        touchPanState.moved = true;
                        schedulePan(dx, dy);
                    }
                    touchPanState.lastX = touch.clientX;
                    touchPanState.lastY = touch.clientY;
                }
            }, { passive: false });

            contentArea.addEventListener('touchend', function (e) {
                if (pinchState && e.touches && e.touches.length < 2) {
                    pinchState = null;
                }
                if (touchPanState && (!e.touches || e.touches.length === 0)) {
                    if (touchPanState.moved) {
                        FT_SUPPRESS_CLICK_UNTIL = Date.now() + 220;
                    }
                    touchPanState = null;
                }
            });
            contentArea.addEventListener('touchcancel', function () {
                pinchState = null;
                touchPanState = null;
            });

            let dragging = false;
            let dragMoved = false;
            let panStarted = false;
            let dragStartX = 0;
            let dragStartY = 0;
            let lastX = 0;
            let lastY = 0;
            const DRAG_THRESHOLD = 1;
            const PAN_SPEED = 1.18;
            contentArea.addEventListener('mousedown', function (e) {
                if (e.button !== 0) return;
                if (e.target.closest('.tree-action-menu') || e.target.closest('.tree-menu-toggle') || e.target.closest('[data-tree-action]')) return;
                e.preventDefault();
                dragging = true;
                dragMoved = false;
                panStarted = false;
                dragStartX = e.clientX;
                dragStartY = e.clientY;
                lastX = e.clientX;
                lastY = e.clientY;
                contentArea.style.cursor = 'grabbing';
            });

            window.addEventListener('mousemove', function (e) {
                if (!dragging) return;
                if (!(e.buttons & 1)) {
                    dragging = false;
                    panStarted = false;
                    contentArea.style.cursor = 'grab';
                    return;
                }
                const dx = e.clientX - lastX;
                const dy = e.clientY - lastY;
                if (!panStarted) {
                    const distX = e.clientX - dragStartX;
                    const distY = e.clientY - dragStartY;
                    if (Math.abs(distX) < DRAG_THRESHOLD && Math.abs(distY) < DRAG_THRESHOLD) {
                        return;
                    }
                    panStarted = true;
                }
                if (Math.abs(dx) > 1 || Math.abs(dy) > 1) {
                    dragMoved = true;
                }
                schedulePan(dx * PAN_SPEED, dy * PAN_SPEED);
                lastX = e.clientX;
                lastY = e.clientY;
            });

            window.addEventListener('mouseup', function () {
                if (!dragging) return;
                dragging = false;
                panStarted = false;
                contentArea.style.cursor = 'grab';
                if (panRaf) {
                    cancelAnimationFrame(panRaf);
                    panRaf = 0;
                }
                flushPan();
                if (dragMoved) {
                    FT_SUPPRESS_CLICK_UNTIL = Date.now() + 180;
                }
            });

            function fitTreeToViewport() {
                const treeRoot = document.getElementById('treeRoot');
                if (!treeRoot) return;
                const firstNode = treeRoot.querySelector('.person-node');
                if (!firstNode) return;
                FT_VIEWPORT.scale = 1;
                FT_VIEWPORT.panX = 0;
                FT_VIEWPORT.panY = 0;
                applyViewportNow();

                const areaRect = contentArea.getBoundingClientRect();
                const treeRect = treeRoot.getBoundingClientRect();
                if (!treeRect.width || !treeRect.height || !areaRect.width || !areaRect.height) return;

                const widthScale = (areaRect.width - 40) / treeRect.width;
                const heightScale = (areaRect.height - 40) / treeRect.height;
                FT_VIEWPORT.scale = clampScale(Math.min(widthScale, heightScale, 1));
                FT_VIEWPORT.panX = clampPan((areaRect.width - (treeRect.width * FT_VIEWPORT.scale)) / 2, 'x', FT_VIEWPORT.scale);
                FT_VIEWPORT.panY = clampPan(24, 'y', FT_VIEWPORT.scale);
                FT_VIEWPORT.apply();
            }

            document.getElementById('ftZoomIn')?.addEventListener('click', function () {
                const rect = contentArea.getBoundingClientRect();
                zoomAtPoint(FT_VIEWPORT.scale * 1.14, rect.left + rect.width / 2, rect.top + rect.height / 2);
            });
            document.getElementById('ftZoomOut')?.addEventListener('click', function () {
                const rect = contentArea.getBoundingClientRect();
                zoomAtPoint(FT_VIEWPORT.scale / 1.14, rect.left + rect.width / 2, rect.top + rect.height / 2);
            });
            document.getElementById('ftFitScreen')?.addEventListener('click', function () {
                fitTreeToViewport();
            });
            document.getElementById('ftCenterRoot')?.addEventListener('click', function () {
                const alreadyAtDefaultScale = Math.abs((FT_VIEWPORT.scale || 1) - 1) < 0.001;
                if (alreadyAtDefaultScale) {
                    centerTreeView(BRANCH_ID);
                    return;
                }
                resetTreeViewport();
                centerTreeView(BRANCH_ID);
            });
            document.getElementById('ftPrintView')?.addEventListener('click', function () {
                const viewModeInput = document.getElementById('ftViewMode');
                if (viewModeInput) {
                    viewModeInput.value = 'print';
                }
                CURRENT_VIEW_MODE = 'print';
                applyTreeViewMode();
                window.print();
            });
            document.getElementById('ftCollapseAll')?.addEventListener('click', function () {
                const renderRoots = getCurrentRenderRoots();
                const protectedIds = new Set(renderRoots.map(function (member) {
                    return Number(member && member.id || 0);
                }).filter(function (id) {
                    return id > 0;
                }));
                const targetIds = [];
                collectScopedMembers(renderRoots).forEach(function (member) {
                    const memberId = Number(member && member.id || 0);
                    if (protectedIds.has(memberId)) return;
                    if (Array.isArray(member.children) && member.children.length > 0 && memberId > 0) {
                        targetIds.push(memberId);
                    }
                });
                setMultipleBranchesCollapsedState(targetIds, true, CURRENT_FOCUS_PERSON_ID || Number(renderRoots[0] && renderRoots[0].id || 0));
            });
            document.getElementById('ftExpandAll')?.addEventListener('click', function () {
                const targetIds = Array.from(document.querySelectorAll('#treeRoot .ft-branch-toggle[data-tree-toggle-id]'))
                    .map(function (button) {
                        return Number(button.getAttribute('data-tree-toggle-id') || 0);
                    })
                    .filter(function (id) {
                        return id > 0;
                    });
                setMultipleBranchesCollapsedState(targetIds, false, CURRENT_FOCUS_PERSON_ID || targetIds[0] || 0);
            });

            window.addEventListener('resize', function () {
                FT_VIEWPORT.apply();
            });
        }

        function bindAvatarPicker(fileInputId, targetInputId) {
            const fileInput = document.getElementById(fileInputId);
            const targetInput = document.getElementById(targetInputId);
            if (!fileInput || !targetInput) return;

            fileInput.addEventListener('change', function () {
                const file = fileInput.files && fileInput.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = function (evt) {
                    const dataUrl = evt && evt.target ? evt.target.result : '';
                    if (typeof dataUrl === 'string' && dataUrl.length > 0) {
                        targetInput.value = dataUrl;
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        function bindBirthDateInputGuards() {
            const todayIso = new Date().toISOString().slice(0, 10);
            ['mDob', 'aDob', 'ftFilterDob'].forEach(function (id) {
                const input = document.getElementById(id);
                if (!input) return;
                input.setAttribute('max', todayIso);
                input.addEventListener('input', function () {
                    const normalized = normalizeDateFilterValue(input.value);
                    if (!normalized) {
                        input.value = '';
                        return;
                    }
                    if (normalized > todayIso) {
                        input.value = todayIso;
                    }
                });
            });
        }

        function normalizeYearInputValue(value) {
            const raw = String(value || '').trim();
            if (!raw) return null;
            const parsed = Number(raw);
            if (!Number.isFinite(parsed) || parsed <= 0) return null;
            return Math.floor(parsed);
        }

        function applyTreeViewMode() {
            const app = document.getElementById('ftApp');
            if (!app) return;
            app.classList.toggle('ft-view-minimal', CURRENT_VIEW_MODE === 'minimal');
            app.classList.toggle('ft-view-print', CURRENT_VIEW_MODE === 'print');
        }

        function bindAdvancedFilters() {
            CURRENT_NAME_FILTER = '';
            CURRENT_DOB_FILTER = '';
            CURRENT_GENERATION_FILTER = null;
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;
            CURRENT_DEATH_YEAR = null;
            CURRENT_VIEW_MODE = 'full';
            const nameInput = document.getElementById('ftFilterName');
            const dobInput = document.getElementById('ftFilterDob');
            const generationInput = document.getElementById('ftFilterGeneration');
            const genderInput = document.getElementById('ftFilterGender');
            const lifeStatusInput = document.getElementById('ftFilterLifeStatus');
            const birthYearInput = document.getElementById('ftFilterBirthYear');
            const deathYearInput = document.getElementById('ftFilterDeathYear');
            const viewModeInput = document.getElementById('ftViewMode');
            const resetBtn = document.getElementById('ftFilterReset');
            if (!nameInput || !dobInput || !generationInput || !genderInput || !lifeStatusInput || !birthYearInput || !deathYearInput || !viewModeInput || !resetBtn) {
                return;
            }
            const todayIso = new Date().toISOString().slice(0, 10);
            dobInput.setAttribute('max', todayIso);

            const applyAllFilters = function () {
                CURRENT_NAME_FILTER = String(nameInput.value || '').trim();
                const normalizedDob = normalizeDateFilterValue(dobInput.value);
                CURRENT_DOB_FILTER = normalizedDob;
                CURRENT_GENERATION_FILTER = normalizeYearInputValue(generationInput.value);
                CURRENT_GENDER_FILTER = String(genderInput.value || '').trim().toLowerCase();
                CURRENT_LIFE_STATUS_FILTER = String(lifeStatusInput.value || '').trim().toLowerCase();
                const birthYear = normalizeYearInputValue(birthYearInput.value);
                CURRENT_BIRTH_YEAR_FROM = birthYear;
                CURRENT_BIRTH_YEAR_TO = birthYear;
                CURRENT_DEATH_YEAR = normalizeYearInputValue(deathYearInput.value);
                CURRENT_VIEW_MODE = String(viewModeInput.value || 'full').trim().toLowerCase() || 'full';
                const hasSearchState = !!(CURRENT_NAME_FILTER
                    || CURRENT_DOB_FILTER
                    || CURRENT_GENERATION_FILTER != null
                    || CURRENT_GENDER_FILTER
                    || CURRENT_LIFE_STATUS_FILTER
                    || CURRENT_BIRTH_YEAR_FROM != null
                    || CURRENT_BIRTH_YEAR_TO != null
                    || CURRENT_DEATH_YEAR != null);
                if (hasSearchState) {
                    CURRENT_TREE_MODE = 'search';
                    CURRENT_DESCENDANT_ROOT_ID = null;
                } else if (CURRENT_DESCENDANT_ROOT_ID != null) {
                    CURRENT_TREE_MODE = 'descendants';
                } else {
                    CURRENT_TREE_MODE = 'default';
                }
                applyTreeViewMode();
                if (String(dobInput.value || '').trim() && !normalizedDob) {
                    dobInput.value = '';
                }
                resetTreeViewport();
                requestTreeRender();
            };

            const applyDebounced = function () {
                if (FT_FILTER_DEBOUNCE) {
                    clearTimeout(FT_FILTER_DEBOUNCE);
                }
                FT_FILTER_DEBOUNCE = setTimeout(function () {
                    applyAllFilters();
                }, 120);
            };

            nameInput.addEventListener('input', applyDebounced);
            dobInput.addEventListener('input', applyDebounced);
            generationInput.addEventListener('change', applyDebounced);
            genderInput.addEventListener('change', applyDebounced);
            lifeStatusInput.addEventListener('change', applyDebounced);
            birthYearInput.addEventListener('input', applyDebounced);
            deathYearInput.addEventListener('input', applyDebounced);
            viewModeInput.addEventListener('change', function () {
                applyAllFilters();
                if (CURRENT_VIEW_MODE === 'print') {
                    window.print();
                }
            });
            dobInput.addEventListener('blur', function () {
                const normalized = normalizeDateFilterValue(dobInput.value);
                dobInput.value = normalized || '';
            });
            resetBtn.addEventListener('click', async function () {
                try {
                    await resetFiltersAndBackToRoot();
                } catch (err) {
                    console.error('Reset reload failed:', err);
                    requestTreeRender();
                }
            });

            applyTreeViewMode();
            window.addEventListener('afterprint', function () {
                if (CURRENT_VIEW_MODE === 'print') {
                    CURRENT_VIEW_MODE = 'full';
                    viewModeInput.value = 'full';
                    applyTreeViewMode();
                }
            });
        }

        bindAvatarPicker('mAvatarFile', 'mAvatar');
        bindAvatarPicker('aAvatarFile', 'aAvatar');
        bindBirthDateInputGuards();
        bindAdvancedFilters();
        initZoomControls();
        setupPersonCardActions();

        async function bootstrapFamilyTree() {
            syncGenerationFilterOptions(SERVER_TOTAL_GENERATIONS);
            await loadBranches();
            await loadRootPersons({ center: true, centerBranchId: BRANCH_ID });
        }

        bootstrapFamilyTree();
</script>


</div>
        </div>
    </div>
</div>
