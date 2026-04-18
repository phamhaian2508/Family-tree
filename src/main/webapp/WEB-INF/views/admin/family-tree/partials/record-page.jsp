<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% boolean canManageRecord = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>
<style>
    .record-page { padding: 20px 0 28px; }
    .record-hero, .record-card, .record-modal-box { background: #fffdf9; border: 1px solid #eadbc4; border-radius: 18px; box-shadow: 0 12px 30px rgba(91, 58, 28, 0.08); }
    .record-hero { padding: 22px 24px; margin-bottom: 18px; background: linear-gradient(135deg, #fff9ec, #f2e0be); }
    .record-hero h2 { margin: 0 0 8px; color: #6f2817; }
    .record-hero p { margin: 0; color: #6a5443; line-height: 1.6; }
    .record-toolbar { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 16px; }
    .record-toolbar input { border: 1px solid #d6b993; border-radius: 12px; padding: 10px 12px; background: #fff; }
    .record-card { padding: 18px; }
    .record-btn { display: inline-flex; align-items: center; justify-content: center; border: 0; border-radius: 12px; padding: 10px 14px; font-weight: 700; cursor: pointer; text-decoration: none; }
    .record-btn-primary { background: #8f2f1f; color: #fff8ea; }
    .record-btn-secondary { background: #f3e7d0; color: #6d3d1e; }
    .record-btn-danger { background: #fbe2df; color: #992f22; }
    .record-table { width: 100%; border-collapse: collapse; }
    .record-table th, .record-table td { padding: 12px 10px; border-bottom: 1px solid #efe3d0; text-align: left; vertical-align: top; }
    .record-table th { color: #6d3d1e; font-size: 13px; }
    .record-chip { display: inline-flex; padding: 7px 12px; border-radius: 999px; background: #f9f1df; color: #70411f; font-size: 12px; font-weight: 700; margin-right: 8px; margin-bottom: 8px; }
    .record-modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; padding: 18px; background: rgba(32, 15, 10, 0.58); z-index: 10050; }
    .record-modal-box { width: min(760px, 100%); padding: 22px; max-height: calc(100vh - 36px); overflow: auto; }
    .record-form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
    .record-field { display: flex; flex-direction: column; gap: 8px; }
    .record-field label { font-weight: 700; color: #674124; }
    .record-field input, .record-field textarea { width: 100%; border: 1px solid #d6b993; border-radius: 12px; padding: 11px 12px; background: #fff; }
    .record-upload-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-top: 2px; }
    .record-upload-btn { padding: 8px 12px; }
    .record-upload-note { color: #7b644c; font-size: 12px; line-height: 1.5; }
    .record-upload-preview { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 4px; }
    .record-upload-preview.is-empty { display: none; }
    .record-upload-thumb { width: 84px; height: 84px; border-radius: 12px; border: 1px solid #d6b993; background: #f9f1df center/cover no-repeat; }
    .record-upload-link { color: #7c331f; font-size: 12px; word-break: break-all; }
    .record-field.is-full { grid-column: 1 / -1; }
    .record-modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; }
    .record-empty { color: #7d654d; padding: 18px 0; }
    @media (max-width: 991px) { .record-form-grid { grid-template-columns: 1fr; } }
</style>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content record-page">
            <div class="record-hero">
                <h2>${param.pageTitle}</h2>
                <p>${param.pageSubtitle}</p>
            </div>
            <div class="record-card">
                <div class="record-toolbar">
                    <input id="recordSearchInput" type="text" placeholder="T&#236;m ki&#7871;m">
                    <input id="recordYearInput" type="number" placeholder="N&#259;m">
                    <% if (canManageRecord) { %>
                        <button id="addRecordBtn" type="button" class="record-btn record-btn-primary">Th&#234;m m&#7899;i</button>
                    <% } %>
                </div>
                <div id="recordSummaryBox"></div>
                <div id="recordTableWrap"></div>
            </div>
        </div>
    </div>
</div>

<div id="recordModal" class="record-modal">
    <div class="record-modal-box">
        <h3 id="recordModalTitle">Th&#234;m m&#7899;i</h3>
        <div id="recordFormGrid" class="record-form-grid"></div>
        <div class="record-modal-actions">
            <button id="closeRecordModalBtn" type="button" class="record-btn record-btn-secondary">&#272;&#243;ng</button>
            <% if (canManageRecord) { %>
                <button id="saveRecordBtn" type="button" class="record-btn record-btn-primary">L&#432;u</button>
            <% } %>
        </div>
    </div>
</div>
