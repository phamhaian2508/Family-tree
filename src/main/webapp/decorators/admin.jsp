<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />
	<title><dec:title default="Trang ch&#7911;" /></title>
	<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
	<link rel="shortcut icon" href="/favicon.svg" />

	<link rel="stylesheet" href="<c:url value='/admin/assets/css/bootstrap.min.css'/>" />
    <link rel="stylesheet" href="<c:url value='/admin/font-awesome/4.5.0/css/font-awesome.min.css'/>" />
    <link rel="stylesheet" href="<c:url value='/admin/assets/css/ace.min.css'/>" class="ace-main-stylesheet" id="main-ace-style" />
    <script type='text/javascript' src="<c:url value='/admin/assets/js/ace-extra.min.js'/>"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="<c:url value='/admin/assets/css/style.css'/>">
	<link rel="stylesheet" href="<c:url value='/admin/assets/css/admin-modern.css'/>">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
		  integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
		  crossorigin="anonymous" referrerpolicy="no-referrer" />
		<!-- jquery -->
		<script type='text/javascript' src="<c:url value='/admin/js/2.1.4/jquery.min.js'/>"></script>
		<script type="text/javascript">
            (function () {
                function csrfMeta(name) {
                    var el = document.querySelector('meta[name="' + name + '"]');
                    return el ? el.getAttribute('content') : '';
                }

                var csrfToken = csrfMeta('_csrf');
                var csrfHeader = csrfMeta('_csrf_header');
                if (!csrfToken || !csrfHeader) {
                    return;
                }

                if (window.jQuery && window.jQuery.ajaxPrefilter) {
                    window.jQuery.ajaxPrefilter(function (options, originalOptions, jqXHR) {
                        var method = (options.type || originalOptions.type || 'GET').toUpperCase();
                        if (method === 'GET' || method === 'HEAD' || method === 'OPTIONS' || method === 'TRACE') {
                            return;
                        }
                        jqXHR.setRequestHeader(csrfHeader, csrfToken);
                    });
                }

                if (window.fetch) {
                    var originalFetch = window.fetch;
                    window.fetch = function (input, init) {
                        var requestInit = init ? Object.assign({}, init) : {};
                        var method = ((requestInit.method || 'GET') + '').toUpperCase();
                        if (method === 'GET' || method === 'HEAD' || method === 'OPTIONS' || method === 'TRACE') {
                            return originalFetch(input, requestInit);
                        }
                        var headers = new Headers(requestInit.headers || {});
                        if (!headers.has(csrfHeader)) {
                            headers.set(csrfHeader, csrfToken);
                        }
                        requestInit.headers = headers;
                        return originalFetch(input, requestInit);
                    };
                }
            })();
		</script>

	<%--sweetalert--%>
	<script type='text/javascript' src="<c:url value='/admin/assets/sweetalert2/sweetalert2.min.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/admin/assets/sweetalert2/sweetalert2.min.css'/>">
	<dec:head/>
</head>
<body class="no-skin admin-modern">
	
	<div class="main-container" id="main-container">
		<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
		</script>
		<!-- header -->
    	<%@ include file="/common/admin/menu.jsp" %>
		<%@ include file="/common/admin/header.jsp" %>
    	<!-- header -->
		
		<dec:body/>
		
		<!-- footer -->
    	<%@ include file="/common/admin/footer.jsp" %>
    	<!-- footer -->
    	
    	<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse display">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
		</a>
	</div>

	<%--jQuery Validation Plugin--%>
	<script src="<c:url value='/admin/js/jqueryvalidate/jquery.validate.min.js'/>"></script>

	<%--common javascript file--%>
	<script type="text/javascript" src="<c:url value='/admin/js/global_admin_script.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/bootstrap.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery-ui.custom.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.ui.touch-punch.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.easypiechart.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.sparkline.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.flot.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.flot.pie.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/jquery.flot.resize.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/ace-elements.min.js'/>"></script>
	<script src="<c:url value='/admin/assets/js/ace.min.js'/>"></script>

	<!-- page specific plugin scripts -->
	<script src="<c:url value='/admin/assets/js/jquery-ui.min.js'/>"></script>

	<script type="text/javascript">
        function showAlertBeforeDelete(callback) {
            swal({
                title: "Xác nhận xóa",
                text: "Bạn có chắc chắn xóa những dòng đã chọn",
                type: "warning",
                showCancelButton: true,
                confirmButtonText: "Xác nhận",
                cancelButtonText: "Hủy bỏ",
                confirmButtonClass: "btn btn-success",
                cancelButtonClass: "btn btn-danger"
            }).then(function (res) {
                if(res.value){
                    callback();
                }else if(res.dismiss == 'cancel'){
                    console.log('cancel');
                }
            });
        }

        $(function () {
            var $body = $('body');
            var $toggle = $('#appSidebarToggle');
            var $overlay = $('#appSidebarOverlay');

            function closeSidebarOnMobile() {
                if (window.innerWidth <= 991) {
                    $body.removeClass('sidebar-open-mobile');
                }
            }

            if ($toggle.length) {
                $toggle.on('click', function (e) {
                    e.preventDefault();
                    if (window.innerWidth <= 991) {
                        $body.toggleClass('sidebar-open-mobile');
                    } else {
                        $body.toggleClass('sidebar-collapsed');
                    }
                });
            }

            if ($overlay.length) {
                $overlay.on('click', function () {
                    $body.removeClass('sidebar-open-mobile');
                });
            }

            $(window).on('resize', function () {
                closeSidebarOnMobile();
            });

            $('.main-content-inner .breadcrumbs').each(function () {
                var $crumb = $(this);
                if ($crumb.find('.breadcrumb').length === 0 || $crumb.find('.crumb-quick-icons').length > 0) {
                    return;
                }
                $crumb.addClass('has-quick-icons');
                var html = ''
                    + '<div class="crumb-quick-icons">'
                    + '  <a href="#" class="crumb-icon-btn has-dot" aria-label="Thông báo" title="Thông báo"><i class="fa fa-bell-o"></i></a>'
                    + '  <a href="#" class="crumb-icon-btn" aria-label="Cài đặt" title="Cài đặt"><i class="fa fa-cog"></i></a>'
                    + '</div>';
                $crumb.append(html);
            });
        });
	</script>
</body>
</html>
