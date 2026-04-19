<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>Tư liệu dòng họ</title>
<link rel="stylesheet" href="<c:url value='/admin/assets/css/media-page.css'/>" />

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content media-admin-page">
            <div id="mediaLibraryApp">
                <div id="libraryListView">
                    <div class="library-header">
                        <h2>Thư viện tư liệu dòng họ</h2>
                        <div class="library-breadcrumb">Lưu giữ ảnh, video và tư liệu gia phả theo phong cách trang nghiêm, đồng bộ với trang chủ và cây gia phả.</div>
                    </div>

                    <div class="library-panel">
                        <div class="library-toolbar">
                            <div class="toolbar-left">
                                <span>Hiển thị</span>
                                <select id="perPageSelect" class="tool-select">
                                    <option value="10">10</option>
                                    <option value="25">25</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="toolbar-right">
                                <input id="albumSearchInput" class="tool-search" type="text" placeholder="Tìm theo tên album hoặc tư liệu">
                                <button id="albumSearchBtn" class="tool-btn tool-btn-teal" type="button"><i class="fa fa-search"></i> Tra cứu</button>
                                <button id="albumRefreshBtn" class="tool-btn tool-btn-slate" type="button"><i class="fa fa-refresh"></i> Làm mới</button>
                                <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                    <button id="addLibraryBtn" class="tool-btn tool-btn-teal add-btn" type="button"><i class="fa fa-plus"></i> Thêm thư viện</button>
                                </security:authorize>
                            </div>
                        </div>
                        <div id="albumGrid" class="album-grid"></div>
                        <div id="albumEmpty" class="empty-box" style="display:none;">Chưa có album phù hợp với điều kiện đang chọn.</div>
                    </div>
                </div>

                <div id="libraryDetailView" style="display:none;">
                    <div class="library-header">
                        <h2>Chi tiết album tư liệu</h2>
                        <div class="library-breadcrumb">Theo dõi đầy đủ ảnh và video của từng album tư liệu, giữ mạch lưu trữ thống nhất với gia phả.</div>
                    </div>
                    <div class="detail-layout">
                        <div class="panel-card info-card">
                            <div class="panel-title">Thông tin album</div>
                            <div class="album-cover" id="albumCover"></div>
                            <div class="info-content">
                                <p class="album-name" id="albumName"></p>
                                <p class="album-desc" id="albumDesc"></p>
                                <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                    <button id="deleteAlbumBtn" class="icon-btn danger" type="button"><i class="fa fa-trash"></i></button>
                                </security:authorize>
                            </div>
                        </div>
                        <div class="panel-card">
                            <div class="tab-bar">
                                <button id="photoTabBtn" class="tab-btn active" type="button">Ảnh album</button>
                                <button id="videoTabBtn" class="tab-btn" type="button">Video</button>
                            </div>
                            <div class="content-tools">
                                <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                    <button id="addPhotoBtn" class="tool-btn tool-btn-teal add-content-btn" type="button"><i class="fa fa-plus"></i> Thêm ảnh</button>
                                    <button id="addVideoBtn" class="tool-btn tool-btn-teal add-content-btn" type="button" style="display:none;"><i class="fa fa-plus"></i> Thêm video</button>
                                </security:authorize>
                            </div>
                            <div id="albumMediaGrid" class="media-grid"></div>
                            <div id="albumMediaEmpty" class="empty-box" style="display:none;">Chưa có tệp nào trong album này.</div>
                        </div>
                    </div>
                    <div class="back-wrap"><button id="backToListBtn" class="back-btn" type="button"><i class="fa fa-arrow-left"></i> Quay lại thư viện</button></div>
                </div>
            </div>

            <div id="albumSeed" style="display:none;">
                <c:forEach var="album" items="${albumList}">
                    <div class="seed-album"
                         data-id="${album.id}"
                         data-name="<c:out value='${album.name}'/>"
                         data-description="<c:out value='${album.description}'/>"
                         data-cover="<c:out value='${album.coverUrl}'/>"
                         data-person="${album.personId}"
                         data-branch="${album.branchId}"></div>
                </c:forEach>
            </div>
            <div id="mediaSeed" style="display:none;">
                <c:forEach var="media" items="${mediaList}">
                    <div class="seed-media"
                         data-id="${media.id}"
                         data-name="<c:out value='${media.fileName}'/>"
                         data-type="<c:out value='${media.mediaType}'/>"
                         data-size="<c:out value='${media.fileSize}'/>"
                         data-date="<c:out value='${media.uploadDate}'/>"
                         data-url="<c:out value='${media.fileUrl}'/>"
                         data-album="${media.albumId}"
                         data-person="${media.personId}"
                         data-branch="${media.branchId}"></div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<div id="modalBackdrop" class="modal-backdrop-custom" style="display:none;">
    <div class="modal-box">
        <div class="modal-head">
            <h3 id="modalTitle">Thông báo</h3>
            <button id="modalCloseBtn" class="modal-close" type="button">&times;</button>
        </div>
        <div class="modal-body">
            <div id="modalMessage" class="modal-message"></div>
            <div id="albumFormBox" style="display:none;">
                <label>Ảnh đại diện album <span>*</span></label>
                <label class="cover-picker">
                    <input id="albumCoverInput" type="file" accept="image/*">
                    <div id="albumCoverPreview" class="cover-preview"><i class="fa fa-picture-o"></i><p>Bấm để chọn ảnh</p></div>
                </label>
                <label>Tên album <span>*</span></label>
                <input id="albumNameInput" class="modal-input" type="text" placeholder="Nhập tên album">
                <label>Mô tả</label>
                <textarea id="albumDescInput" class="modal-input" rows="4" placeholder="Nhập mô tả."></textarea>
            </div>
        </div>
        <div class="modal-foot">
            <button id="modalCancelBtn" class="modal-btn cancel" type="button">Hủy bỏ</button>
            <button id="modalOkBtn" class="modal-btn ok" type="button">Xác nhận</button>
        </div>
    </div>
</div>

<div id="previewBackdrop" class="preview-backdrop" style="display:none;">
    <div class="preview-box">
        <div class="preview-head">
            <h3 id="previewTitle">Xem tệp</h3>
            <button id="previewCloseBtn" class="modal-close" type="button">&times;</button>
        </div>
        <div id="previewBody" class="preview-body"></div>
    </div>
</div>

<script>
var canUpload = false;
<security:authorize access="hasAnyRole('MANAGER','EDITOR')">canUpload = true;</security:authorize>
var currentFamilyTreeId = Number('${empty currentFamilyTreeId ? 0 : currentFamilyTreeId}');

var state = { view: 'list', perPage: 10, search: '', tab: 'photos', albumId: null, albums: [], mediaItems: [] };
var modal = { resolve: null, coverFile: null };

function n(v) { return String(v || '').trim(); }
function h(v) { return String(v || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;'); }

function parseAlbums() {
    var albums = [];
    document.querySelectorAll('#albumSeed .seed-album').forEach(function (x) {
        var id = Number(x.dataset.id || 0);
        if (!id) return;
        albums.push({
            id: id,
            name: n(x.dataset.name),
            description: n(x.dataset.description),
            cover: n(x.dataset.cover),
            personId: x.dataset.person && x.dataset.person !== 'null' ? Number(x.dataset.person) : null,
            branchId: x.dataset.branch && x.dataset.branch !== 'null' ? Number(x.dataset.branch) : null,
            items: []
        });
    });
    return albums;
}

function parseMedia() {
    var items = [];
    document.querySelectorAll('#mediaSeed .seed-media').forEach(function (x) {
        items.push({
            id: Number(x.dataset.id || 0),
            fileName: n(x.dataset.name),
            mediaType: n(x.dataset.type).toUpperCase(),
            fileSize: n(x.dataset.size),
            uploadDate: n(x.dataset.date),
            fileUrl: n(x.dataset.url),
            albumId: x.dataset.album && x.dataset.album !== 'null' ? Number(x.dataset.album) : null,
            personId: x.dataset.person && x.dataset.person !== 'null' ? Number(x.dataset.person) : null,
            branchId: x.dataset.branch && x.dataset.branch !== 'null' ? Number(x.dataset.branch) : null
        });
    });
    return items.filter(function (i) { return i.id > 0 && i.fileUrl; });
}

function mapUploadedItem(dto, ctx) {
    return {
        id: Number(dto.id || 0),
        fileName: n(dto.fileName),
        mediaType: n(dto.mediaType).toUpperCase(),
        fileSize: n(dto.fileSize),
        uploadDate: n(dto.uploadDate),
        fileUrl: n(dto.fileUrl),
        albumId: dto.albumId != null ? Number(dto.albumId) : (ctx && ctx.albumId ? Number(ctx.albumId) : null),
        personId: dto.personId != null ? Number(dto.personId) : (ctx && ctx.personId ? Number(ctx.personId) : null),
        branchId: dto.branchId != null ? Number(dto.branchId) : (ctx && ctx.branchId ? Number(ctx.branchId) : null)
    };
}

function cover(a) {
    if (!a.cover) return '<div class="cover-fallback"><i class="fa fa-picture-o"></i></div>';
    return '<img src="' + h(a.cover) + '" alt="' + h(a.name) + '">';
}

function buildAlbums() {
    var arr = state.albums.map(function (a) {
        return { id: a.id, name: a.name, description: a.description, cover: a.cover, personId: a.personId, branchId: a.branchId, items: [] };
    });
    var map = {};
    arr.forEach(function (a) { map[a.id] = a; });
    var common = { id: 0, name: 'Thư viện chung', description: 'Các tệp chưa gắn album', cover: '', items: [] };

    state.mediaItems.forEach(function (m) {
        if (m.albumId && map[m.albumId]) map[m.albumId].items.push(m);
        else common.items.push(m);
    });
    if (common.items.length) arr.push(common);

    arr.forEach(function (a) {
        if (!a.cover && a.items.length) a.cover = a.items[0].fileUrl;
        a.total = a.items.length;
    });
    return arr.sort(function (a, b) { return b.total - a.total; });
}

function current() { return buildAlbums().find(function (a) { return a.id === state.albumId; }) || null; }

function renderList() {
    var list = buildAlbums().filter(function (a) { return a.name.toLowerCase().indexOf(state.search.toLowerCase()) >= 0; }).slice(0, state.perPage);
    var g = document.getElementById('albumGrid');
    var e = document.getElementById('albumEmpty');
    if (!list.length) { g.innerHTML = ''; e.style.display = 'block'; return; }
    e.style.display = 'none';
    g.innerHTML = list.map(function (a) {
        var manageActions = canUpload
            ? '<div class="mini-actions"><button class="icon-btn edit" data-open="1" type="button"><i class="fa fa-pencil"></i></button><button class="icon-btn danger" data-del-album="1" type="button"><i class="fa fa-trash"></i></button></div>'
            : '';
        return '<div class="album-item" data-id="' + a.id + '"><div class="album-thumb">' + cover(a) + '</div><div class="album-body"><p class="name">' + h(a.name || 'Album') + '</p><p class="desc">' + h(a.description || '') + '</p><div class="album-foot"><a href="#" data-open="1">Chi tiết →</a>' + manageActions + '</div></div></div>';
    }).join('');
}

function renderDetail() {
    var a = current();
    if (!a) { state.view = 'list'; switchView(); return; }
    document.getElementById('albumCover').innerHTML = cover(a);
    document.getElementById('albumName').textContent = a.name;
    document.getElementById('albumDesc').textContent = a.description || ('Tổng ' + a.total + ' tệp');
    var deleteAlbumBtn = document.getElementById('deleteAlbumBtn');
    var addPhotoBtn = document.getElementById('addPhotoBtn');
    var addVideoBtn = document.getElementById('addVideoBtn');
    if (deleteAlbumBtn) {
        deleteAlbumBtn.style.display = canUpload && a.id > 0 ? 'inline-flex' : 'none';
    }
    if (addPhotoBtn) {
        addPhotoBtn.style.display = canUpload && state.tab === 'photos' ? 'inline-flex' : 'none';
    }
    if (addVideoBtn) {
        addVideoBtn.style.display = canUpload && state.tab === 'videos' ? 'inline-flex' : 'none';
    }

    var list = a.items.filter(function (i) { return state.tab === 'photos' ? i.mediaType === 'IMAGE' : i.mediaType !== 'IMAGE'; });
    var g = document.getElementById('albumMediaGrid');
    var e = document.getElementById('albumMediaEmpty');
    if (!list.length) { g.innerHTML = ''; e.style.display = 'block'; return; }
    e.style.display = 'none';
    g.innerHTML = list.map(function (i) {
        var p = i.mediaType === 'VIDEO'
            ? '<video muted preload="metadata"><source src="' + h(i.fileUrl) + '"></video>'
            : (i.mediaType === 'AUDIO' ? '<div class="audio-fallback"><i class="fa fa-music"></i></div>' : '<img src="' + h(i.fileUrl) + '" alt="' + h(i.fileName) + '">');
        var del = canUpload ? '<button class="action-btn danger" data-del-media="' + i.id + '" type="button"><i class="fa fa-trash"></i> Xóa</button>' : '';
        return '<div class="media-item"><div class="media-thumb" data-view="' + i.id + '">' + p + '</div><div class="media-meta"><span title="' + h(i.fileName) + '">' + h(i.fileName || ('Tệp #' + i.id)) + '</span><div class="media-actions"><button class="action-btn view" data-view="' + i.id + '" type="button"><i class="fa fa-eye"></i> Xem</button><button class="action-btn download" data-download="' + i.id + '" type="button"><i class="fa fa-download"></i> Tải</button>' + del + '</div></div></div>';
    }).join('');
}

function switchView() {
    document.getElementById('libraryListView').style.display = state.view === 'list' ? '' : 'none';
    document.getElementById('libraryDetailView').style.display = state.view === 'detail' ? '' : 'none';
    if (state.view === 'list') renderList(); else renderDetail();
}

function openM(o) {
    o = o || {};
    document.getElementById('modalTitle').textContent = o.title || 'Thông báo';
    document.getElementById('modalMessage').innerHTML = o.message || '';
    document.getElementById('albumFormBox').style.display = o.form ? '' : 'none';
    document.getElementById('modalOkBtn').textContent = o.okText || 'Xác nhận';
    document.getElementById('modalCancelBtn').style.display = o.hideCancel ? 'none' : '';
    document.getElementById('modalBackdrop').style.display = 'flex';
    return new Promise(function (r) { modal.resolve = r; });
}

function closeM(v) {
    document.getElementById('modalBackdrop').style.display = 'none';
    if (modal.resolve) {
        var r = modal.resolve;
        modal.resolve = null;
        r(v);
    }
}

function info(msg) { return openM({ title: 'Thông báo', message: '<p>' + h(msg) + '</p>', okText: 'Đóng', hideCancel: true }); }
function ask(msg, title) { return openM({ title: title || 'Xác nhận', message: '<p>' + h(msg) + '</p>', okText: 'Xác nhận' }); }

function openPreview(it) {
    if (!it) return;
    document.getElementById('previewTitle').textContent = it.fileName || ('Tệp #' + it.id);
    var body = document.getElementById('previewBody');
    if (it.mediaType === 'VIDEO') body.innerHTML = '<video controls autoplay src="' + h(it.fileUrl) + '"></video>';
    else if (it.mediaType === 'AUDIO') body.innerHTML = '<div class="audio-preview"><i class="fa fa-music"></i><audio controls autoplay src="' + h(it.fileUrl) + '"></audio></div>';
    else body.innerHTML = '<img src="' + h(it.fileUrl) + '" alt="' + h(it.fileName) + '">';
    document.getElementById('previewBackdrop').style.display = 'flex';
}

function closePreview() {
    document.getElementById('previewBackdrop').style.display = 'none';
    document.getElementById('previewBody').innerHTML = '';
}

function upload(fs, ctx, displayNames) {
    if (!canUpload || !fs || !fs.length) return Promise.resolve([]);
    var fd = new FormData();
    Array.prototype.forEach.call(fs, function (f, idx) {
        fd.append('files', f);
        var fallback = String(f.name || '').replace(/\.[^/.]+$/, '');
        var custom = displayNames && displayNames[idx] ? String(displayNames[idx]).trim() : '';
        fd.append('displayNames', custom || fallback);
        fd.append('visibilityScopes', 'PUBLIC');
    });
    if (currentFamilyTreeId > 0) fd.append('familyTreeId', currentFamilyTreeId);
    if (ctx && ctx.albumId) fd.append('albumId', ctx.albumId);
    if (ctx && ctx.personId) fd.append('personId', ctx.personId);
    if (ctx && ctx.branchId) fd.append('branchId', ctx.branchId);
    return fetch('/api/media/upload', { method: 'POST', body: fd }).then(function (res) {
        if (!res.ok) return res.text().then(function (t) { throw new Error(t || 'Tải lên thất bại'); });
        return res.json();
    });
}

function askDisplayNames(fs, title) {
    if (!fs || !fs.length) return Promise.resolve([]);
    var html = '<div><p>Đặt tên cho từng tệp trước khi tải lên.</p>';
    Array.prototype.forEach.call(fs, function (f, idx) {
        var base = String(f.name || '').replace(/\.[^/.]+$/, '');
        html += '<input class="modal-input js-upload-name" data-idx="' + idx + '" value="' + h(base) + '" placeholder="Nhập tên ảnh/video">';
    });
    html += '</div>';
    return openM({ title: title || 'Đặt tên tệp', message: html, okText: 'Tải lên' }).then(function (r) {
        if (!r || !r.confirmed) return null;
        var names = [];
        document.querySelectorAll('.js-upload-name').forEach(function (inp) {
            var idx = Number(inp.getAttribute('data-idx') || 0);
            names[idx] = n(inp.value);
        });
        return names;
    });
}

function pick(acc, multi, cb) {
    var i = document.createElement('input');
    i.type = 'file';
    i.accept = acc || '*/*';
    i.multiple = !!multi;
    i.style.display = 'none';
    document.body.appendChild(i);
    i.addEventListener('change', function () {
        if (i.files && i.files.length) cb(i.files);
        document.body.removeChild(i);
    });
    i.click();
}

function createAlbum() {
    if (!canUpload) return;
    document.getElementById('albumNameInput').value = '';
    document.getElementById('albumDescInput').value = '';
    document.getElementById('albumCoverInput').value = '';
    document.getElementById('albumCoverPreview').innerHTML = '<i class="fa fa-picture-o"></i><p>Bấm để chọn ảnh</p>';
    document.getElementById('albumCoverPreview').classList.remove('has-image');
    modal.coverFile = null;

    openM({ title: 'Thêm album', form: true, okText: 'Lưu lại' }).then(function (r) {
        if (!r || !r.confirmed) return;
        var name = n(document.getElementById('albumNameInput').value);
        var desc = n(document.getElementById('albumDescInput').value);
        if (!name) { info('Tên album không được để trống.'); return; }
        var fd = new FormData();
        fd.append('name', name);
        fd.append('description', desc);
        fd.append('accessScope', 'PUBLIC');
        if (currentFamilyTreeId > 0) fd.append('familyTreeId', currentFamilyTreeId);
        fetch('/api/media/albums', { method: 'POST', body: fd })
            .then(function (res) { if (!res.ok) return res.text().then(function (t) { throw new Error(t || 'Tạo album thất bại'); }); return res.json(); })
            .then(function (a) { if (!modal.coverFile) return a; return upload([modal.coverFile], { albumId: Number(a.id) }).then(function () { return a; }); })
            .then(function () { window.location.reload(); })
            .catch(function (err) { info(err.message || 'Không thể tạo album.'); });
    });
}

function delAlbum(id) {
    if (!canUpload) return;
    ask('Bạn có chắc muốn xóa album này không? Tất cả ảnh/video bên trong cũng sẽ bị xóa vĩnh viễn.', 'Xóa album')
        .then(function (r) {
            if (!r || !r.confirmed) return;
            fetch('/api/media/albums/' + encodeURIComponent(id), { method: 'DELETE' })
                .then(function (res) { if (!res.ok) return res.text().then(function (t) { throw new Error(t || 'Xóa album thất bại'); }); })
                .then(function () {
                    state.albums = state.albums.filter(function (a) { return a.id !== id; });
                    state.mediaItems = state.mediaItems.filter(function (m) { return m.albumId !== id; });
                    state.view = 'list';
                    state.albumId = null;
                    switchView();
                })
                .catch(function (err) { info(err.message || 'Không thể xóa album.'); });
        });
}

function delMedia(id) {
    if (!canUpload) return;
    ask('Bạn có chắc muốn xóa tệp này không?', 'Xóa tệp')
        .then(function (r) {
            if (!r || !r.confirmed) return;
            fetch('/api/media/' + encodeURIComponent(id), { method: 'DELETE' })
                .then(function (res) { if (!res.ok) return res.text().then(function (t) { throw new Error(t || 'Xóa tệp thất bại'); }); })
                .then(function () {
                    state.mediaItems = state.mediaItems.filter(function (m) { return m.id !== id; });
                    renderDetail();
                    renderList();
                })
                .catch(function (err) { info(err.message || 'Không thể xóa tệp.'); });
        });
}

function bind() {
    document.getElementById('perPageSelect').addEventListener('change', function (e) { state.perPage = Number(e.target.value || 10); renderList(); });
    document.getElementById('albumSearchInput').addEventListener('input', function (e) { state.search = n(e.target.value); renderList(); });
    document.getElementById('albumSearchBtn').addEventListener('click', renderList);
    document.getElementById('albumRefreshBtn').addEventListener('click', function () { window.location.reload(); });

    document.getElementById('addLibraryBtn') && document.getElementById('addLibraryBtn').addEventListener('click', createAlbum);
    document.getElementById('albumGrid').addEventListener('click', function (e) {
        var card = e.target.closest('.album-item');
        if (!card) return;
        if (e.target.closest('[data-del-album]')) {
            var idd = Number(card.getAttribute('data-id') || 0);
            if (idd > 0) delAlbum(idd);
            return;
        }
        if (!e.target.closest('[data-open]')) return;
        state.albumId = Number(card.getAttribute('data-id') || 0);
        state.tab = 'photos';
        document.getElementById('photoTabBtn').classList.add('active');
        document.getElementById('videoTabBtn').classList.remove('active');
        state.view = 'detail';
        switchView();
    });

    document.getElementById('backToListBtn').addEventListener('click', function () { state.view = 'list'; switchView(); });
    document.getElementById('photoTabBtn').addEventListener('click', function () { state.tab = 'photos'; this.classList.add('active'); document.getElementById('videoTabBtn').classList.remove('active'); renderDetail(); });
    document.getElementById('videoTabBtn').addEventListener('click', function () { state.tab = 'videos'; this.classList.add('active'); document.getElementById('photoTabBtn').classList.remove('active'); renderDetail(); });

    document.getElementById('addPhotoBtn') && document.getElementById('addPhotoBtn').addEventListener('click', function () {
        var a = current();
        var ctx = a ? { albumId: a.id, personId: a.personId, branchId: a.branchId } : {};
        pick('image/*', true, function (fs) {
            askDisplayNames(fs, 'Đặt tên ảnh')
                .then(function (names) { if (!names) return; return upload(fs, ctx, names); })
                .then(function (items) {
                    if (!items) return;
                    (items || []).forEach(function (dto) {
                        var mapped = mapUploadedItem(dto, ctx);
                        if (mapped.id > 0) state.mediaItems.unshift(mapped);
                    });
                    renderDetail();
                    renderList();
                })
                .catch(function (err) { info(err.message || 'Không thể tải ảnh lên.'); });
        });
    });

    document.getElementById('addVideoBtn') && document.getElementById('addVideoBtn').addEventListener('click', function () {
        var a = current();
        var ctx = a ? { albumId: a.id, personId: a.personId, branchId: a.branchId } : {};
        pick('video/*,audio/*', true, function (fs) {
            askDisplayNames(fs, 'Đặt tên video')
                .then(function (names) { if (!names) return; return upload(fs, ctx, names); })
                .then(function (items) {
                    if (!items) return;
                    (items || []).forEach(function (dto) {
                        var mapped = mapUploadedItem(dto, ctx);
                        if (mapped.id > 0) state.mediaItems.unshift(mapped);
                    });
                    renderDetail();
                    renderList();
                })
                .catch(function (err) { info(err.message || 'Không thể tải video lên.'); });
        });
    });

    document.getElementById('deleteAlbumBtn') && document.getElementById('deleteAlbumBtn').addEventListener('click', function () {
        var a = current();
        if (a && a.id > 0) delAlbum(a.id);
    });

    document.getElementById('albumMediaGrid').addEventListener('click', function (e) {
        var v = e.target.closest('[data-view]');
        if (v) {
            var idv = Number(v.getAttribute('data-view') || 0);
            var m = state.mediaItems.find(function (x) { return x.id === idv; });
            openPreview(m);
            return;
        }
        var d = e.target.closest('[data-download]');
        if (d) {
            var dd = Number(d.getAttribute('data-download') || 0);
            if (dd > 0) window.open('/api/media/' + encodeURIComponent(dd) + '/download', '_blank');
            return;
        }
        var del = e.target.closest('[data-del-media]');
        if (del) {
            var idm = Number(del.getAttribute('data-del-media') || 0);
            if (idm > 0) delMedia(idm);
        }
    });

    document.getElementById('modalCloseBtn').addEventListener('click', function () { closeM({ confirmed: false }); });
    document.getElementById('modalCancelBtn').addEventListener('click', function () { closeM({ confirmed: false }); });
    document.getElementById('modalOkBtn').addEventListener('click', function () { closeM({ confirmed: true }); });
    document.getElementById('modalBackdrop').addEventListener('click', function (e) { if (e.target === document.getElementById('modalBackdrop')) closeM({ confirmed: false }); });

    document.getElementById('albumCoverInput').addEventListener('change', function () {
        var f = this.files && this.files[0];
        var pv = document.getElementById('albumCoverPreview');
        modal.coverFile = f || null;
        if (!f) {
            pv.innerHTML = '<i class="fa fa-picture-o"></i><p>Bấm để chọn ảnh</p>';
            pv.classList.remove('has-image');
            pv.style.backgroundImage = 'none';
            return;
        }
        var rd = new FileReader();
        rd.onload = function (ev) {
            pv.innerHTML = '';
            pv.style.backgroundImage = 'url("' + ev.target.result + '")';
            pv.classList.add('has-image');
        };
        rd.readAsDataURL(f);
    });

    document.getElementById('previewCloseBtn').addEventListener('click', closePreview);
    document.getElementById('previewBackdrop').addEventListener('click', function (e) {
        if (e.target === document.getElementById('previewBackdrop')) closePreview();
    });
}

state.albums = parseAlbums();
state.mediaItems = parseMedia();
bind();
switchView();
</script>
