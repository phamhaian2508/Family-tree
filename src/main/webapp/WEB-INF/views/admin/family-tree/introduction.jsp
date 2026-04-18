<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<% boolean canManageIntroduction = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>
<title>Gi&#7899;i thi&#7879;u d&#242;ng h&#7885;</title>

<style>
    .content-admin-page { padding: 20px 0 28px; }
    .content-hero, .content-card { background: #fffdf9; border: 1px solid #eadbc4; border-radius: 18px; box-shadow: 0 12px 30px rgba(91, 58, 28, 0.08); }
    .content-hero { padding: 22px 24px; margin-bottom: 18px; background: linear-gradient(135deg, #fff9ec, #f2e0be); }
    .content-hero h2 { margin: 0 0 8px; color: #6f2817; }
    .content-hero p { margin: 0; color: #6a5443; line-height: 1.6; }
    .content-card { padding: 20px; }
    .content-grid { display: grid; grid-template-columns: 1.4fr 1fr; gap: 18px; }
    .content-field { display: flex; flex-direction: column; gap: 8px; margin-bottom: 14px; }
    .content-field label { font-weight: 700; color: #674124; }
    .content-field input, .content-field textarea { width: 100%; border: 1px solid #d6b993; border-radius: 12px; padding: 11px 12px; background: #fff; }
    .content-actions { display: flex; justify-content: flex-end; gap: 10px; }
    .content-btn { display: inline-flex; align-items: center; justify-content: center; border: 0; border-radius: 12px; padding: 10px 14px; font-weight: 700; cursor: pointer; text-decoration: none; }
    .content-btn-primary { background: #8f2f1f; color: #fff8ea; }
    .content-btn-secondary { background: #f3e7d0; color: #6d3d1e; }
    .content-preview-box { display: flex; flex-direction: column; gap: 14px; }
    .content-chip { display: inline-flex; align-items: center; gap: 6px; padding: 8px 12px; border-radius: 999px; background: #f9f1df; color: #70411f; font-weight: 700; font-size: 12px; }
    .content-note { color: #7b644c; font-size: 13px; line-height: 1.6; }
    @media (max-width: 991px) { .content-grid { grid-template-columns: 1fr; } }
</style>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content content-admin-page">
            <div class="content-hero">
                <h2>Gi&#7899;i thi&#7879;u d&#242;ng h&#7885;</h2>
                <p>Qu&#7843;n l&#253; b&#224;i gi&#7899;i thi&#7879;u ch&#237;nh cho c&#226;y gia ph&#7843; <strong>${currentFamilyTreeName}</strong>. M&#7895;i d&#242;ng h&#7885; c&#243; m&#7897;t n&#7897;i dung gi&#7899;i thi&#7879;u ri&#234;ng, hi&#7875;n th&#7883; &#273;&#7897;c l&#7853;p.</p>
            </div>
            <div class="content-grid">
                <div class="content-card">
                    <div class="content-field"><label for="introTitle">Ti&#234;u &#273;&#7873;</label><input id="introTitle" type="text" maxlength="255"></div>
                    <div class="content-field"><label for="introContent">N&#7897;i dung chi ti&#7871;t</label><textarea id="introContent" rows="14"></textarea></div>
                    <div class="content-actions">
                        <button id="reloadIntroBtn" type="button" class="content-btn content-btn-secondary">T&#7843;i l&#7841;i</button>
                        <% if (canManageIntroduction) { %>
                            <button id="saveIntroBtn" type="button" class="content-btn content-btn-primary">L&#432;u n&#7897;i dung</button>
                        <% } %>
                    </div>
                </div>
                <div class="content-card content-preview-box">
                    <div class="content-chip">D&#242;ng h&#7885; hi&#7879;n t&#7841;i: ${currentFamilyTreeName}</div>
                    <div class="content-note" id="introStatusText">B&#224;i gi&#7899;i thi&#7879;u n&#224;y &#273;&#432;&#7907;c l&#432;u ri&#234;ng cho d&#242;ng h&#7885; hi&#7879;n t&#7841;i.</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        var endpoint = '/api/family-content/introduction';
        var canManage = <%= canManageIntroduction %>;
        var currentFamilyTreeId = Number('${empty currentFamilyTreeId ? 0 : currentFamilyTreeId}');
        function openDialog(options) {
            function normalizeDialogResult(result) {
                if (typeof result === 'boolean') {
                    return { isConfirmed: result };
                }
                if (!result) {
                    return { isConfirmed: false };
                }
                if (typeof result.isConfirmed === 'boolean') {
                    return result;
                }
                if (typeof result.value !== 'undefined') {
                    return { isConfirmed: !!result.value };
                }
                if (result.dismiss) {
                    return { isConfirmed: false, dismiss: result.dismiss };
                }
                return { isConfirmed: false };
            }
            if (window.Swal && typeof window.Swal.fire === 'function') {
                return window.Swal.fire(options).then(normalizeDialogResult);
            }
            if (typeof window.swal === 'function') {
                return window.swal({
                    title: options.title,
                    text: options.text,
                    type: options.icon,
                    showCancelButton: !!options.showCancelButton,
                    confirmButtonText: options.confirmButtonText || '\u0110\u00f3ng',
                    cancelButtonText: options.cancelButtonText || 'H\u1ee7y',
                    reverseButtons: !!options.reverseButtons
                }).then(normalizeDialogResult);
            }
            window.alert(options.text || options.title || '');
            return Promise.resolve({ isConfirmed: true });
        }
        function notify(message) {
            return openDialog({
                icon: 'info',
title: 'Th\u00f4ng b\u00e1o',
                text: message,
confirmButtonText: '\u0110\u00f3ng'
            });
        }
        function setReadOnlyMode() {
            if (canManage) {
                return;
            }
            ['introTitle', 'introContent'].forEach(function (id) {
                var el = document.getElementById(id);
                if (el) {
                    el.readOnly = true;
                }
            });
        }
        function fillForm(data) {
            document.getElementById('introTitle').value = data && data.title ? data.title : '';
            document.getElementById('introContent').value = data && data.content ? data.content : '';
        }
        function loadIntroduction() {
            fetch(endpoint).then(function (res) { return res.json(); }).then(fillForm).catch(function () { notify('Kh\u00f4ng th\u1ec3 t\u1ea3i n\u1ed9i dung gi\u1edbi thi\u1ec7u.'); });
        }
        function saveIntroduction() {
            var payload = {
                title: document.getElementById('introTitle').value.trim(),
                coverImage: '',
                galleryImages: '',
                videoUrl: '',
                content: document.getElementById('introContent').value.trim(),
                visible: true
            };
            if (!payload.title) { notify('Ti\u00eau \u0111\u1ec1 kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.'); return; }
            if (!payload.content) { notify('N\u1ed9i dung gi\u1edbi thi\u1ec7u kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.'); return; }
            fetch(endpoint, { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) })
                .then(function (res) { if (!res.ok) { return res.text().then(function (text) { throw new Error(text || 'L\u01b0u th\u1ea5t b\u1ea1i'); }); } return res.json(); })
                .then(function (data) { fillForm(data); notify('\u0110\u00e3 l\u01b0u n\u1ed9i dung gi\u1edbi thi\u1ec7u.'); })
                .catch(function (err) { notify(err && err.message ? err.message : 'Kh\u00f4ng th\u1ec3 l\u01b0u d\u1eef li\u1ec7u.'); });
        }
        if (canManage && document.getElementById('saveIntroBtn')) {
            document.getElementById('saveIntroBtn').addEventListener('click', saveIntroduction);
        }
        document.getElementById('reloadIntroBtn').addEventListener('click', loadIntroduction);
        setReadOnlyMode();
        loadIntroduction();
    })();
</script>
