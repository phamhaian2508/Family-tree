<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
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
        <div class="ft-filter-strip">
            <!-- RIGHT TOOLBAR -->
            <div class="ft-toolbar-right">
                <div class="dropdown" id="generationDropdown">
                    <button class="btn btn-white border dropdown-toggle d-flex align-items-center gap-2 filter-chip" type="button">
                        <i class="bi bi-funnel" style="color:#2563eb"></i>
                        <span id="activeGenerationLabel">Tất cả đời</span>
                    </button>
                    <ul id="generationMenu" class="dropdown-menu dropdown-menu-end"></ul>
                </div>
                <div id="advancedFilterBar" class="d-flex align-items-center gap-2" style="flex-wrap: wrap;">
                    <div class="ft-filter-field">
                        <label for="ftFilterName" class="ft-filter-label">Họ tên</label>
                        <input id="ftFilterName" class="form-control input-sm" style="width: 280px;" placeholder="Tìm theo tên thành viên..." />
                    </div>
                    <div class="ft-filter-field">
                        <label for="ftFilterDob" class="ft-filter-label">Ngày sinh</label>
                        <input id="ftFilterDob" type="date" class="form-control input-sm" aria-label="Lọc theo ngày sinh" />
                    </div>
                    <div class="ft-filter-field ft-filter-action">
                        <button id="ftFilterReset" class="btn btn-sm btn-light" type="button">Làm mới</button>
                    </div>
                </div>
                <div id="treeQuickStats">
                    <span id="ftStatGenerations" class="ft-stat-chip">0 thế hệ</span>
                    <span id="ftStatMembers" class="ft-stat-chip">0 thành viên</span>
                </div>
                <% if (canManageMember) { %>
                    <button id="btnCreateFirst" class="btn btn-dark d-flex align-items-center gap-2">
                        <i class="bi bi-person-plus"></i> Tạo thành viên đầu tiên
                    </button>
                <% } %>
            </div>
        </div>
        <div class="ft-canvas">
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
        let CURRENT_DOB_FILTER = '';
        let CURRENT_GENDER_FILTER = '';
        let CURRENT_LIFE_STATUS_FILTER = '';
        let CURRENT_BIRTH_YEAR_FROM = null;
        let CURRENT_BIRTH_YEAR_TO = null;
        let CURRENT_FOCUS_PERSON_ID = null;
        let FT_SUPPRESS_CLICK_UNTIL = 0;
        let ACTIVE_BRANCH_NAME = '';
        let FT_RENDER_PENDING = false;
        let FT_FILTER_RENDER_SEQ = 0;
        let FT_FILTER_DEBOUNCE = null;
        const FT_VIEWPORT = {
            initialized: false,
            scale: 1,
            panX: 0,
            panY: 0
        };
        const EXISTING_PERSON_CACHE = {
            m: [],
            a: []
        };

        function isMainBranchName(name) {
            return String(name || '').trim().toLowerCase() === 'chinh';
        }

        function getTreeBranchQueryId() {
            return 0;
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
            const allBranches = Array.isArray(branches) ? branches : [];
            const mainBranch = allBranches.find(function (branch) {
                return isMainBranchName(branch && branch.name);
            });
            const allowedNumbered = allBranches
                .filter(function (branch) {
                    const name = String((branch && branch.name) || '').trim();
                    return name === '1' || name === '2';
                })
                .sort(function (a, b) {
                    return Number(a.id || 0) - Number(b.id || 0);
                });
            BRANCH_CACHE = [];
            if (mainBranch) BRANCH_CACHE.push(mainBranch);
            allowedNumbered.forEach(function (item) {
                if (!BRANCH_CACHE.some(function (x) { return Number(x.id) === Number(item.id); })) {
                    BRANCH_CACHE.push(item);
                }
            });
            if (!BRANCH_CACHE.length) {
                BRANCH_CACHE = allBranches.slice(0, 1);
            }

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
                    return isMainBranchName(branch && branch.name);
                });
            }
            if (!currentBranch) {
                currentBranch = BRANCH_CACHE[0];
            }

            if (currentBranch) {
                BRANCH_ID = Number(currentBranch.id);
                ACTIVE_BRANCH_NAME = String(currentBranch.name || '');
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
                    ACTIVE_BRANCH_NAME = String(selected.name || '');
                    activeBranchLabel.textContent = selected.name || ('Chi ' + selected.id);
                    CURRENT_GENERATION_FILTER = null;
                    CURRENT_FOCUS_PERSON_ID = null;
                    const activeGenerationLabel = document.getElementById('activeGenerationLabel');
                    if (activeGenerationLabel) {
                        activeGenerationLabel.textContent = 'Tất cả đời';
                    }
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = String(nextBranchId);
                    if (aBranch) aBranch.value = String(nextBranchId);
                    branchMenu.classList.remove('show');
                    loadRootPersons({ center: true, centerBranchId: nextBranchId });
                });
            }
        }

        function getMaxGeneration(person) {
            if (!person) return 1;
            const ownGen = getEffectiveGeneration(person);
            const spouseGenParsed = Number(person.spouseGeneration);
            const spouseGen = Number.isFinite(spouseGenParsed) && spouseGenParsed > 0 ? spouseGenParsed : ownGen;
            let maxGen = Math.max(ownGen, spouseGen);
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
                const spouseGenParsed = Number(person && person.spouseGeneration);
                const spouseGen = Number.isFinite(spouseGenParsed) && spouseGenParsed > 0 ? spouseGenParsed : ownGen;
                return Math.max(maxGen, ownGen, spouseGen);
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

        function getRenderedMemberCount() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return 0;
            return treeRoot.querySelectorAll('.person-node').length;
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
                    requestTreeRender();
                });
            }
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
                if (mainBranch) {
                    BRANCH_ID = Number(mainBranch.id || BRANCH_ID);
                    ACTIVE_BRANCH_NAME = String(mainBranch.name || '');
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = String(BRANCH_ID);
                    if (aBranch) aBranch.value = String(BRANCH_ID);
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

        function getRawGeneration(person) {
            const parsed = Number(person && person.generation);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
        }

        function getRawSpouseGeneration(person) {
            const parsed = Number(person && person.spouseGeneration);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
        }

        function getSpouseEffectiveGeneration(person) {
            const spouseParsed = Number(person && person.spouseGeneration);
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
            const candidates = [];
            candidates.push({
                fullName: person.fullName || '',
                dob: person.dob || '',
                gender: person.gender || '',
                dod: person.dod || ''
            });
            if (person.spouseId) {
                candidates.push({
                    fullName: person.spouseFullName || '',
                    dob: person.spouseDob || '',
                    gender: person.spouseGender || '',
                    dod: person.spouseDod || ''
                });
            }

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

            return true;
        }

        function hasAdvancedFilter() {
            return !!(CURRENT_NAME_FILTER
                || CURRENT_DOB_FILTER
                || CURRENT_GENDER_FILTER
                || CURRENT_LIFE_STATUS_FILTER
                || CURRENT_BIRTH_YEAR_FROM != null
                || CURRENT_BIRTH_YEAR_TO != null);
        }

        function hasAnyActiveFilter() {
            return CURRENT_GENERATION_FILTER != null || hasAdvancedFilter();
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

        function collectScopedMembers(roots, generationFilter) {
            const scoped = [];
            const seen = new Set();
            (Array.isArray(roots) ? roots : []).forEach(function (root) {
                if (generationFilter == null) {
                    collectMembersFromTree(root, scoped, seen);
                    return;
                }
                collectMembersByGeneration(root, generationFilter, scoped);
            });
            return scoped;
        }

        function computeVisibleStatsFromMembers(members) {
            const memberIds = new Set();
            const generationValues = new Set();
            (Array.isArray(members) ? members : []).forEach(function (person) {
                if (!person) return;
                const id = Number(person.id || 0);
                if (id > 0) memberIds.add(id);
                const spouseId = Number(person.spouseId || 0);
                if (spouseId > 0) memberIds.add(spouseId);

                const ownGen = getRawGeneration(person);
                if (ownGen != null) generationValues.add(ownGen);
                const spouseGen = getRawSpouseGeneration(person);
                if (spouseGen != null) generationValues.add(spouseGen);
            });

            const generationCount = generationValues.size > 0
                ? generationValues.size
                : (memberIds.size > 0 ? 1 : 0);
            return {
                generations: generationCount,
                members: memberIds.size
            };
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
            const name = String(branchName || '').trim();
            return name === '1' || name === '2';
        }

        function buildDefaultAvatarDataUri(gender) {
            const normalizedGender = String(gender || '').toLowerCase();
            const bodyPath = normalizedGender === 'female'
                ? '<path d="M68 89c18 0 33 15 33 34v10H35v-10c0-19 15-34 33-34z" fill="#737887"/><path d="M68 35c11 0 20 9 20 20v10c0 9 6 15 12 20 3 2 3 6 0 8-9 7-20 11-32 11s-23-4-32-11c-3-2-3-6 0-8 6-5 12-11 12-20V55c0-11 9-20 20-20z" fill="#737887"/>'
                : '<ellipse cx="68" cy="52" rx="18" ry="22" fill="#737887"/><path d="M68 86c20 0 35 16 35 35v12H33v-12c0-19 15-35 35-35z" fill="#737887"/>';
            const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="136" height="136" viewBox="0 0 136 136"><rect x="0" y="0" width="136" height="136" rx="10" fill="#c5cad3"/>' + bodyPath + '</svg>';
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

        function buildTreeMenu(person, opts) {
            const isSpouse = !!(opts && opts.isSpouse);
            const isRoot = !!(opts && opts.isRoot);
            const rawGender = String(person.gender || 'other').toLowerCase();
            const gender = (rawGender === 'male' || rawGender === 'female' || rawGender === 'other') ? rawGender : 'other';
            const hasSpouse = !!person.spouseId;
            const branchName = person.branchName || '';
            const personId = Number(person.id || 0);

            let items = '';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="back-root" data-person-id="' + personId + '"><i class="fas fa-long-arrow-alt-left"></i> Trở về gốc</a></li>';
            items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="copy-data" data-person-id="' + personId + '"><i class="fas fa-clone"></i> Sao chép dữ liệu</a></li>';

            if (canManageMember) {
                if (!isSpouse && gender === 'male' && !hasSpouse) {
                    items += '<li><a class="dropdown-item cursor-pointer" data-tree-action="add-spouse" data-person-id="' + personId + '"><i class="fa-solid fa-square-plus"></i> Thêm hôn thê</a></li>';
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

            return '' +
                '<div class="' + cssGender + ' person-node ' + className + '"' + spouseIdAttr + ' data-id="' + personId + '" data-branch-id="' + escapeHtml(branchId) + '">' +
                    (showGenerationBadge ? ('<span class="rounded bg-white fw-bold generation-number">' + generation + '</span>') : '') +
                    (showManageMenu
                        ? '<div class="dropdown btn-setting-custom">' +
                            '<button class="btn btn-sm btn-dark btn-setting-custom tree-menu-toggle" type="button" data-menu-id="' + menuId + '"><i class="fa-solid fa-gear"></i></button>' +
                            '<ul class="dropdown-menu fs-13 transform-none tree-action-menu" id="' + menuId + '">' + buildTreeMenu(person, { isSpouse: isSpouse, isRoot: isRoot }) + '</ul>' +
                          '</div>'
                        : '') +
                    '<img src="' + escapeHtml(avatar) + '" class="rounded mb-2 mt-3 avatar-tree" alt="' + escapeHtml(fullName) + '" onerror="this.src=\'' + fallbackAvatar + '\'">' +
                    '<div class="person-text">' +
                        '<div data-id="' + personId + '" class="name-phado">' + escapeHtml(fullName) + '</div>' +
                        datesHtml +
                    '</div>' +
                    embeddedHtml +
                '</div>';
        }

        function renderTreeNode(person, opts) {
            const options = opts || {};
            const spouse = person.spouseId ? {
                id: person.spouseId,
                fullName: person.spouseFullName,
                gender: person.spouseGender,
                generation: getSpouseEffectiveGeneration(person),
                branchName: person.spouseBranchName || person.branchName,
                avatar: person.spouseAvatar,
                dob: person.spouseDob,
                dod: person.spouseDod,
                spouseId: person.id
            } : null;

            const mainCardPerson = (spouse
                && String(person.gender || '').toLowerCase() === 'female'
                && String(spouse.gender || '').toLowerCase() === 'male')
                ? spouse
                : person;
            const spouseCardPerson = (spouse && mainCardPerson && Number(mainCardPerson.id || 0) === Number(person.id || 0))
                ? spouse
                : (spouse ? person : null);

            const children = Array.isArray(person.children) ? person.children : [];
            let childrenHtml = '';
            if (children.length > 0) {
                childrenHtml = '<ul class="ul-person" style="display:flex;justify-content:center;">'
                    + children.map(function (child) {
                        return renderTreeNode(child, { isRoot: false });
                    }).join('')
                    + '</ul>';
            }

            return '' +
                '<li class="li-person">' +
                    '<div class="box-person ' + (spouse ? 'has-spouse' : 'no-spouse') + '">' +
                        buildPersonCard(mainCardPerson, {
                            isSpouse: false,
                            isRoot: !!options.isRoot,
                            embeddedHtml: spouseCardPerson ? buildPersonCard(spouseCardPerson, { isSpouse: true, isRoot: false }) : ''
                        }) +
                    '</div>' +
                    childrenHtml +
                '</li>';
        }

        function renderForest(roots) {
            if (!Array.isArray(roots) || roots.length === 0) return '';
            return roots.map(function (root) {
                return '<div class="ft-forest-root"><ul class="ul-person">' + renderTreeNode(root, { isRoot: true }) + '</ul></div>';
            }).join('');
        }

        function collectMembersByGeneration(person, generationFilter, result) {
            if (!person) return;
            const selectedGeneration = Number(generationFilter);
            const ownGen = getEffectiveGeneration(person);
            const spouseGenParsed = Number(person.spouseGeneration);
            const spouseGen = Number.isFinite(spouseGenParsed) && spouseGenParsed > 0 ? spouseGenParsed : ownGen;
            if (ownGen === selectedGeneration || spouseGen === selectedGeneration) {
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
                    generation: getSpouseEffectiveGeneration(person),
                    branchName: person.spouseBranchName || person.branchName,
                    avatar: person.spouseAvatar,
                    dob: person.spouseDob,
                    dod: person.spouseDod,
                    spouseId: person.id
                } : null;
                const mainCardPerson = (spouse
                    && String(person.gender || '').toLowerCase() === 'female'
                    && String(spouse.gender || '').toLowerCase() === 'male')
                    ? spouse
                    : person;
                const spouseCardPerson = (spouse && mainCardPerson && Number(mainCardPerson.id || 0) === Number(person.id || 0))
                    ? spouse
                    : (spouse ? person : null);

                const ownRawGeneration = getRawGeneration(person);
                const spouseRawGeneration = getRawSpouseGeneration(person);
                const sameGeneration = !spouse
                    || (ownRawGeneration != null
                    && spouseRawGeneration != null
                    && ownRawGeneration === spouseRawGeneration);
                const ownBranch = normalizeSearchText(person.branchName || '');
                const spouseBranch = normalizeSearchText(person.spouseBranchName || person.branchName || '');
                const sameBranch = !spouse || !ownBranch || !spouseBranch || ownBranch === spouseBranch;
                const canRenderTogether = !!spouse && sameGeneration && sameBranch;

                if (!spouse || canRenderTogether) {
                    return '<li class="li-person"><div class="box-person ' + (spouse ? 'has-spouse' : 'no-spouse') + '">' +
                        buildPersonCard(mainCardPerson, {
                            isSpouse: false,
                            embeddedHtml: spouseCardPerson ? buildPersonCard(spouseCardPerson, { isSpouse: true }) : ''
                        }) +
                        '</div></li>';
                }

                return '<li class="li-person"><div class="box-person no-spouse">' +
                    buildPersonCard(mainCardPerson, {
                        isSpouse: false
                    }) +
                    '</div></li>' +
                    '<li class="li-person"><div class="box-person no-spouse">' +
                    buildPersonCard(spouseCardPerson, {
                        isSpouse: false
                    }) +
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
            FT_VIEWPORT.panX += (areaRect.left + areaRect.width / 2) - (nodeRect.left + nodeRect.width / 2);
            FT_VIEWPORT.panY += (areaRect.top + areaRect.height / 2) - (nodeRect.top + nodeRect.height / 2);
            if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
        }

        function resetTreeViewport() {
            if (!FT_VIEWPORT.initialized) return;
            FT_VIEWPORT.scale = 1;
            FT_VIEWPORT.panX = 0;
            FT_VIEWPORT.panY = 0;
            if (typeof FT_VIEWPORT.apply === 'function') {
                FT_VIEWPORT.apply();
            }
        }

        async function resetFiltersAndBackToRoot() {
            const nameInput = document.getElementById('ftFilterName');
            const dobInput = document.getElementById('ftFilterDob');
            if (nameInput) nameInput.value = '';
            if (dobInput) dobInput.value = '';

            CURRENT_GENERATION_FILTER = null;
            CURRENT_FOCUS_PERSON_ID = null;
            CURRENT_NAME_FILTER = '';
            CURRENT_DOB_FILTER = '';
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;

            const activeGenerationLabel = document.getElementById('activeGenerationLabel');
            if (activeGenerationLabel) {
                activeGenerationLabel.textContent = 'Tất cả đời';
            }

            if (FT_FILTER_DEBOUNCE) {
                clearTimeout(FT_FILTER_DEBOUNCE);
                FT_FILTER_DEBOUNCE = null;
            }

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

            let renderRoots = CURRENT_TREE_ROOTS;
            if (CURRENT_FOCUS_PERSON_ID != null) {
                const focused = findPersonByIdInRoots(CURRENT_FOCUS_PERSON_ID);
                if (focused) {
                    renderRoots = [focused];
                }
            }

            const scopedMembers = collectScopedMembers(renderRoots, CURRENT_GENERATION_FILTER);
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
            const stats = computeVisibleStatsFromMembers(visibleMembers);
            const isViewingWholeTree = !hasAnyActiveFilter() && CURRENT_FOCUS_PERSON_ID == null;
            if (isViewingWholeTree) {
                updateTopStats(stats.generations, HOME_TOTAL_MEMBERS);
            } else {
                updateTopStats(stats.generations, stats.members);
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
                    renderGenerationMenu(1);
                    treeRoot.innerHTML = '';
                    updateTopStats(0, 0);
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true, []);
                    }
                    return;
                }
                CURRENT_TREE_ROOTS = validRoots;
                if (CURRENT_FOCUS_PERSON_ID != null && !findPersonByIdInRoots(CURRENT_FOCUS_PERSON_ID)) {
                    CURRENT_FOCUS_PERSON_ID = null;
                }
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(false, validRoots);
                }
                const menuGenerationMax = getMaxGenerationFromRoots(validRoots);
                renderGenerationMenu(menuGenerationMax);
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
                    if (action === 'view-descendants') {
                        CURRENT_FOCUS_PERSON_ID = personId;
                        requestTreeRender();
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
            scaleWrap.style.willChange = 'transform';

            FT_VIEWPORT.scale = FT_VIEWPORT.initialized ? FT_VIEWPORT.scale : 1;
            FT_VIEWPORT.panX = FT_VIEWPORT.initialized ? FT_VIEWPORT.panX : 0;
            FT_VIEWPORT.panY = FT_VIEWPORT.initialized ? FT_VIEWPORT.panY : 0;

            const minScale = 0.005;
            const maxScale = 2.2;
            let viewportRaf = 0;
            let interactionTimer = 0;
            const clampScale = function (value) {
                if (!Number.isFinite(value)) return FT_VIEWPORT.scale || 1;
                return Math.min(maxScale, Math.max(minScale, value));
            };
            const clampPan = function (value) {
                if (!Number.isFinite(value)) return 0;
                const PAN_LIMIT = 10000000;
                return Math.min(PAN_LIMIT, Math.max(-PAN_LIMIT, value));
            };

            const setInteractingState = function () {
                if (!app) return;
                app.classList.add('ft-interacting');
                if (interactionTimer) clearTimeout(interactionTimer);
                interactionTimer = setTimeout(function () {
                    app.classList.remove('ft-interacting');
                }, 160);
            };

            const applyViewportNow = function () {
                viewportRaf = 0;
                FT_VIEWPORT.scale = clampScale(FT_VIEWPORT.scale);
                FT_VIEWPORT.panX = clampPan(FT_VIEWPORT.panX);
                FT_VIEWPORT.panY = clampPan(FT_VIEWPORT.panY);
                scaleWrap.style.transform = 'translate(' + FT_VIEWPORT.panX + 'px,' + FT_VIEWPORT.panY + 'px) scale(' + FT_VIEWPORT.scale + ')';
            };

            FT_VIEWPORT.apply = function () {
                if (viewportRaf) return;
                viewportRaf = requestAnimationFrame(applyViewportNow);
            };

            const zoomAtPoint = function (nextScale, clientX, clientY) {
                const clamped = clampScale(nextScale);
                const areaRect = contentArea.getBoundingClientRect();
                const localX = clientX - areaRect.left;
                const localY = clientY - areaRect.top;
                const worldX = (localX - FT_VIEWPORT.panX) / FT_VIEWPORT.scale;
                const worldY = (localY - FT_VIEWPORT.panY) / FT_VIEWPORT.scale;
                FT_VIEWPORT.scale = clamped;
                FT_VIEWPORT.panX = clampPan(localX - worldX * FT_VIEWPORT.scale);
                FT_VIEWPORT.panY = clampPan(localY - worldY * FT_VIEWPORT.scale);
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
                if (FT_VIEWPORT.scale < 0.03 && factor > 1) {
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

        function bindAdvancedFilters() {
            CURRENT_NAME_FILTER = '';
            CURRENT_DOB_FILTER = '';
            CURRENT_GENDER_FILTER = '';
            CURRENT_LIFE_STATUS_FILTER = '';
            CURRENT_BIRTH_YEAR_FROM = null;
            CURRENT_BIRTH_YEAR_TO = null;
            const nameInput = document.getElementById('ftFilterName');
            const dobInput = document.getElementById('ftFilterDob');
            const resetBtn = document.getElementById('ftFilterReset');
            if (!nameInput || !dobInput || !resetBtn) {
                return;
            }
            const todayIso = new Date().toISOString().slice(0, 10);
            dobInput.setAttribute('max', todayIso);

            const applyAllFilters = function () {
                CURRENT_NAME_FILTER = String(nameInput.value || '').trim();
                const normalizedDob = normalizeDateFilterValue(dobInput.value);
                CURRENT_DOB_FILTER = normalizedDob;
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
        }

        bindAvatarPicker('mAvatarFile', 'mAvatar');
        bindAvatarPicker('aAvatarFile', 'aAvatar');
        bindBirthDateInputGuards();
        bindAdvancedFilters();
        initZoomControls();
        setupPersonCardActions();

        async function bootstrapFamilyTree() {
            await loadBranches();
            await loadRootPersons({ center: true, centerBranchId: BRANCH_ID });
        }

        bootstrapFamilyTree();
</script>


</div>
        </div>
    </div>
</div>
