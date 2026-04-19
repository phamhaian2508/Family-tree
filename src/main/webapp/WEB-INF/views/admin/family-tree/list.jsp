﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>C&acirc;y gia ph&#7843;</title>

<style>
    .family-tree-admin-page {
        padding: 20px 0 28px;
    }
    .family-tree-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 16px;
        margin-bottom: 20px;
        padding: 20px 24px;
        border-radius: 16px;
        background: linear-gradient(135deg, #fff9ec, #f2e0be);
        border: 1px solid #ead2a7;
    }
    .family-tree-header h2 {
        margin: 0 0 8px;
        font-size: 28px;
        color: #6f2817;
    }
    .family-tree-header p {
        margin: 0;
        max-width: 760px;
        color: #6a5443;
        line-height: 1.6;
    }
    .family-tree-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 18px;
    }
    .family-tree-card {
        background: #fffdf9;
        border: 1px solid #eadbc4;
        border-radius: 18px;
        overflow: hidden;
        box-shadow: 0 12px 30px rgba(91, 58, 28, 0.08);
    }
    .family-tree-card.is-active {
        border-color: #8f2f1f;
        box-shadow: 0 18px 36px rgba(143, 47, 31, 0.18);
    }
    .family-tree-cover {
        height: 180px;
        background:
            linear-gradient(180deg, rgba(251, 244, 227, 0.98), rgba(234, 214, 171, 0.98)),
            url("/web/images/hero-paper-bg.png");
        background-size: auto, 240px;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        border-bottom: 1px solid rgba(177, 144, 88, 0.2);
    }
    .family-tree-cover-link {
        display: flex;
        width: 100%;
        height: 100%;
        align-items: center;
        justify-content: center;
        text-decoration: none;
    }
    .family-tree-cover-image {
        width: 100%;
        height: 100%;
        object-fit: contain;
        object-position: center;
        display: block;
        background: #fff;
    }
    .family-tree-cover-placeholder {
        width: 100%;
        height: 100%;
        background: linear-gradient(135deg, #c99d55, #7b2f23);
        color: #fff8ea;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 18px;
        font-size: 15px;
        font-weight: 700;
    }
    .family-tree-body {
        padding: 18px 18px 16px;
    }
    .family-tree-name {
        margin: 0 0 8px;
        font-size: 20px;
        color: #532013;
    }
    .family-tree-desc {
        min-height: 66px;
        margin: 0 0 16px;
        color: #695746;
        line-height: 1.6;
    }
    .family-tree-stats {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-bottom: 16px;
    }
    .family-tree-stat {
        padding: 7px 12px;
        border-radius: 999px;
        background: #f9f1df;
        color: #70411f;
        font-size: 12px;
        font-weight: 700;
    }
    .family-tree-actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .tree-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 0;
        border-radius: 12px;
        padding: 10px 14px;
        font-weight: 700;
        cursor: pointer;
        text-decoration: none;
    }
    .tree-btn-primary {
        background: #8f2f1f;
        color: #fff8ea;
    }
    .tree-btn-secondary {
        background: #f3e7d0;
        color: #6d3d1e;
    }
    .tree-btn-danger {
        background: #fbe2df;
        color: #992f22;
    }
    .family-tree-empty {
        padding: 48px 24px;
        text-align: center;
        border: 1px dashed #d7bea0;
        border-radius: 18px;
        background: #fffdfa;
        color: #705a44;
    }
    .tree-modal-backdrop {
        position: fixed;
        inset: 0;
        background: rgba(32, 15, 10, 0.58);
        display: none;
        align-items: center;
        justify-content: center;
        padding: 18px;
        z-index: 10050;
    }
    .tree-modal {
        width: min(560px, 100%);
        background: #fffaf3;
        border-radius: 18px;
        padding: 22px;
        box-shadow: 0 22px 50px rgba(0, 0, 0, 0.22);
    }
    .tree-modal h3 {
        margin: 0 0 16px;
        color: #5a1f14;
    }
    .tree-field {
        display: flex;
        flex-direction: column;
        gap: 8px;
        margin-bottom: 14px;
    }
    .tree-field label {
        font-weight: 700;
        color: #674124;
    }
    .tree-field input,
    .tree-field textarea {
        width: 100%;
        border: 1px solid #d6b993;
        border-radius: 12px;
        padding: 11px 12px;
        background: #fff;
    }
    .tree-cover-picker {
        display: block;
        cursor: pointer;
    }
    .tree-cover-picker input {
        display: none;
    }
    .tree-cover-preview {
        height: 180px;
        border-radius: 14px;
        border: 1px dashed #d6b993;
        background:
            linear-gradient(180deg, rgba(251, 244, 227, 0.98), rgba(234, 214, 171, 0.98)),
            url("/web/images/hero-paper-bg.png");
        background-size: auto, 220px;
        background-position: center;
        background-repeat: no-repeat;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #7d654d;
        font-weight: 700;
        text-align: center;
        padding: 18px;
    }
    .tree-cover-preview.has-image {
        border-style: solid;
        background-size: contain;
        background-color: #fff;
    }
    .tree-cover-note {
        color: #7b644c;
        font-size: 12px;
        line-height: 1.5;
        margin-top: 8px;
    }
    .tree-modal-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 18px;
    }
</style>

<% boolean canManageFamilyTree = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content family-tree-admin-page">
            <div class="family-tree-header">
                <div>
                    <h2>C&acirc;y gia ph&#7843;</h2>
                    <p>Ch&#7885;n c&acirc;y gia ph&#7843; &#273;&#7875; v&agrave;o xem ngay, ch&#7881;nh s&#7917;a th&ocirc;ng tin c&#417; b&#7843;n ho&#7863;c t&#7841;o c&acirc;y m&#7899;i cho gia &#273;&igrave;nh kh&aacute;c. &#7842;nh &#273;&#7841;i di&#7879;n &#273;&#432;&#7907;c hi&#7875;n th&#7883; &#273;&#7847;y &#273;&#7911; tr&#432;&#7899;c khi m&#7903; c&acirc;y.</p>
                </div>
                <% if (canManageFamilyTree) { %>
                    <button id="addFamilyTreeBtn" type="button" class="tree-btn tree-btn-primary">Th&ecirc;m c&acirc;y gia ph&#7843;</button>
                <% } %>
            </div>

            <div id="familyTreeGrid" class="family-tree-grid"></div>
            <div id="familyTreeEmpty" class="family-tree-empty" style="display:none;">Ch&#432;a c&oacute; c&acirc;y gia ph&#7843; n&agrave;o. H&atilde;y t&#7841;o c&acirc;y &#273;&#7847;u ti&ecirc;n &#273;&#7875; b&#7855;t &#273;&#7847;u qu&#7843;n l&yacute;.</div>

            <div id="familyTreeSeed" style="display:none;">
                <c:forEach var="item" items="${familyTreeList}">
                    <div class="family-tree-seed"
                         data-id="${item.id}"
                         data-name="<c:out value='${item.name}'/>"
                         data-description="<c:out value='${item.description}'/>"
                         data-cover="<c:out value='${item.coverImage}'/>"
                         data-branches="${item.totalBranches}"
                         data-members="${item.totalMembers}"
                         data-albums="${item.totalAlbums}"></div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<div id="familyTreeModalBackdrop" class="tree-modal-backdrop">
    <div class="tree-modal">
        <h3 id="familyTreeModalTitle">Th&ecirc;m c&acirc;y gia ph&#7843;</h3>
        <div class="tree-field">
            <label for="familyTreeNameInput">T&ecirc;n gia ph&#7843;</label>
            <input id="familyTreeNameInput" type="text" maxlength="255" placeholder="V&iacute; d&#7909;: H&#7885; Nguy&#7877;n V&#259;n">
        </div>
        <div class="tree-field">
            <label for="familyTreeDescInput">M&ocirc; t&#7843;</label>
            <textarea id="familyTreeDescInput" rows="4" maxlength="1000" placeholder="M&ocirc; t&#7843; ng&#7855;n &#273;&#7875; ph&acirc;n bi&#7879;t c&acirc;y gia ph&#7843;"></textarea>
        </div>
        <div class="tree-field">
            <label for="familyTreeCoverInput">&#7842;nh &#273;&#7841;i di&#7879;n</label>
            <input id="familyTreeCoverInput" type="file" accept="image/*">
            <div id="familyTreeCoverPreview" class="tree-cover-preview">Ch&#432;a ch&#7885;n &#7843;nh &#273;&#7841;i di&#7879;n</div>
        </div>
        <div class="tree-modal-actions">
            <button id="cancelFamilyTreeBtn" type="button" class="tree-btn tree-btn-secondary">H&#7911;y</button>
            <button id="saveFamilyTreeBtn" type="button" class="tree-btn tree-btn-primary">L&#432;u</button>
        </div>
    </div>
</div>

<script>
    (function () {
        var canManage = <%= canManageFamilyTree %>;
        var currentFamilyTreeId = Number('${empty currentFamilyTreeId ? 0 : currentFamilyTreeId}');
        var state = {
            items: [],
            editingId: null,
            coverImage: '',
            coverFile: null
        };

        function n(value) {
            return String(value || '').trim();
        }

        function h(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function parseSeed() {
            var items = [];
            document.querySelectorAll('.family-tree-seed').forEach(function (node) {
                var id = Number(node.getAttribute('data-id') || 0);
                if (!id) {
                    return;
                }
                items.push({
                    id: id,
                    name: n(node.getAttribute('data-name')),
                    description: n(node.getAttribute('data-description')),
                    coverImage: n(node.getAttribute('data-cover')),
                    totalBranches: Number(node.getAttribute('data-branches') || 0),
                    totalMembers: Number(node.getAttribute('data-members') || 0),
                    totalAlbums: Number(node.getAttribute('data-albums') || 0)
                });
            });
            return items;
        }

        function render() {
            var grid = document.getElementById('familyTreeGrid');
            var empty = document.getElementById('familyTreeEmpty');
            if (!state.items.length) {
                grid.innerHTML = '';
                empty.style.display = 'block';
                return;
            }
            empty.style.display = 'none';
            grid.innerHTML = state.items.map(function (item) {
                var active = item.id === currentFamilyTreeId ? ' is-active' : '';
                var openUrl = '/admin/familytree?familyTreeId=' + item.id;
                var coverHtml = item.coverImage
                    ? '<a class="family-tree-cover-link" href="' + openUrl + '" aria-label="M\u1edf c\u00e2y gia ph\u1ea3 ' + h(item.name) + '">'
                        + '<img class="family-tree-cover-image" src="' + h(item.coverImage) + '" alt="' + h(item.name) + '" loading="lazy" decoding="async">'
                        + '</a>'
                    : '<a class="family-tree-cover-link" href="' + openUrl + '" aria-label="M\u1edf c\u00e2y gia ph\u1ea3 ' + h(item.name) + '">'
                        + '<div class="family-tree-cover-placeholder">' + h(item.name) + '</div>'
                        + '</a>';
                var manageActions = canManage
                    ? '<button class="tree-btn tree-btn-secondary" data-edit="' + item.id + '" type="button">Ch\u1ec9nh s\u1eeda</button>'
                        + '<button class="tree-btn tree-btn-danger" data-delete="' + item.id + '" type="button">X\u00f3a</button>'
                    : '';
                return ''
                    + '<div class="family-tree-card' + active + '">'
                    + '  <div class="family-tree-cover">' + coverHtml + '</div>'
                    + '  <div class="family-tree-body">'
                    + '      <h3 class="family-tree-name">' + h(item.name) + '</h3>'
                    + '      <p class="family-tree-desc">' + h(item.description || 'Ch\u01b0a c\u1eadp nh\u1eadt m\u00f4 t\u1ea3.') + '</p>'
                    + '      <div class="family-tree-stats">'
                    + '          <span class="family-tree-stat">' + item.totalBranches + ' chi nh\u00e1nh</span>'
                    + '          <span class="family-tree-stat">' + item.totalMembers + ' th\u00e0nh vi\u00ean</span>'
                    + '          <span class="family-tree-stat">' + item.totalAlbums + ' album</span>'
                    + '      </div>'
                    + '      <div class="family-tree-actions">'
                    + '          <a class="tree-btn tree-btn-primary" href="' + openUrl + '">V\u00e0o xem ngay</a>'
                    + manageActions
                    + '      </div>'
                    + '  </div>'
                    + '</div>';
            }).join('');
        }

        function resetModal() {
            state.editingId = null;
            state.coverImage = '';
            state.coverFile = null;
            document.getElementById('familyTreeModalTitle').textContent = 'Th\u00eam c\u00e2y gia ph\u1ea3';
            document.getElementById('familyTreeNameInput').value = '';
            document.getElementById('familyTreeDescInput').value = '';
            document.getElementById('familyTreeCoverInput').value = '';
            renderCoverPreview('');
        }

        function renderCoverPreview(dataUrl) {
            var preview = document.getElementById('familyTreeCoverPreview');
            if (dataUrl) {
                preview.style.backgroundImage = 'url("' + dataUrl + '")';
                preview.textContent = '';
                preview.classList.add('has-image');
                return;
            }
            preview.style.backgroundImage = 'none';
            preview.textContent = 'Ch\u01b0a ch\u1ecdn \u1ea3nh \u0111\u1ea1i di\u1ec7n';
            preview.classList.remove('has-image');
        }

        function openModal(item) {
            if (!canManage) {
                return;
            }
            resetModal();
            if (item) {
                state.editingId = item.id;
                state.coverImage = item.coverImage || '';
                state.coverFile = null;
                document.getElementById('familyTreeModalTitle').textContent = 'C\u1eadp nh\u1eadt c\u00e2y gia ph\u1ea3';
                document.getElementById('familyTreeNameInput').value = item.name || '';
                document.getElementById('familyTreeDescInput').value = item.description || '';
                renderCoverPreview(state.coverImage);
            }
            document.getElementById('familyTreeModalBackdrop').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('familyTreeModalBackdrop').style.display = 'none';
        }

        function payload() {
            return {
                name: n(document.getElementById('familyTreeNameInput').value),
                description: n(document.getElementById('familyTreeDescInput').value),
                coverImage: n(state.coverImage)
            };
        }

        function persistFamilyTree(url, method, data) {
            return fetch(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(function (res) {
                if (!res.ok) {
                    return res.text().then(function (text) {
throw new Error(toFriendlyErrorMessage(text, 'Kh\u00f4ng th\u1ec3 l\u01b0u c\u00e2y gia ph\u1ea3. Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i d\u1eef li\u1ec7u.'));
                    });
                }
                return res.json();
            });
        }

        function uploadCoverImage(familyTreeId) {
            if (!state.coverFile) {
                return Promise.resolve(n(state.coverImage));
            }
            var formData = new FormData();
            formData.append('files', state.coverFile);
            formData.append('displayNames', n(state.coverFile.name).replace(/\.[^/.]+$/, ''));
            formData.append('visibilityScopes', 'PUBLIC');
            formData.append('familyTreeId', familyTreeId);
            return fetch('/api/media/upload', {
                method: 'POST',
                body: formData
            })
                .then(function (res) {
                    if (!res.ok) {
                        return res.text().then(function (text) {
throw new Error(toFriendlyErrorMessage(text, 'Kh\u00f4ng th\u1ec3 t\u1ea3i \u1ea3nh \u0111\u1ea1i di\u1ec7n l\u00ean server.'));
                        });
                    }
                    return res.json();
                })
                .then(function (items) {
                    var uploaded = Array.isArray(items) && items.length ? items[0] : null;
                    var fileUrl = uploaded && uploaded.fileUrl ? n(uploaded.fileUrl) : '';
                    if (!fileUrl) {
throw new Error('Kh\u00f4ng nh\u1eadn \u0111\u01b0\u1ee3c URL \u1ea3nh sau khi t\u1ea3i l\u00ean.');
                    }
                    state.coverImage = fileUrl;
                    state.coverFile = null;
                    return fileUrl;
                });
        }

        function validatePayload(data) {
            if (!data.name) {
                showErrorMessage('Vui l\u00f2ng nh\u1eadp t\u00ean c\u00e2y gia ph\u1ea3.');
                return false;
            }
            return true;
        }

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
            if (options.showCancelButton) {
                return Promise.resolve({
                    isConfirmed: window.confirm(options.text || options.title || '')
                });
            }
            window.alert(options.text || options.title || '');
            return Promise.resolve({ isConfirmed: true });
        }

        function showErrorMessage(message) {
            return openDialog({
                icon: 'error',
                title: 'Th\u00f4ng b\u00e1o',
                text: message,
                confirmButtonText: '\u0110\u00f3ng'
            });
        }

        function askDeleteConfirmation(itemName) {
            return openDialog({
                icon: 'warning',
                title: 'X\u00e1c nh\u1eadn x\u00f3a',
                text: 'X\u00f3a c\u00e2y gia ph\u1ea3 "' + itemName + '"? D\u1eef li\u1ec7u li\u00ean quan c\u1ee7a c\u00e2y n\u00e0y s\u1ebd b\u1ecb x\u00f3a.',
                showCancelButton: true,
                confirmButtonText: 'X\u00f3a',
                cancelButtonText: 'H\u1ee7y',
                reverseButtons: true
            });
        }
        function toFriendlyErrorMessage(rawMessage, fallbackMessage) {
            var message = n(rawMessage);
            if (!message) {
                return fallbackMessage;
            }
            if (message.charAt(0) === '{') {
                try {
                    var parsed = JSON.parse(message);
                    var parsedMessage = parsed && parsed.message ? n(parsed.message) : '';
                    if (parsedMessage) {
                        return parsedMessage;
                    }
                } catch (e) {
                }
            }
            var normalized = message.toLowerCase();
            if (normalized.indexOf('localhost') >= 0
                || normalized.indexOf('<!doctype') >= 0
                || normalized.indexOf('<html') >= 0
                || normalized.indexOf('whitelabel error page') >= 0
                || normalized === 'bad request') {
                return fallbackMessage;
            }
            return message;
        }
        function saveFamilyTree() {
            var data = payload();
            if (!validatePayload(data)) {
                return;
            }
            var url = state.editingId ? '/api/family-trees/' + state.editingId : '/api/family-trees';
            var method = state.editingId ? 'PUT' : 'POST';
            fetch(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
                .then(function (res) {
                    if (!res.ok) {
                        return res.text().then(function (text) {
throw new Error(toFriendlyErrorMessage(text, 'Kh\u00f4ng th\u1ec3 l\u01b0u c\u00e2y gia ph\u1ea3. Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i d\u1eef li\u1ec7u.'));
                        });
                    }
                    return res.json();
                })
                .then(function (saved) {
                    if (!state.editingId && saved && Number(saved.id || 0) > 0) {
                        window.location.href = '/admin/familytree?familyTreeId=' + saved.id + '&openCreateFirst=1';
                        return;
                    }
                    window.location.reload();
                })
                .catch(function (err) {
                    showErrorMessage(toFriendlyErrorMessage(err && err.message, 'Kh\u00f4ng th\u1ec3 l\u01b0u c\u00e2y gia ph\u1ea3. Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i d\u1eef li\u1ec7u.'));
                });
        }

        function saveFamilyTreeWithUpload() {
            var data = payload();
            if (!validatePayload(data)) {
                return;
            }
            var url = state.editingId ? '/api/family-trees/' + state.editingId : '/api/family-trees';
            var method = state.editingId ? 'PUT' : 'POST';
            var basePayload = {
                name: data.name,
                description: data.description,
                coverImage: state.coverFile ? '' : data.coverImage
            };
            persistFamilyTree(url, method, basePayload)
                .then(function (saved) {
                    var savedId = Number(saved && saved.id || state.editingId || 0);
                    if (!savedId) {
                        throw new Error('Kh\u00f4ng x\u00e1c \u0111\u1ecbnh \u0111\u01b0\u1ee3c c\u00e2y gia ph\u1ea3 sau khi l\u01b0u.');
                    }
                    return uploadCoverImage(savedId).then(function (coverUrl) {
                        if (!coverUrl || coverUrl === n(saved.coverImage)) {
                            return saved;
                        }
                        return persistFamilyTree('/api/family-trees/' + savedId, 'PUT', {
                            name: data.name,
                            description: data.description,
                            coverImage: coverUrl
                        });
                    });
                })
                .then(function (saved) {
                    var savedId = Number(saved && saved.id || state.editingId || 0);
                    if (!state.editingId && savedId > 0) {
                        window.location.href = '/admin/familytree?familyTreeId=' + savedId + '&openCreateFirst=1';
                        return;
                    }
                    window.location.href = '/admin/family-trees?familyTreeId=' + currentFamilyTreeId;
                })
                .catch(function (err) {
                    showErrorMessage(toFriendlyErrorMessage(err && err.message, 'Kh\u00f4ng th\u1ec3 l\u01b0u c\u00e2y gia ph\u1ea3. Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i d\u1eef li\u1ec7u.'));
                });
        }

        function handleDeleteFamilyTree(id) {
            if (!canManage) {
                return;
            }
            var item = state.items.find(function (x) { return x.id === id; });
            if (!item) {
                return;
            }
            if (Number(item.totalMembers || 0) > 0) {
                showErrorMessage('Ch\u1ec9 c\u00f3 th\u1ec3 x\u00f3a c\u00e2y gia ph\u1ea3 khi s\u1ed1 th\u00e0nh vi\u00ean b\u1eb1ng 0.');
                return;
            }
            askDeleteConfirmation(item.name)
                .then(function (result) {
                    if (!result.isConfirmed) {
                        return null;
                    }
                    return fetch('/api/family-trees/' + id, { method: 'DELETE' })
                        .then(function (res) {
                            if (!res.ok) {
                                return res.text().then(function (text) {
                                    throw new Error(toFriendlyErrorMessage(text, 'Kh\u00f4ng th\u1ec3 x\u00f3a c\u00e2y gia ph\u1ea3.'));
                                });
                            }
                            return true;
                        });
                })
                .then(function (deleted) {
                    if (!deleted) {
                        return;
                    }
                    window.location.href = '/admin/family-trees?familyTreeId=' + currentFamilyTreeId;
                })
                .catch(function (err) {
                    showErrorMessage(toFriendlyErrorMessage(err && err.message, 'Kh\u00f4ng th\u1ec3 x\u00f3a c\u00e2y gia ph\u1ea3.'));
                });
        }
        document.getElementById('familyTreeGrid').addEventListener('click', function (event) {
            var editButton = event.target.closest('[data-edit]');
            if (editButton) {
                var editId = Number(editButton.getAttribute('data-edit') || 0);
                openModal(state.items.find(function (item) { return item.id === editId; }) || null);
                return;
            }
            var deleteButton = event.target.closest('[data-delete]');
            if (deleteButton) {
                handleDeleteFamilyTree(Number(deleteButton.getAttribute('data-delete') || 0));
            }
        });

        document.getElementById('familyTreeCoverInput').addEventListener('change', function () {
            var file = this.files && this.files[0];
            if (!file) {
                state.coverFile = null;
                renderCoverPreview(state.coverImage);
                return;
            }
            state.coverFile = file;
            var reader = new FileReader();
            reader.onload = function (event) {
                renderCoverPreview(event && event.target ? String(event.target.result || '') : '');
            };
            reader.readAsDataURL(file);
        });

        document.getElementById('cancelFamilyTreeBtn').addEventListener('click', closeModal);
        document.getElementById('saveFamilyTreeBtn').addEventListener('click', saveFamilyTreeWithUpload);
        document.getElementById('familyTreeModalBackdrop').addEventListener('click', function (event) {
            if (event.target === this) {
                closeModal();
            }
        });

        var addButton = document.getElementById('addFamilyTreeBtn');
        if (addButton) {
            addButton.addEventListener('click', function () {
                openModal(null);
            });
        }

        state.items = parseSeed();
        render();
    })();
</script>


