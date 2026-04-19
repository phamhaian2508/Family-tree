<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<% boolean canManageIntroduction = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>
<title>Gi&#7899;i thi&#7879;u d&#242;ng h&#7885;</title>

<style>
    .content-admin-page { padding: 20px 0 28px; }
    .content-hero, .content-card { background: #fffdf9; border: 1px solid #eadbc4; border-radius: 18px; box-shadow: 0 12px 30px rgba(91, 58, 28, 0.08); }
    .content-hero { padding: 22px 24px; margin-bottom: 18px; background: linear-gradient(135deg, #fff9ec, #f2e0be); }
    .content-hero h2 { margin: 0 0 8px; color: #6f2817; font-size: 28px; line-height: 1.3; }
    .content-hero p { margin: 0; color: #6a5443; line-height: 1.65; font-size: 15px; }
    .content-card { padding: 20px; }
    .content-grid { display: grid; grid-template-columns: 7fr 3fr; gap: 18px; align-items: start; }
    .content-field { display: flex; flex-direction: column; gap: 8px; margin-bottom: 14px; }
    .content-field label { font-weight: 700; color: #674124; font-size: 14px; }
    .content-field input,
    .content-field textarea {
        width: 100%;
        border: 1px solid #d6b993;
        border-radius: 12px;
        padding: 14px 16px;
        background: #fff;
        color: #5b3b21;
        font-size: 15px;
    }
    .content-field input::placeholder,
    .content-field textarea::placeholder { color: #9b8469; }
    .content-field textarea { min-height: 380px; resize: vertical; line-height: 1.7; }
    .content-actions { display: flex; justify-content: flex-end; gap: 10px; }
    .content-btn { display: inline-flex; align-items: center; justify-content: center; border: 0; border-radius: 12px; padding: 10px 14px; font-weight: 700; cursor: pointer; text-decoration: none; font-size: 14px; }
    .content-btn-primary { background: #8f2f1f; color: #fff8ea; }
    .content-btn-secondary { background: #f3e7d0; color: #6d3d1e; }
    .content-preview-box { display: flex; flex-direction: column; gap: 14px; }
    .content-preview-panel {
        background: linear-gradient(180deg, #fffcf5, #f7efe1);
        border: 1px solid #ecd8bb;
        border-radius: 16px;
        padding: 18px;
        min-height: 430px;
    }
    .content-preview-title {
        margin: 0 0 14px;
        color: #6a341f;
        font-size: 20px;
        line-height: 1.45;
        font-weight: 700;
        letter-spacing: 0.01em;
        font-family: "Palatino Linotype", "Book Antiqua", Georgia, serif;
        text-wrap: balance;
    }
    .content-preview-body {
        color: #654a33;
        line-height: 1.75;
        white-space: pre-line;
        font-size: 14px;
    }
    .content-preview-title.is-empty,
    .content-preview-body.is-empty { display: none; }
    @media (max-width: 991px) {
        .content-grid { grid-template-columns: 1fr; }
    }
</style>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content content-admin-page">
            <div class="content-hero">
                <h2>Gi&#7899;i thi&#7879;u d&#242;ng h&#7885;</h2>
                <p>Qu&#7843;n l&#253; b&#224;i gi&#7899;i thi&#7879;u ch&#237;nh cho c&#226;y gia ph&#7843; <strong><c:out value="${currentFamilyTreeName}"/></strong>.</p>
            </div>
            <div class="content-grid">
                <div class="content-card">
                    <div class="content-field">
                        <label for="introTitle">Ti&#234;u &#273;&#7873;</label>
                        <input id="introTitle" type="text" maxlength="255">
                    </div>
                    <div class="content-field">
                        <label for="introContent">N&#7897;i dung</label>
                        <textarea id="introContent" rows="14"></textarea>
                    </div>
                    <div class="content-actions">
                        <button id="resetIntroBtn" type="button" class="content-btn content-btn-secondary">&#272;&#7863;t l&#7841;i</button>
                        <% if (canManageIntroduction) { %>
                            <button id="saveIntroBtn" type="button" class="content-btn content-btn-primary">L&#432;u n&#7897;i dung</button>
                        <% } %>
                    </div>
                </div>
                <div class="content-card content-preview-box">
                    <div class="content-preview-panel">
                        <h3 class="content-preview-title is-empty" id="introPreviewTitle"></h3>
                        <div class="content-preview-body is-empty" id="introPreviewContent"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        var endpoint = '/api/family-content/introduction';
        var canManage = <%= canManageIntroduction %>;
        var savedState = { title: '', content: '' };
        var titleInput = document.getElementById('introTitle');
        var contentInput = document.getElementById('introContent');
        var previewTitle = document.getElementById('introPreviewTitle');
        var previewContent = document.getElementById('introPreviewContent');

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
            [titleInput, contentInput].forEach(function (el) {
                if (el) {
                    el.readOnly = true;
                }
            });
        }

        function syncPreview() {
            var title = titleInput.value.trim();
            var content = contentInput.value.trim();
            previewTitle.textContent = title;
            previewContent.textContent = content;
            previewTitle.classList.toggle('is-empty', !title);
            previewContent.classList.toggle('is-empty', !content);
        }

        function fillForm(data) {
            savedState.title = data && data.title ? data.title : '';
            savedState.content = data && data.content ? data.content : '';
            titleInput.value = savedState.title;
            contentInput.value = savedState.content;
            syncPreview();
        }

        function resetForm() {
            titleInput.value = savedState.title;
            contentInput.value = savedState.content;
            syncPreview();
        }

        function loadIntroduction() {
            fetch(endpoint)
                .then(function (res) { return res.json(); })
                .then(fillForm)
                .catch(function () { notify('Kh\u00f4ng th\u1ec3 t\u1ea3i n\u1ed9i dung gi\u1edbi thi\u1ec7u.'); });
        }

        function saveIntroduction() {
            var payload = {
                title: titleInput.value.trim(),
                coverImage: '',
                galleryImages: '',
                videoUrl: '',
                content: contentInput.value.trim(),
                visible: true
            };
            if (!payload.title) {
                notify('Ti\u00eau \u0111\u1ec1 kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.');
                return;
            }
            if (!payload.content) {
                notify('N\u1ed9i dung gi\u1edbi thi\u1ec7u kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.');
                return;
            }
            fetch(endpoint, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
                .then(function (res) {
                    if (!res.ok) {
                        return res.text().then(function (text) {
                            throw new Error(text || 'L\u01b0u th\u1ea5t b\u1ea1i');
                        });
                    }
                    return res.json();
                })
                .then(function (data) {
                    fillForm(data);
                    notify('\u0110\u00e3 l\u01b0u n\u1ed9i dung gi\u1edbi thi\u1ec7u.');
                })
                .catch(function (err) {
                    notify(err && err.message ? err.message : 'Kh\u00f4ng th\u1ec3 l\u01b0u d\u1eef li\u1ec7u.');
                });
        }

        titleInput.addEventListener('input', syncPreview);
        contentInput.addEventListener('input', syncPreview);

        if (canManage && document.getElementById('saveIntroBtn')) {
            document.getElementById('saveIntroBtn').addEventListener('click', saveIntroduction);
        }
        document.getElementById('resetIntroBtn').addEventListener('click', resetForm);

        setReadOnlyMode();
        syncPreview();
        loadIntroduction();
    })();
</script>
