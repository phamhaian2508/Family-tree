<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="formUrl" value="/api/user"/>
<c:url var="adminProfileBaseUrl" value="/admin/profile/"/>
<html>
<head>
    <title>Ch&#7881;nh s&#7917;a ng&#432;&#7901;i d&#249;ng</title>
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
                <li class="active">Ch&#7881;nh s&#7917;a ng&#432;&#7901;i d&#249;ng</li>
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
                                ${messageResponse}
                        </div>
                    </c:if>
                    <div id="profile">
                        <form:form id="formEdit" class="form-horizontal" modelAttribute="model">
                        <div class="space-4"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right">
                                <%--<spring:message code="label.username"/>--%>
                                    T&#234;n &#273;&#259;ng nh&#7853;p
                            </label>
                            <div class="col-sm-9">
                                <form:input path="userName" id="userName" cssClass="form-control" disabled="true"/>
                            </div>
                        </div>
                        <div class="space-4"></div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right">
                                <%--<spring:message code="label.fullname"/>--%>
                                    T&#234;n &#273;&#7847;y &#273;&#7911;
                            </label>
                            <div class="col-sm-9">
                                <form:input path="fullName" id="fullName" cssClass="form-control"/>
                            </div>
                        </div>
                        <!--Btn-->
                        <div class="col-sm-12">
                                <label class="col-sm-3 control-label no-padding-right message-info"></label>
                                <input type="button" class="btn btn-white btn-warning btn-bold"
                                       value="C&#7853;p nh&#7853;t ng&#432;&#7901;i d&#249;ng" id="btnUpdateUser"/>
                        </div>
                        <!--Btn-->
                        <form:hidden path="id" id="userId"/>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        $("#btnUpdateUser").click(function (event) {
            event.preventDefault();
            var normalizedFullName = $.trim($('#fullName').val() || '');
            if (!normalizedFullName) {
                window.location.href = "${adminProfileBaseUrl}" + encodeURIComponent($('#userName').val()) + "?message=full_name_invalid";
                return;
            }
            var dataArray = {};
            dataArray["fullName"] = normalizedFullName;
            if ($('#userId').val() != "") {
                updateInfo(dataArray, $('#userName').val());
            }
        });

        function updateInfo(data, username) {
            $.ajax({
                url: '${formUrl}/profile/' + encodeURIComponent(username),
                type: 'PUT',
                dataType: 'json',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function (res) {
                    window.location.href = "${adminProfileBaseUrl}" + encodeURIComponent(res.userName) + "?message=update_success";
                },
                error: function (res) {
                    if (res && res.responseText) {
                        if (res.responseText === 'full_name_invalid'
                            || res.responseText === 'access_denied'
                            || res.responseText === 'user_not_found') {
                            window.location.href = "${adminProfileBaseUrl}" + encodeURIComponent(username) + "?message=" + res.responseText;
                            return;
                        }
                    }
                    window.location.href = "${adminProfileBaseUrl}" + encodeURIComponent(username) + "?message=error_system";
                }
            });
        }
    </script>
</div>
</body>
</html>

