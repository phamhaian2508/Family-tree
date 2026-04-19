<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
</head>
<body>
<section class="gpo-auth-shell">
    <div class="gpo-auth-ornament" aria-hidden="true"></div>
    <div class="row g-0">
        <div class="col-lg-5">
            <aside class="gpo-auth-ceremony">
                <p class="gpo-auth-kicker">Gia nhập hệ thống gia phả</p>
                <h1 class="gpo-auth-title">Đăng ký để cùng gìn giữ cội nguồn</h1>
                <p class="gpo-auth-desc">
                    Tạo tài khoản để trở thành một phần của không gian lưu trữ gia phả số, nơi con cháu cùng nhau
                    cập nhật hồ sơ thành viên, tư liệu ảnh và các mốc lễ nghi quan trọng của dòng họ.
                </p>

                <div class="gpo-auth-notes">
                    <article class="gpo-auth-note">
                        <h2>Hồ sơ rõ ràng</h2>
                        <p>Thông tin cá nhân được nhập theo cấu trúc dễ hiểu, thuận tiện cho việc đối chiếu và xác thực.</p>
                    </article>
                    <article class="gpo-auth-note">
                        <h2>Dễ mở rộng</h2>
                        <p>Sau khi có tài khoản, thành viên có thể được kết nối vào từng nhánh gia phả và bổ sung hồ sơ.</p>
                    </article>
                    <article class="gpo-auth-note">
                        <h2>Đồng bộ thẩm mỹ</h2>
                        <p>Toàn bộ màn hình đăng ký giữ cùng chất liệu trang chủ để tạo cảm giác nhất quán và tôn nghiêm.</p>
                    </article>
                </div>
            </aside>
        </div>

        <div class="col-lg-7">
            <section class="gpo-auth-form-panel">
                <div class="gpo-auth-card gpo-auth-card-wide">
                    <div class="gpo-auth-card-head">
                        <p class="gpo-auth-card-kicker">Hồ sơ thành viên mới</p>
                        <h2>Đăng ký</h2>
                        <p class="gpo-auth-card-subtitle">Điền đầy đủ thông tin để tạo tài khoản tham gia hệ thống gia phả.</p>
                    </div>

                    <c:if test="${not empty messageResponse}">
                        <div class="gpo-alert gpo-alert-${alert}">
                            <c:out value="${messageResponse}"/>
                        </div>
                    </c:if>

                    <form action="<c:url value='/register' />" id="formRegister" method="post" class="gpo-auth-form">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="fullName">Họ và tên</label>
                                    <input type="text" class="form-control gpo-form-control"
                                           id="fullName" name="fullName" placeholder="Nguyễn Văn A" maxlength="100" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="regUsername">Tên đăng nhập</label>
                                    <input type="text" class="form-control gpo-form-control"
                                           id="regUsername" name="userName" placeholder="nguyenvana" maxlength="50" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="gender">Giới tính</label>
                                    <select class="form-select gpo-form-control" id="gender" name="gender" required>
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="male">Nam</option>
                                        <option value="female">Nữ</option>
                                        <option value="other">Khác</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="dob">Ngày sinh</label>
                                    <input type="date" class="form-control gpo-form-control"
                                           id="dob" name="dob" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="email">Email</label>
                                    <input type="email" class="form-control gpo-form-control"
                                           id="email" name="email" placeholder="email@example.com" maxlength="100">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="phone">Số điện thoại</label>
                                    <input type="tel" class="form-control gpo-form-control"
                                           id="phone" name="phone" placeholder="0912 345 678" maxlength="20">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="regPassword">Mật khẩu</label>
                                    <input type="password" class="form-control gpo-form-control"
                                           id="regPassword" name="password" placeholder="Tối thiểu 6 ký tự" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="gpo-field">
                                    <label class="gpo-form-label" for="confirmPassword">Xác nhận mật khẩu</label>
                                    <input type="password" class="form-control gpo-form-control"
                                           id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                                </div>
                            </div>
                        </div>

                        <label class="gpo-check gpo-check-block">
                            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                            <span>Tôi đồng ý với điều khoản sử dụng và chính sách bảo mật của hệ thống gia phả.</span>
                        </label>

                        <button type="submit" class="btn gpo-auth-button">Đăng ký tài khoản</button>
                    </form>

                    <div class="gpo-auth-bottom">
                        <p>Đã có tài khoản thành viên?</p>
                        <a href="/login" class="gpo-link gpo-link-strong">Quay lại màn hình đăng nhập</a>
                    </div>
                </div>
            </section>
        </div>
    </div>
</section>
</body>
</html>
