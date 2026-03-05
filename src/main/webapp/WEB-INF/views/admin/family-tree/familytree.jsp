<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<title>Cây gia phả</title>
<!-- Icons (Bootstrap Icons) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

<link rel="stylesheet" href="assets/css/family-tree-page.css" />

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
        <div class="ft-canvas">
            <!-- LEFT TOOLBAR (Zoom) -->
            <div class="ft-toolbar-left">
                <button id="zoomIn" class="btn btn-sm btn-light" title="Phóng to"><i class="bi bi-zoom-in"></i></button>
                <div id="zoomLabel" class="text-secondary small fw-semibold">100%</div>
                <button id="zoomOut" class="btn btn-sm btn-light" title="Thu nhỏ"><i class="bi bi-zoom-out"></i></button>
                <div class="w-100 my-1" style="height:1px;background:#f1f5f9;"></div>
                <button id="zoomReset" class="btn btn-sm btn-light" title="Đặt lại"><i class="bi bi-aspect-ratio"></i></button>
            </div>

            <!-- RIGHT TOOLBAR -->
            <div class="ft-toolbar-right">
                <div class="dropdown" id="branchDropdown">
                    <button class="btn btn-white border dropdown-toggle d-flex align-items-center gap-2 filter-chip" type="button">
                        <i class="bi bi-diagram-3" style="color:#16a34a"></i>
                        <span id="activeBranchLabel">Tất cả các chi</span>
                    </button>
                    <ul id="branchMenu" class="dropdown-menu dropdown-menu-end"></ul>
                </div>

                <div class="dropdown" id="generationDropdown">
                    <button class="btn btn-white border dropdown-toggle d-flex align-items-center gap-2 filter-chip" type="button">
                        <i class="bi bi-funnel" style="color:#2563eb"></i>
                        <span id="activeGenerationLabel">Tất cả đời</span>
                    </button>
                    <ul id="generationMenu" class="dropdown-menu dropdown-menu-end"></ul>
                </div>
                <div id="advancedFilterBar" class="d-flex align-items-center gap-2" style="flex-wrap: wrap;">
                    <input id="ftFilterName" class="form-control input-sm" style="width: 170px;" placeholder="Tim theo ten..." />
                    <select id="ftFilterGender" class="form-control input-sm" style="width: 120px;">
                        <option value="">Gioi tinh</option>
                        <option value="male">Nam</option>
                        <option value="female">Nu</option>
                        <option value="other">Khac</option>
                    </select>
                    <select id="ftFilterLifeStatus" class="form-control input-sm" style="width: 120px;">
                        <option value="">Tinh trang</option>
                        <option value="alive">Con song</option>
                        <option value="deceased">Da mat</option>
                    </select>
                    <input id="ftFilterBirthYearFrom" type="number" min="1000" max="3000" class="form-control input-sm" style="width: 100px;" placeholder="Nam tu" />
                    <input id="ftFilterBirthYearTo" type="number" min="1000" max="3000" class="form-control input-sm" style="width: 100px;" placeholder="Nam den" />
                    <button id="ftFilterReset" class="btn btn-sm btn-light" type="button">Reset</button>
                </div>
                <% if (canManageMember) { %>
                    <button id="btnCreateFirst" class="btn btn-dark d-flex align-items-center gap-2">
                        <i class="bi bi-person-plus"></i> Tạo thành viên đầu tiên
                    </button>
                <% } %>
            </div>

            <!-- CONTENT -->
            <div id="contentArea" class="ft-scroll">
                <div id="scaleWrap" class="ft-tree-scale">
                    <div class="d-flex justify-content-center">
                        <div id="treeRoot"></div>
                    </div>
                </div>
            </div>

            <!-- LEGEND -->
            <div id="legend" class="ft-legend">
                <span class="text-uppercase text-secondary fw-bold" style="font-size: 11px; letter-spacing: .12em;">Giới tính</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-male">♂</span> Nam</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-female">♀</span> Nữ</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-other">⚥</span> Khác</span>
                <span style="width:1px;height:16px;background:#e5e7eb;"></span>
                <span class="d-inline-flex align-items-center gap-2">
                    <span style="width:22px;border-top:2px dashed #f9a8d4;"></span> Vợ / Chồng
                </span>
                <span style="width:1px;height:16px;background:#e5e7eb;"></span>
                <span class="d-inline-flex align-items-center gap-2">
                    <span style="width:1px;height:14px;background:#6b7280;"></span> Con cái
                </span>
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
        let BRANCH_ID = 1;
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
            const dd = document.getElementById('generationDropdown');
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
        let CURRENT_GENERATION_FILTER = null;
        let CURRENT_NAME_FILTER = '';
        let CURRENT_GENDER_FILTER = '';
        let CURRENT_LIFE_STATUS_FILTER = '';
        let CURRENT_BIRTH_YEAR_FROM = null;
        let CURRENT_BIRTH_YEAR_TO = null;
        const EXISTING_PERSON_CACHE = {
            m: [],
            a: []
        };

        function setBranchFormOptions(branches) {
            const hiddenBranchIds = ['mBranch', 'aBranch'];
            hiddenBranchIds.forEach(function (inputId) {
                const inputEl = document.getElementById(inputId);
                if (!inputEl) return;
                if (inputEl.value == null || inputEl.value === '') {
                    inputEl.value = String(BRANCH_ID);
                }
            });
        }

        function renderBranchMenu(branches, preferredBranchId) {
            const branchMenu = document.getElementById('branchMenu');
            const activeBranchLabel = document.getElementById('activeBranchLabel');
            if (!branchMenu || !activeBranchLabel) return;
            BRANCH_CACHE = Array.isArray(branches) ? branches : [];

            branchMenu.innerHTML = BRANCH_CACHE.map(function (branch) {
                const id = Number(branch.id);
                const name = branch.name || ('Chi ' + id);
                return '<li><button type="button" class="dropdown-item" data-branch-id="' + id + '">' + escapeHtml(name) + '</button></li>';
            }).join('');

            const targetBranchId = preferredBranchId != null ? Number(preferredBranchId) : Number(BRANCH_ID);
            let currentBranch = BRANCH_CACHE.find(function (branch) {
                return Number(branch.id) === targetBranchId;
            });
            if (!currentBranch) {
                currentBranch = BRANCH_CACHE.find(function (branch) {
                    return String(branch.name || '').trim().toLowerCase() === 'chinh';
                });
            }
            if (!currentBranch) {
                currentBranch = branches[0];
            }

            if (currentBranch) {
                BRANCH_ID = Number(currentBranch.id);
                activeBranchLabel.textContent = currentBranch.name || ('Chi ' + currentBranch.id);
                const mBranch = document.getElementById('mBranch');
                const aBranch = document.getElementById('aBranch');
                if (mBranch) mBranch.value = String(BRANCH_ID);
                if (aBranch) aBranch.value = String(BRANCH_ID);
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
                    activeBranchLabel.textContent = selected.name || ('Chi ' + selected.id);
                    CURRENT_GENERATION_FILTER = null;
                    const activeGenerationLabel = document.getElementById('activeGenerationLabel');
                    if (activeGenerationLabel) {
                        activeGenerationLabel.textContent = 'Tất cả đời';
                    }
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = String(nextBranchId);
                    if (aBranch) aBranch.value = String(nextBranchId);
                    branchMenu.classList.remove('show');
                    loadRootPersons();
                });
            }
        }

        function getMaxGeneration(person) {
            if (!person) return 1;
            let maxGen = Number(person.generation || 1);
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

        function renderGenerationMenu(maxGeneration) {
            const generationMenu = document.getElementById('generationMenu');
            const activeGenerationLabel = document.getElementById('activeGenerationLabel');
            if (!generationMenu || !activeGenerationLabel) return;

            const maxGen = Math.max(1, Number(maxGeneration || 1));
            if (CURRENT_GENERATION_FILTER != null && Number(CURRENT_GENERATION_FILTER) > maxGen) {
                CURRENT_GENERATION_FILTER = null;
            }
            let html = '<li><button type="button" class="dropdown-item" data-generation="">Tất cả đời</button></li>';
            for (let gen = 1; gen <= maxGen; gen++) {
                html += '<li><button type="button" class="dropdown-item" data-generation="' + gen + '">Đời ' + gen + '</button></li>';
            }
            generationMenu.innerHTML = html;
            activeGenerationLabel.textContent = CURRENT_GENERATION_FILTER ? ('Đời ' + CURRENT_GENERATION_FILTER) : 'Tất cả đời';

            if (generationMenu.dataset.boundGenerationClick !== 'true') {
                generationMenu.dataset.boundGenerationClick = 'true';
                generationMenu.addEventListener('click', function (e) {
                    const target = e.target.closest('[data-generation]');
                    if (!target) return;
                    const value = target.getAttribute('data-generation');
                    CURRENT_GENERATION_FILTER = value ? Number(value) : null;
                    activeGenerationLabel.textContent = CURRENT_GENERATION_FILTER ? ('Đời ' + CURRENT_GENERATION_FILTER) : 'Tất cả đời';
                    generationMenu.classList.remove('show');
                    applyGenerationFilterAndRender();
                });
            }
        }

        async function loadBranches(preferredBranchId) {
            try {
                const res = await fetch('/api/branch');
                if (!res.ok) return;
                const branches = await res.json();
                if (!Array.isArray(branches) || branches.length === 0) return;
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
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '');
        }

        function getBirthYearFromDateString(dateStr) {
            if (!dateStr || typeof dateStr !== 'string') return null;
            const parts = dateStr.split('-');
            if (parts.length !== 3) return null;
            const year = Number(parts[0]);
            return Number.isFinite(year) ? year : null;
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
            const normalizedNameFilter = normalizeSearchText(CURRENT_NAME_FILTER).trim();
            const fullName = normalizeSearchText(person.fullName || '');
            const spouseName = normalizeSearchText(person.spouseFullName || '');
            if (normalizedNameFilter) {
                const nameMatched = fullName.indexOf(normalizedNameFilter) >= 0
                    || spouseName.indexOf(normalizedNameFilter) >= 0;
                if (!nameMatched) return false;
            }

            if (CURRENT_GENDER_FILTER) {
                const g = String(person.gender || '').toLowerCase();
                if (g !== CURRENT_GENDER_FILTER) return false;
            }

            if (CURRENT_LIFE_STATUS_FILTER) {
                const hasDod = !!person.dod;
                if (CURRENT_LIFE_STATUS_FILTER === 'alive' && hasDod) return false;
                if (CURRENT_LIFE_STATUS_FILTER === 'deceased' && !hasDod) return false;
            }

            const birthYear = getBirthYearFromDateString(person.dob || '');
            if (CURRENT_BIRTH_YEAR_FROM != null) {
                if (birthYear == null || birthYear < CURRENT_BIRTH_YEAR_FROM) return false;
            }
            if (CURRENT_BIRTH_YEAR_TO != null) {
                if (birthYear == null || birthYear > CURRENT_BIRTH_YEAR_TO) return false;
            }

            return true;
        }

        function hasAdvancedFilter() {
            return !!(CURRENT_NAME_FILTER
                || CURRENT_GENDER_FILTER
                || CURRENT_LIFE_STATUS_FILTER
                || CURRENT_BIRTH_YEAR_FROM != null
                || CURRENT_BIRTH_YEAR_TO != null);
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
                const spouseId = Number(person.spouseId || 0);
                if (spouseId) consumed.add(spouseId);
            });
            return result;
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

        function fillActionFormFromExisting(person) {
            if (!person) return;
            if (actionState.mode === 'add-spouse') {
                const normalized = String(person.gender || '').toLowerCase();
                if (normalized !== 'female') {
                    showToast('Chỉ được chọn thành viên nữ để thêm vợ', 'error');
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
                document.getElementById('generationMenu')?.classList.remove('show');
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
                    const rootRes = await fetch('/api/person/roots?branchId=' + encodeURIComponent(BRANCH_ID));
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

        function setActionGender(gender) {
            const target = gender || '';
            document.getElementById('aGender').value = target;
            document.querySelectorAll('#actionGenderGrid .gender-choice').forEach(function (btn) {
                btn.classList.toggle('active', btn.getAttribute('data-gender') === target);
            });
        }

        function setActionGenderMode(mode) {
            const spouseMode = mode === 'add-spouse';
            document.querySelectorAll('#actionGenderGrid .gender-choice').forEach(function (btn) {
                const value = btn.getAttribute('data-gender');
                const disabled = spouseMode && value !== 'female';
                btn.disabled = disabled;
                btn.style.opacity = disabled ? '0.45' : '1';
                btn.style.pointerEvents = disabled ? 'none' : '';
            });
            if (spouseMode) {
                setActionGender('female');
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

            let title = 'Thêm thành viên';
            let icon = 'bi-person-plus';
            let defaultGen = generation;
            let defaultGender = '';

            if (mode === 'add-spouse') {
                title = 'Thêm vợ - ' + fullName;
                icon = 'bi-person-plus';
                defaultGen = generation;
                defaultGender = 'female';
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
            document.getElementById('aBranch').value = String(BRANCH_ID);
            if (mode === 'add-child') {
                document.getElementById('aBranchName').value = 'Tự động: con đời 1 sẽ là chi 1, 2, 3...';
            } else if (mode === 'add-spouse') {
                document.getElementById('aBranchName').value = 'Tự động: cùng chi với chồng';
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
            document.getElementById('aExistingGenderFilter').value = mode === 'add-spouse' ? 'female' : '';
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
            if (mode === 'add-spouse' && payload.gender && payload.gender.toLowerCase() !== 'female') {
                showToast('Chi duoc phep them vo co gioi tinh nu', 'error');
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
                    showToast('Thêm vợ thành công', 'success');
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
                    showToast('Chi duoc phep them con trong chi 1 hoac chi 2', 'error');
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
            const normalized = String(branchName || '').trim();
            return normalized === '1' || normalized === '2';
        }

        function sanitizeAvatarUrl(url, fallbackName) {
            const fallback = 'https://ui-avatars.com/api/?name=' + encodeURIComponent(fallbackName || 'Unknown') + '&background=e5e7eb&color=111827';
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
            const childrenText = children.length > 0
                ? children.map(function (child) {
                    const childName = escapeHtml(child.fullName || 'Chưa có tên');
                    const childGen = child.generation != null ? ('Đời ' + child.generation) : '';
                    return '<span class="badge" style="background:#f3f4f6;color:#111827;margin:2px;padding:4px 8px;border-radius:999px;">'
                        + childName + (childGen ? ' (' + childGen + ')' : '') + '</span>';
                }).join(' ')
                : '--';

            body.innerHTML = ''
                + '<div class="row g-3">'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Họ và tên</div><div>' + formatOptionalText(person.fullName) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Giới tính</div><div>' + getGenderLabel(person.gender) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Ngày sinh</div><div>' + formatOptionalText(formatDate(person.dob || '')) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Ngày mất</div><div>' + formatOptionalText(formatDate(person.dod || '')) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Đời</div><div>' + formatOptionalText(person.generation) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Chi</div><div>' + formatOptionalText(person.branchName) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Quê quán</div><div>' + formatOptionalText(person.hometown) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Nơi ở hiện tại (mộ phần)</div><div>' + formatOptionalText(person.currentResidence) + '</div></div>'
                + '  <div class="col-md-6"><div class="form-label fw-semibold">Nghề nghiệp</div><div>' + formatOptionalText(person.occupation) + '</div></div>'
                + '  <div class="col-12"><div class="form-label fw-semibold">Ghi chú khác</div><div>' + formatOptionalText(person.otherNote) + '</div></div>'
                + '  <div class="col-12"><div class="form-label fw-semibold">Con</div><div>' + childrenText + '</div></div>'
                + '</div>';

            if (!canManageMember) {
                actions.innerHTML = '<button type="button" class="btn btn-link text-secondary" data-close="detailMemberModal">Đóng</button>';
                return;
            }

            const canAddSpouse = String(person.gender || '').toLowerCase() === 'male' && !person.spouseId;
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

        function buildPersonCard(person, options) {
            const opts = options || {};
            const isSpouse = !!opts.isSpouse;
            const personIdRaw = Number(person.id);
            const personId = Number.isFinite(personIdRaw) ? personIdRaw : 0;
            const rawGender = String(person.gender || 'other').toLowerCase();
            const gender = (rawGender === 'male' || rawGender === 'female' || rawGender === 'other') ? rawGender : 'other';
            const genderClass = gender === 'male' ? 'bg-male' : (gender === 'female' ? 'bg-female' : 'bg-other');
            const genderSymbol = gender === 'male' ? '\u2642' : (gender === 'female' ? '\u2640' : '\u26A5');
            const ringClass = gender === 'male' ? 'ring-male' : (gender === 'female' ? 'ring-female' : 'ring-other');
            const generationParsed = Number(person.generation);
            const generation = Number.isFinite(generationParsed) && generationParsed > 0 ? generationParsed : 1;
            const branchName = person.branchName || 'Chưa có chi';
            const fullName = person.fullName || 'Chưa có tên';
            const avatar = sanitizeAvatarUrl(person.avatar, fullName);
            const safeFullName = escapeHtml(fullName);
            const safeBranchName = escapeHtml(branchName);
            const dobText = escapeHtml(formatDate(person.dob));
            const dodText = escapeHtml(formatDate(person.dod));
            const encodedName = encodeURIComponent(fullName);
            const encodedAvatar = encodeURIComponent(avatar);
            const encodedDob = encodeURIComponent(person.dob || '');
            const encodedDod = encodeURIComponent(person.dod || '');
            const hasSpouse = !!person.spouseId;

            let menuItems = '';
            if (canManageMember) {
                menuItems = ''
                    + '<button type="button" class="btn-blue" data-action="edit-member"><i class="bi bi-pencil"></i> Sửa thông tin</button>'
                    + '<button type="button" class="btn-red" data-action="delete-member"><i class="bi bi-trash"></i> Xóa</button>';
                if (gender === 'male' && !hasSpouse) {
                    menuItems = '<button type="button" class="btn-amber" data-action="add-spouse"><i class="bi bi-heart"></i> Thêm vợ</button>' + menuItems;
                }
                if (gender === 'male' && canAddChildInBranch(branchName)) {
                    menuItems = '<button type="button" class="btn-emerald" data-action="add-child"><i class="bi bi-person-plus"></i> Thêm con</button>' + menuItems;
                }
            }

            return '' +
                '<div class="person-card' + (isSpouse ? ' spouse' : '') + '" data-id="' + personId + '" data-full-name="' + encodedName + '" data-generation="' + generation + '" data-gender="' + gender + '" data-avatar="' + encodedAvatar + '" data-dob="' + encodedDob + '" data-dod="' + encodedDod + '" data-has-spouse="' + (hasSpouse ? '1' : '0') + '">' +
                    '<div class="badge-gender ' + genderClass + '">' + genderSymbol + '</div>' +
                    '<div class="d-flex align-items-center gap-2">' +
                        '<img class="avatar ' + ringClass + '" src="' + escapeHtml(avatar) + '" alt="' + safeFullName + '" onerror="this.src=\'https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName) + '&background=e5e7eb&color=111827\'" />' +
                        '<div>' +
                            '<p class="person-name">' + safeFullName + '</p>' +
                            '<p class="person-meta">Chi: ' + safeBranchName + '</p>' +
                            '<p class="person-meta">Sinh: ' + (dobText || '--') + '</p>' +
                            (dodText ? '<p class="person-meta">Mất: ' + dodText + '</p>' : '') +
                        '</div>' +
                    '</div>' +
                    '<span class="badge-gen">G' + generation + '</span>' +
                    (canManageMember ? ('<div class="card-menu">' + menuItems + '<span class="menu-caret"></span></div>') : '') +
                '</div>';
        }

        function renderTreeNode(person) {
            const spouse = person.spouseId ? {
                id: person.spouseId,
                fullName: person.spouseFullName,
                gender: person.spouseGender,
                generation: person.spouseGeneration || person.generation,
                branchName: person.spouseBranchName || person.branchName,
                avatar: person.spouseAvatar,
                dob: person.spouseDob,
                dod: person.spouseDod,
                spouseId: person.id
            } : null;

            const children = person.children || [];
            let childrenHtml = '';
            if (children.length > 0) {
                const childSlots = children.map(function (child, idx) {
                    return '' +
                        '<div class="child-slot">' +
                            (idx > 0 ? '<div class="hline-left"></div>' : '') +
                            (idx < children.length - 1 ? '<div class="hline-right"></div>' : '') +
                            '<div class="vline" style="height:18px;"></div>' +
                            renderTreeNode(child) +
                        '</div>';
                }).join('');

                childrenHtml =
                    '<div class="vline" style="height:20px;"></div>' +
                    '<div class="children-row">' + childSlots + '</div>';
            }

            return '' +
                '<div class="ft-node">' +
                    '<div class="ft-row">' +
                        buildPersonCard(person, { isSpouse: false }) +
                        (spouse
                            ? '<div class="marriage"><span class="dash"></span><i class="bi bi-heart-fill"></i><span class="dash"></span></div>' + buildPersonCard(spouse, { isSpouse: true })
                            : '') +
                    '</div>' +
                    childrenHtml +
                '</div>';
        }

        function renderForest(roots) {
            if (!Array.isArray(roots) || roots.length === 0) {
                return '';
            }
            return roots.map(function (root) {
                return '<div class="ft-forest-root" style="margin-bottom:24px;">' + renderTreeNode(root) + '</div>';
            }).join('');
        }

        function collectMembersByGeneration(person, generationFilter, result) {
            if (!person) return;
            if (Number(person.generation || 0) === Number(generationFilter)) {
                result.push(person);
            }
            const children = Array.isArray(person.children) ? person.children : [];
            children.forEach(function (child) {
                collectMembersByGeneration(child, generationFilter, result);
            });
        }

        function renderGenerationOnly(members) {
            if (!members || members.length === 0) {
                return '' +
                    '<div class="ft-empty">' +
                    '<div class="fw-semibold">Không có thành viên ở đời này</div>' +
                    '</div>';
            }

            const rows = members.map(function (person) {
                const spouse = person.spouseId ? {
                    id: person.spouseId,
                    fullName: person.spouseFullName,
                    gender: person.spouseGender,
                    generation: person.spouseGeneration || person.generation,
                    branchName: person.spouseBranchName || person.branchName,
                    avatar: person.spouseAvatar,
                    dob: person.spouseDob,
                    dod: person.spouseDod,
                    spouseId: person.id
                } : null;

                return '' +
                    '<div class="ft-row" style="margin:0 12px 16px 12px;">' +
                        buildPersonCard(person, { isSpouse: false }) +
                        (spouse
                            ? '<div class="marriage"><span class="dash"></span><i class="bi bi-heart-fill"></i><span class="dash"></span></div>' + buildPersonCard(spouse, { isSpouse: true })
                            : '') +
                    '</div>';
            }).join('');

            return '<div class="d-flex" style="flex-wrap:wrap;justify-content:center;align-items:flex-start;">' + rows + '</div>';
        }

        function applyGenerationFilterAndRender() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;
            if (!Array.isArray(CURRENT_TREE_ROOTS) || CURRENT_TREE_ROOTS.length === 0) {
                treeRoot.innerHTML = '';
                return;
            }

            if (CURRENT_GENERATION_FILTER == null && !hasAdvancedFilter()) {
                treeRoot.innerHTML = renderForest(CURRENT_TREE_ROOTS);
                return;
            }

            const members = [];
            const seen = new Set();
            CURRENT_TREE_ROOTS.forEach(function (root) {
                if (CURRENT_GENERATION_FILTER == null) {
                    collectMembersFromTree(root, members, seen);
                } else {
                    collectMembersByGeneration(root, CURRENT_GENERATION_FILTER, members);
                }
            });
            const filtered = dedupeMembersForList(members.filter(memberMatchesAdvancedFilters));
            treeRoot.innerHTML = renderGenerationOnly(filtered);
        }

        async function loadRootPersons(options) {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;
            const opts = options || {};
            const forceReload = !!opts.forceReload;

            try {
                const cacheKey = getRootCacheKey(BRANCH_ID);
                let roots = forceReload ? null : ROOT_PERSON_CACHE[cacheKey];
                if (!Array.isArray(roots)) {
                    const res = await fetch("/api/person/roots?branchId=" + encodeURIComponent(BRANCH_ID));
                    if (!res.ok) {
                        treeRoot.innerHTML = '';
                        if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                            await window.ftRefreshCreateFirstVisibility(true, []);
                        }
                        return;
                    }
                    roots = await res.json();
                    ROOT_PERSON_CACHE[cacheKey] = roots;
                }

                const validRoots = Array.isArray(roots)
                    ? roots.filter(function (item) { return item && item.id; })
                    : [];
                if (validRoots.length === 0) {
                    CURRENT_TREE_ROOTS = [];
                    renderGenerationMenu(1);
                    treeRoot.innerHTML = '';
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true, []);
                    }
                    return;
                }
                CURRENT_TREE_ROOTS = validRoots;
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(false, validRoots);
                }
                renderGenerationMenu(getMaxGenerationFromRoots(validRoots));
                applyGenerationFilterAndRender();
            } catch (err) {
                console.error('Load root person failed:', err);
                CURRENT_TREE_ROOTS = [];
                treeRoot.innerHTML = '';
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(true, []);
                }
            }
        }

        function setupPersonCardActions() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || treeRoot.dataset.actionsBound === 'true') return;
            treeRoot.dataset.actionsBound = 'true';

            treeRoot.addEventListener('click', function (e) {
                const card = e.target.closest('.person-card');
                if (!card) return;
                e.stopPropagation();
                const personId = Number(card.getAttribute('data-id') || 0);
                openDetailMemberModal(personId);
            });
        }

        function initZoomControls() {
            const scaleWrap = document.getElementById('scaleWrap');
            const zoomLabel = document.getElementById('zoomLabel');
            const zoomInBtn = document.getElementById('zoomIn');
            const zoomOutBtn = document.getElementById('zoomOut');
            const zoomResetBtn = document.getElementById('zoomReset');
            if (!scaleWrap || !zoomLabel || !zoomInBtn || !zoomOutBtn || !zoomResetBtn) return;

            let currentScale = 1;
            const step = 0.1;
            const minScale = 0.5;
            const maxScale = 2;

            const applyScale = function () {
                scaleWrap.style.transform = 'scale(' + currentScale.toFixed(2) + ')';
                zoomLabel.textContent = Math.round(currentScale * 100) + '%';
                zoomOutBtn.disabled = currentScale <= minScale;
                zoomInBtn.disabled = currentScale >= maxScale;
            };

            zoomInBtn.addEventListener('click', function () {
                currentScale = Math.min(maxScale, currentScale + step);
                applyScale();
            });

            zoomOutBtn.addEventListener('click', function () {
                currentScale = Math.max(minScale, currentScale - step);
                applyScale();
            });

            zoomResetBtn.addEventListener('click', function () {
                currentScale = 1;
                applyScale();
            });

            applyScale();
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

        function bindAdvancedFilters() {
            const nameInput = document.getElementById('ftFilterName');
            const genderSelect = document.getElementById('ftFilterGender');
            const lifeStatusSelect = document.getElementById('ftFilterLifeStatus');
            const yearFromInput = document.getElementById('ftFilterBirthYearFrom');
            const yearToInput = document.getElementById('ftFilterBirthYearTo');
            const resetBtn = document.getElementById('ftFilterReset');
            if (!nameInput || !genderSelect || !lifeStatusSelect || !yearFromInput || !yearToInput || !resetBtn) {
                return;
            }

            const apply = function () {
                CURRENT_NAME_FILTER = String(nameInput.value || '').trim();
                CURRENT_GENDER_FILTER = String(genderSelect.value || '').trim().toLowerCase();
                CURRENT_LIFE_STATUS_FILTER = String(lifeStatusSelect.value || '').trim().toLowerCase();

                const fromYear = Number(yearFromInput.value || '');
                const toYear = Number(yearToInput.value || '');
                CURRENT_BIRTH_YEAR_FROM = Number.isFinite(fromYear) && fromYear > 0 ? fromYear : null;
                CURRENT_BIRTH_YEAR_TO = Number.isFinite(toYear) && toYear > 0 ? toYear : null;
                applyGenerationFilterAndRender();
            };

            nameInput.addEventListener('input', apply);
            genderSelect.addEventListener('change', apply);
            lifeStatusSelect.addEventListener('change', apply);
            yearFromInput.addEventListener('input', apply);
            yearToInput.addEventListener('input', apply);
            resetBtn.addEventListener('click', function () {
                nameInput.value = '';
                genderSelect.value = '';
                lifeStatusSelect.value = '';
                yearFromInput.value = '';
                yearToInput.value = '';
                CURRENT_NAME_FILTER = '';
                CURRENT_GENDER_FILTER = '';
                CURRENT_LIFE_STATUS_FILTER = '';
                CURRENT_BIRTH_YEAR_FROM = null;
                CURRENT_BIRTH_YEAR_TO = null;
                applyGenerationFilterAndRender();
            });
        }

        bindAvatarPicker('mAvatarFile', 'mAvatar');
        bindAvatarPicker('aAvatarFile', 'aAvatar');
        bindAdvancedFilters();
        initZoomControls();
        setupPersonCardActions();

        async function bootstrapFamilyTree() {
            await loadBranches();
            await loadRootPersons();
        }

        bootstrapFamilyTree();
</script>


</div>
        </div>
    </div>
</div>
