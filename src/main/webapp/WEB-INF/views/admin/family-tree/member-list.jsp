<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<title>Danh sách thành viên gia phả</title>

<c:url var="familyTreesUrl" value="/admin/family-trees"/>
<c:url var="exportExcelUrl" value="/admin/family-tree-members/export"/>

<style>
    .ft-member-page {
        padding: 18px 0 28px;
    }
    .ft-member-shell {
        background: #fffdf9;
        border: 1px solid #eadbc4;
        border-radius: 18px;
        box-shadow: 0 12px 30px rgba(91, 58, 28, 0.08);
        overflow: hidden;
    }
    .ft-member-topbar {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 16px;
        padding: 20px 22px;
        background: linear-gradient(135deg, #fff9ec, #f2e0be);
        border-bottom: 1px solid #ead2a7;
    }
    .ft-member-topbar h2 {
        margin: 0 0 8px;
        color: #6f2817;
        font-size: 28px;
    }
    .ft-member-topbar p {
        margin: 0;
        color: #6a5443;
        line-height: 1.6;
        max-width: 780px;
    }
    .ft-member-actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .ft-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        border: 0;
        border-radius: 10px;
        padding: 10px 14px;
        font-weight: 700;
        text-decoration: none;
        cursor: pointer;
    }
    .ft-btn-back {
        background: #576b84;
        color: #fff;
    }
    .ft-btn-export {
        background: #18866f;
        color: #fff;
    }
    .ft-member-controls {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        padding: 18px 22px 14px;
        flex-wrap: wrap;
    }
    .ft-member-control-group {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
    }
    .ft-member-control-group label {
        margin: 0;
        color: #6b4a2a;
        font-weight: 700;
    }
    .ft-member-select,
    .ft-member-search {
        height: 40px;
        border: 1px solid #d8c1a4;
        border-radius: 8px;
        padding: 0 12px;
        background: #fff;
        color: #5d4632;
    }
    .ft-member-search {
        min-width: 240px;
    }
    .ft-btn-refresh {
        width: 40px;
        height: 40px;
        padding: 0;
        background: #596d85;
        color: #fff;
    }
    .ft-member-note {
        padding: 0 22px 14px;
        color: #7a654d;
        font-size: 13px;
        line-height: 1.6;
    }
    .ft-member-table-wrap {
        padding: 0 22px 16px;
        overflow-x: auto;
    }
    .ft-member-table {
        width: 100%;
        min-width: 1300px;
        border-collapse: collapse;
        background: #fff;
    }
    .ft-member-table th,
    .ft-member-table td {
        border: 1px solid #d9dfeb;
        padding: 12px 10px;
        vertical-align: top;
    }
    .ft-member-table th {
        background: #eef3f8;
        color: #233245;
        font-size: 14px;
        white-space: nowrap;
    }
    .ft-member-table td {
        color: #3f3f3f;
    }
    .ft-member-table tbody tr:nth-child(even) {
        background: #fcfcfd;
    }
    .ft-member-table tbody tr.is-hidden {
        display: none;
    }
    .ft-member-empty {
        display: none;
        padding: 36px 22px;
        text-align: center;
        color: #6f5d48;
        border-top: 1px dashed #dfceb8;
    }
    .ft-member-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        padding: 12px 22px 20px;
        flex-wrap: wrap;
    }
    .ft-member-summary {
        color: #6f5d48;
    }
    .ft-member-pagination {
        display: flex;
        gap: 6px;
        align-items: center;
        flex-wrap: wrap;
    }
    .ft-page-btn {
        min-width: 34px;
        height: 34px;
        border: 1px solid #d5dbe8;
        border-radius: 8px;
        background: #fff;
        color: #36516f;
        font-weight: 700;
        cursor: pointer;
    }
    .ft-page-btn.is-active {
        background: #197b67;
        border-color: #197b67;
        color: #fff;
    }
    @media (max-width: 767px) {
        .ft-member-topbar,
        .ft-member-controls,
        .ft-member-footer {
            flex-direction: column;
            align-items: stretch;
        }
        .ft-member-search {
            min-width: 0;
            width: 100%;
        }
        .ft-member-control-group {
            width: 100%;
        }
    }
</style>

<div class="main-content">
    <div class="main-content-inner">
        <div class="page-content ft-member-page">
            <div class="ft-member-shell">
                <div class="ft-member-topbar">
                    <div>
                        <h2>Danh sách thành viên</h2>
                        <p>
                            Cây hiện tại:
                            <strong><c:out value="${empty currentFamilyTreeName ? 'Chưa chọn cây gia phả' : currentFamilyTreeName}"/></strong>.
                            Các cột trong bảng chỉ lấy từ dữ liệu đang có thật trong hệ thống. Ô trống nghĩa là thông tin đó chưa được cập nhật.
                        </p>
                    </div>
                    <div class="ft-member-actions">
                        <a class="ft-btn ft-btn-back" href="${familyTreesUrl}?familyTreeId=${currentFamilyTreeId}">
                            <i class="fa fa-arrow-left"></i>
                            <span>Về danh sách</span>
                        </a>
                        <a class="ft-btn ft-btn-export" href="${exportExcelUrl}?familyTreeId=${currentFamilyTreeId}">
                            <i class="fa fa-download"></i>
                            <span>Tải xuống Excel</span>
                        </a>
                    </div>
                </div>

                <div class="ft-member-controls">
                    <div class="ft-member-control-group">
                        <label for="pageSizeSelect">Hiển thị</label>
                        <select id="pageSizeSelect" class="ft-member-select">
                            <option value="10">10</option>
                            <option value="25">25</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                        </select>
                    </div>
                    <div class="ft-member-control-group">
                        <select id="genderFilter" class="ft-member-select">
                            <option value="">Giới tính</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                        <input id="memberSearchInput" class="ft-member-search" type="search" placeholder="Tìm kiếm theo tên, cha mẹ, phu thê, học vấn, địa chỉ...">
                        <button id="refreshTableBtn" class="ft-btn ft-btn-refresh" type="button" title="Làm mới">
                            <i class="fa fa-refresh"></i>
                        </button>
                    </div>
                </div>

                <div class="ft-member-note">
                    Dữ liệu học vấn được ghép thận trọng từ hồ sơ học tập và khen thưởng khi có thể đối chiếu chắc chắn.
                    Nhóm máu hiện chưa có trường lưu riêng trong hệ thống nên đang để trống để tránh sai dữ liệu.
                </div>

                <div class="ft-member-table-wrap">
                    <table class="ft-member-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ và tên</th>
                            <th>Đời</th>
                            <th>Giới tính</th>
                            <th>Ngày sinh</th>
                            <th>Ngày mất</th>
                            <th>Thân phụ</th>
                            <th>Thân mẫu</th>
                            <th>Phu thê</th>
                            <th>Tình trạng hôn nhân</th>
                            <th>Học vấn</th>
                            <th>Nhóm máu</th>
                            <th>Số điện thoại</th>
                            <th>Địa chỉ</th>
                        </tr>
                        </thead>
                        <tbody id="memberTableBody">
                        <c:forEach var="item" items="${members}">
                            <tr data-gender="<c:out value='${item.gender}'/>"
                                data-search="<c:out value='${item.fullName} ${item.generation} ${item.gender} ${item.dateOfBirth} ${item.dateOfDeath} ${item.fatherFullName} ${item.motherFullName} ${item.spouseFullName} ${item.maritalStatus} ${item.education} ${item.bloodType} ${item.phoneNumber} ${item.address}'/>">
                                <td class="js-row-index"></td>
                                <td><c:out value="${item.fullName}"/></td>
                                <td><c:out value="${item.generation}"/></td>
                                <td><c:out value="${item.gender}"/></td>
                                <td><c:out value="${item.dateOfBirth}"/></td>
                                <td><c:out value="${item.dateOfDeath}"/></td>
                                <td><c:out value="${item.fatherFullName}"/></td>
                                <td><c:out value="${item.motherFullName}"/></td>
                                <td><c:out value="${item.spouseFullName}"/></td>
                                <td><c:out value="${item.maritalStatus}"/></td>
                                <td><c:out value="${item.education}"/></td>
                                <td><c:out value="${item.bloodType}"/></td>
                                <td><c:out value="${item.phoneNumber}"/></td>
                                <td><c:out value="${item.address}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div id="memberEmptyState" class="ft-member-empty">
                    Không có bản ghi nào phù hợp với bộ lọc hiện tại.
                </div>

                <div class="ft-member-footer">
                    <div id="memberSummary" class="ft-member-summary">Hiển thị 0-0/0 bản ghi</div>
                    <div id="memberPagination" class="ft-member-pagination"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('#memberTableBody tr'));
        var pageSizeSelect = document.getElementById('pageSizeSelect');
        var genderFilter = document.getElementById('genderFilter');
        var searchInput = document.getElementById('memberSearchInput');
        var refreshButton = document.getElementById('refreshTableBtn');
        var emptyState = document.getElementById('memberEmptyState');
        var summary = document.getElementById('memberSummary');
        var pagination = document.getElementById('memberPagination');
        var currentPage = 1;

        function normalize(value) {
            var text = String(value || '').toLowerCase();
            if (typeof text.normalize === 'function') {
                text = text.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            }
            return text
                .replace(/đ/g, 'd')
                .replace(/\s+/g, ' ')
                .trim();
        }

        function collectRowText(row) {
            var cells = Array.prototype.slice.call(row.querySelectorAll('td'));
            return cells.map(function (cell) {
                return cell.textContent || '';
            }).join(' ');
        }

        var rowMeta = rows.map(function (row) {
            return {
                row: row,
                gender: normalize(row.getAttribute('data-gender') || ''),
                search: normalize(row.getAttribute('data-search') || collectRowText(row))
            };
        });

        function getFilteredRows() {
            var gender = normalize(genderFilter.value || '');
            var keyword = normalize(searchInput.value || '');
            return rowMeta.filter(function (item) {
                var matchesGender = !gender || item.gender === gender;
                var matchesSearch = !keyword || item.search.indexOf(keyword) >= 0;
                return matchesGender && matchesSearch;
            }).map(function (item) {
                return item.row;
            });
        }

        function renderPagination(totalPages) {
            pagination.innerHTML = '';
            if (totalPages <= 1) {
                return;
            }

            function createButton(label, page, disabled, active) {
                var button = document.createElement('button');
                button.type = 'button';
                button.className = 'ft-page-btn' + (active ? ' is-active' : '');
                button.textContent = label;
                button.disabled = !!disabled;
                if (!disabled) {
                    button.addEventListener('click', function () {
                        currentPage = page;
                        render();
                    });
                }
                pagination.appendChild(button);
            }

            createButton('<<', Math.max(1, currentPage - 1), currentPage === 1, false);
            for (var page = 1; page <= totalPages; page++) {
                createButton(String(page), page, false, page === currentPage);
            }
            createButton('>>', Math.min(totalPages, currentPage + 1), currentPage === totalPages, false);
        }

        function render() {
            var filteredRows = getFilteredRows();
            var pageSize = Number(pageSizeSelect.value || 10);
            var totalItems = filteredRows.length;
            var totalPages = totalItems === 0 ? 1 : Math.ceil(totalItems / pageSize);

            if (currentPage > totalPages) {
                currentPage = totalPages;
            }
            if (currentPage < 1) {
                currentPage = 1;
            }

            var start = totalItems === 0 ? 0 : (currentPage - 1) * pageSize;
            var end = Math.min(start + pageSize, totalItems);

            rows.forEach(function (row) {
                row.classList.add('is-hidden');
            });

            filteredRows.slice(start, end).forEach(function (row, index) {
                row.classList.remove('is-hidden');
                var cell = row.querySelector('.js-row-index');
                if (cell) {
                    cell.textContent = String(start + index + 1);
                }
            });

            emptyState.style.display = totalItems === 0 ? 'block' : 'none';
            summary.textContent = 'Hiển thị ' + (totalItems === 0 ? 0 : start + 1) + '-' + end + '/' + totalItems + ' bản ghi';
            renderPagination(totalPages);
        }

        function resetFilters() {
            genderFilter.value = '';
            searchInput.value = '';
            pageSizeSelect.value = '10';
            currentPage = 1;
            render();
        }

        pageSizeSelect.addEventListener('change', function () {
            currentPage = 1;
            render();
        });
        genderFilter.addEventListener('change', function () {
            currentPage = 1;
            render();
        });
        searchInput.addEventListener('input', function () {
            currentPage = 1;
            render();
        });
        searchInput.addEventListener('search', function () {
            currentPage = 1;
            render();
        });
        searchInput.addEventListener('keyup', function () {
            currentPage = 1;
            render();
        });
        refreshButton.addEventListener('click', resetFilters);

        render();
    })();
</script>
