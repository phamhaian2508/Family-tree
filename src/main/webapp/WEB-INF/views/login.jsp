<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
</head>
<body>
<section class="gpo-auth-shell">
    <div class="gpo-auth-ornament" aria-hidden="true"></div>
    <div class="row g-0">
        <div class="col-lg-5">
            <aside class="gpo-auth-ceremony">
                <p class="gpo-auth-kicker">Nghi thức vào gia phả số</p>
                <h1 class="gpo-auth-title">Đăng nhập để tiếp nối mạch tộc hệ</h1>
                <p class="gpo-auth-desc">
                    Khu quản trị dành cho thành viên đã được cấp tài khoản để cập nhật gia phả, bổ sung tư liệu
                    và gìn giữ những ghi chép quan trọng của dòng họ theo từng đời.
                </p>

                <div class="gpo-auth-notes">
                    <article class="gpo-auth-note">
                        <h2>Trang nghiêm</h2>
                        <p>Không gian đăng nhập giữ cùng chất liệu giấy cổ, sắc đỏ son và nền nâu trầm như trang chủ.</p>
                    </article>
                    <article class="gpo-auth-note">
                        <h2>Dễ sử dụng</h2>
                        <p>Form rõ ràng, chữ lớn hơn, tương phản tốt hơn để người lớn tuổi vẫn thao tác thuận tiện.</p>
                    </article>
                    <article class="gpo-auth-note">
                        <h2>Kết nối gia tộc</h2>
                        <p>Mỗi lần đăng nhập là một lần tiếp cận kho tư liệu, sơ đồ và hồ sơ thành viên của gia tộc.</p>
                    </article>
                </div>
            </aside>
        </div>

        <div class="col-lg-7">
            <section class="gpo-auth-form-panel">
                <div class="gpo-auth-card">
                    <div class="gpo-auth-card-head">
                        <p class="gpo-auth-card-kicker">Thông tin thành viên</p>
                        <h2>Đăng nhập</h2>
                        <p class="gpo-auth-card-subtitle">Nhập tài khoản để truy cập hệ thống gia phả và tư liệu dòng họ.</p>
                    </div>

                    <c:if test="${param.incorrectAccount != null}">
                        <div class="gpo-alert gpo-alert-danger">
                            Tên đăng nhập hoặc mật khẩu không đúng.
                        </div>
                    </c:if>
                    <c:if test="${param.accessDenied != null}">
                        <div class="gpo-alert gpo-alert-warning">
                            Bạn không có quyền truy cập trang này.
                        </div>
                    </c:if>
                    <c:if test="${param.sessionTimeout != null}">
                        <div class="gpo-alert gpo-alert-info">
                            Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.
                        </div>
                    </c:if>
                    <c:if test="${not empty registerSuccessMessage}">
                        <div class="gpo-alert gpo-alert-success">
                            <c:out value="${registerSuccessMessage}"/>
                        </div>
                    </c:if>

                    <form action="j_spring_security_check" id="formLogin" method="post" class="gpo-auth-form">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="gpo-field">
                            <label class="gpo-form-label" for="userName">Tên đăng nhập</label>
                            <input type="text" class="form-control gpo-form-control"
                                   id="userName" name="j_username" placeholder="Nhập tên đăng nhập" required>
                        </div>
                        <div class="gpo-field">
                            <label class="gpo-form-label" for="password">Mật khẩu</label>
                            <input type="password" class="form-control gpo-form-control"
                                   id="password" name="j_password" placeholder="Nhập mật khẩu" required>
                        </div>

                        <div class="gpo-auth-row">
                            <label class="gpo-check">
                                <input type="checkbox" id="rememberMe">
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                            <a href="#" class="gpo-link">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn gpo-auth-button">Đăng nhập</button>
                    </form>

                    <div class="gpo-auth-bottom">
                        <p>Chưa có tài khoản thành viên?</p>
                        <a href="/dang-ky" class="gpo-link gpo-link-strong">Đăng ký tham gia gia phả</a>
                    </div>
                </div>
            </section>
        </div>
    </div>
</section>
</body>
</html>
