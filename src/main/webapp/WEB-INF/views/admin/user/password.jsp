<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="changePasswordURL" value="/api/user/change-password"/>
<html>
<head>
    <title>&#272;&#7893;i m&#7853;t kh&#7849;u</title>
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
                    <a href="<c:url value='/admin/home'/>">Trang ch&#7911;</a>
                </li>
                <li class="active">&#272;&#7893;i m&#7853;t kh&#7849;u</li>
            </ul><!-- /.breadcrumb -->
        </div>
        <div class="page-content user-mgmt-page user-form-page">
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
                    <div id="profile">
                        <form:form id="formChangePassword" class="form-horizontal" name="formChangePassword">
                            <div class="space-4"></div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right">
                                    <%--<spring:message code="label.password.old"/>--%>
                                        M&#7853;t kh&#7849;u c&#361;
                                </label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="oldPassword" name="oldPassword"/>
                                </div>
                            </div>
                            <div class="space-4"></div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right">
                                    <%--<spring:message code="label.password.new"/>--%>
                                        M&#7853;t kh&#7849;u m&#7899;i
                                </label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword"/>
                                </div>
                            </div>
                            <div class="space-4"></div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right">
                                    <%--<spring:message code="label.password.repeat"/>--%>
                                        Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u m&#7899;i
                                </label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"/>
                                </div>
                            </div>
                            <!--Btn-->
                            <div class="col-sm-12">
                                <label class="col-sm-3 control-label no-padding-right message-info"></label>
                                <input type="button" class="btn btn-white btn-warning btn-bold" value="&#272;&#7893;i m&#7853;t kh&#7849;u" id="btnChangePassword"/>
                            </div>
                            <!--Btn-->
                            <input type="hidden" value="${model.id}" id="userId"/>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            $('#btnChangePassword').click(function () {
                $('#formChangePassword').submit();
            });
        });
        $(function() {
            $("form[name='formChangePassword']").validate({
                rules: {
                    oldPassword: "required",
                    newPassword: {
                        required: true,
                        minlength: 8
                    },
                    confirmPassword: "required"
                },
                messages: {
                    oldPassword: "Kh&#244;ng b&#7887; tr&#7889;ng",
                    newPassword: {
                        required: "Kh&#244;ng b&#7887; tr&#7889;ng",
                        minlength: "M&#7853;t kh&#7849;u t&#7889;i thi&#7875;u 8 k&#253; t&#7921;"
                    },
                    confirmPassword: "Kh&#244;ng b&#7887; tr&#7889;ng"
                },
                submitHandler: function(form) {
                    var formData = $('#formChangePassword').serializeArray();
                    var dataArray = {};
                    $.each(formData, function (i, v) {
                        dataArray["" + v.name + ""] = v.value;
                    });
                    changePassword(dataArray, $('#userId').val());
                }
            });
        });

        function changePassword(data, id) {
            $.ajax({
                url: '${changePasswordURL}/'+id,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function (res) {
                    if (res == 'update_success') {
                        window.location.href = "<c:url value='/admin/profile-password?message=update_success'/>";
                    } else if (res == 'change_password_fail') {
                        window.location.href = "<c:url value='/admin/profile-password?message=change_password_fail'/>";
                    } else if (res == 'change_password_weak') {
                        window.location.href = "<c:url value='/admin/profile-password?message=change_password_weak'/>";
                    } else if (res == 'change_password_same_old') {
                        window.location.href = "<c:url value='/admin/profile-password?message=change_password_same_old'/>";
                    } else if (res == 'access_denied') {
                        window.location.href = "<c:url value='/admin/profile-password?message=access_denied'/>";
                    }
                },
                error: function (res) {
                    if (res && res.responseText) {
                        if (res.responseText === 'change_password_weak') {
                            window.location.href = "<c:url value='/admin/profile-password?message=change_password_weak'/>";
                            return;
                        }
                        if (res.responseText === 'change_password_same_old') {
                            window.location.href = "<c:url value='/admin/profile-password?message=change_password_same_old'/>";
                            return;
                        }
                        if (res.responseText === 'change_password_fail') {
                            window.location.href = "<c:url value='/admin/profile-password?message=change_password_fail'/>";
                            return;
                        }
                        if (res.responseText === 'access_denied') {
                            window.location.href = "<c:url value='/admin/profile-password?message=access_denied'/>";
                            return;
                        }
                    }
                    window.location.href = "<c:url value='/admin/profile-password?message=error_system'/>";
                }
            });
        }
    </script>
</div>
</body>
</html>

