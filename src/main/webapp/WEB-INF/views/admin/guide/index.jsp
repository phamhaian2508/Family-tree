<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="familyTreeUrl" value="/admin/familytree"/>
<c:url var="mediaUrl" value="/admin/media"/>
<c:url var="userListUrl" value="/admin/user-list"/>
<c:url var="securityAuditUrl" value="/admin/security-audit"/>
<c:url var="livestreamUrl" value="/admin/livestream"/>
<html>
<head>
    <title>Hướng dẫn sử dụng</title>
    <style>
        .guide-page{color:#3d2a1d}
        .guide-wrap,.guide-hero,.guide-toc,.guide-card{position:relative;border:1px solid rgba(123,74,42,.16);border-radius:8px;background:linear-gradient(180deg,rgba(255,249,235,.98),rgba(244,230,199,.98)),url("/web/images/paper-texture.png");background-size:auto,280px;box-shadow:0 12px 24px rgba(73,37,18,.06);overflow:hidden}
        .guide-hero:before,.guide-toc:before,.guide-card:before{content:"";position:absolute;inset:0;background:radial-gradient(circle at 12% 24%,rgba(140,36,31,.06),transparent 16%),radial-gradient(circle at 88% 24%,rgba(183,143,61,.08),transparent 18%);pointer-events:none}
        .guide-hero>*,.guide-toc>*,.guide-card>*{position:relative;z-index:1}
        .guide-wrap{display:grid;gap:18px;padding:0;background:none;border:0;box-shadow:none}
        .guide-hero{display:grid;grid-template-columns:minmax(0,1.6fr) minmax(240px,.9fr);gap:18px;padding:22px 24px}
        .guide-kicker{margin:0 0 8px;color:#8a3b22;font-size:12px;font-weight:700;letter-spacing:.14em;text-transform:uppercase}
        .guide-title{margin:0;color:#6a201d;font-family:"Noto Serif","Palatino Linotype",Georgia,serif;font-size:34px;line-height:1.2;font-weight:700}
        .guide-subtitle,.guide-card-intro,.guide-box li,.guide-note,.guide-links{color:#5e4535;font-size:16px;line-height:1.7}
        .guide-subtitle{margin:10px 0 0}
        .guide-chip-row,.guide-actions,.guide-links{display:flex;flex-wrap:wrap;gap:10px}
        .guide-chip,.guide-links a{display:inline-flex;align-items:center;min-height:36px;padding:0 14px;border:1px solid rgba(138,59,34,.2);background:rgba(255,248,231,.9);color:#7b2a1f;border-radius:999px;font-size:14px;font-weight:700;text-decoration:none}
        .guide-actions{margin-top:16px}
        .guide-btn{display:inline-flex;align-items:center;justify-content:center;min-height:42px;padding:0 16px;border:1px solid #8c241f;border-radius:6px;background:#8c241f;color:#fff2d4;font-size:14px;font-weight:700;text-decoration:none}
        .guide-btn.alt{background:rgba(255,248,231,.9);color:#7b2a1f;border-color:rgba(138,59,34,.2)}
        .guide-side{padding:16px 18px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,250,239,.88)}
        .guide-side h3,.guide-toc h3,.guide-card-title,.guide-box h4{margin:0;color:#6a201d;font-family:"Noto Serif","Palatino Linotype",Georgia,serif;font-weight:700}
        .guide-side h3{font-size:20px;margin-bottom:8px}
        .guide-side ol{margin:12px 0 0;padding-left:18px}
        .guide-side li{margin-bottom:8px;color:#5b4634;font-size:15px;line-height:1.65}
        .guide-layout{display:grid;grid-template-columns:280px minmax(0,1fr);gap:18px;align-items:start}
        .guide-toc{position:sticky;top:12px;padding:16px}
        .guide-toc h3{font-size:21px;margin-bottom:8px}
        .guide-toc p{margin:0 0 12px;color:#6b5441;font-size:14px;line-height:1.6}
        .guide-toc nav{display:grid;gap:8px}
        .guide-toc a{display:block;padding:10px 12px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,251,242,.92);color:#5b4634;font-size:15px;font-weight:700;text-decoration:none}
        .guide-content{display:grid;gap:16px}
        .guide-card-head{padding:16px 18px;background:#84221e;border-top:1px solid rgba(230,198,132,.35);box-shadow:inset 0 0 0 1px rgba(230,198,132,.12);display:flex;align-items:center;gap:12px}
        .guide-index{display:inline-flex;align-items:center;justify-content:center;width:34px;height:34px;border-radius:50%;border:1px solid rgba(230,198,132,.3);background:rgba(255,239,198,.16);color:#f8e6bc;font-weight:700;flex:0 0 auto}
        .guide-card-title{color:#f8e6bc;font-size:24px}
        .guide-card-body{padding:18px}
        .guide-card-intro{margin:0 0 16px}
        .guide-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
        .guide-box{padding:14px 15px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,250,239,.9)}
        .guide-box h4{font-size:18px;margin-bottom:10px}
        .guide-box ul,.guide-box ol{margin:0;padding-left:18px}
        .guide-box li{margin-bottom:8px;font-size:15px;line-height:1.65}
        .guide-note{margin-top:14px;padding:12px 14px;border-left:4px solid #8c241f;border-radius:6px;background:rgba(143,32,32,.08);color:#5a1916;font-size:15px;line-height:1.65}
        .guide-process{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px}
        .guide-links{margin-top:14px;font-size:15px}
        @media (max-width:1199px){.guide-hero,.guide-layout{grid-template-columns:1fr}.guide-toc{position:static}}
        @media (max-width:991px){.guide-grid,.guide-process{grid-template-columns:1fr}.guide-title{font-size:30px}}
        @media (max-width:767px){.guide-hero,.guide-card-body,.guide-toc,.guide-card-head{padding:14px}.guide-card-title{font-size:21px}.guide-title{font-size:26px}.guide-subtitle,.guide-card-intro,.guide-box li,.guide-note,.guide-links{font-size:14px}}
    </style>
</head>
<body>
<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
                <li class="active">Hướng dẫn sử dụng</li>
            </ul>
        </div>

        <div class="page-content guide-page">
            <div class="guide-wrap">
                <div class="guide-hero">
                    <div>
                        <p class="guide-kicker">Sổ tay sử dụng hệ thống</p>
                        <h2 class="guide-title">Hướng dẫn đầy đủ cho toàn bộ website gia phả</h2>
                        <p class="guide-subtitle">Trang này gom lại toàn bộ các thao tác chính của hệ thống: từ trang chủ nội bộ, cây gia phả, thư viện tư liệu, quản lý người dùng, bảo mật đến livestream. Nội dung được viết lại theo đúng luồng sử dụng thực tế để dễ tra cứu và dễ làm theo.</p>
                        <div class="guide-actions">
                            <a class="guide-btn" href="${homeUrl}">Về trang tổng quan</a>
                            <a class="guide-btn alt" href="${familyTreeUrl}">Mở cây gia phả</a>
                            <a class="guide-btn alt" href="${mediaUrl}">Mở thư viện tư liệu</a>
                        </div>
                        <div class="guide-chip-row" style="margin-top:16px">
                            <span class="guide-chip">Trang chủ nội bộ</span>
                            <span class="guide-chip">Cây gia phả</span>
                            <span class="guide-chip">Tư liệu dòng họ</span>
                            <span class="guide-chip">Người dùng</span>
                            <span class="guide-chip">Bảo mật &amp; kiểm toán</span>
                            <span class="guide-chip">Livestream</span>
                        </div>
                    </div>
                    <div class="guide-side">
                        <h3>Luồng nên làm</h3>
                        <p class="guide-subtitle" style="margin-top:0">Nên bắt đầu từ tổng quan, sửa đúng dữ liệu ở cây gia phả trước, sau đó mới bổ sung tư liệu và rà lại nhật ký hệ thống.</p>
                        <ol>
                            <li>Xem nhanh số lượng thành viên, nhánh họ và tư liệu tại trang chủ.</li>
                            <li>Vào cây gia phả để thêm người, sửa quan hệ, xem hậu duệ hoặc tra cứu.</li>
                            <li>Bổ sung ảnh, video và hồ sơ vào thư viện tư liệu.</li>
                            <li>Kiểm tra quyền người dùng và nhật ký bảo mật sau khi cập nhật lớn.</li>
                        </ol>
                    </div>
                </div>

                <div class="guide-layout">
                    <aside class="guide-toc">
                        <h3>Mục lục nhanh</h3>
                        <p>Chọn đúng phần cần xem để đi thẳng tới module tương ứng.</p>
                        <nav>
                            <a href="#sec-start">1. Bắt đầu với hệ thống</a>
                            <a href="#sec-home">2. Trang chủ nội bộ</a>
                            <a href="#sec-tree">3. Cây gia phả</a>
                            <a href="#sec-media">4. Thư viện tư liệu</a>
                            <a href="#sec-users">5. Quản lý người dùng</a>
                            <a href="#sec-security">6. Bảo mật &amp; kiểm toán</a>
                            <a href="#sec-live">7. Livestream dòng họ</a>
                            <a href="#sec-process">8. Quy trình nên làm</a>
                            <a href="#sec-trouble">9. Lỗi thường gặp</a>
                        </nav>
                    </aside>

                    <div class="guide-content">
                        <section class="guide-card" id="sec-start">
                            <div class="guide-card-head"><span class="guide-index">1</span><h3 class="guide-card-title">Bắt đầu với hệ thống</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Khu vực công khai dùng để giới thiệu và dẫn người dùng tới màn đăng nhập, còn khu vực nội bộ là nơi cập nhật dữ liệu gia phả. Khi mới đăng nhập, nên làm việc theo từng module thay vì sửa nhiều nơi cùng lúc.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Bắt đầu nhanh</h4>
                                        <ol>
                                            <li>Đăng nhập bằng đúng tài khoản được cấp.</li>
                                            <li>Mở đúng menu cần làm việc từ thanh bên trái.</li>
                                            <li>Nếu cần sửa quan hệ gia đình, ưu tiên làm trong cây gia phả trước.</li>
                                            <li>Sau khi sửa xong, kiểm tra lại hiển thị để chắc chắn dữ liệu đã đúng.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Quyền thường gặp</h4>
                                        <ul>
                                            <li><strong>Trưởng quản phả:</strong> quản lý toàn bộ dữ liệu và người dùng.</li>
                                            <li><strong>Biên tập phả:</strong> cập nhật cây gia phả và tư liệu.</li>
                                            <li><strong>Thành viên họ tộc:</strong> xem thông tin theo quyền được cấp.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-home">
                            <div class="guide-card-head"><span class="guide-index">2</span><h3 class="guide-card-title">Trang chủ nội bộ</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Trang chủ nội bộ là nơi nhìn nhanh toàn cảnh dòng họ: số thành viên, số nhánh gia tộc, thư viện tư liệu và những ghi chép mới.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Nên xem trước</h4>
                                        <ul>
                                            <li>Các ô số liệu đầu trang để biết quy mô dữ liệu hiện tại.</li>
                                            <li>Phần thông tin dòng họ để rà quê quán, nhánh họ và dữ liệu còn thiếu.</li>
                                            <li>Khối ghi chép gần đây để biết ai vừa cập nhật điều gì.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Khi nào nên dùng</h4>
                                        <ul>
                                            <li>Khi mới đăng nhập và cần nắm hiện trạng toàn hệ thống.</li>
                                            <li>Khi chuẩn bị bổ sung dữ liệu cho nhiều thành viên.</li>
                                            <li>Khi cần mở nhanh sang cây gia phả, tư liệu hoặc hướng dẫn.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-tree">
                            <div class="guide-card-head"><span class="guide-index">3</span><h3 class="guide-card-title">Cây gia phả</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Đây là khu vực quan trọng nhất của hệ thống. Cây gia phả dùng để tra cứu huyết thống, theo dõi nhiều thế hệ, xem hậu duệ và cập nhật quan hệ cha mẹ, vợ chồng, con cái.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Tra cứu và điều hướng</h4>
                                        <ol>
                                            <li>Dùng ô tìm theo họ tên để tìm một người cụ thể.</li>
                                            <li>Chọn thêm chi họ hoặc thế hệ khi cây quá lớn.</li>
                                            <li>Kéo thả để di chuyển cây, phóng to hoặc thu nhỏ khi cần.</li>
                                            <li>Bấm vào node để mở chi tiết, xem cha mẹ, phối ngẫu, con và tư liệu.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Phân biệt thao tác</h4>
                                        <ul>
                                            <li><strong>Đưa ra giữa cây:</strong> chỉ focus người đang chọn.</li>
                                            <li><strong>Xem hậu duệ:</strong> dựng subtree con cháu từ người đó.</li>
                                            <li><strong>Thêm con / thêm vợ chồng:</strong> mở rộng cây từ node đang có.</li>
                                            <li><strong>Thu gọn / mở rộng nhánh:</strong> giảm rối khi cây nhiều đời.</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="guide-note">Nếu chỉ muốn tìm người thì dùng tìm kiếm. Nếu muốn xem con cháu của một người thì dùng đúng nút <strong>Xem hậu duệ</strong>. Hai chế độ này khác nhau và không nên dùng lẫn.</div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-media">
                            <div class="guide-card-head"><span class="guide-index">4</span><h3 class="guide-card-title">Thư viện tư liệu</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Thư viện tư liệu dùng để lưu ảnh, video, giấy tờ, sắc phong và các tư liệu liên quan đến thành viên hoặc sự kiện trong dòng họ.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Thêm tư liệu</h4>
                                        <ol>
                                            <li>Tạo hoặc chọn đúng album trước khi tải tệp lên.</li>
                                            <li>Nhập tên hiển thị rõ nghĩa và mô tả ngắn khi cần.</li>
                                            <li>Kiểm tra preview ảnh hoặc video sau khi tải.</li>
                                            <li>Nếu liên quan đến một thành viên, nên ghi rõ tên hoặc năm sự kiện.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Cách quản lý tốt hơn</h4>
                                        <ul>
                                            <li>Phân album theo chủ đề: ảnh thờ, giấy tờ, sự kiện, video.</li>
                                            <li>Tránh tải trùng nhiều bản giống nhau.</li>
                                            <li>Không xóa tệp khi chưa rà xem đang dùng ở đâu.</li>
                                            <li>Ưu tiên tệp rõ, tên dễ hiểu và dung lượng hợp lý.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-users">
                            <div class="guide-card-head"><span class="guide-index">5</span><h3 class="guide-card-title">Quản lý người dùng</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Màn này dùng để tạo tài khoản, phân quyền, sửa thông tin và hỗ trợ người cùng làm dữ liệu truy cập đúng phần họ được phép dùng.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Thao tác thường dùng</h4>
                                        <ul>
                                            <li>Thêm tài khoản cho người phụ trách nhập liệu hoặc quản lý.</li>
                                            <li>Sửa họ tên, trạng thái hoạt động và thông tin cơ bản khi cần.</li>
                                            <li>Reset mật khẩu khi người dùng quên hoặc cần cấp lại.</li>
                                            <li>Rà tài khoản cũ để tránh trùng hoặc quyền quá rộng.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Nguyên tắc phân quyền</h4>
                                        <ul>
                                            <li>Chỉ cấp quyền cao cho người thật sự chịu trách nhiệm dữ liệu.</li>
                                            <li>Biên tập viên nên tập trung vào cập nhật cây và tư liệu.</li>
                                            <li>Tài khoản không còn dùng nên khóa hoặc chỉnh lại ngay.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-security">
                            <div class="guide-card-head"><span class="guide-index">6</span><h3 class="guide-card-title">Bảo mật &amp; kiểm toán</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Phần này giúp theo dõi đăng nhập, hoạt động thay đổi dữ liệu và các dấu hiệu bất thường có thể ảnh hưởng tới độ tin cậy của gia phả.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Nên xem định kỳ</h4>
                                        <ol>
                                            <li>Nhìn nhanh các khối số liệu để biết hôm nay có gì nổi bật.</li>
                                            <li>Dùng bộ lọc để xem theo mức rủi ro hoặc nội dung thay đổi.</li>
                                            <li>Rà các lần đăng nhập thất bại hoặc sửa dữ liệu hàng loạt.</li>
                                            <li>Nếu nghi ngờ, đổi mật khẩu hoặc khóa tài khoản liên quan.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Dấu hiệu cần chú ý</h4>
                                        <ul>
                                            <li>Nhiều lần đăng nhập thất bại liên tiếp.</li>
                                            <li>Thay đổi dữ liệu lớn nhưng không rõ người thực hiện.</li>
                                            <li>Tài khoản quản lý dùng ngoài thời gian thông thường.</li>
                                            <li>Có nhật ký xóa dữ liệu hoặc đổi quan hệ mà chưa xác nhận.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-live">
                            <div class="guide-card-head"><span class="guide-index">7</span><h3 class="guide-card-title">Livestream dòng họ</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Livestream dùng cho họp họ trực tuyến, chia sẻ lễ giỗ hoặc gặp mặt con cháu. Giao diện đã đồng bộ với toàn hệ thống nhưng luồng chức năng cũ vẫn được giữ nguyên.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Tạo và mở phòng</h4>
                                        <ol>
                                            <li>Nhập tiêu đề rõ nghĩa cho buổi phát.</li>
                                            <li>Cấp quyền camera, micro hoặc chia sẻ màn hình khi trình duyệt hỏi.</li>
                                            <li>Kiểm tra khung video và link tham gia trước khi mời người khác.</li>
                                            <li>Chỉ cấp quyền đặc biệt cho đúng người cần dùng.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Khi đang phát</h4>
                                        <ul>
                                            <li>Theo dõi chat và danh sách người tham gia để nắm tình hình.</li>
                                            <li>Hộp thoại chia sẻ màn hình là của Chrome, không phải lỗi của trang.</li>
                                            <li>Khi host rời phòng, phiên livestream sẽ kết thúc cho mọi người.</li>
                                            <li>Nên kiểm tra mạng ổn định trước những buổi quan trọng.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-process">
                            <div class="guide-card-head"><span class="guide-index">8</span><h3 class="guide-card-title">Quy trình nên làm khi cập nhật dữ liệu</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Nếu cần làm cẩn thận và tránh sai sót, nên đi theo trình tự dưới đây thay vì cập nhật rời rạc từng nơi.</p>
                                <div class="guide-process">
                                    <div class="guide-box"><h4>Bước 1</h4><p class="guide-card-intro" style="margin:0">Xem trang chủ nội bộ để nắm số liệu và phần đang thiếu.</p></div>
                                    <div class="guide-box"><h4>Bước 2</h4><p class="guide-card-intro" style="margin:0">Sửa quan hệ và thành viên trực tiếp trong cây gia phả trước.</p></div>
                                    <div class="guide-box"><h4>Bước 3</h4><p class="guide-card-intro" style="margin:0">Bổ sung ảnh, video và hồ sơ vào thư viện tư liệu.</p></div>
                                    <div class="guide-box"><h4>Bước 4</h4><p class="guide-card-intro" style="margin:0">Kiểm tra lại quyền nếu có người mới cùng nhập liệu.</p></div>
                                    <div class="guide-box"><h4>Bước 5</h4><p class="guide-card-intro" style="margin:0">Rà nhật ký bảo mật sau mỗi đợt cập nhật lớn.</p></div>
                                    <div class="guide-box"><h4>Bước 6</h4><p class="guide-card-intro" style="margin:0">Dùng livestream khi cần chia sẻ nhanh cho nhiều thành viên.</p></div>
                                </div>
                            </div>
                        </section>

                        <section class="guide-card" id="sec-trouble">
                            <div class="guide-card-head"><span class="guide-index">9</span><h3 class="guide-card-title">Lỗi thường gặp</h3></div>
                            <div class="guide-card-body">
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Trong cây gia phả</h4>
                                        <ul>
                                            <li><strong>Không thấy người vừa thêm:</strong> kiểm tra lại bộ lọc tên, chi họ hoặc thế hệ.</li>
                                            <li><strong>Cây trắng khi thao tác:</strong> dùng nút về trung tâm và kiểm tra mức zoom hiện tại.</li>
                                            <li><strong>Không xem được hậu duệ:</strong> người đó có thể chưa có dữ liệu con cháu.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Trong tư liệu và người dùng</h4>
                                        <ul>
                                            <li><strong>Không tải được video:</strong> kiểm tra loại file, dung lượng và cửa sổ upload.</li>
                                            <li><strong>Preview bị lệch:</strong> tải lại trang bằng Ctrl + F5 nếu vừa cập nhật giao diện.</li>
                                            <li><strong>Không thấy menu người dùng:</strong> tài khoản hiện tại chưa có quyền phù hợp.</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="guide-note">Khi thấy dữ liệu hiển thị bất thường sau một loạt chỉnh sửa, không nên sửa chồng tiếp ngay. Hãy kiểm tra lại cây, bộ lọc đang bật và nhật ký thay đổi để xác định đúng điểm phát sinh.</div>
                                <div class="guide-links">
                                    <a href="${homeUrl}">Trang chủ</a>
                                    <a href="${familyTreeUrl}">Cây gia phả</a>
                                    <a href="${mediaUrl}">Tư liệu</a>
                                    <a href="${userListUrl}">Người dùng</a>
                                    <a href="${securityAuditUrl}">Bảo mật &amp; kiểm toán</a>
                                    <a href="${livestreamUrl}">Livestream</a>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
