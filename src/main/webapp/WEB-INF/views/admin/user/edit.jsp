<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="formUrl" value="/api/user"/>
<html>
<head>
    <title>Chỉnh sửa người dùng</title>
</head>
<body>
<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <script type="text/javascript">
                try {
                    ace.settings.check('breadcrumbs', 'fixed')
                } catch (e) {
                }
            </script>
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="<c:url value='/admin/home'/>">Trang chủ</a>
                </li>
                <li class="active">Chỉnh sửa người dùng</li>
            </ul>
        </div>

        <div class="page-content user-mgmt-page user-form-page">
            <div class="user-form-shell">
                <section class="user-hero">
                    <div class="user-hero-copy">
                        <p class="user-hero-kicker">Thông tin tài khoản</p>
                        <h2 class="user-list-title">
                            <c:choose>
                                <c:when test="${not empty model.id}">Cập nhật người gìn giữ gia phả</c:when>
                                <c:otherwise>Thêm người dùng mới</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="user-list-subtitle">Điền thông tin theo khung biểu mẫu trang nghiêm, rõ ràng và thống nhất với toàn bộ giao diện nội bộ.</p>
                    </div>
                    <div class="user-hero-meta">
                        <span class="user-hero-chip">Vai trò rõ ràng</span>
                        <span class="user-hero-chip">Tài khoản dễ quản lý</span>
                        <span class="user-hero-chip">Đồng bộ hệ thống</span>
                    </div>
                </section>

                <div class="row">
                    <div class="col-xs-12">
                        <c:if test="${not empty messageResponse}">
                            <div class="alert alert-block alert-${alert}">
                                <button type="button" class="close" data-dismiss="alert">
                                    <i class="ace-icon fa fa-times"></i>
                                </button>
                                    <c:out value="${messageResponse}"/>
                            </div>
                        </c:if>

                        <div class="user-form-layout">
                            <div class="user-form-card">
                                <div class="user-section-head">
                                    <div>
                                        <h3>Biểu mẫu tài khoản</h3>
                                        <p>Khai báo vai trò, tên đăng nhập và thông tin hiển thị của thành viên hệ thống.</p>
                                    </div>
                                </div>

                                <form:form id="formEdit" class="form-horizontal" modelAttribute="model">
                                    <div id="profile" class="user-profile-form">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="roleCode">Vai trò</label>
                                            <div class="col-sm-9">
                                                <form:select path="roleCode" id="roleCode" cssClass="form-control">
                                                    <form:option value="" label="--- Chọn vai trò ---"/>
                                                    <form:options items="${model.roleDTOs}"/>
                                                </form:select>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="userName">Tên đăng nhập</label>
                                            <div class="col-sm-9">
                                                <c:if test="${not empty model.id}">
                                                    <form:input path="userName" id="userName" cssClass="form-control" disabled="true"/>
                                                </c:if>
                                                <c:if test="${empty model.id}">
                                                    <form:input path="userName" id="userName" cssClass="form-control"/>
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="fullName">Tên đầy đủ</label>
                                            <div class="col-sm-9">
                                                <form:input path="fullName" id="fullName" cssClass="form-control"/>
                                            </div>
                                        </div>

                                        <div class="user-form-actions">
                                            <label class="col-sm-3 control-label no-padding-right message-info"></label>
                                            <div class="col-sm-9">
                                                <div class="user-action-buttons">
                                                    <c:if test="${not empty model.id}">
                                                        <input type="button" class="btn btn-white btn-warning btn-bold user-primary-btn"
                                                               value="Cập nhật người dùng" id="btnAddOrUpdateUsers"/>
                                                        <input type="button" class="btn btn-white btn-warning btn-bold user-secondary-btn"
                                                               value="Reset mật khẩu" id="btnResetPassword"/>
                                                        <img src="/img/loading.gif" style="display: none; height: 72px" id="loading_image" alt="loading">
                                                    </c:if>
                                                    <c:if test="${empty model.id}">
                                                        <input type="button" class="btn btn-white btn-warning btn-bold user-primary-btn"
                                                               value="Thêm mới người dùng" id="btnAddOrUpdateUsers"/>
                                                        <img src="/img/loading.gif" style="display: none; height: 72px" id="loading_image" alt="loading">
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <form:hidden path="id" id="userId"/>
                                    </div>
                                </form:form>
                            </div>

                            <aside class="user-side-card">
                                <div class="user-section-head">
                                    <div>
                                        <h3>Ghi chú quản trị</h3>
                                        <p>Một vài nguyên tắc giúp quản lý tài khoản gọn hơn, đúng vai trò hơn.</p>
                                    </div>
                                </div>
                                <div class="user-side-list">
                                    <div class="user-side-item">
                                        <strong>Vai trò</strong>
                                        <span>Chỉ cấp quyền quản trị cho người trực tiếp phụ trách dữ liệu gia phả.</span>
                                    </div>
                                    <div class="user-side-item">
                                        <strong>Tên đăng nhập</strong>
                                        <span>Giữ cấu trúc ngắn gọn, dễ nhận biết và không đổi sau khi đã cấp tài khoản.</span>
                                    </div>
                                    <div class="user-side-item">
                                        <strong>Họ tên</strong>
                                        <span>Nên nhập đúng tên hiển thị để dễ tra cứu trong các phần quản trị khác.</span>
                                    </div>
                                </div>
                            </aside>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $("#btnAddOrUpdateUsers").click(function (event) {
        event.preventDefault();
        var formData = $("#formEdit").serializeArray();
        var dataArray = {};
        $.each(formData, function (i, v) {
            dataArray["" + v.name + ""] = v.value;
        });
        if ($('#userId').val() != "") {
            var userId = $('#userId').val();
            var roleCode = dataArray['roleCode'];
            if (roleCode != '') {
                updateUser(dataArray, $('#userId').val());
            } else {
                window.location.href = "<c:url value='/admin/user-edit-"+userId+"?message=role_require'/>";
            }
        }
        else {
            var userName = dataArray['userName'];
            var roleCode = dataArray['roleCode'];
            if (userName != '' && roleCode != '') {
                $('#loading_image').show();
                addUser(dataArray);
            } else {
                window.location.href = "<c:url value='/admin/user-edit?message=username_role_require'/>";
            }
        }
    });

    $('#btnResetPassword').click(function (event) {
        event.preventDefault();
        $('#loading_image').show();
        resetPassword($('#userId').val());
    });

    function addUser(data) {
        $.ajax({
            url: '${formUrl}',
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (res) {
                $('#loading_image').hide();
                window.location.href = "<c:url value='/admin/user-edit-"+res.id+"?message=insert_success'/>";
            },
            error: function (res) {
                var message = (res && res.responseText) ? res.responseText : 'error_system';
                window.location.href = "<c:url value='/admin/user-edit?message='/>" + message;
            }
        });
    }

    function updateUser(data, id) {
        $.ajax({
            url: '${formUrl}/' + id,
            type: 'PUT',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (res) {
                window.location.href = "<c:url value='/admin/user-edit-"+res.id+"?message=update_success'/>";
            },
            error: function (res) {
                var message = (res && res.responseText) ? res.responseText : 'error_system';
                window.location.href = "<c:url value='/admin/user-edit-"+id+"?message='/>" + message;
            }
        });
    }

    function resetPassword(id) {
        $.ajax({
            url: '${formUrl}/password/'+id+'/reset',
            type: 'PUT',
            dataType: 'json',
            success: function (res) {
                $('#loading_image').hide();
                window.location.href = "<c:url value='/admin/user-edit-"+res.id+"?message=reset_password_success'/>";
            },
            error: function (res) {
                var message = (res && res.responseText) ? res.responseText : 'error_system';
                window.location.href = "<c:url value='/admin/user-edit-"+id+"?message='/>" + message;
            }
        });
    }
</script>
</body>
</html>
