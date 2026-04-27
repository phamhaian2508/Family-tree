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
        width: 100% !important;
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
        grid-template-columns: minmax(260px, 1.8fr) minmax(160px, 1fr) minmax(190px, 1fr) auto;
        align-items: end;
        gap: 10px !important;
        min-width: 100%;
    }
    #ftApp #advancedFilterBar .ft-filter-field {
        min-width: 0;
        display: flex;
        flex-direction: column;
        align-items: stretch;
        gap: 6px;
    }
    #ftApp #advancedFilterBar .ft-filter-field-search {
        grid-column: span 1;
    }
    #ftApp #advancedFilterBar .ft-filter-field:has(#branchDropdown),
    #ftApp #advancedFilterBar .ft-filter-field:has(#ftFilterGender),
    #ftApp #advancedFilterBar .ft-filter-field:has(#ftFilterLifeStatus),
    #ftApp #advancedFilterBar .ft-filter-field:has(#ftFilterBirthYear),
    #ftApp #advancedFilterBar .ft-filter-field:has(#ftFilterDeathYear) {
        display: none !important;
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
        display: flex;
        align-items: flex-end;
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
        position: relative;
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
    #ftApp .ft-page-banner {
        display: none !important;
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
    #ftApp .ft-page-banner-text {
        display: none;
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
        border: 3px solid rgba(140, 36, 31, 0.42);
        border-radius: 10px;
        overflow: hidden;
        background:
            linear-gradient(180deg, rgba(255, 251, 243, 0.96), rgba(244, 229, 194, 0.98)),
            url("/web/images/paper-texture.png");
        background-size: auto, 300px;
        box-shadow:
            inset 0 0 0 1px rgba(247, 224, 214, 0.92),
            0 10px 22px rgba(73, 37, 18, 0.06);
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
        user-select: none;
        -webkit-user-select: none;
    }
    #ftApp .ft-tree-scale {
        position: relative;
        min-width: max-content;
        min-height: max-content;
        transform: translate3d(0, 0, 0);
        backface-visibility: hidden;
        transform-style: preserve-3d;
        user-select: none;
        -webkit-user-select: none;
        -webkit-user-drag: none;
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
        position: relative;
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
    #ftApp #treeRoot .box-person.ft-root-box {
        padding-top: 156px;
    }
    #ftApp #treeRoot .ft-root-ornament {
        position: absolute;
        top: -36px;
        left: 50%;
        transform: translateX(-50%);
        width: min(430px, calc(100% + 180px));
        display: flex;
        align-items: center;
        justify-content: space-between;
        pointer-events: none;
        user-select: none;
        z-index: 3;
    }
    #ftApp #treeRoot .ft-root-ornament img {
        width: 150px;
        height: 150px;
        object-fit: contain;
        filter: drop-shadow(0 4px 10px rgba(73, 37, 18, 0.16));
        opacity: 0.96;
    }
    #ftApp #treeRoot .person-node {
        width: var(--node-width);
        min-height: 224px;
        border-radius: 8px !important;
        border: 3px solid rgba(140, 36, 31, 0.62) !important;
        padding: 10px 10px 12px !important;
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)),
            url("/web/images/paper-texture.png") !important;
        background-size: auto, 240px !important;
        box-shadow:
            inset 0 0 0 1px rgba(255, 247, 226, 0.96),
            inset 0 0 0 7px rgba(140, 36, 31, 0.08),
            0 8px 20px rgba(73, 37, 18, 0.08) !important;
        position: relative;
        overflow: visible;
        backface-visibility: hidden;
        transform: translateZ(0);
        transition: transform 0.16s ease, box-shadow 0.16s ease, border-color 0.16s ease;
    }
    #ftApp #treeRoot .person-node::before,
    #ftApp #treeRoot .person-node::after {
        content: none;
        display: none;
    }
    #ftApp #treeRoot .person-node:hover {
        transform: translateY(-2px);
        border-color: rgba(140, 36, 31, 0.82) !important;
        box-shadow:
            inset 0 0 0 1px rgba(255, 247, 226, 0.98),
            inset 0 0 0 7px rgba(140, 36, 31, 0.12),
            0 12px 28px rgba(73, 37, 18, 0.12) !important;
    }
    #ftApp #treeRoot .person-node.male,
    #ftApp #treeRoot .person-node.female,
    #ftApp #treeRoot .person-node.other {
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)),
            url("/web/images/paper-texture.png") !important;
    }
    #ftApp #treeRoot .person-node.female {
        border-color: rgba(140, 36, 31, 0.62) !important;
    }
    #ftApp #treeRoot .person-node.male {
        border-color: rgba(140, 36, 31, 0.62) !important;
    }
    #ftApp #treeRoot .person-node.person-role-founder {
        background:
            linear-gradient(180deg, rgba(255, 245, 213, 1), rgba(238, 214, 162, 0.98)),
            url("/web/images/paper-texture.png") !important;
        border-color: rgba(140, 36, 31, 0.62) !important;
    }
    #ftApp #treeRoot .person-node.person-role-lineage-head {
        border-color: rgba(140, 36, 31, 0.62) !important;
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
        border: 3px solid rgba(140, 36, 31, 0.72);
        box-shadow:
            0 0 0 1px rgba(255, 247, 226, 0.96),
            0 4px 10px rgba(73, 37, 18, 0.12);
        pointer-events: none;
        user-select: none;
        -webkit-user-select: none;
        -webkit-user-drag: none;
    }
    #ftApp #treeRoot .person-node,
    #ftApp #treeRoot .person-node * {
        user-select: none;
        -webkit-user-select: none;
        -webkit-user-drag: none;
    }
    #ftApp.ft-interacting .ft-tree-scale {
        will-change: transform;
    }
    #ftApp.ft-interacting #treeRoot .person-node {
        transition: none !important;
        animation: none !important;
        box-shadow: none !important;
        background: #efe0be !important;
        background-image: none !important;
        border-color: rgba(120, 73, 42, 0.12) !important;
        transform: none !important;
        backface-visibility: visible !important;
    }
    #ftApp.ft-interacting #treeRoot .person-node::before,
    #ftApp.ft-interacting #treeRoot .person-node::after,
    #ftApp.ft-interacting #treeRoot .box-person.has-spouse::before {
        display: none !important;
    }
    #ftApp.ft-interacting #treeRoot .person-node *,
    #ftApp.ft-interacting #treeRoot .tree-action-menu,
    #ftApp.ft-interacting #treeRoot .tree-action-menu * {
        transition: none !important;
        animation: none !important;
        text-rendering: auto !important;
    }
    #ftApp.ft-pan-active #treeRoot {
        pointer-events: none;
    }
    #ftApp.ft-pan-active #treeRoot .person-node {
        transition: none !important;
        animation: none !important;
        box-shadow: none !important;
        background: #efe0be !important;
        background-image: none !important;
        border-color: rgba(120, 73, 42, 0.12) !important;
        transform: none !important;
        backface-visibility: visible !important;
    }
    #ftApp.ft-pan-active #treeRoot .person-node::before,
    #ftApp.ft-pan-active #treeRoot .person-node::after,
    #ftApp.ft-pan-active #treeRoot .box-person.has-spouse::before {
        display: none !important;
    }
    #ftApp.ft-pan-active #treeRoot .person-node *,
    #ftApp.ft-pan-active #treeRoot .tree-action-menu,
    #ftApp.ft-pan-active #treeRoot .tree-action-menu * {
        transition: none !important;
        animation: none !important;
        text-rendering: auto !important;
    }
    #ftApp.ft-low-zoom #treeRoot .person-node {
        box-shadow: 0 2px 8px rgba(73, 37, 18, 0.05) !important;
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)) !important;
    }
    #ftApp.ft-low-zoom #treeRoot .person-node::before,
    #ftApp.ft-low-zoom #treeRoot .person-node::after,
    #ftApp.ft-low-zoom #treeRoot .box-person.has-spouse::before {
        display: none !important;
    }
    #ftApp.ft-low-zoom #treeRoot .avatar-tree {
        box-shadow: none !important;
        border-width: 1px;
    }
    #ftApp.ft-low-zoom #treeRoot .person-node.person-role-notable {
        box-shadow: 0 2px 8px rgba(73, 37, 18, 0.05) !important;
    }
    #ftApp.ft-low-zoom #treeRoot .person-node.person-role-deceased .avatar-tree {
        filter: none;
    }
    #ftApp.ft-low-zoom #treeRoot .li-person::before,
    #ftApp.ft-low-zoom #treeRoot .li-person::after,
    #ftApp.ft-low-zoom #treeRoot .ul-person .ul-person::before,
    #ftApp.ft-low-zoom #treeRoot .li-person:last-child::before {
        border-width: 3px !important;
    }
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .avatar-tree,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .ft-node-headline,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .person-dates,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .ft-node-status,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .btn-setting-custom,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .tree-action-menu,
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .ft-root-ornament {
        visibility: hidden !important;
    }
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .person-text {
        margin-top: 0 !important;
        padding: 0 2px;
    }
    #ftApp.ft-interacting.ft-low-zoom #treeRoot .name-phado {
        font-size: 16px !important;
        line-height: 1.12 !important;
        text-shadow: none !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node,
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.male,
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.female,
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.other {
        background: #f2e5c8 !important;
        background-image: none !important;
        box-shadow: none !important;
        border-color: rgba(120, 73, 42, 0.16) !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.person-role-founder {
        background: #ead29d !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node:hover {
        transform: none !important;
        box-shadow: none !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node,
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node *,
    #ftApp.ft-ultra-low-zoom #treeRoot .tree-action-menu,
    #ftApp.ft-ultra-low-zoom #treeRoot .tree-action-menu * {
        transition: none !important;
        animation: none !important;
        text-rendering: auto !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.person-role-notable {
        box-shadow: none !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node {
        transform: none !important;
        backface-visibility: visible !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .avatar-tree,
    #ftApp.ft-ultra-low-zoom #treeRoot .person-node.person-role-deceased .avatar-tree {
        box-shadow: none !important;
        border-width: 1px;
        filter: none;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .li-person::before,
    #ftApp.ft-ultra-low-zoom #treeRoot .li-person::after,
    #ftApp.ft-ultra-low-zoom #treeRoot .ul-person .ul-person::before,
    #ftApp.ft-ultra-low-zoom #treeRoot .li-person:last-child::before {
        border-width: 2px !important;
    }
    #ftApp.ft-ultra-low-zoom #treeRoot .ft-root-ornament {
        display: none !important;
    }
    #ftApp.ft-ultra-low-zoom .ft-tree-scale {
        transform-style: flat;
    }
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .avatar-tree,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .ft-node-headline,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-dates,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .ft-node-status,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .btn-setting-custom,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .tree-action-menu,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .ft-root-ornament {
        visibility: hidden !important;
    }
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-text {
        margin-top: 0 !important;
        padding: 0 2px;
    }
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .name-phado {
        font-size: 16px !important;
        line-height: 1.12 !important;
        text-shadow: none !important;
    }
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-node,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-node.male,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-node.female,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-node.other,
    #ftApp.ft-pan-active.ft-ultra-low-zoom #treeRoot .person-node.person-role-founder {
        background: #efe0be !important;
        background-image: none !important;
        box-shadow: none !important;
        border-color: rgba(120, 73, 42, 0.12) !important;
    }
    #ftApp #treeRoot .ft-node-headline {
        position: relative;
        display: block;
        min-height: 22px;
        padding: 0 42px 0 2px;
    }
    #ftApp #treeRoot .ft-node-meta {
        position: absolute;
        top: 0;
        right: 2px;
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 6px;
    }
    #ftApp #treeRoot .ft-node-role,
    #ftApp #treeRoot .ft-node-gender,
    #ftApp #treeRoot .ft-node-generation,
    #ftApp #treeRoot .ft-node-status {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 18px;
        padding: 1px 6px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    #ftApp #treeRoot .ft-node-role {
        position: absolute;
        top: 0;
        left: 0;
        max-width: calc(100% - 46px);
        background: rgba(140, 36, 31, 0.08);
        color: #7b221f;
        border: 1px solid rgba(140, 36, 31, 0.12);
        white-space: nowrap;
    }
    #ftApp #treeRoot .ft-node-gender {
        background: rgba(181, 140, 82, 0.14);
        color: #6a4b33;
        border: 1px solid rgba(181, 140, 82, 0.16);
    }
    #ftApp #treeRoot .ft-node-generation {
        background: rgba(108, 84, 62, 0.08);
        color: #5b4333;
        border: 1px solid rgba(108, 84, 62, 0.12);
        min-width: 22px;
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
    #ftApp #treeRoot .person-node > .dropdown.btn-setting-custom {
        position: absolute;
        top: 0;
        right: 0;
        left: auto;
        z-index: 5;
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
        display: none;
        position: absolute !important;
        left: calc(100% + 8px) !important;
        right: auto !important;
        top: 0 !important;
        bottom: auto !important;
        z-index: 10020 !important;
        min-width: 188px;
        border-radius: 6px;
        border: 1px solid rgba(120, 73, 42, 0.16);
        background: #f8f0df url("/web/images/paper-texture.png") !important;
        background-size: 220px !important;
        box-shadow: 0 14px 30px rgba(73, 37, 18, 0.16);
        padding: 4px 0;
        margin: 0;
    }
    #ftApp #treeRoot .tree-action-menu.show {
        display: block;
    }
    #ftApp #treeRoot .tree-action-menu li {
        list-style: none;
    }
    #ftApp #treeRoot .tree-action-menu .dropdown-item {
        padding: 9px 12px;
        font-size: 14px;
    }
    #ftApp .ft-branch-toggle-wrap {
        display: flex;
        justify-content: center;
        margin: 6px 0 2px;
        position: relative;
        z-index: 2;
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
    #ftApp .ft-tree-empty-state {
        display: none;
        align-items: center;
        justify-content: center;
        min-height: 420px;
        padding: 28px;
    }
    #ftApp .ft-tree-empty-state.is-visible {
        display: flex;
    }
    #ftApp .ft-tree-empty-card {
        width: min(620px, 100%);
        padding: 26px 28px;
        border-radius: 18px;
        border: 1px solid rgba(120, 73, 42, 0.16);
        background:
            linear-gradient(180deg, rgba(255, 249, 231, 0.98), rgba(243, 230, 198, 0.98)),
            url("/web/images/paper-texture.png");
        background-size: auto, 280px;
        box-shadow: 0 16px 34px rgba(73, 37, 18, 0.12);
        text-align: center;
    }
    #ftApp .ft-tree-empty-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 14px;
        padding: 8px 14px;
        border-radius: 999px;
        background: rgba(140, 36, 31, 0.08);
        color: #7c271d;
        font-size: 12px;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }
    #ftApp .ft-tree-empty-title {
        margin: 0 0 10px;
        color: #6a201d;
        font-family: "Noto Serif", "Palatino Linotype", Georgia, serif;
        font-size: 30px;
        line-height: 1.18;
    }
    #ftApp .ft-tree-empty-text {
        margin: 0 auto;
        max-width: 520px;
        color: #634a39;
        font-size: 15px;
        line-height: 1.65;
    }
    #ftApp .ft-tree-empty-actions {
        margin-top: 20px;
        display: flex;
        justify-content: center;
        gap: 12px;
        flex-wrap: wrap;
    }
    #ftApp .ft-tree-empty-hint {
        margin-top: 14px;
        color: #7c614c;
        font-size: 13px;
        line-height: 1.6;
    }
    #ftApp .ft-canvas.is-empty #contentArea,
    #ftApp .ft-canvas.is-empty #legend {
        display: none;
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
        #ftApp .container-fluid {
            padding-left: 8px !important;
            padding-right: 8px !important;
        }
        #ftApp .ft-filter-grid {
            grid-template-columns: 1fr;
        }
        #ftApp .ft-filter-field-search {
            grid-column: auto;
        }
        #ftApp .ft-page-banner,
        #ftApp .ft-filter-strip {
            padding: 10px;
        }
        #ftApp .ft-page-banner-title {
            font-size: 22px;
        }
        #ftApp .ft-page-banner-text,
        #ftApp .ft-canvas-note {
            font-size: 13px;
        }
        #ftApp .ft-quick-strip,
        #ftApp .ft-tree-controls,
        #ftApp .ft-canvas-meta {
            width: 100%;
            gap: 8px;
        }
        #ftApp .ft-tree-controls .btn,
        #ftApp .ft-canvas-meta .ft-meta-chip {
            width: calc(50% - 4px);
            justify-content: center;
        }
        #ftApp .ft-canvas {
            min-height: 360px;
            height: calc(100vh - 210px) !important;
        }
        #ftApp .ft-scroll {
            padding: 12px 8px 20px !important;
        }
        #ftApp #treeRoot .box-person {
            --node-width: 138px;
            --spouse-gap: 8px;
            min-height: 172px;
            padding-right: calc(var(--node-width) + var(--spouse-gap));
        }
        #ftApp #treeRoot .box-person.no-spouse {
            min-height: 0;
        }
        #ftApp #treeRoot .person-node {
            min-height: 164px;
            padding: 8px 8px 10px !important;
        }
        #ftApp #treeRoot .avatar-tree {
            width: 70px !important;
            height: 64px !important;
            margin-top: 10px !important;
        }
        #ftApp #treeRoot .name-phado {
            font-size: 14px !important;
            line-height: 1.25 !important;
        }
        #ftApp #treeRoot .person-dates {
            font-size: 11px !important;
            line-height: 1.35 !important;
        }
        #ftApp #treeRoot .ft-node-status,
        #ftApp #treeRoot .ft-node-role,
        #ftApp #treeRoot .tree-branch-chip {
            font-size: 10px !important;
        }
        #ftApp #treeRoot .person-text {
            margin-top: 10px !important;
            gap: 4px !important;
        }
        #ftApp #treeRoot .li-person {
            padding-left: 4px !important;
            padding-right: 4px !important;
        }
        #ftApp #treeRoot .ul-person.ft-forest-roots,
        #ftApp #treeRoot .ul-person {
            padding-top: 18px !important;
        }
        #ftApp #detailMemberModal .modal-dialog {
            width: calc(100vw - 16px);
            max-width: calc(100vw - 16px) !important;
            margin: 8px auto !important;
            padding: 0 !important;
            min-height: auto !important;
        }
        #ftApp #detailMemberModal .modal-content {
            min-height: auto !important;
            max-height: calc(100vh - 16px) !important;
            border-radius: 14px !important;
        }
        #ftApp #detailMemberModal .modal-header,
        #ftApp #detailMemberModal .modal-body,
        #ftApp #detailMemberModal .modal-footer {
            padding-left: 12px;
            padding-right: 12px;
        }
        #ftApp #detailMemberModal .modal-body {
            padding-top: 12px;
            padding-bottom: 12px;
        }
        #ftApp #detailMemberModal .modal-footer {
            gap: 8px;
            justify-content: stretch;
        }
        #ftApp #detailMemberModal .modal-footer .btn {
            flex: 1 1 calc(50% - 4px);
            min-width: 0;
        }
        #ftApp .ft-detail-hero {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
            padding: 12px;
        }
        #ftApp .ft-detail-avatar {
            width: 74px;
            height: 74px;
        }
        #ftApp .ft-detail-name {
            font-size: 22px;
            line-height: 1.25;
        }
        #ftApp .ft-detail-subline,
        #ftApp .ft-detail-empty,
        #ftApp #detailMemberBody .form-label + div {
            font-size: 14px;
            line-height: 1.45;
        }
        #ftApp .ft-detail-pill {
            min-height: 28px;
            padding: 5px 10px;
            font-size: 12px;
            margin: 2px 4px 2px 0;
        }
        #ftApp .ft-detail-media-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 8px;
        }
    }
    @media (max-width: 575px) {
        #ftApp .ft-tree-controls .btn,
        #ftApp .ft-canvas-meta .ft-meta-chip {
            width: 100%;
        }
        #ftApp .ft-canvas {
            min-height: 320px;
            height: calc(100vh - 230px) !important;
        }
        #ftApp #treeRoot .box-person {
            --node-width: 126px;
            --spouse-gap: 6px;
            min-height: 156px;
        }
        #ftApp #treeRoot .person-node {
            min-height: 150px;
            padding: 7px 7px 9px !important;
        }
        #ftApp #treeRoot .avatar-tree {
            width: 62px !important;
            height: 58px !important;
        }
        #ftApp #treeRoot .name-phado {
            font-size: 13px !important;
        }
        #ftApp #treeRoot .person-dates {
            font-size: 10px !important;
        }
        #ftApp #detailMemberModal .modal-footer .btn {
            flex: 1 1 100%;
        }
    }
    #ftApp .ft-tree-controls .btn.is-busy {
        opacity: 0.72;
        pointer-events: none;
    }
    #ftApp .ft-export-button {
        min-width: 112px;
    }
    #ftApp .ft-export-dropdown {
        position: relative;
    }
    #ftApp .ft-export-toggle {
        min-width: 156px;
        justify-content: space-between;
        gap: 10px;
    }
    #ftApp .ft-export-toggle::after {
        display: none;
    }
    #ftApp .ft-export-toggle .fa-caret-down {
        font-size: 14px;
        opacity: 0.75;
    }
    #ftApp .ft-export-dropdown .dropdown-menu {
        min-width: 100%;
        margin-top: 8px;
        padding: 8px;
    }
    #ftApp .ft-export-dropdown .dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        width: 100%;
        min-height: 42px;
        border: 0;
        background: transparent;
        text-align: left;
        font-size: 14px;
    }
    #ftApp .ft-export-dropdown .dropdown-item i {
        width: 18px;
        text-align: center;
        flex: 0 0 18px;
    }
    #ftApp .ft-export-dropdown .dropdown-item:disabled {
        opacity: 0.6;
        cursor: default;
    }
    #ftApp .ft-export-host {
        position: absolute;
        left: -100000px;
        top: 0;
        width: auto;
        height: auto;
        overflow: visible;
        pointer-events: none;
        z-index: 0;
    }
    #ftApp .ft-export-host,
    #ftApp .ft-export-host * {
        animation: none !important;
        transition: none !important;
    }
    #ftApp .ft-export-host .ft-canvas-shell {
        width: max-content !important;
        max-width: none !important;
        overflow: visible !important;
        border-width: 3px !important;
        border-color: rgba(140, 36, 31, 0.72) !important;
        box-shadow: inset 0 0 0 1px rgba(247, 224, 214, 0.98) !important;
    }
    #ftApp .ft-export-host .ft-canvas {
        height: auto !important;
        min-height: 0 !important;
        overflow: visible !important;
        box-shadow: none !important;
    }
    #ftApp .ft-export-host .ft-scroll {
        overflow: visible !important;
        width: auto !important;
        min-width: 0 !important;
        height: auto !important;
        padding: 0 !important;
    }
    #ftApp .ft-export-host .ft-tree-scale {
        transform: none !important;
        width: auto !important;
        min-width: 0 !important;
        will-change: auto !important;
    }
    #ftApp .ft-export-host #treeRoot {
        --connector-height: 44px !important;
    }
    #ftApp .ft-export-host #treeRoot .li-person > .ul-person {
        margin-top: 0 !important;
    }
    #ftApp .ft-export-host #treeRoot .box-person {
        min-height: 0 !important;
        margin-bottom: 0 !important;
    }
    #ftApp .ft-export-host #treeRoot .box-person.no-spouse,
    #ftApp .ft-export-host #treeRoot .box-person.has-spouse {
        min-height: 0 !important;
    }
    #ftApp .ft-export-host .ft-branch-subtree,
    #ftApp .ft-export-host .ft-branch-subtree.is-collapsed {
        max-height: none !important;
        opacity: 1 !important;
        overflow: visible !important;
        pointer-events: none !important;
    }
    #ftApp .ft-export-host .ft-export-scene {
        display: inline-block;
        padding: 176px 64px 72px;
        min-width: max-content;
        min-height: max-content;
    }
    #ftApp .ft-export-host .ft-export-root {
        display: inline-block;
        min-width: max-content;
    }
    #ftApp .ft-export-host .ft-canvas {
        background: #f8f0df !important;
        background-image: none !important;
        box-shadow: none !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node,
    #ftApp .ft-export-host #treeRoot .person-node.male,
    #ftApp .ft-export-host #treeRoot .person-node.female,
    #ftApp .ft-export-host #treeRoot .person-node.other {
        border-width: 3px !important;
        border-color: rgba(140, 36, 31, 0.82) !important;
        background: linear-gradient(180deg, rgba(255, 249, 231, 1), rgba(243, 230, 198, 1)) !important;
        background-image: none !important;
        box-shadow:
            inset 0 0 0 1px rgba(255, 247, 226, 0.98),
            inset 0 0 0 7px rgba(140, 36, 31, 0.1) !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node.person-role-founder {
        border-color: rgba(140, 36, 31, 0.72) !important;
        background: linear-gradient(180deg, rgba(255, 245, 213, 1), rgba(238, 214, 162, 1)) !important;
        background-image: none !important;
    }
    #ftApp .ft-export-host .ft-branch-toggle-wrap,
    #ftApp .ft-export-host .tree-action-menu,
    #ftApp .ft-export-host .tree-menu-toggle,
    #ftApp .ft-export-host .btn-setting-custom,
    #ftApp .ft-export-host .ft-tree-menu-layer,
    #ftApp .ft-export-host #legend,
    #ftApp .ft-export-host #treeEmptyState {
        display: none !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node,
    #ftApp .ft-export-host #treeRoot .person-node:hover {
        transform: none !important;
        transition: none !important;
        backface-visibility: visible !important;
        transform-style: flat !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node::before,
    #ftApp .ft-export-host #treeRoot .person-node::after,
    #ftApp .ft-export-host #treeRoot .box-person.has-spouse::before,
    #ftApp .ft-export-host #treeRoot .box-person.has-spouse::after {
        box-shadow: none !important;
        filter: none !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node::before {
        content: none !important;
        display: none !important;
    }
    #ftApp .ft-export-host #treeRoot .person-node::after {
        content: none !important;
        display: none !important;
    }
    #ftApp .ft-export-host #treeRoot .avatar-tree,
    #ftApp .ft-export-host #treeRoot .person-role-deceased .avatar-tree,
    #ftApp .ft-export-host #treeRoot .ft-root-ornament img {
        background: #efe3c3 !important;
        filter: none !important;
        box-shadow: none !important;
    }
    #ftApp .ft-export-host #treeRoot .avatar-tree,
    #ftApp .ft-export-host #treeRoot .person-role-deceased .avatar-tree {
        border-width: 3px !important;
        border-color: rgba(140, 36, 31, 0.82) !important;
        box-shadow: 0 0 0 1px rgba(255, 247, 226, 1) !important;
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
                    <div id="ftExportDropdown" class="dropdown ft-export-dropdown">
                        <button id="ftExportToggle" type="button" class="btn btn-sm btn-light dropdown-toggle ft-export-toggle">
                            <span><i class="fa fa-download"></i> Xuất dữ liệu</span>
                            <i class="fa fa-caret-down"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <li><button id="ftExportPng" type="button" class="dropdown-item"><i class="fa fa-image"></i> Xuất PNG</button></li>
                            <li><button id="ftExportPdf" type="button" class="dropdown-item"><i class="fa fa-file-pdf-o"></i> Xuất PDF</button></li>
                            <li><button id="ftExportSvg" type="button" class="dropdown-item"><i class="fa fa-code"></i> Xuất SVG</button></li>
                        </ul>
                    </div>
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
                <div id="treeEmptyState" class="ft-tree-empty-state" aria-live="polite">
                    <div class="ft-tree-empty-card">
                        <div class="ft-tree-empty-badge">
                            <i class="fa fa-seedling"></i>
                            Cây mới chưa khởi tạo
                        </div>
                        <h3 class="ft-tree-empty-title">Cần thêm thành viên đầu tiên để bắt đầu cây gia phả</h3>
                        <p class="ft-tree-empty-text">
                            Cây gia phả này hiện chưa có thành viên gốc nên hệ thống chưa thể hiển thị sơ đồ huyết thống.
                            Hãy thêm thành viên đầu tiên để tạo gốc cây, sau đó mới tiếp tục thêm vợ/chồng, con và các nhánh khác.
                        </p>
                        <div class="ft-tree-empty-actions">
                            <% if (canManageMember) { %>
                                <button id="treeEmptyCreateFirstBtn" type="button" class="btn btn-dark">
                                    <i class="fa fa-user-plus"></i>
                                    Thêm thành viên đầu tiên
                                </button>
                            <% } else { %>
                                <a href="${homeUrl}" class="btn btn-light">Quay lại trang chủ</a>
                            <% } %>
                        </div>
                        <div class="ft-tree-empty-hint">
                            <% if (canManageMember) { %>
                                Sau khi lưu thành viên đầu tiên, sơ đồ gia phả của cây này sẽ được mở đầy đủ.
                            <% } else { %>
                                Bạn không có quyền thêm thành viên. Hãy liên hệ quản trị viên hoặc người biên tập của cây gia phả này.
                            <% } %>
                        </div>
                    </div>
                </div>

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
                            <input type="text" id="mDod" class="form-control" placeholder="dd/MM hoặc dd/MM/yyyy" />
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
                            <input type="text" id="aDod" class="form-control" placeholder="dd/MM hoặc dd/MM/yyyy" />
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

<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
    <script>
        // Nếu muốn truyền branchId từ server side:
        // const BRANCH_ID = "<%= request.getAttribute("branchId") %>";
        let BRANCH_ID = 0;
        const CURRENT_FAMILY_TREE_ID = Number('${empty currentFamilyTreeId ? 0 : currentFamilyTreeId}');
        const SHOULD_AUTO_OPEN_CREATE_FIRST = new URLSearchParams(window.location.search).get('openCreateFirst') === '1';
        const HOME_TOTAL_MEMBERS = Number('${empty totalMembers ? 0 : totalMembers}');
        const SHOULD_ENFORCE_FIRST_MEMBER = HOME_TOTAL_MEMBERS === 0;
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

        (function () {
            const dd = document.getElementById('ftExportDropdown');
            if (!dd) return;
            const btn = dd.querySelector('.dropdown-toggle');
            const menu = dd.querySelector('.dropdown-menu');
            if (!btn || !menu) return;

            btn.addEventListener('click', function (e) {
                if (btn.disabled) return;
                e.stopPropagation();
                menu.classList.toggle('show');
                btn.setAttribute('aria-expanded', menu.classList.contains('show') ? 'true' : 'false');
            });

            menu.addEventListener('click', function (e) {
                e.stopPropagation();
                const actionButton = e.target.closest('button');
                if (!actionButton || actionButton.disabled) return;
                menu.classList.remove('show');
                btn.setAttribute('aria-expanded', 'false');
            });

            document.addEventListener('click', function () {
                menu.classList.remove('show');
                btn.setAttribute('aria-expanded', 'false');
            });

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    menu.classList.remove('show');
                    btn.setAttribute('aria-expanded', 'false');
                }
            });
        })();

        function collapseLegacyFilterFields() {
            ['branchDropdown', 'ftFilterGender', 'ftFilterLifeStatus', 'ftFilterBirthYear', 'ftFilterDeathYear'].forEach(function (id) {
                const input = document.getElementById(id);
                const field = input && input.closest('.ft-filter-field');
                if (field) {
                    field.style.display = 'none';
                }
            });
        }

        function configureVisibleFilters() {
            const currentYear = new Date().getFullYear();
            const nameLabel = document.querySelector('label[for="ftFilterName"]');
            const nameInput = document.getElementById('ftFilterName');
            const birthYearLabel = document.querySelector('label[for="ftFilterDob"]');
            const birthYearInput = document.getElementById('ftFilterDob');

            if (nameLabel) {
                nameLabel.textContent = 'Tìm theo tên';
            }
            if (nameInput) {
                nameInput.placeholder = 'Nhập tên, không cần đầy đủ...';
                nameInput.setAttribute('autocomplete', 'off');
            }
            if (birthYearLabel) {
                birthYearLabel.textContent = 'Năm sinh';
            }
            if (birthYearInput) {
                birthYearInput.type = 'number';
                birthYearInput.min = '1';
                birthYearInput.max = String(currentYear);
                birthYearInput.step = '1';
                birthYearInput.inputMode = 'numeric';
                birthYearInput.placeholder = 'Ví dụ 1942';
                birthYearInput.setAttribute('aria-label', 'Lọc theo năm sinh');
            }
        }

        function resetSecondaryFiltersForNameSearch() {
            const generationInput = document.getElementById('ftFilterGeneration');
            const dobInput = document.getElementById('ftFilterDob');
            const genderInput = document.getElementById('ftFilterGender');
            const lifeStatusInput = document.getElementById('ftFilterLifeStatus');
            const birthYearInput = document.getElementById('ftFilterBirthYear');
            const deathYearInput = document.getElementById('ftFilterDeathYear');

            if (generationInput) generationInput.value = '';
            if (dobInput) dobInput.value = '';
            if (genderInput) genderInput.value = '';
            if (lifeStatusInput) lifeStatusInput.value = '';
            if (birthYearInput) birthYearInput.value = '';
            if (deathYearInput) deathYearInput.value = '';

            CURRENT_DOB_FILTER = '';
            CURRENT_GENERATION_FILTER = null;
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;
            CURRENT_DEATH_YEAR = null;
        }

        function restoreDefaultBranchSelection() {
            BRANCH_ID = 0;
            ACTIVE_BRANCH_NAME = 'Toàn bộ';
            const activeBranchLabel = document.getElementById('activeBranchLabel');
            if (activeBranchLabel) {
                activeBranchLabel.textContent = 'Toàn bộ';
            }
            document.getElementById('branchMenu')?.classList.remove('show');

            const formBranchId = getDefaultFormBranchId(BRANCH_CACHE);
            const normalizedFormBranchId = formBranchId > 0 ? String(formBranchId) : '';
            const mBranch = document.getElementById('mBranch');
            const aBranch = document.getElementById('aBranch');
            if (mBranch) mBranch.value = normalizedFormBranchId;
            if (aBranch) aBranch.value = normalizedFormBranchId;
        }

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
        let FT_EXPORT_IN_PROGRESS = false;
        const FT_EXPORT_MAX_CANVAS_DIMENSION = 12288;
        const FT_EXPORT_MAX_CANVAS_AREA = 50331648;
        const FT_EXPORT_PNG_TARGET_SCALE = 3.2;
        const FT_EXPORT_PNG_MAX_SCALE = 4;
        const FT_EXPORT_PDF_TARGET_SCALE = 2.4;
        const FT_EXPORT_PDF_MAX_SCALE = 3.2;
        let ACTIVE_BRANCH_NAME = '';
        let FT_RENDER_PENDING = false;
        let FT_FILTER_RENDER_SEQ = 0;
        let FT_FILTER_DEBOUNCE = null;
        const COLLAPSED_NODE_IDS = new Set();
        const SERVER_TOTAL_GENERATIONS = Number('${empty totalGenerations ? 1 : totalGenerations}');
        const PERSON_DETAIL_CACHE = {};
        const FT_VIEWPORT = {
            initialized: false,
            scale: 1,
            panX: 0,
            panY: 0,
            skipPanClampOnce: false
        };
        const FT_TREE_METRICS = {
            width: 0,
            height: 0,
            dirty: true
        };
        const EXISTING_PERSON_CACHE = {
            m: [],
            a: []
        };
        let HAS_AUTO_OPENED_CREATE_FIRST = false;

        function invalidateTreeMetrics() {
            FT_TREE_METRICS.dirty = true;
        }

        function measureTreeMetrics(force) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) {
                FT_TREE_METRICS.width = 0;
                FT_TREE_METRICS.height = 0;
                FT_TREE_METRICS.dirty = false;
                return FT_TREE_METRICS;
            }
            if (!force && FT_TREE_METRICS.dirty !== true) {
                return FT_TREE_METRICS;
            }
            FT_TREE_METRICS.width = Math.max(
                treeRoot.scrollWidth || 0,
                treeRoot.offsetWidth || 0,
                treeRoot.clientWidth || 0
            );
            FT_TREE_METRICS.height = Math.max(
                treeRoot.scrollHeight || 0,
                treeRoot.offsetHeight || 0,
                treeRoot.clientHeight || 0
            );
            FT_TREE_METRICS.dirty = false;
            return FT_TREE_METRICS;
        }

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

        function appendFamilyTreeId(url) {
            const normalizedTreeId = Number(CURRENT_FAMILY_TREE_ID || 0);
            if (!Number.isFinite(normalizedTreeId) || normalizedTreeId <= 0) {
                return url;
            }
            if (/[?&]familyTreeId=/.test(url)) {
                return url;
            }
            return url + (url.indexOf('?') >= 0 ? '&' : '?') + 'familyTreeId=' + encodeURIComponent(normalizedTreeId);
        }

        function withFamilyTreePayload(payload) {
            const normalizedTreeId = Number(CURRENT_FAMILY_TREE_ID || 0);
            if (!Number.isFinite(normalizedTreeId) || normalizedTreeId <= 0) {
                return Object.assign({}, payload || {});
            }
            return Object.assign({}, payload || {}, { familyTreeId: normalizedTreeId });
        }

        function maybeOpenCreateFirstModal() {
            if ((!SHOULD_AUTO_OPEN_CREATE_FIRST && !SHOULD_ENFORCE_FIRST_MEMBER) || HAS_AUTO_OPENED_CREATE_FIRST || !canManageMember) {
                return;
            }
            const actionBtn = document.getElementById('treeEmptyCreateFirstBtn') || document.getElementById('btnCreateFirst');
            if (!actionBtn) {
                return;
            }
            HAS_AUTO_OPENED_CREATE_FIRST = true;
            history.replaceState({}, document.title, window.location.pathname + '?familyTreeId=' + encodeURIComponent(CURRENT_FAMILY_TREE_ID));
            requestAnimationFrame(function () {
                actionBtn.click();
            });
        }

        function setTreeEmptyStateVisible(visible) {
            const emptyState = document.getElementById('treeEmptyState');
            const canvas = document.querySelector('#ftApp .ft-canvas');
            if (emptyState) {
                emptyState.classList.toggle('is-visible', !!visible);
            }
            if (canvas) {
                canvas.classList.toggle('is-empty', !!visible);
            }
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
                const res = await fetch(appendFamilyTreeId('/api/branch'));
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
                Object.keys(PERSON_DETAIL_CACHE).forEach(function (key) {
                    delete PERSON_DETAIL_CACHE[key];
                });
                return;
            }
            delete ROOT_PERSON_CACHE[getRootCacheKey(branchId)];
            Object.keys(PERSON_DETAIL_CACHE).forEach(function (key) {
                delete PERSON_DETAIL_CACHE[key];
            });
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
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^a-z0-9]+/g, ' ')
                .replace(/\s+/g, ' ')
                .trim();
        }

        function normalizeCompactSearchText(value) {
            return normalizeSearchText(value).replace(/\s+/g, '');
        }

        function nameTokenMatches(queryToken, nameToken) {
            const query = String(queryToken || '').trim();
            const token = String(nameToken || '').trim();
            if (!query || !token) return false;
            if (query === token) return true;
            if (query.length <= 1) return false;
            return token.indexOf(query) === 0;
        }

        function queryTokensMatchNameTokens(queryTokens, nameTokens) {
            const sourceTokens = Array.isArray(queryTokens) ? queryTokens.filter(Boolean) : [];
            const targetTokens = Array.isArray(nameTokens) ? nameTokens.filter(Boolean) : [];
            if (!sourceTokens.length) return true;
            if (!targetTokens.length) return false;

            const usedIndexes = new Set();
            return sourceTokens.every(function (queryToken) {
                for (let index = 0; index < targetTokens.length; index += 1) {
                    if (usedIndexes.has(index)) continue;
                    if (nameTokenMatches(queryToken, targetTokens[index])) {
                        usedIndexes.add(index);
                        return true;
                    }
                }
                return false;
            });
        }

        function fuzzyNameMatches(fullName, query) {
            const normalizedQuery = normalizeSearchText(query);
            if (!normalizedQuery) return true;

            const normalizedName = normalizeSearchText(fullName);
            if (!normalizedName) return false;
            if (normalizedName.indexOf(normalizedQuery) >= 0) return true;

            const compactName = normalizeCompactSearchText(normalizedName);
            const compactQuery = normalizeCompactSearchText(normalizedQuery);
            if (compactQuery && compactQuery.length >= 6 && compactName.indexOf(compactQuery) >= 0) return true;

            const queryTokens = normalizedQuery.split(' ').filter(Boolean);
            const nameTokens = normalizedName.split(' ').filter(Boolean);
            if (!queryTokens.length) return true;

            if (queryTokens.length === 1) {
                const singleToken = queryTokens[0];
                return nameTokens.some(function (nameToken) {
                    return nameTokenMatches(singleToken, nameToken);
                });
            }

            return queryTokensMatchNameTokens(queryTokens, nameTokens);
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
            const raw = String(dateStr || '').trim();
            if (!raw) return null;
            const match = raw.match(/\d{4}/);
            if (!match) return null;
            const year = Number(match[0]);
            return Number.isFinite(year) && year > 0 ? year : null;
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
                dod: getDeathDisplay(person)
            });
            getPersonSpouses(person).forEach(function (spouse) {
                candidates.push({
                    fullName: spouse.fullName || '',
                    dob: spouse.dob || '',
                    gender: spouse.gender || '',
                    dod: getDeathDisplay(spouse)
                });
            });

            const normalizedNameFilter = normalizeSearchText(CURRENT_NAME_FILTER).trim();
            if (normalizedNameFilter) {
                const nameMatched = candidates.some(function (c) {
                    return fuzzyNameMatches(c.fullName, normalizedNameFilter);
                });
                if (!nameMatched) return false;
            }

            if (CURRENT_DOB_FILTER != null) {
                const dobMatched = candidates.some(function (c) {
                    return getBirthYearFromDateString(c.dob || '') === CURRENT_DOB_FILTER;
                });
                if (!dobMatched) {
                    return false;
                }
            }

            return true;
        }

        function hasAdvancedFilter() {
            return !!(CURRENT_NAME_FILTER
                || CURRENT_DOB_FILTER
                || CURRENT_GENERATION_FILTER != null);
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
            restoreDefaultBranchSelection();
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
                let url = appendFamilyTreeId('/api/person/available?branchId=' + encodeURIComponent(branchId));
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
            const emptyBtn = document.getElementById('treeEmptyCreateFirstBtn');
            if (!btn && !emptyBtn) return;
            // Default hidden; will be toggled after loading root person state.
            if (btn) {
                btn.style.setProperty('display', 'none', 'important');
            }

            window.ftSetCreateFirstVisible = function (visible) {
                if (btn) {
                    btn.style.setProperty('display', visible ? 'inline-flex' : 'none', 'important');
                }
                setTreeEmptyStateVisible(visible);
            };

            window.ftRefreshCreateFirstVisibility = async function (fallbackVisible, knownRoots) {
                try {
                    if (Array.isArray(knownRoots)) {
                        const hasKnownRoot = knownRoots.some(function (item) { return item && item.id; });
                        window.ftSetCreateFirstVisible(!hasKnownRoot);
                        return;
                    }
                    const rootRes = await fetch(appendFamilyTreeId('/api/person/roots?branchId=' + encodeURIComponent(getTreeBranchQueryId())));
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

            const openCreateFirstModal = function () {
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
                const defaultBranchId = getDefaultFormBranchId();
                setVal('mGeneration', '1');
                setVal('mBranch', defaultBranchId > 0 ? String(defaultBranchId) : '');
                setVal('mBranchName', 'Tự động: Chi chính của cây gia phả');
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

                refreshExistingPersonCache('m', defaultBranchId);
            };

            if (btn) {
                btn.addEventListener('click', openCreateFirstModal);
            }
            if (emptyBtn) {
                emptyBtn.addEventListener('click', openCreateFirstModal);
            }
        })();

        // Lưu thành viên đầu tiên
        document.getElementById("btnSaveMember").addEventListener("click", async (e) => {
            e.preventDefault();
            const sourceMode = getSourceMode('mSourceMode', 'new');
            const selectedExistingId = document.getElementById('mExistingPerson').value;
            const fullName = document.getElementById("mFullname").value.trim();
            const dob = document.getElementById("mDob").value || null;   // "YYYY-MM-DD"
            const parsedDod = parseFlexibleDeathDateInput(document.getElementById("mDod").value);
            const generation = document.getElementById("mGeneration").value;
            const avatar = document.getElementById("mAvatar").value.trim() || null;

            const genderEl = document.querySelector('input[name="mGender"]:checked');
            const gender = genderEl ? genderEl.value : null;

            if (parsedDod.error) {
                showToast(parsedDod.error, 'error');
                return;
            }

            const payload = withFamilyTreePayload({
                fullName,
                dob,          // LocalDate nhận chuỗi yyyy-MM-dd OK
                dod: parsedDod.iso,
                dodDisplay: parsedDod.display,
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
            });

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
                const res = await fetch(appendFamilyTreeId("/api/person"), {
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
            document.getElementById('aDod').value = getDeathDisplay(person);
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
            document.getElementById('aDod').value = mode === 'edit-member' ? getDeathDisplay(person) : '';
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

            const parsedDod = parseFlexibleDeathDateInput(document.getElementById('aDod').value);
            if (parsedDod.error) {
                showToast(parsedDod.error, 'error');
                return;
            }

            const payload = withFamilyTreePayload({
                fullName: fullName,
                dob: document.getElementById('aDob').value || null,
                dod: parsedDod.iso,
                dodDisplay: parsedDod.display,
                generation: Number(document.getElementById('aGeneration').value || 1),
                gender: document.getElementById('aGender').value || null,
                avatar: document.getElementById('aAvatar').value.trim() || null,
                hometown: document.getElementById('aHometown').value.trim() || null,
                currentResidence: document.getElementById('aCurrentResidence').value.trim() || null,
                occupation: document.getElementById('aOccupation').value.trim() || null,
                otherNote: document.getElementById('aOtherNote').value.trim() || null
            });
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
                    const res = await fetch(appendFamilyTreeId('/api/person/' + personId + '/spouse'), {
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
                    const res = await fetch(appendFamilyTreeId('/api/person/' + personId + '/child'), {
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
                    const res = await fetch(appendFamilyTreeId('/api/person/' + personId), {
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
            if (String(dateStr).indexOf('/') >= 0) return String(dateStr);
            const parts = dateStr.split('-');
            if (parts.length !== 3) return dateStr;
            return parts[2] + '/' + parts[1] + '/' + parts[0];
        }

        function parseFlexibleDeathDateInput(value) {
            const raw = String(value || '').trim();
            if (!raw) {
                return { iso: null, display: null, error: '' };
            }
            const isValidCalendarDate = function (day, month, year) {
                if (!day || !month || !year) return false;
                const parsed = new Date(Date.UTC(year, month - 1, day));
                return parsed.getUTCFullYear() === year
                    && (parsed.getUTCMonth() + 1) === month
                    && parsed.getUTCDate() === day;
            };
            if (/^\d{4}-\d{2}-\d{2}$/.test(raw)) {
                const parts = raw.split('-');
                const year = Number(parts[0]);
                const month = Number(parts[1]);
                const day = Number(parts[2]);
                if (!isValidCalendarDate(day, month, year)) {
                    return { iso: null, display: null, error: 'Ngay mat khong hop le' };
                }
                return { iso: raw, display: formatDate(raw), error: '' };
            }
            if (/^\d{2}\/\d{2}\/\d{4}$/.test(raw)) {
                const parts = raw.split('/');
                const day = Number(parts[0]);
                const month = Number(parts[1]);
                const year = Number(parts[2]);
                if (!isValidCalendarDate(day, month, year)) {
                    return { iso: null, display: null, error: 'Ngay mat khong hop le' };
                }
                const iso = parts[2] + '-' + parts[1] + '-' + parts[0];
                return { iso: iso, display: raw, error: '' };
            }
            if (/^\d{2}\/\d{2}$/.test(raw)) {
                const parts = raw.split('/');
                const day = Number(parts[0]);
                const month = Number(parts[1]);
                if (!isValidCalendarDate(day, month, 2000)) {
                    return { iso: null, display: null, error: 'Ngay mat khong hop le' };
                }
                return { iso: null, display: raw, error: '' };
            }
            if (/^\d{4}$/.test(raw)) {
                return { iso: null, display: raw, error: '' };
            }
            return { iso: null, display: null, error: 'Ngay mat chi nhap dang dd/MM, dd/MM/yyyy hoac yyyy' };
        }

        function getDeathDisplay(person) {
            if (!person) return '';
            return String(person.dodDisplay || formatDate(person.dod || '') || '').trim();
        }

        function hasDeathInfo(person) {
            return !!getDeathDisplay(person);
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
            const normalizedId = Number(personId || 0);
            if (normalizedId > 0 && PERSON_DETAIL_CACHE[normalizedId]) {
                return PERSON_DETAIL_CACHE[normalizedId];
            }
            const res = await fetch(appendFamilyTreeId('/api/person/' + encodeURIComponent(personId)));
            if (!res.ok) {
                throw new Error(await res.text() || 'Không tải được thông tin thành viên');
            }
            const detail = await res.json();
            if (normalizedId > 0) {
                PERSON_DETAIL_CACHE[normalizedId] = detail;
            }
            return detail;
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
            const spouseIds = new Set();
            if (person.spouseId != null && Number(person.spouseId) > 0) {
                spouseIds.add(Number(person.spouseId));
            }
            spouses.forEach(function (spouse) {
                const spouseId = Number(spouse && spouse.id || 0);
                if (spouseId > 0) {
                    spouseIds.add(spouseId);
                }
            });
            const sharedChildren = spouseIds.size > 0
                ? children.filter(function (child) {
                    const fatherId = Number(child && child.fatherId || 0);
                    const motherId = Number(child && child.motherId || 0);
                    return spouseIds.has(fatherId) || spouseIds.has(motherId);
                })
                : children;
            const detailChildrenHtml = sharedChildren.length > 0
                ? sharedChildren.map(function (child) {
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
                + '          <div class="ft-detail-subline">' + formatOptionalText(formatDate(person.dob || '')) + ' - ' + formatOptionalText(getDeathDisplay(person)) + '</div>'
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
                + '    <div class="col-12"><div class="form-label fw-semibold">Con</div><div>' + detailChildrenHtml + '</div></div>'
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
            const addSpouseLabel = getExpectedSpouseGender(person) === 'male' ? 'Thêm chồng' : 'Thêm vợ';
            const canAddChild = canAddChildInBranch(person.branchName);
            actions.innerHTML = ''
                + '<button type="button" class="btn btn-link text-secondary" data-close="detailMemberModal">Đóng</button>'
                + '<button type="button" class="btn btn-outline-secondary" id="detailEditMemberBtn"><i class="bi bi-pencil"></i> Sửa thông tin</button>'
                + (canAddChild
                    ? '<button type="button" class="btn btn-outline-secondary" id="detailAddChildBtn"><i class="bi bi-person-plus"></i> Thêm con</button>'
                    : '')
                + (canAddSpouse
                    ? '<button type="button" class="btn btn-outline-secondary" id="detailAddSpouseBtn"><i class="bi bi-heart"></i> ' + addSpouseLabel + '</button>'
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
            if (canAddSpouse) {
                document.getElementById('detailAddSpouseBtn')?.addEventListener('click', function () {
                    window.ftUi.closeModal('detailMemberModal');
                    openActionMemberModal('add-spouse', person);
                });
            }
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
                const res = await fetch(appendFamilyTreeId('/api/person/' + person.id), {
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
            if (hasDeathInfo(person)) {
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
            const dodRaw = String(getDeathDisplay(person) || '').trim();
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
            const genderBadge = gender === 'female' ? 'Nữ' : (gender === 'male' ? 'Nam' : 'Khác');
            const generationBadge = generation > 0 ? String(generation) : '?';
            const generationLabel = 'Đời ' + generationBadge;

            return '' +
                '<div class="' + cssGender + ' person-node person-role-' + roleKey + ' ' + className + '" draggable="false"' + spouseIdAttr + ' data-id="' + personId + '" data-branch-id="' + escapeHtml(branchId) + '" data-role-key="' + roleKey + '">' +
                    (showGenerationBadge ? ('<span class="rounded bg-white fw-bold generation-number">' + generation + '</span>') : '') +
                    (showManageMenu
                        ? '<div class="dropdown btn-setting-custom">' +
                            '<button class="btn btn-sm btn-dark btn-setting-custom tree-menu-toggle" type="button" data-menu-id="' + menuId + '"><i class="fa fa-ellipsis-h"></i></button>' +
                            '<ul class="dropdown-menu fs-13 transform-none tree-action-menu" id="' + menuId + '">' + buildTreeMenu(person, { isSpouse: isSpouse, isRoot: isRoot }) + '</ul>' +
                          '</div>'
                        : '') +
                    '<div class="ft-node-headline">' +
                        '<span class="ft-node-role">' + escapeHtml(generationLabel) + '</span>' +
                        '<span class="ft-node-meta">' +
                            '<span class="ft-node-gender">' + escapeHtml(genderBadge) + '</span>' +
                        '</span>' +
                    '</div>' +
                    '<img src="' + escapeHtml(avatar) + '" class="rounded mb-2 mt-3 avatar-tree" alt="' + escapeHtml(fullName) + '" draggable="false" onerror="this.src=\'' + fallbackAvatar + '\'">' +
                    '<div class="person-text">' +
                        '<div data-id="' + personId + '" class="name-phado">' + escapeHtml(fullName) + '</div>' +
                        datesHtml +
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
            const forceExpanded = options.forceExpanded === true;
            const showToggle = options.showToggle !== false;
            const children = Array.isArray(person.children) ? person.children : [];
            const personId = Number(person && person.id || 0);
            const isCollapsed = !forceExpanded && personId > 0 && COLLAPSED_NODE_IDS.has(personId);
            const rootOrnamentHtml = options.isRoot
                ? '<div class="ft-root-ornament">'
                    + '<img src="<c:url value="/admin/assets/images/dragon-left.png"/>" alt="" aria-hidden="true">'
                    + '<img src="<c:url value="/admin/assets/images/dragon-right.png"/>" alt="" aria-hidden="true">'
                  + '</div>'
                : '';
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
                            maxDepth: maxDepth,
                            forceExpanded: forceExpanded,
                            showToggle: showToggle
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
                    '<div class="ft-branch-head' + (overflowHtml ? ' ft-depth-cap-row' : '') + '">' +
                        '<div class="box-person ' + (hasAnySpouse(person) ? 'has-spouse' : 'no-spouse') + (options.isRoot ? ' ft-root-box' : '') + '">' +
                            rootOrnamentHtml +
                            buildMemberPairHtml(person, {
                                isRoot: !!options.isRoot
                            }) +
                        '</div>' +
                    '</div>' +
                    (children.length > 0 && showToggle
                        ? '<div class="ft-branch-toggle-wrap"><button type="button" class="ft-branch-toggle" data-tree-toggle-id="' + personId + '" aria-expanded="' + (!isCollapsed) + '">' + (isCollapsed ? 'Mở nhánh con' : 'Thu gọn nhánh') + '</button></div>'
                        : '') +
                    branchSubtreeHtml +
                '</li>';
        }

        function renderForest(roots, opts) {
            if (!Array.isArray(roots) || roots.length === 0) return '';
            const options = opts || {};
            return '<ul class="ul-person ft-forest-roots">' + roots.map(function (root) {
                return renderTreeNode(root, {
                    isRoot: true,
                    depth: 1,
                    maxDepth: getTreeHeightLimitForRoot(root),
                    forceExpanded: options.forceExpanded === true,
                    showToggle: options.showToggle !== false
                });
            }).join('') + '</ul>';
        }

        function renderForestForExport(roots) {
            return renderForest(roots, {
                forceExpanded: true,
                showToggle: false
            });
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

        function getOffsetBottomWithinAncestor(element, ancestor) {
            if (!element || !ancestor) return 0;
            let current = element;
            let offsetTop = 0;

            while (current && current !== ancestor) {
                offsetTop += current.offsetTop || 0;
                current = current.offsetParent;
            }

            return offsetTop + (element.offsetHeight || 0);
        }

        function syncBranchToggleSpacingForRoot(rootElement) {
            if (!rootElement) return;

            rootElement.querySelectorAll('.li-person').forEach(function (item) {
                const head = item.querySelector('.ft-branch-head');
                const box = head ? head.querySelector('.box-person') : null;
                const toggleWrap = Array.from(item.children).find(function (child) {
                    return child && child.classList && child.classList.contains('ft-branch-toggle-wrap');
                });

                if (toggleWrap) {
                    toggleWrap.style.marginTop = '6px';
                }
                if (!box || !toggleWrap || !box.classList.contains('has-spouse')) {
                    return;
                }

                const nodes = box.querySelectorAll('.person-node');
                if (!nodes.length) {
                    return;
                }

                const boxHeight = box.offsetHeight || 0;
                const maxNodeBottom = Array.from(nodes).reduce(function (maxBottom, node) {
                    return Math.max(maxBottom, getOffsetBottomWithinAncestor(node, box));
                }, 0);
                const overflowBottom = Math.max(0, Math.ceil(maxNodeBottom - boxHeight));

                if (overflowBottom > 0) {
                    toggleWrap.style.marginTop = (6 + overflowBottom) + 'px';
                }
            });
        }

        function syncBranchToggleSpacing() {
            syncBranchToggleSpacingForRoot(document.getElementById('treeRoot'));
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
                invalidateTreeMetrics();
                window.setTimeout(function () {
                    invalidateTreeMetrics();
                    if (typeof FT_VIEWPORT.apply === 'function') {
                        FT_VIEWPORT.apply();
                    }
                }, durationMs + 30);
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
                invalidateTreeMetrics();
                if (typeof FT_VIEWPORT.apply === 'function') {
                    FT_VIEWPORT.apply();
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

            invalidateTreeMetrics();
            window.setTimeout(function () {
                invalidateTreeMetrics();
                if (typeof FT_VIEWPORT.apply === 'function') {
                    FT_VIEWPORT.apply();
                }
            }, 230);
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
            restoreDefaultBranchSelection();

            if (FT_FILTER_DEBOUNCE) {
                clearTimeout(FT_FILTER_DEBOUNCE);
                FT_FILTER_DEBOUNCE = null;
            }

            applyTreeViewMode();
            resetTreeViewport();
            clearRootPersonCache();
            await loadRootPersons({ forceReload: false, center: true, centerBranchId: BRANCH_ID });
        }

        async function fetchRootsByBranchId(branchId) {
            const res = await fetch(appendFamilyTreeId('/api/person/roots?branchId=' + encodeURIComponent(branchId)));
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
                setTreeEmptyStateVisible(true);
                if (app) app.classList.remove('ft-heavy');
                invalidateTreeMetrics();
                updateTopStats(0, 0);
                return;
            }
            setTreeEmptyStateVisible(false);

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
            invalidateTreeMetrics();
            syncBranchToggleSpacing();
            requestAnimationFrame(function () {
                syncBranchToggleSpacing();
                measureTreeMetrics(true);
            });
            if (app) {
                const nodes = treeRoot.getElementsByClassName('person-node').length;
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
                        const branchRes = await fetch(appendFamilyTreeId('/api/branch'));
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
                    invalidateTreeMetrics();
                    updateTopStats(0, 0);
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true, []);
                    }
                    maybeOpenCreateFirstModal();
                    return;
                }
                CURRENT_TREE_ROOTS = validRoots;
                invalidateTreeMetrics();
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
                invalidateTreeMetrics();
                updateTopStats(0, 0);
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(true, []);
                }
                maybeOpenCreateFirstModal();
            }
        }

        async function fetchAllRootsForExport() {
            let roots = await fetchRootsByBranchId(0);
            if ((!Array.isArray(roots) || roots.length === 0)) {
                const branchRes = await fetch(appendFamilyTreeId('/api/branch'));
                if (branchRes.ok) {
                    const branches = await branchRes.json();
                    const ids = (Array.isArray(branches) ? branches : [])
                        .map(function (branch) {
                            return Number(branch && branch.id || 0);
                        })
                        .filter(function (id) {
                            return id > 0;
                        });
                    const rootLists = [];
                    for (let i = 0; i < ids.length; i += 1) {
                        const branchRoots = await fetchRootsByBranchId(ids[i]);
                        if (branchRoots.length > 0) {
                            rootLists.push(branchRoots);
                        }
                    }
                    roots = mergeRootLists(rootLists);
                }
            }
            const validRoots = Array.isArray(roots)
                ? roots.filter(function (item) { return item && item.id; })
                : [];
            return validRoots.length > 0 ? validRoots : (Array.isArray(CURRENT_TREE_ROOTS) ? CURRENT_TREE_ROOTS : []);
        }

        function waitForAnimationFrames(frameCount) {
            const totalFrames = Math.max(1, Number(frameCount || 1));
            return new Promise(function (resolve) {
                let remaining = totalFrames;
                const nextFrame = function () {
                    remaining -= 1;
                    if (remaining <= 0) {
                        resolve();
                        return;
                    }
                    requestAnimationFrame(nextFrame);
                };
                requestAnimationFrame(nextFrame);
            });
        }

        function waitForTimeout(ms) {
            return new Promise(function (resolve) {
                setTimeout(resolve, Math.max(0, Number(ms || 0)));
            });
        }

        function sanitizeExportFileName(value) {
            const normalized = String(value || '')
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^a-zA-Z0-9]+/g, '-')
                .replace(/^-+|-+$/g, '')
                .toLowerCase();
            return normalized || 'gia-pha';
        }

        function getFamilyTreeExportBaseName() {
            const titleText = (document.querySelector('.ft-page-banner-title') || {}).textContent || 'gia-pha';
            const branchText = (document.getElementById('activeBranchLabel') || {}).textContent || '';
            const familyPart = sanitizeExportFileName(titleText);
            const branchPart = branchText && branchText.trim() && branchText.trim().toLowerCase() !== 'toàn bộ'
                ? ('-' + sanitizeExportFileName(branchText))
                : '';
            const now = new Date();
            const stamp = [
                now.getFullYear(),
                String(now.getMonth() + 1).padStart(2, '0'),
                String(now.getDate()).padStart(2, '0'),
                String(now.getHours()).padStart(2, '0'),
                String(now.getMinutes()).padStart(2, '0')
            ].join('');
            return familyPart + branchPart + '-' + stamp;
        }

        function setTreeExportBusyState(isBusy) {
            const exportMenu = document.querySelector('#ftExportDropdown .dropdown-menu');
            if (exportMenu && isBusy) {
                exportMenu.classList.remove('show');
            }
            ['ftExportToggle', 'ftExportPng', 'ftExportPdf', 'ftExportSvg'].forEach(function (buttonId) {
                const button = document.getElementById(buttonId);
                if (!button) return;
                button.disabled = !!isBusy;
                button.classList.toggle('is-busy', !!isBusy);
            });
        }

        function resolveExportScaleProfile(format) {
            const exportFormat = String(format || 'png').toLowerCase();
            if (exportFormat === 'pdf') {
                return {
                    targetScale: FT_EXPORT_PDF_TARGET_SCALE,
                    maxScale: FT_EXPORT_PDF_MAX_SCALE
                };
            }
            return {
                targetScale: FT_EXPORT_PNG_TARGET_SCALE,
                maxScale: FT_EXPORT_PNG_MAX_SCALE
            };
        }

        function computeExportCanvasScale(width, height, format) {
            const safeWidth = Math.max(1, Number(width || 0));
            const safeHeight = Math.max(1, Number(height || 0));
            const deviceScale = Math.max(1, Number(window.devicePixelRatio || 1));
            const profile = resolveExportScaleProfile(format);
            const preferredScale = Math.min(
                profile.maxScale,
                Math.max(profile.targetScale, deviceScale)
            );
            const scaleByDimension = Math.min(
                FT_EXPORT_MAX_CANVAS_DIMENSION / safeWidth,
                FT_EXPORT_MAX_CANVAS_DIMENSION / safeHeight
            );
            const scaleByArea = Math.sqrt(FT_EXPORT_MAX_CANVAS_AREA / (safeWidth * safeHeight));
            const scale = Math.min(preferredScale, scaleByDimension, scaleByArea);
            return Math.max(0.15, Math.min(preferredScale, Number.isFinite(scale) ? scale : preferredScale));
        }

        function buildExportScaleAttempts(baseScale) {
            const normalizedBase = Math.max(1, Number(baseScale || 1));
            const attempts = [
                normalizedBase,
                Math.max(1.8, normalizedBase * 0.82),
                Math.max(1.35, normalizedBase * 0.66)
            ];
            return attempts.filter(function (scale, index, source) {
                return Number.isFinite(scale) && scale > 0 && source.indexOf(scale) === index;
            });
        }

        function isCanvasLikelyAllBlack(canvas) {
            if (!canvas || typeof canvas.getContext !== 'function' || canvas.width <= 0 || canvas.height <= 0) {
                return false;
            }
            const context = canvas.getContext('2d', { willReadFrequently: true });
            if (!context || typeof context.getImageData !== 'function') {
                return false;
            }
            try {
                const sampleCols = 10;
                const sampleRows = 10;
                const stepX = Math.max(1, Math.floor(canvas.width / sampleCols));
                const stepY = Math.max(1, Math.floor(canvas.height / sampleRows));
                let total = 0;
                let darkOpaque = 0;
                for (let y = 0; y < canvas.height; y += stepY) {
                    for (let x = 0; x < canvas.width; x += stepX) {
                        const pixel = context.getImageData(x, y, 1, 1).data;
                        const alpha = Number(pixel[3] || 0);
                        const brightness = (Number(pixel[0] || 0) + Number(pixel[1] || 0) + Number(pixel[2] || 0)) / 3;
                        total += 1;
                        if (alpha >= 220 && brightness <= 10) {
                            darkOpaque += 1;
                        }
                    }
                }
                return total > 0 && (darkOpaque / total) >= 0.92;
            } catch (err) {
                return false;
            }
        }

        async function renderExportCanvasBitmap(element, width, height, format) {
            const exportWidth = Math.max(1, Math.ceil(Number(width || 0)));
            const exportHeight = Math.max(1, Math.ceil(Number(height || 0)));
            const baseScale = computeExportCanvasScale(exportWidth, exportHeight, format);
            const attemptScales = buildExportScaleAttempts(baseScale);
            let lastError = null;

            for (let i = 0; i < attemptScales.length; i += 1) {
                const scale = attemptScales[i];
                try {
                    const canvas = await window.html2canvas(element, {
                        backgroundColor: '#f8f0df',
                        scale: scale,
                        useCORS: true,
                        imageTimeout: 15000,
                        logging: false,
                        removeContainer: true,
                        width: exportWidth,
                        height: exportHeight,
                        windowWidth: exportWidth,
                        windowHeight: exportHeight,
                        scrollX: 0,
                        scrollY: 0
                    });
                    if (isCanvasLikelyAllBlack(canvas)) {
                        lastError = new Error('Canvas export bi den o scale ' + scale);
                        continue;
                    }
                    return canvas;
                } catch (err) {
                    lastError = err;
                }
            }

            throw lastError || new Error('Khong tao duoc canvas export');
        }

        function resolvePdfPageSize(canvasWidth, canvasHeight) {
            const maxUnit = 2400;
            let width = Math.max(1, Number(canvasWidth || 1)) * 0.75;
            let height = Math.max(1, Number(canvasHeight || 1)) * 0.75;
            const ratio = width / height;
            if (width > maxUnit) {
                width = maxUnit;
                height = width / ratio;
            }
            if (height > maxUnit) {
                height = maxUnit;
                width = height * ratio;
            }
            return {
                width: Math.max(1, width),
                height: Math.max(1, height)
            };
        }

        function downloadBlob(blob, fileName) {
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.download = fileName;
            document.body.appendChild(link);
            link.click();
            link.remove();
            setTimeout(function () {
                URL.revokeObjectURL(url);
            }, 1000);
        }

        function blobToDataUrl(blob) {
            return new Promise(function (resolve, reject) {
                const reader = new FileReader();
                reader.onload = function () {
                    resolve(String(reader.result || ''));
                };
                reader.onerror = function () {
                    reject(reader.error || new Error('Khong doc duoc du lieu blob'));
                };
                reader.readAsDataURL(blob);
            });
        }

        function collectSvgExportCssText() {
            const cssParts = [];
            Array.from(document.styleSheets || []).forEach(function (sheet) {
                try {
                    if (sheet.href) {
                        const sheetUrl = new URL(sheet.href, window.location.href);
                        if (sheetUrl.origin !== window.location.origin) {
                            return;
                        }
                    }
                    Array.from(sheet.cssRules || []).forEach(function (rule) {
                        if (rule && typeof rule.cssText === 'string' && rule.cssText.trim()) {
                            cssParts.push(rule.cssText);
                        }
                    });
                } catch (err) {
                    // Bo qua stylesheet khong truy cap duoc (thuong do CORS)
                }
            });
            cssParts.push(
                '#ftApp.ft-svg-export-app{' +
                'display:inline-block;' +
                'width:100%;' +
                'height:100%;' +
                'background:#f8f0df;' +
                'color:#35241a;' +
                'overflow:visible;' +
                '}' +
                '#ftApp.ft-svg-export-app .ft-export-host{' +
                'position:static !important;' +
                'left:0 !important;' +
                'top:0 !important;' +
                'width:auto !important;' +
                'height:auto !important;' +
                'overflow:visible !important;' +
                'pointer-events:none !important;' +
                '}' +
                '#ftApp.ft-svg-export-app .ft-export-shell{' +
                'display:inline-block !important;' +
                '}' +
                '#ftApp.ft-svg-export-app .ft-export-host, ' +
                '#ftApp.ft-svg-export-app .ft-export-host *{' +
                'box-sizing:border-box;' +
                '}'
            );
            return cssParts.join('\n');
        }

        async function inlineImagesForSvg(element) {
            const images = element ? Array.from(element.querySelectorAll('img')) : [];
            if (!images.length) {
                return;
            }
            await Promise.all(images.map(async function (image) {
                const rawSrc = String(image.getAttribute('src') || image.src || '').trim();
                if (!rawSrc || /^data:/i.test(rawSrc)) {
                    return;
                }
                let absoluteUrl = rawSrc;
                try {
                    absoluteUrl = new URL(rawSrc, window.location.href).href;
                } catch (err) {
                    return;
                }
                try {
                    const response = await fetch(absoluteUrl, {
                        credentials: 'include'
                    });
                    if (!response.ok) {
                        throw new Error('Khong tai duoc anh');
                    }
                    const blob = await response.blob();
                    const dataUrl = await blobToDataUrl(blob);
                    if (dataUrl) {
                        image.setAttribute('src', dataUrl);
                        return;
                    }
                } catch (err) {
                    // Neu khong inline duoc thi giu URL tuyet doi de trinh xem SVG van co co hoi tai anh.
                }
                image.setAttribute('src', absoluteUrl);
            }));
        }

        function buildFamilyTreeSvgMarkup(stage, width, height) {
            const xhtmlNs = 'http://www.w3.org/1999/xhtml';
            const serializer = new XMLSerializer();
            const appWrapper = document.createElementNS(xhtmlNs, 'div');
            appWrapper.setAttribute('xmlns', xhtmlNs);
            appWrapper.setAttribute('id', 'ftApp');
            appWrapper.setAttribute('class', 'ft-svg-export-app');
            appWrapper.style.width = Math.ceil(width) + 'px';
            appWrapper.style.height = Math.ceil(height) + 'px';
            appWrapper.style.background = '#f8f0df';
            appWrapper.style.overflow = 'visible';

            const styleElement = document.createElementNS(xhtmlNs, 'style');
            styleElement.textContent = collectSvgExportCssText();
            appWrapper.appendChild(styleElement);
            appWrapper.appendChild(stage.host.cloneNode(true));

            const foreignObjectMarkup = serializer.serializeToString(appWrapper);
            const svgWidth = Math.ceil(width);
            const svgHeight = Math.ceil(height);
            return ''
                + '<?xml version="1.0" encoding="UTF-8"?>'
                + '<svg xmlns="http://www.w3.org/2000/svg" width="' + svgWidth + '" height="' + svgHeight + '" viewBox="0 0 ' + svgWidth + ' ' + svgHeight + '">'
                + '<rect width="100%" height="100%" fill="#f8f0df"/>'
                + '<foreignObject x="0" y="0" width="100%" height="100%">'
                + foreignObjectMarkup
                + '</foreignObject>'
                + '</svg>';
        }

        function waitForImagesInElement(element) {
            const images = element ? Array.from(element.querySelectorAll('img')) : [];
            if (!images.length) {
                return Promise.resolve();
            }
            return Promise.all(images.map(function (image) {
                if (image.complete && image.naturalWidth > 0) {
                    return Promise.resolve();
                }
                return new Promise(function (resolve) {
                    let settled = false;
                    const finish = function () {
                        if (settled) return;
                        settled = true;
                        image.removeEventListener('load', finish);
                        image.removeEventListener('error', finish);
                        resolve();
                    };
                    image.addEventListener('load', finish, { once: true });
                    image.addEventListener('error', finish, { once: true });
                    setTimeout(finish, 5000);
                });
            }));
        }

        function buildFamilyTreeExportStage(app, canvasElement, roots) {
            const exportHost = document.createElement('div');
            exportHost.className = 'ft-export-host';
            exportHost.setAttribute('aria-hidden', 'true');

            const exportShell = document.createElement('div');
            exportShell.className = 'ft-canvas-shell ft-export-shell';

            const exportCanvas = canvasElement.cloneNode(true);
            exportCanvas.classList.add('ft-export-canvas');

            const exportEmptyState = exportCanvas.querySelector('#treeEmptyState');
            if (exportEmptyState) {
                exportEmptyState.remove();
            }
            const exportLegend = exportCanvas.querySelector('#legend');
            if (exportLegend) {
                exportLegend.remove();
            }

            const exportContentArea = exportCanvas.querySelector('#contentArea');
            const exportScaleWrap = exportCanvas.querySelector('#scaleWrap');
            const exportTreeRoot = exportCanvas.querySelector('#treeRoot');
            if (!exportContentArea || !exportScaleWrap || !exportTreeRoot) {
                throw new Error('Khong tao duoc vung export cay gia pha');
            }

            exportTreeRoot.innerHTML = renderForestForExport(roots);
            exportShell.appendChild(exportCanvas);
            exportHost.appendChild(exportShell);
            app.appendChild(exportHost);

            return {
                host: exportHost,
                shell: exportShell,
                canvas: exportCanvas,
                contentArea: exportContentArea,
                scaleWrap: exportScaleWrap,
                root: exportTreeRoot
            };
        }

        function prepareFamilyTreeExportStage(stage, options) {
            if (!stage || !stage.root || !stage.canvas || !stage.contentArea || !stage.scaleWrap || !stage.shell) {
                throw new Error('Khong tao duoc stage export gia pha');
            }

            const opts = options || {};
            const paddingTop = Math.max(0, Number(opts.paddingTop || 0));
            const paddingHorizontal = Math.max(0, Number(opts.paddingHorizontal || 0));
            const paddingBottom = Math.max(0, Number(opts.paddingBottom || 0));

            syncBranchToggleSpacingForRoot(stage.root);
            stage.shell.style.width = 'max-content';
            stage.shell.style.maxWidth = 'none';
            stage.shell.style.overflow = 'visible';
            stage.canvas.style.height = 'auto';
            stage.canvas.style.minHeight = '0';
            stage.canvas.style.overflow = 'visible';
            stage.contentArea.style.padding = paddingTop + 'px ' + paddingHorizontal + 'px ' + paddingBottom + 'px';
            stage.contentArea.style.overflow = 'visible';
            stage.contentArea.style.width = 'max-content';
            stage.contentArea.style.minWidth = '0';
            stage.contentArea.style.height = 'auto';
            stage.scaleWrap.style.transform = 'none';
            stage.scaleWrap.style.width = 'max-content';
            stage.scaleWrap.style.minWidth = 'max-content';
            stage.scaleWrap.style.willChange = 'auto';
            Array.from(stage.root.querySelectorAll('.ft-branch-subtree')).forEach(function (subtree) {
                subtree.classList.remove('is-collapsed');
                subtree.style.maxHeight = 'none';
                subtree.style.opacity = '1';
                subtree.style.overflow = 'visible';
                subtree.setAttribute('aria-hidden', 'false');
            });
        }

        async function createFamilyTreeSvgBlob() {
            const app = document.getElementById('ftApp');
            const canvasElement = app ? app.querySelector('.ft-canvas') : null;
            if (!app || !canvasElement) {
                throw new Error('Khong tim thay vung cay gia pha de xuat SVG');
            }

            const roots = await fetchAllRootsForExport();
            if (!Array.isArray(roots) || roots.length === 0) {
                throw new Error('Cay gia pha chua co du lieu de xuat');
            }

            const previousCollapsed = Array.from(COLLAPSED_NODE_IDS);
            const previousViewMode = CURRENT_VIEW_MODE;
            const exportPaddingTop = 260;
            const exportPaddingHorizontal = 64;
            const exportPaddingBottom = 72;
            let exportStage = null;

            CURRENT_VIEW_MODE = 'full';
            applyTreeViewMode();
            COLLAPSED_NODE_IDS.clear();

            try {
                exportStage = buildFamilyTreeExportStage(app, canvasElement, roots);
                prepareFamilyTreeExportStage(exportStage, {
                    paddingTop: exportPaddingTop,
                    paddingHorizontal: exportPaddingHorizontal,
                    paddingBottom: exportPaddingBottom
                });

                await waitForAnimationFrames(3);
                await waitForImagesInElement(exportStage.host);
                await waitForTimeout(180);
                await waitForAnimationFrames(2);

                const rootRect = exportStage.root.getBoundingClientRect();
                const width = Math.max(
                    exportStage.root.scrollWidth || 0,
                    exportStage.root.offsetWidth || 0,
                    exportStage.root.clientWidth || 0,
                    Math.ceil(rootRect.width || 0)
                ) + (exportPaddingHorizontal * 2);
                const height = Math.max(
                    exportStage.root.scrollHeight || 0,
                    exportStage.root.offsetHeight || 0,
                    exportStage.root.clientHeight || 0,
                    Math.ceil(rootRect.height || 0)
                ) + exportPaddingTop + exportPaddingBottom;

                if (width <= 0 || height <= 0) {
                    throw new Error('Khong do duoc kich thuoc cay gia pha de xuat SVG');
                }

                exportStage.canvas.style.width = Math.ceil(width) + 'px';
                exportStage.canvas.style.height = Math.ceil(height) + 'px';
                exportStage.contentArea.style.width = Math.ceil(width) + 'px';
                exportStage.contentArea.style.height = Math.ceil(height) + 'px';
                await waitForAnimationFrames(2);
                await inlineImagesForSvg(exportStage.host);

                const svgMarkup = buildFamilyTreeSvgMarkup(exportStage, width, height);
                return new Blob([svgMarkup], {
                    type: 'image/svg+xml;charset=UTF-8'
                });
            } finally {
                if (exportStage && exportStage.host && exportStage.host.parentNode) {
                    exportStage.host.parentNode.removeChild(exportStage.host);
                }
                COLLAPSED_NODE_IDS.clear();
                previousCollapsed.forEach(function (personId) {
                    COLLAPSED_NODE_IDS.add(Number(personId));
                });
                CURRENT_VIEW_MODE = previousViewMode;
                applyTreeViewMode();
            }
        }

        async function captureFamilyTreeCanvasLegacy(format) {
            if (typeof window.html2canvas !== 'function') {
                throw new Error('Không tải được thư viện xuất ảnh');
            }

            const app = document.getElementById('ftApp');
            const canvasShell = app ? app.querySelector('.ft-canvas-shell') : null;
            const canvasElement = app ? app.querySelector('.ft-canvas') : null;
            const contentArea = document.getElementById('contentArea');
            const scaleWrap = document.getElementById('scaleWrap');
            const treeRoot = document.getElementById('treeRoot');
            const treeEmptyState = document.getElementById('treeEmptyState');
            if (!app || !canvasShell || !canvasElement || !contentArea || !scaleWrap || !treeRoot) {
                throw new Error('Không tìm thấy vùng cây gia phả để xuất');
            }

            const roots = await fetchAllRootsForExport();
            if (!Array.isArray(roots) || roots.length === 0) {
                throw new Error('Cây gia phả chưa có dữ liệu để xuất');
            }

            return await (async function () {
                const previousCollapsedSafe = Array.from(COLLAPSED_NODE_IDS);
                const previousViewModeSafe = CURRENT_VIEW_MODE;
                const exportPaddingTopSafe = 176;
                const exportPaddingHorizontalSafe = 64;
                const exportPaddingBottomSafe = 72;
                let exportStageSafe = null;

                CURRENT_VIEW_MODE = 'full';
                COLLAPSED_NODE_IDS.clear();

                try {
                    exportStageSafe = buildFamilyTreeExportStage(app, canvasElement, roots);
                    syncBranchToggleSpacingForRoot(exportStageSafe.root);
                    await waitForAnimationFrames(3);
                    await waitForImagesInElement(exportStageSafe.host);
                    await waitForTimeout(220);
                    exportStageSafe.shell.style.width = 'max-content';
                    exportStageSafe.shell.style.maxWidth = 'none';
                    exportStageSafe.shell.style.overflow = 'visible';
                    exportStageSafe.canvas.style.height = 'auto';
                    exportStageSafe.canvas.style.minHeight = '0';
                    exportStageSafe.canvas.style.overflow = 'visible';
                    exportStageSafe.contentArea.style.padding = exportPaddingTopSafe + 'px ' + exportPaddingHorizontalSafe + 'px ' + exportPaddingBottomSafe + 'px';
                    exportStageSafe.contentArea.style.overflow = 'visible';
                    exportStageSafe.contentArea.style.width = 'max-content';
                    exportStageSafe.contentArea.style.minWidth = '0';
                    exportStageSafe.contentArea.style.height = 'auto';
                    exportStageSafe.scaleWrap.style.transform = 'none';
                    exportStageSafe.scaleWrap.style.width = 'max-content';
                    exportStageSafe.scaleWrap.style.minWidth = 'max-content';
                    exportStageSafe.scaleWrap.style.willChange = 'auto';
                    await waitForAnimationFrames(2);

                    const rootRectSafe = exportStageSafe.root.getBoundingClientRect();
                    const widthSafe = Math.max(
                        exportStageSafe.root.scrollWidth || 0,
                        exportStageSafe.root.offsetWidth || 0,
                        exportStageSafe.root.clientWidth || 0,
                        Math.ceil(rootRectSafe.width || 0)
                    ) + (exportPaddingHorizontalSafe * 2);
                    const heightSafe = Math.max(
                        exportStageSafe.root.scrollHeight || 0,
                        exportStageSafe.root.offsetHeight || 0,
                        exportStageSafe.root.clientHeight || 0,
                        Math.ceil(rootRectSafe.height || 0)
                    ) + exportPaddingTopSafe + exportPaddingBottomSafe;

                    if (widthSafe <= 0 || heightSafe <= 0) {
                        throw new Error('Khong do duoc kich thuoc cay gia pha de xuat');
                    }

                    exportStageSafe.canvas.style.width = Math.ceil(widthSafe) + 'px';
                    exportStageSafe.canvas.style.height = Math.ceil(heightSafe) + 'px';
                    exportStageSafe.contentArea.style.width = Math.ceil(widthSafe) + 'px';
                    exportStageSafe.contentArea.style.height = Math.ceil(heightSafe) + 'px';
                    await waitForAnimationFrames(2);

                    const scaleSafe = computeExportCanvasScale(widthSafe, heightSafe, format);
                    return await window.html2canvas(exportStageSafe.canvas, {
                        backgroundColor: '#f8f0df',
                        scale: scaleSafe,
                        useCORS: true,
                        logging: false,
                        width: Math.ceil(widthSafe),
                        height: Math.ceil(heightSafe),
                        windowWidth: Math.ceil(widthSafe),
                        windowHeight: Math.ceil(heightSafe),
                        scrollX: 0,
                        scrollY: 0
                    });
                } finally {
                    if (exportStageSafe && exportStageSafe.host && exportStageSafe.host.parentNode) {
                        exportStageSafe.host.parentNode.removeChild(exportStageSafe.host);
                    }
                    COLLAPSED_NODE_IDS.clear();
                    previousCollapsedSafe.forEach(function (personId) {
                        COLLAPSED_NODE_IDS.add(Number(personId));
                    });
                    CURRENT_VIEW_MODE = previousViewModeSafe;
                }
            }());

            const previousCollapsed = Array.from(COLLAPSED_NODE_IDS);
            const previousViewMode = CURRENT_VIEW_MODE;
            const previousEmptyVisible = treeEmptyState ? treeEmptyState.classList.contains('is-visible') : false;
            const previousAppHeavy = app.classList.contains('ft-heavy');
            const previousLowZoom = app.classList.contains('ft-low-zoom');
            const previousUltraLowZoom = app.classList.contains('ft-ultra-low-zoom');
            const previousPanActive = app.classList.contains('ft-pan-active');
            const previousInteracting = app.classList.contains('ft-interacting');
            const previousTreeHtml = treeRoot.innerHTML;
            const previousCanvasShellStyle = canvasShell.getAttribute('style') || '';
            const previousCanvasStyle = canvasElement.getAttribute('style') || '';
            const previousContentAreaStyle = contentArea.getAttribute('style') || '';
            const previousScaleWrapStyle = scaleWrap.getAttribute('style') || '';
            const previousViewportScale = FT_VIEWPORT.scale;
            const previousViewportPanX = FT_VIEWPORT.panX;
            const previousViewportPanY = FT_VIEWPORT.panY;
            const exportPaddingTop = 260;
            const exportPaddingHorizontal = 64;
            const exportPaddingBottom = 72;

            CURRENT_VIEW_MODE = 'full';
            applyTreeViewMode();
            app.classList.add('ft-exporting');
            app.classList.remove('ft-heavy');
            app.classList.remove('ft-low-zoom');
            app.classList.remove('ft-ultra-low-zoom');
            app.classList.remove('ft-pan-active');
            app.classList.remove('ft-interacting');
            setTreeEmptyStateVisible(false);
            COLLAPSED_NODE_IDS.clear();

            try {
                treeRoot.innerHTML = renderForest(roots);
                invalidateTreeMetrics();
                syncBranchToggleSpacingForRoot(treeRoot);
                await waitForAnimationFrames(3);
                await waitForImagesInElement(treeRoot);
                await waitForTimeout(220);
                canvasShell.style.width = 'max-content';
                canvasShell.style.maxWidth = 'none';
                canvasShell.style.overflow = 'visible';
                canvasElement.style.height = 'auto';
                canvasElement.style.minHeight = '0';
                canvasElement.style.overflow = 'visible';
                contentArea.style.padding = exportPaddingTop + 'px ' + exportPaddingHorizontal + 'px ' + exportPaddingBottom + 'px';
                contentArea.style.overflow = 'visible';
                contentArea.style.width = 'max-content';
                contentArea.style.minWidth = '0';
                contentArea.style.height = 'auto';
                scaleWrap.style.transform = 'none';
                scaleWrap.style.width = 'max-content';
                scaleWrap.style.minWidth = 'max-content';
                scaleWrap.style.willChange = 'auto';
                await waitForAnimationFrames(2);
                const rootRect = treeRoot.getBoundingClientRect();
                const width = Math.max(
                    treeRoot.scrollWidth || 0,
                    treeRoot.offsetWidth || 0,
                    treeRoot.clientWidth || 0,
                    Math.ceil(rootRect.width || 0)
                ) + (exportPaddingHorizontal * 2);
                const height = Math.max(
                    treeRoot.scrollHeight || 0,
                    treeRoot.offsetHeight || 0,
                    treeRoot.clientHeight || 0,
                    Math.ceil(rootRect.height || 0)
                ) + exportPaddingTop + exportPaddingBottom;
                if (width <= 0 || height <= 0) {
                    throw new Error('Không đo được kích thước cây gia phả để xuất');
                }
                canvasElement.style.width = Math.ceil(width) + 'px';
                canvasElement.style.height = Math.ceil(height) + 'px';
                contentArea.style.width = Math.ceil(width) + 'px';
                contentArea.style.height = Math.ceil(height) + 'px';
                await waitForAnimationFrames(2);
                const scale = computeExportCanvasScale(width, height, format);
                return await window.html2canvas(canvasElement, {
                    backgroundColor: '#f8f0df',
                    scale: scale,
                    useCORS: true,
                    logging: false,
                    width: Math.ceil(width),
                    height: Math.ceil(height),
                    windowWidth: Math.ceil(width),
                    windowHeight: Math.ceil(height),
                    scrollX: 0,
                    scrollY: 0
                });
            } finally {
                treeRoot.innerHTML = previousTreeHtml;
                if (previousCanvasShellStyle) {
                    canvasShell.setAttribute('style', previousCanvasShellStyle);
                } else {
                    canvasShell.removeAttribute('style');
                }
                if (previousCanvasStyle) {
                    canvasElement.setAttribute('style', previousCanvasStyle);
                } else {
                    canvasElement.removeAttribute('style');
                }
                if (previousContentAreaStyle) {
                    contentArea.setAttribute('style', previousContentAreaStyle);
                } else {
                    contentArea.removeAttribute('style');
                }
                if (previousScaleWrapStyle) {
                    scaleWrap.setAttribute('style', previousScaleWrapStyle);
                } else {
                    scaleWrap.removeAttribute('style');
                }
                COLLAPSED_NODE_IDS.clear();
                previousCollapsed.forEach(function (personId) {
                    COLLAPSED_NODE_IDS.add(Number(personId));
                });
                CURRENT_VIEW_MODE = previousViewMode;
                applyTreeViewMode();
                app.classList.remove('ft-exporting');
                app.classList.toggle('ft-heavy', previousAppHeavy);
                app.classList.toggle('ft-low-zoom', previousLowZoom);
                app.classList.toggle('ft-ultra-low-zoom', previousUltraLowZoom);
                app.classList.toggle('ft-pan-active', previousPanActive);
                app.classList.toggle('ft-interacting', previousInteracting);
                setTreeEmptyStateVisible(previousEmptyVisible);
                FT_VIEWPORT.scale = previousViewportScale;
                FT_VIEWPORT.panX = previousViewportPanX;
                FT_VIEWPORT.panY = previousViewportPanY;
                invalidateTreeMetrics();
                syncBranchToggleSpacingForRoot(treeRoot);
                requestAnimationFrame(function () {
                    syncBranchToggleSpacingForRoot(treeRoot);
                    measureTreeMetrics(true);
                    if (FT_VIEWPORT.initialized && typeof FT_VIEWPORT.apply === 'function') {
                        FT_VIEWPORT.apply();
                    }
                });
            }
        }

        async function captureFamilyTreeCanvas(format) {
            if (typeof window.html2canvas !== 'function') {
                throw new Error('Không tải được thư viện xuất ảnh');
            }

            const app = document.getElementById('ftApp');
            const canvasElement = app ? app.querySelector('.ft-canvas') : null;
            if (!app || !canvasElement) {
                throw new Error('Không tìm thấy vùng cây gia phả để xuất');
            }

            const roots = await fetchAllRootsForExport();
            if (!Array.isArray(roots) || roots.length === 0) {
                throw new Error('Cây gia phả chưa có dữ liệu để xuất');
            }

            const previousCollapsed = Array.from(COLLAPSED_NODE_IDS);
            const previousViewMode = CURRENT_VIEW_MODE;
            const exportPaddingTop = 260;
            const exportPaddingHorizontal = 64;
            const exportPaddingBottom = 72;
            let exportStage = null;

            CURRENT_VIEW_MODE = 'full';
            applyTreeViewMode();
            COLLAPSED_NODE_IDS.clear();

            try {
                exportStage = buildFamilyTreeExportStage(app, canvasElement, roots);
                prepareFamilyTreeExportStage(exportStage, {
                    paddingTop: exportPaddingTop,
                    paddingHorizontal: exportPaddingHorizontal,
                    paddingBottom: exportPaddingBottom
                });

                await waitForAnimationFrames(3);
                await waitForImagesInElement(exportStage.host);
                await waitForTimeout(180);
                await waitForAnimationFrames(2);

                const rootRect = exportStage.root.getBoundingClientRect();
                const width = Math.max(
                    exportStage.root.scrollWidth || 0,
                    exportStage.root.offsetWidth || 0,
                    exportStage.root.clientWidth || 0,
                    Math.ceil(rootRect.width || 0)
                ) + (exportPaddingHorizontal * 2);
                const height = Math.max(
                    exportStage.root.scrollHeight || 0,
                    exportStage.root.offsetHeight || 0,
                    exportStage.root.clientHeight || 0,
                    Math.ceil(rootRect.height || 0)
                ) + exportPaddingTop + exportPaddingBottom;

                if (width <= 0 || height <= 0) {
                    throw new Error('Không đo được kích thước cây gia phả để xuất');
                }

                exportStage.canvas.style.width = Math.ceil(width) + 'px';
                exportStage.canvas.style.height = Math.ceil(height) + 'px';
                exportStage.contentArea.style.width = Math.ceil(width) + 'px';
                exportStage.contentArea.style.height = Math.ceil(height) + 'px';
                await waitForAnimationFrames(2);

                return await renderExportCanvasBitmap(exportStage.canvas, width, height, format);
            } finally {
                if (exportStage && exportStage.host && exportStage.host.parentNode) {
                    exportStage.host.parentNode.removeChild(exportStage.host);
                }
                COLLAPSED_NODE_IDS.clear();
                previousCollapsed.forEach(function (personId) {
                    COLLAPSED_NODE_IDS.add(Number(personId));
                });
                CURRENT_VIEW_MODE = previousViewMode;
                applyTreeViewMode();
            }
        }

        async function exportFamilyTreeFile(format) {
            if (FT_EXPORT_IN_PROGRESS) {
                return;
            }

            const exportFormat = String(format || '').toLowerCase();
            if (exportFormat !== 'png' && exportFormat !== 'pdf' && exportFormat !== 'svg') {
                showToast('Định dạng xuất không hợp lệ', 'error');
                return;
            }

            FT_EXPORT_IN_PROGRESS = true;
            setTreeExportBusyState(true);
            try {
                const baseName = getFamilyTreeExportBaseName();
                if (exportFormat === 'svg') {
                    const svgBlob = await createFamilyTreeSvgBlob();
                    downloadBlob(svgBlob, baseName + '.svg');
                    showToast('Da xuat SVG gia pha', 'success');
                    return;
                } else if (exportFormat === 'png') {
                    const canvas = await captureFamilyTreeCanvas(exportFormat);
                    await new Promise(function (resolve, reject) {
                        if (canvas.toBlob) {
                            canvas.toBlob(function (blob) {
                                if (!blob) {
                                    reject(new Error('Không tạo được file PNG'));
                                    return;
                                }
                                downloadBlob(blob, baseName + '.png');
                                resolve();
                            }, 'image/png');
                            return;
                        }
                        try {
                            const dataUrl = canvas.toDataURL('image/png');
                            const link = document.createElement('a');
                            link.href = dataUrl;
                            link.download = baseName + '.png';
                            document.body.appendChild(link);
                            link.click();
                            link.remove();
                            resolve();
                        } catch (err) {
                            reject(err);
                        }
                    });
                } else {
                    const canvas = await captureFamilyTreeCanvas(exportFormat);
                    const jsPdfApi = window.jspdf && window.jspdf.jsPDF;
                    if (!jsPdfApi) {
                        throw new Error('Không tải được thư viện PDF');
                    }
                    const pageSize = resolvePdfPageSize(canvas.width, canvas.height);
                    const pdf = new jsPdfApi({
                        orientation: pageSize.width >= pageSize.height ? 'landscape' : 'portrait',
                        unit: 'pt',
                        format: [pageSize.width, pageSize.height],
                        compress: false
                    });
                    pdf.addImage(
                        canvas,
                        'PNG',
                        0,
                        0,
                        pageSize.width,
                        pageSize.height,
                        undefined,
                        'SLOW'
                    );
                    pdf.save(baseName + '.pdf');
                }
                showToast(exportFormat === 'png' ? 'Đã xuất ảnh PNG gia phả' : 'Đã xuất PDF gia phả', 'success');
            } catch (err) {
                console.error('Family tree export failed:', err);
                showToast(err && err.message ? err.message : 'Xuất gia phả thất bại', 'error');
            } finally {
                FT_EXPORT_IN_PROGRESS = false;
                setTreeExportBusyState(false);
            }
        }

        function setupPersonCardActions() {
            const treeRoot = document.getElementById('treeRoot');
            const app = document.getElementById('ftApp');
            if (!treeRoot || treeRoot.dataset.actionsBound === 'true') return;
            treeRoot.dataset.actionsBound = 'true';

            function ensureTreeMenuLayer() {
                if (!app) return null;
                let layer = app.querySelector('.ft-tree-menu-layer');
                if (!layer) {
                    layer = document.createElement('div');
                    layer.className = 'ft-tree-menu-layer';
                    app.appendChild(layer);
                }
                return layer;
            }

            function restoreTreeMenu(menu) {
                if (!menu) return;
                const placeholder = menu.__treeMenuPlaceholder;
                if (placeholder && placeholder.parentNode) {
                    placeholder.parentNode.insertBefore(menu, placeholder);
                    placeholder.parentNode.removeChild(placeholder);
                }
                menu.__treeMenuPlaceholder = null;
                menu.classList.remove('is-floating');
                menu.style.removeProperty('left');
                menu.style.removeProperty('top');
                menu.style.removeProperty('right');
                menu.style.removeProperty('bottom');
            }

            function resetTreeMenuPosition(menu) {
                if (!menu) return;
                menu.style.removeProperty('left');
                menu.style.removeProperty('top');
                menu.style.removeProperty('right');
                menu.style.removeProperty('bottom');
            }

            function floatTreeMenu(menu) {
                if (!menu || menu.classList.contains('is-floating')) return;
                const layer = ensureTreeMenuLayer();
                const parentNode = menu.parentNode;
                if (!layer || !parentNode) return;
                const placeholder = document.createComment('tree-action-menu-placeholder');
                parentNode.insertBefore(placeholder, menu);
                menu.__treeMenuPlaceholder = placeholder;
                layer.appendChild(menu);
                menu.classList.add('is-floating');
                menu.style.left = '0px';
                menu.style.top = '0px';
                menu.style.right = 'auto';
                menu.style.bottom = 'auto';
            }

            function positionTreeMenu(menu, toggle) {
                if (!menu || !toggle) return;
                resetTreeMenuPosition(menu);
                const toggleRect = toggle.getBoundingClientRect();
                const menuRect = menu.getBoundingClientRect();
                const viewportWidth = window.innerWidth || document.documentElement.clientWidth || 0;
                const viewportHeight = window.innerHeight || document.documentElement.clientHeight || 0;
                const gap = 8;
                const gutter = 12;

                let left = toggleRect.right + gap;
                let top = toggleRect.top;
                const maxLeft = Math.max(gutter, viewportWidth - menuRect.width - gutter);
                const maxTop = Math.max(gutter, viewportHeight - menuRect.height - gutter);

                if (left > maxLeft) {
                    left = Math.max(gutter, toggleRect.left - menuRect.width - gap);
                }
                left = Math.max(gutter, Math.min(left, maxLeft));
                top = Math.max(gutter, Math.min(top, maxTop));

                menu.style.left = Math.round(left) + 'px';
                menu.style.top = Math.round(top) + 'px';
            }

            async function handleTreeActionClick(actionEl) {
                if (!actionEl) return;
                closeAllTreeMenus();
                const action = String(actionEl.getAttribute('data-tree-action') || '');
                const personId = Number(actionEl.getAttribute('data-person-id') || 0);
                let person = findPersonByIdInRoots(personId);
                if (!person && action !== 'back-root' && personId > 0) {
                    try {
                        person = await loadPersonDetailById(personId);
                    } catch (err) {
                        console.error('Load person detail for action failed:', err);
                        showToast('KhÃ´ng táº£i Ä‘Æ°á»£c thÃ´ng tin thÃ nh viÃªn', 'error');
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
                        'Há» tÃªn: ' + (person.fullName || ''),
                        'Giá»›i tÃ­nh: ' + (person.gender || ''),
                        'NgÃ y sinh: ' + formatDate(person.dob),
                        'NgÃ y máº¥t: ' + formatDate(person.dod),
                        'Chi: ' + (person.branchName || '')
                    ].join('\n');
                    if (navigator.clipboard && navigator.clipboard.writeText) {
                        navigator.clipboard.writeText(copyData).then(function () {
                            showToast('ÄÃ£ sao chÃ©p dá»¯ liá»‡u', 'success');
                        }).catch(function () {
                            showToast('KhÃ´ng thá»ƒ sao chÃ©p dá»¯ liá»‡u', 'error');
                        });
                    } else {
                        showToast('TrÃ¬nh duyá»‡t khÃ´ng há»— trá»£ sao chÃ©p', 'error');
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
            }

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
                    const ownerNode = toggle.closest('.person-node');
                    const ownerLi = toggle.closest('.li-person');
                    closeAllTreeMenus();
                    if (willOpen) {
                        menu.classList.add('show');
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

            document.addEventListener('click', function (e) {
                if (e.target.closest('.tree-menu-toggle')) {
                    return;
                }
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

            const resolveMinScale = function () {
                const metrics = measureTreeMetrics();
                const largestAxis = Math.max(metrics.width || 0, metrics.height || 0);
                if (window.innerWidth <= 767) {
                    if (largestAxis >= 12000) return 0.10;
                    if (largestAxis >= 8000) return 0.11;
                    return 0.12;
                }
                if (largestAxis >= 16000) return 0.05;
                if (largestAxis >= 10000) return 0.06;
                if (largestAxis >= 7000) return 0.07;
                return 0.08;
            };
            const minScale = resolveMinScale();
            const maxScale = window.innerWidth <= 767 ? 1.04 : 1.12;
            const lowZoomThreshold = window.innerWidth <= 767 ? 0.58 : 0.58;
            const ultraLowZoomThreshold = window.innerWidth <= 767 ? 0.18 : 0.14;
            const lowZoomExitThreshold = Math.min(maxScale, lowZoomThreshold + 0.05);
            const ultraLowZoomExitThreshold = Math.min(maxScale, ultraLowZoomThreshold + 0.03);
            let viewportRaf = 0;
            let interactionTimer = 0;
            let bypassPanClamp = false;
            let isLowZoomMode = FT_VIEWPORT.scale <= lowZoomThreshold;
            let isUltraLowZoomMode = FT_VIEWPORT.scale <= ultraLowZoomThreshold;
            const getPanBounds = function (scaleValue) {
                const scale = Number.isFinite(scaleValue) ? scaleValue : FT_VIEWPORT.scale || 1;
                const viewportWidth = contentArea.clientWidth || 0;
                const viewportHeight = contentArea.clientHeight || 0;
                const metrics = measureTreeMetrics();
                const treeWidth = metrics.width || 0;
                const treeHeight = metrics.height || 0;
                const scaledWidth = Math.max(treeWidth * scale, 0);
                const scaledHeight = Math.max(treeHeight * scale, 0);
                const lowZoomRangeBoost = scale < lowZoomThreshold
                    ? 1 + Math.min(1.35, ((lowZoomThreshold - scale) / Math.max(0.01, lowZoomThreshold - minScale)) * 1.35)
                    : 1;
                const ultraLowZoomBoost = scale <= ultraLowZoomThreshold
                    ? 1 + Math.min(3.2, ((ultraLowZoomThreshold - scale) / Math.max(0.01, ultraLowZoomThreshold - minScale)) * 3.2)
                    : 1;
                const bufferX = Math.max(120, viewportWidth * 0.28) * lowZoomRangeBoost * ultraLowZoomBoost;
                const bufferTop = Math.max(40, viewportHeight * 0.08) * Math.min(1.45 * ultraLowZoomBoost, lowZoomRangeBoost * ultraLowZoomBoost);
                const bufferBottom = Math.max(120, viewportHeight * 0.22) * lowZoomRangeBoost * ultraLowZoomBoost;
                let minX;
                let maxX;
                let minY;
                let maxY;

                if (scaledWidth <= viewportWidth) {
                    const centeredX = (viewportWidth - scaledWidth) / 2;
                    const extraX = scale <= ultraLowZoomThreshold
                        ? Math.max(bufferX, viewportWidth * 1.75, scaledWidth * 1.6)
                        : bufferX;
                    minX = centeredX - extraX;
                    maxX = centeredX + extraX;
                } else {
                    minX = viewportWidth - scaledWidth - bufferX;
                    maxX = bufferX;
                }

                if (scaledHeight <= viewportHeight) {
                    const centeredY = Math.max(bufferTop, (viewportHeight - scaledHeight) / 2);
                    const extraTop = scale <= ultraLowZoomThreshold
                        ? Math.max(bufferTop, viewportHeight * 0.9, scaledHeight * 0.85)
                        : bufferTop;
                    const extraBottom = scale <= ultraLowZoomThreshold
                        ? Math.max(bufferBottom, viewportHeight * 1.4, scaledHeight * 1.2)
                        : bufferBottom;
                    minY = centeredY - extraBottom;
                    maxY = centeredY + extraTop;
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
                if (!app.classList.contains('ft-interacting')) {
                    app.classList.add('ft-interacting');
                }
                scaleWrap.style.willChange = 'transform';
                if (interactionTimer) clearTimeout(interactionTimer);
                interactionTimer = setTimeout(function () {
                    app.classList.remove('ft-interacting');
                    scaleWrap.style.willChange = 'auto';
                }, 220);
            };
            const setPanActive = function (active) {
                if (!app) return;
                app.classList.toggle('ft-pan-active', !!active);
            };
            const syncZoomPerformanceMode = function () {
                if (!app) return;
                const currentScale = FT_VIEWPORT.scale || 1;
                if (isLowZoomMode) {
                    if (currentScale >= lowZoomExitThreshold) {
                        isLowZoomMode = false;
                    }
                } else if (currentScale <= lowZoomThreshold) {
                    isLowZoomMode = true;
                }

                if (isUltraLowZoomMode) {
                    if (currentScale >= ultraLowZoomExitThreshold) {
                        isUltraLowZoomMode = false;
                    }
                } else if (currentScale <= ultraLowZoomThreshold) {
                    isUltraLowZoomMode = true;
                }

                app.classList.toggle('ft-low-zoom', isLowZoomMode);
                app.classList.toggle('ft-ultra-low-zoom', isUltraLowZoomMode);
            };

            const applyViewportNow = function () {
                viewportRaf = 0;
                FT_VIEWPORT.scale = clampScale(FT_VIEWPORT.scale);
                const skipPanClampOnce = FT_VIEWPORT.skipPanClampOnce === true;
                FT_VIEWPORT.skipPanClampOnce = false;
                if (!skipPanClampOnce && !bypassPanClamp) {
                    FT_VIEWPORT.panX = clampPan(FT_VIEWPORT.panX, 'x', FT_VIEWPORT.scale);
                    FT_VIEWPORT.panY = clampPan(FT_VIEWPORT.panY, 'y', FT_VIEWPORT.scale);
                }
                scaleWrap.style.transform = 'translate3d(' + FT_VIEWPORT.panX + 'px,' + FT_VIEWPORT.panY + 'px,0) scale(' + FT_VIEWPORT.scale + ')';
                syncZoomPerformanceMode();
            };

            FT_VIEWPORT.apply = function () {
                if (viewportRaf) return;
                viewportRaf = requestAnimationFrame(applyViewportNow);
            };
            FT_VIEWPORT.applyNow = applyViewportNow;
            const applyViewportImmediate = function () {
                if (viewportRaf) {
                    cancelAnimationFrame(viewportRaf);
                    viewportRaf = 0;
                }
                applyViewportNow();
            };
            FT_VIEWPORT.applyImmediate = applyViewportImmediate;
            const canBypassPanClamp = function () {
                return (FT_VIEWPORT.scale || 1) <= ultraLowZoomThreshold;
            };
            const resolvePanSpeed = function () {
                const scaleValue = FT_VIEWPORT.scale || 1;
                if (scaleValue <= ultraLowZoomThreshold) return PAN_SPEED * 1.9;
                if (scaleValue <= lowZoomThreshold) return PAN_SPEED * 1.45;
                if (scaleValue <= 0.9) return PAN_SPEED * 1.18;
                return PAN_SPEED * 1.08;
            };

            const zoomAtPoint = function (nextScale, clientX, clientY, options) {
                const opts = options || {};
                const clamped = clampScale(nextScale);
                const areaRect = contentArea.getBoundingClientRect();
                const localX = clientX - areaRect.left;
                const localY = clientY - areaRect.top;
                const worldX = (localX - FT_VIEWPORT.panX) / FT_VIEWPORT.scale;
                const worldY = (localY - FT_VIEWPORT.panY) / FT_VIEWPORT.scale;
                FT_VIEWPORT.scale = clamped;
                const nextPanX = localX - worldX * FT_VIEWPORT.scale;
                const nextPanY = localY - worldY * FT_VIEWPORT.scale;
                FT_VIEWPORT.panX = opts.skipClamp ? nextPanX : clampPan(nextPanX, 'x', FT_VIEWPORT.scale);
                FT_VIEWPORT.panY = opts.skipClamp ? nextPanY : clampPan(nextPanY, 'y', FT_VIEWPORT.scale);
                setInteractingState();
                if (opts.immediate) {
                    applyViewportImmediate();
                } else {
                    FT_VIEWPORT.apply();
                }
            };

            let pendingPanDx = 0;
            let pendingPanDy = 0;
            let panRaf = 0;
            let wheelZoomRaf = 0;
            let pendingWheelDelta = 0;
            let pendingWheelClientX = 0;
            let pendingWheelClientY = 0;
            let wheelZoomIdleTimer = 0;
            const flushPan = function () {
                panRaf = 0;
                if (!pendingPanDx && !pendingPanDy) return;
                FT_VIEWPORT.panX += pendingPanDx;
                FT_VIEWPORT.panY += pendingPanDy;
                pendingPanDx = 0;
                pendingPanDy = 0;
                applyViewportImmediate();
            };
            const schedulePan = function (dx, dy) {
                pendingPanDx += dx;
                pendingPanDy += dy;
                setInteractingState();
                if (!panRaf) {
                    panRaf = requestAnimationFrame(flushPan);
                }
            };
            const flushWheelZoom = function () {
                wheelZoomRaf = 0;
                if (Math.abs(pendingWheelDelta) < 0.01) return;
                const delta = pendingWheelDelta;
                const clientX = pendingWheelClientX;
                const clientY = pendingWheelClientY;
                pendingWheelDelta = 0;
                let wheelSensitivity = 0.00185;
                if (FT_VIEWPORT.scale <= ultraLowZoomThreshold) {
                    wheelSensitivity *= 0.82;
                } else if (FT_VIEWPORT.scale <= lowZoomThreshold) {
                    wheelSensitivity *= 0.92;
                } else if (FT_VIEWPORT.scale >= 0.9) {
                    wheelSensitivity *= 1.16;
                }
                const factor = Math.exp(-delta * wheelSensitivity);
                const clampedFactor = Math.min(1.18, Math.max(0.85, factor));
                zoomAtPoint(FT_VIEWPORT.scale * clampedFactor, clientX, clientY, { skipClamp: true, immediate: true });
            };
            const finishWheelZoom = function () {
                wheelZoomIdleTimer = 0;
                bypassPanClamp = false;
                FT_VIEWPORT.apply();
            };
            const scheduleWheelZoom = function (delta, clientX, clientY) {
                pendingWheelDelta += delta;
                pendingWheelClientX = clientX;
                pendingWheelClientY = clientY;
                bypassPanClamp = true;
                if (wheelZoomIdleTimer) {
                    clearTimeout(wheelZoomIdleTimer);
                }
                wheelZoomIdleTimer = setTimeout(finishWheelZoom, 60);
                if (!wheelZoomRaf) {
                    wheelZoomRaf = requestAnimationFrame(flushWheelZoom);
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
                const deltaModeScale = e.deltaMode === 1 ? 16 : (e.deltaMode === 2 ? Math.max(contentArea.clientHeight || 0, window.innerHeight || 0) : 1);
                const normalizedDelta = e.deltaY * deltaModeScale;
                const ctrlAdjustedDelta = e.ctrlKey ? normalizedDelta * 0.6 : normalizedDelta;
                scheduleWheelZoom(ctrlAdjustedDelta, e.clientX, e.clientY);
            }, { passive: false });
            contentArea.addEventListener('selectstart', function (e) {
                if (e.target.closest('.tree-action-menu')) {
                    return;
                }
                e.preventDefault();
            });
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
                        bypassPanClamp = canBypassPanClamp();
                        setPanActive(true);
                        const panSpeed = resolvePanSpeed();
                        schedulePan(dx * panSpeed, dy * panSpeed);
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
                    bypassPanClamp = false;
                    setPanActive(false);
                    touchPanState = null;
                    FT_VIEWPORT.apply();
                }
            });
            contentArea.addEventListener('touchcancel', function () {
                bypassPanClamp = false;
                setPanActive(false);
                pinchState = null;
                touchPanState = null;
                FT_VIEWPORT.apply();
            });

            let dragging = false;
            let dragMoved = false;
            let panStarted = false;
            let dragStartX = 0;
            let dragStartY = 0;
            let lastX = 0;
            let lastY = 0;
            const DRAG_THRESHOLD = 1;
            const PAN_SPEED = 1.38;
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
                contentArea.style.cursor = 'grab';
            });

            window.addEventListener('mousemove', function (e) {
                if (!dragging) return;
                if (!(e.buttons & 1)) {
                    dragging = false;
                    panStarted = false;
                    bypassPanClamp = false;
                    contentArea.style.cursor = 'grab';
                    setPanActive(false);
                    FT_VIEWPORT.apply();
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
                    e.preventDefault();
                    bypassPanClamp = canBypassPanClamp();
                    contentArea.style.cursor = 'grabbing';
                    setPanActive(true);
                }
                if (Math.abs(dx) > 1 || Math.abs(dy) > 1) {
                    dragMoved = true;
                }
                const panSpeed = resolvePanSpeed();
                schedulePan(dx * panSpeed, dy * panSpeed);
                lastX = e.clientX;
                lastY = e.clientY;
            });

            window.addEventListener('mouseup', function () {
                if (!dragging) return;
                dragging = false;
                panStarted = false;
                bypassPanClamp = false;
                contentArea.style.cursor = 'grab';
                setPanActive(false);
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
                if (!treeRoot || !treeRoot.querySelector('.person-node')) return;
                FT_VIEWPORT.scale = 1;
                FT_VIEWPORT.panX = 0;
                FT_VIEWPORT.panY = 0;
                applyViewportNow();

                const areaRect = contentArea.getBoundingClientRect();
                const metrics = measureTreeMetrics(true);
                if (!metrics.width || !metrics.height || !areaRect.width || !areaRect.height) return;

                const widthScale = (areaRect.width - 40) / metrics.width;
                const heightScale = (areaRect.height - 40) / metrics.height;
                FT_VIEWPORT.scale = clampScale(Math.min(widthScale, heightScale, 1));
                FT_VIEWPORT.panX = clampPan((areaRect.width - (metrics.width * FT_VIEWPORT.scale)) / 2, 'x', FT_VIEWPORT.scale);
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
            document.getElementById('ftExportPng')?.addEventListener('click', function () {
                exportFamilyTreeFile('png');
            });
            document.getElementById('ftExportPdf')?.addEventListener('click', function () {
                exportFamilyTreeFile('pdf');
            });
            document.getElementById('ftExportSvg')?.addEventListener('click', function () {
                exportFamilyTreeFile('svg');
            });

            let resizeRaf = 0;
            window.addEventListener('resize', function () {
                if (resizeRaf) {
                    cancelAnimationFrame(resizeRaf);
                }
                resizeRaf = requestAnimationFrame(function () {
                    resizeRaf = 0;
                    invalidateTreeMetrics();
                    syncBranchToggleSpacing();
                    FT_VIEWPORT.apply();
                });
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
            ['mDob', 'aDob'].forEach(function (id) {
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
            const viewModeInput = document.getElementById('ftViewMode');
            const resetBtn = document.getElementById('ftFilterReset');
            if (!nameInput || !dobInput || !generationInput || !viewModeInput || !resetBtn) {
                return;
            }
            const currentYear = new Date().getFullYear();
            dobInput.setAttribute('max', String(currentYear));

            const applyAllFilters = function () {
                CURRENT_NAME_FILTER = String(nameInput.value || '').trim();
                const rawDobYear = normalizeYearInputValue(dobInput.value);
                const normalizedDob = rawDobYear != null ? Math.min(rawDobYear, currentYear) : null;
                CURRENT_DOB_FILTER = normalizedDob;
                CURRENT_GENERATION_FILTER = normalizeYearInputValue(generationInput.value);
                CURRENT_GENDER_FILTER = '';
                CURRENT_LIFE_STATUS_FILTER = '';
                CURRENT_BIRTH_YEAR_FROM = null;
                CURRENT_BIRTH_YEAR_TO = null;
                CURRENT_DEATH_YEAR = null;
                CURRENT_VIEW_MODE = String(viewModeInput.value || 'full').trim().toLowerCase() || 'full';
                const hasSearchState = !!(CURRENT_NAME_FILTER
                    || CURRENT_DOB_FILTER
                    || CURRENT_GENERATION_FILTER != null);
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
                } else if (rawDobYear != null && rawDobYear > currentYear) {
                    dobInput.value = String(currentYear);
                }
                resetTreeViewport();
                requestTreeRender();
            };

            const shouldResetToCenteredRoot = function () {
                const hasName = !!String(nameInput.value || '').trim();
                const hasBirthYear = normalizeYearInputValue(dobInput.value) != null;
                const hasGeneration = normalizeYearInputValue(generationInput.value) != null;
                return !hasName && !hasBirthYear && !hasGeneration;
            };

            const applyDebounced = function () {
                if (FT_FILTER_DEBOUNCE) {
                    clearTimeout(FT_FILTER_DEBOUNCE);
                }
                FT_FILTER_DEBOUNCE = setTimeout(async function () {
                    if (shouldResetToCenteredRoot()) {
                        try {
                            await resetFiltersAndBackToRoot();
                        } catch (err) {
                            console.error('Centered reset failed:', err);
                            applyAllFilters();
                        }
                        return;
                    }
                    applyAllFilters();
                }, 120);
            };

            nameInput.addEventListener('input', applyDebounced);
            nameInput.addEventListener('input', function () {
                if (String(nameInput.value || '').trim()) {
                    resetSecondaryFiltersForNameSearch();
                }
            });
            dobInput.addEventListener('input', applyDebounced);
            generationInput.addEventListener('change', applyDebounced);
            viewModeInput.addEventListener('change', function () {
                applyAllFilters();
                if (CURRENT_VIEW_MODE === 'print') {
                    window.print();
                }
            });
            dobInput.addEventListener('blur', function () {
                const normalized = normalizeYearInputValue(dobInput.value);
                if (normalized != null && normalized > currentYear) {
                    dobInput.value = String(currentYear);
                    return;
                }
                dobInput.value = normalized != null ? String(normalized) : '';
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

        configureVisibleFilters();
        collapseLegacyFilterFields();
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
