<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% boolean canManageRecord = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>
<style>
    .record-page {
        padding: 20px 0 28px;
        background:
            radial-gradient(circle at top right, rgba(234, 204, 155, 0.18), transparent 28%),
            linear-gradient(180deg, rgba(255, 250, 241, 0.92), rgba(255, 255, 255, 0));
    }
    .record-hero, .record-card, .record-modal-box {
        background: #fffdf9;
        border: 1px solid #eadbc4;
        border-radius: 22px;
        box-shadow: 0 18px 40px rgba(91, 58, 28, 0.09);
    }
    .record-hero {
        display: flex;
        justify-content: space-between;
        gap: 20px;
        align-items: flex-start;
        padding: 24px 28px 22px;
        margin-bottom: 16px;
        background:
            radial-gradient(circle at top right, rgba(255, 247, 224, 0.62), transparent 34%),
            linear-gradient(135deg, #fffaf0, #f4e5c9);
    }
    .record-hero-copy { max-width: 760px; }
    .record-hero h2 {
        margin: 0 0 8px;
        color: #5f2d19;
        font-size: 31px;
        line-height: 1.32;
        font-family: "Palatino Linotype", "Book Antiqua", Georgia, serif;
        font-weight: 700;
        letter-spacing: 0;
    }
    .record-hero p {
        margin: 0;
        color: #715a46;
        line-height: 1.68;
        font-size: 16px;
        max-width: 700px;
    }
    .record-card { padding: 22px; }
    .record-toolbar-shell {
        padding: 16px 18px;
        border-radius: 18px;
        background: linear-gradient(180deg, #fffaf3, #fffdf9);
        border: 1px solid #efe1cd;
        margin-bottom: 18px;
    }
    .record-toolbar-head {
        display: flex;
        justify-content: space-between;
        gap: 18px;
        align-items: flex-start;
        margin-bottom: 14px;
    }
    .record-toolbar-title {
        margin: 0 0 3px;
        color: #694028;
        font-size: 20px;
        font-family: "Palatino Linotype", "Book Antiqua", Georgia, serif;
        font-weight: 700;
    }
    .record-toolbar-desc {
        margin: 0;
        color: #856b55;
        font-size: 14px;
        line-height: 1.6;
    }
    .record-toolbar {
        display: flex;
        flex-wrap: wrap;
        gap: 14px;
        align-items: center;
    }
    .record-toolbar input {
        border: 1px solid #d6b993;
        border-radius: 14px;
        padding: 14px 16px;
        background: #fff;
        min-width: 280px;
        color: #5d3a22;
        font-size: 15px;
    }
    .record-toolbar input::placeholder { color: #a57b56; }
    .record-toolbar #recordSearchInput {
        flex: 1 1 360px;
        min-width: 360px;
        max-width: 420px;
    }
    .record-toolbar #recordYearInput {
        flex: 0 0 220px;
        min-width: 220px;
    }
    .record-summary {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 16px;
    }
    .record-btn { display: inline-flex; align-items: center; justify-content: center; border: 0; border-radius: 14px; padding: 13px 18px; font-weight: 700; cursor: pointer; text-decoration: none; font-size: 15px; }
    .record-btn-primary { background: #8f2f1f; color: #fff8ea; }
    .record-btn-secondary { background: #f3e7d0; color: #6d3d1e; }
    .record-btn-danger { background: #fbe2df; color: #992f22; }
    .record-toolbar .record-btn-primary {
        min-width: 140px;
    }
    .record-table-panel {
        overflow: hidden;
        border: 1px solid #efe1cd;
        border-radius: 18px;
        background: linear-gradient(180deg, #fffefd, #fffaf4);
    }
    .record-table-scroll { overflow-x: auto; }
    .record-table { width: 100%; border-collapse: collapse; }
    .record-table th, .record-table td { padding: 15px 14px; border-bottom: 1px solid #efe3d0; text-align: left; vertical-align: top; }
    .record-table th {
        color: #744627;
        font-size: 12px;
        letter-spacing: 0.04em;
        text-transform: uppercase;
        background: #fff8eb;
        white-space: nowrap;
    }
    .record-table tbody tr:hover { background: rgba(249, 241, 223, 0.42); }
    .record-chip {
        display: inline-flex;
        align-items: center;
        padding: 8px 13px;
        border-radius: 999px;
        background: #f9f1df;
        color: #70411f;
        font-size: 12px;
        font-weight: 700;
    }
    .record-modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; padding: 18px; background: rgba(32, 15, 10, 0.58); z-index: 10050; }
    .record-modal-box { width: min(820px, 100%); padding: 24px; max-height: calc(100vh - 36px); overflow: auto; }
    .record-modal-box h3 {
        margin: 0 0 18px;
        color: #5f2c18;
        font-size: 24px;
        font-family: "Palatino Linotype", "Book Antiqua", Georgia, serif;
    }
    .record-form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
    .record-field { display: flex; flex-direction: column; gap: 8px; padding: 14px; border-radius: 16px; background: #fffdf9; border: 1px solid #f1e4d3; }
    .record-field label { font-weight: 700; color: #674124; font-size: 13px; }
    .record-field input, .record-field textarea { width: 100%; border: 1px solid #d6b993; border-radius: 12px; padding: 12px 13px; background: #fff; color: #5a3922; font-size: 14px; }
    .record-upload-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-top: 2px; }
    .record-upload-btn { padding: 8px 12px; }
    .record-upload-note { color: #7b644c; font-size: 12px; line-height: 1.5; }
    .record-upload-preview { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 4px; }
    .record-upload-preview.is-empty { display: none; }
    .record-upload-thumb { width: 84px; height: 84px; border-radius: 12px; border: 1px solid #d6b993; background: #f9f1df center/cover no-repeat; }
    .record-upload-link { color: #7c331f; font-size: 12px; word-break: break-all; }
    .record-field.is-full { grid-column: 1 / -1; }
    .record-modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
    .record-empty {
        padding: 52px 24px;
        text-align: center;
        color: #7d654d;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
    }
    .record-empty-title {
        margin: 0;
        color: #69341e;
        font-size: 22px;
        font-family: "Palatino Linotype", "Book Antiqua", Georgia, serif;
        font-weight: 700;
    }
    .record-empty-note {
        margin: 0;
        color: #8d735c;
        font-size: 14px;
        line-height: 1.7;
        max-width: 520px;
    }
    @media (max-width: 991px) {
        .record-hero,
        .record-toolbar-head { flex-direction: column; }
        .record-form-grid { grid-template-columns: 1fr; }
        .record-toolbar input,
        .record-toolbar #recordSearchInput,
        .record-toolbar #recordYearInput,
        .record-toolbar .record-btn-primary {
            min-width: 100%;
            max-width: none;
            flex: 1 1 100%;
        }
    }
</style>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content record-page">
            <div class="record-hero">
                <div class="record-hero-copy">
                    <h2><c:out value="${param.pageTitle}"/></h2>
                    <p><c:out value="${param.pageSubtitle}"/></p>
                </div>
            </div>
            <div class="record-card">
                <div class="record-toolbar-shell">
                    <div class="record-toolbar-head">
                        <div>
                            <h3 class="record-toolbar-title">Danh sách bản ghi</h3>
                            <p class="record-toolbar-desc">Tra cứu nhanh theo tên hoặc năm, sau đó thêm mới hay cập nhật trực tiếp từng bản ghi.</p>
                        </div>
                    </div>
                    <div class="record-toolbar">
                        <input id="recordSearchInput" type="text" placeholder="Tìm kiếm">
                        <input id="recordYearInput" type="number" placeholder="Năm">
                        <% if (canManageRecord) { %>
                            <button id="addRecordBtn" type="button" class="record-btn record-btn-primary">Thêm mới</button>
                        <% } %>
                    </div>
                </div>
                <div id="recordSummaryBox" class="record-summary"></div>
                <div class="record-table-panel">
                    <div id="recordTableWrap"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="recordModal" class="record-modal">
    <div class="record-modal-box">
        <h3 id="recordModalTitle">Thêm mới</h3>
        <div id="recordFormGrid" class="record-form-grid"></div>
        <div class="record-modal-actions">
            <button id="closeRecordModalBtn" type="button" class="record-btn record-btn-secondary">Đóng</button>
            <% if (canManageRecord) { %>
                <button id="saveRecordBtn" type="button" class="record-btn record-btn-primary">Lưu</button>
            <% } %>
        </div>
    </div>
</div>
