<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#7b1e1e">
    <title><dec:title default="Đăng nhập" /> | Gia phả Họ Trần Đức</title>
    <link rel="icon" type="image/svg+xml" href="<c:url value='/favicon.svg' />" />
    <link rel="shortcut icon" href="<c:url value='/favicon.svg' />" />
    <link rel="stylesheet" href="<c:url value='/web/vendor/bootstrap/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="<c:url value='/login/style.css' />">
</head>
<body class="gpo-auth-page">
    <header class="gpo-auth-header">
        <div class="container gpo-auth-header-inner">
            <a href="/trang-chu" class="gpo-auth-brand">
                <span class="gpo-auth-brand-mark">Gia phả</span>
                <span class="gpo-auth-brand-text">
                    <strong>Họ Trần Đức</strong>
                    <small>Nhân Hữu - Nhân Thắng - Bắc Ninh</small>
                </span>
            </a>
            <a href="/trang-chu" class="gpo-auth-home-link">Về trang chủ</a>
        </div>
    </header>

    <main class="gpo-auth-main">
        <div class="container">
            <dec:body/>
        </div>
    </main>

    <footer class="gpo-auth-footer">
        <div class="container">
            <p>&copy; 2026 Gia phả Họ Trần Đức. Không gian số tôn nghiêm để lưu giữ cội nguồn và kết nối hậu duệ.</p>
        </div>
    </footer>

    <script src="<c:url value='/web/vendor/bootstrap/js/bootstrap.bundle.min.js' />"></script>
</body>
</html>
