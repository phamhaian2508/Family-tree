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
        .guide-page{color:#3d2a1d}.guide-wrap,.guide-hero,.guide-toc,.guide-card{position:relative;border:1px solid rgba(123,74,42,.16);border-radius:8px;background:linear-gradient(180deg,rgba(255,249,235,.98),rgba(244,230,199,.98)),url("/web/images/paper-texture.png");background-size:auto,280px;box-shadow:0 12px 24px rgba(73,37,18,.06);overflow:hidden}.guide-hero:before,.guide-toc:before,.guide-card:before{content:"";position:absolute;inset:0;background:radial-gradient(circle at 12% 24%,rgba(140,36,31,.06),transparent 16%),radial-gradient(circle at 88% 24%,rgba(183,143,61,.08),transparent 18%);pointer-events:none}.guide-hero>*,.guide-toc>*,.guide-card>*{position:relative;z-index:1}.guide-wrap{display:grid;gap:18px;padding:0;background:none;border:0;box-shadow:none}.guide-hero{display:grid;grid-template-columns:minmax(0,1.6fr) minmax(240px,.9fr);gap:18px;padding:22px 24px}.guide-kicker{margin:0 0 8px;color:#8a3b22;font-size:12px;font-weight:700;letter-spacing:.14em;text-transform:uppercase}.guide-title{margin:0;color:#6a201d;font-family:"Noto Serif","Palatino Linotype",Georgia,serif;font-size:34px;line-height:1.2;font-weight:700}.guide-subtitle,.guide-card-intro,.guide-box li,.guide-note,.guide-links{color:#5e4535;font-size:16px;line-height:1.7}.guide-subtitle{margin:10px 0 0}.guide-chip-row,.guide-actions,.guide-links{display:flex;flex-wrap:wrap;gap:10px}.guide-chip,.guide-links a{display:inline-flex;align-items:center;min-height:36px;padding:0 14px;border:1px solid rgba(138,59,34,.2);background:rgba(255,248,231,.9);color:#7b2a1f;border-radius:999px;font-size:14px;font-weight:700;text-decoration:none}.guide-actions{margin-top:16px}.guide-btn{display:inline-flex;align-items:center;justify-content:center;min-height:42px;padding:0 16px;border:1px solid #8c241f;border-radius:6px;background:#8c241f;color:#fff2d4;font-size:14px;font-weight:700;text-decoration:none}.guide-btn.alt{background:rgba(255,248,231,.9);color:#7b2a1f;border-color:rgba(138,59,34,.2)}.guide-side{padding:16px 18px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,250,239,.88)}.guide-side h3,.guide-toc h3,.guide-card-title,.guide-box h4{margin:0;color:#6a201d;font-family:"Noto Serif","Palatino Linotype",Georgia,serif;font-weight:700}.guide-side h3{font-size:20px;margin-bottom:8px}.guide-side ol{margin:12px 0 0;padding-left:18px}.guide-side li{margin-bottom:8px;color:#5b4634;font-size:15px;line-height:1.65}.guide-layout{display:grid;grid-template-columns:280px minmax(0,1fr);gap:18px;align-items:start}.guide-toc{position:sticky;top:12px;padding:16px}.guide-toc h3{font-size:21px;margin-bottom:8px}.guide-toc p{margin:0 0 12px;color:#6b5441;font-size:14px;line-height:1.6}.guide-toc nav{display:grid;gap:8px}.guide-toc a{display:block;padding:10px 12px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,251,242,.92);color:#5b4634;font-size:15px;font-weight:700;text-decoration:none}.guide-content{display:grid;gap:16px}.guide-card-head{padding:16px 18px;background:#84221e;border-top:1px solid rgba(230,198,132,.35);box-shadow:inset 0 0 0 1px rgba(230,198,132,.12);display:flex;align-items:center;gap:12px}.guide-index{display:inline-flex;align-items:center;justify-content:center;width:34px;height:34px;border-radius:50%;border:1px solid rgba(230,198,132,.3);background:rgba(255,239,198,.16);color:#f8e6bc;font-weight:700;flex:0 0 auto}.guide-card-title{color:#f8e6bc;font-size:24px}.guide-card-body{padding:18px}.guide-card-intro{margin:0 0 16px}.guide-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}.guide-box{padding:14px 15px;border:1px solid rgba(138,59,34,.12);border-radius:6px;background:rgba(255,250,239,.9)}.guide-box h4{font-size:18px;margin-bottom:10px}.guide-box ul,.guide-box ol{margin:0;padding-left:18px}.guide-box li{margin-bottom:8px;font-size:15px;line-height:1.65}.guide-note{margin-top:14px;padding:12px 14px;border-left:4px solid #8c241f;border-radius:6px;background:rgba(143,32,32,.08);color:#5a1916;font-size:15px;line-height:1.65}.guide-process{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px}.guide-links{margin-top:14px;font-size:15px}@media (max-width:1199px){.guide-hero,.guide-layout{grid-template-columns:1fr}.guide-toc{position:static}}@media (max-width:991px){.guide-grid,.guide-process{grid-template-columns:1fr}.guide-title{font-size:30px}}@media (max-width:767px){.guide-hero,.guide-card-body,.guide-toc,.guide-card-head{padding:14px}.guide-card-title{font-size:21px}.guide-title{font-size:26px}.guide-subtitle,.guide-card-intro,.guide-box li,.guide-note,.guide-links{font-size:14px}}
    </style>
</head>
<body>
<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li><i class="ace-icon fa-solid fa-house-chimney home-icon"></i><a href="${homeUrl}">Trang chủ</a></li>
                <li class="active">Hướng dẫn sử dụng</li>
            </ul>
        </div>
        <div class="page-content guide-page">
            <div class="guide-wrap">
                <div class="guide-hero">
                    <div>
                        <p class="guide-kicker">Sổ tay sử dụng hệ thống</p>
                        <h2 class="guide-title">Hướng dẫn đầy đủ cho toàn bộ website gia phả</h2>
                        <p class="guide-subtitle">Trang này gom lại toàn bộ các thao tác chính trong khu quản trị: trang chủ nội bộ, cây gia phả, thư viện tư liệu, quản lý người dùng, bảo mật và livestream. Nội dung được viết theo đúng luồng làm việc thực tế để người mới vẫn theo được, còn người đang nhập dữ liệu có thể tra cứu lại thật nhanh.</p>
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
                        <p class="guide-subtitle" style="margin-top:0">Nếu cần cập nhật dữ liệu cho đúng và tránh sai quan hệ, nên đi theo trình tự này thay vì sửa rời rạc từng nơi.</p>
                        <ol>
                            <li>Xem trang chủ nội bộ để nắm nhanh số lượng thành viên, tư liệu và phần đang thiếu.</li>
                            <li>Chọn đúng cây gia phả đang làm việc trước khi thêm hoặc sửa dữ liệu.</li>
                            <li>Cập nhật thành viên và quan hệ trong cây gia phả trước.</li>
                            <li>Bổ sung ảnh, video, hồ sơ và giấy tờ vào thư viện tư liệu sau đó.</li>
                            <li>Rà lại vai trò tài khoản và nhật ký bảo mật sau các đợt sửa lớn.</li>
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
                                <p class="guide-card-intro">Khu vực công khai dùng để giới thiệu và dẫn người dùng tới màn đăng nhập, còn khu vực nội bộ là nơi cập nhật dữ liệu thật của gia phả. Khi mới vào hệ thống, nên hiểu rõ mình đang có quyền xem, quyền sửa hay quyền quản trị để tránh thao tác nhầm.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Trước khi bắt đầu</h4>
                                        <ol>
                                            <li>Đăng nhập bằng đúng tài khoản được cấp, không dùng chung tài khoản.</li>
                                            <li>Đọc nhanh menu bên trái để xác định mình cần vào gia phả, tư liệu, người dùng hay bảo mật.</li>
                                            <li>Nếu đang sửa thông tin người hoặc quan hệ, luôn ưu tiên làm trong cây gia phả trước.</li>
                                            <li>Sau mỗi thay đổi lớn, tải lại màn hình và kiểm tra ngay kết quả hiển thị.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Hiểu đúng vai trò</h4>
                                        <ul>
                                            <li><strong>Trưởng quản phả:</strong> quản lý tài khoản, bảo mật và toàn bộ dữ liệu.</li>
                                            <li><strong>Biên tập phả:</strong> cập nhật cây gia phả và tư liệu hàng ngày.</li>
                                            <li><strong>Thành viên họ tộc:</strong> truy cập nội bộ theo quyền được cấp.</li>
                                            <li>Mỗi thao tác quan trọng nên gắn với đúng người phụ trách, không nên sửa thay mà không kiểm soát.</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="guide-note">Nguyên tắc đơn giản: dữ liệu người và quan hệ nằm trong cây gia phả; ảnh, video và hồ sơ nằm trong thư viện tư liệu; tài khoản và phân quyền nằm trong quản lý người dùng.</div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-home">
                            <div class="guide-card-head"><span class="guide-index">2</span><h3 class="guide-card-title">Trang chủ nội bộ</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Trang chủ nội bộ là nơi nhìn nhanh toàn cảnh dòng họ: số lượng thành viên, số đời, tư liệu, công đức và những cập nhật gần đây. Đây là điểm nên mở đầu tiên mỗi khi đăng nhập.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Nên xem trước</h4>
                                        <ul>
                                            <li>Bốn ô số liệu đầu trang để biết quy mô hiện tại.</li>
                                            <li>Khối thông tin dòng họ để rà lại phần tên họ, số đời và các ghi chú chính.</li>
                                            <li>Khu người giữ gìn gia phả để biết ai đang phụ trách dữ liệu.</li>
                                            <li>Hoạt động gần đây để xem ai vừa thêm người, sửa quan hệ hay bổ sung tư liệu.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Khi nào nên dùng</h4>
                                        <ul>
                                            <li>Khi mới đăng nhập và cần nắm nhanh hiện trạng hệ thống.</li>
                                            <li>Khi chuẩn bị nhập nhiều dữ liệu mới cho một đợt cập nhật.</li>
                                            <li>Khi cần mở nhanh sang cây gia phả, tư liệu, công đức hoặc hướng dẫn.</li>
                                            <li>Khi muốn đối chiếu sau cập nhật xem số liệu đã tăng đúng chưa.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-tree">
                            <div class="guide-card-head"><span class="guide-index">3</span><h3 class="guide-card-title">Cây gia phả</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Đây là khu vực quan trọng nhất của hệ thống. Cây gia phả dùng để tra cứu huyết thống, theo dõi nhiều thế hệ, xem hậu duệ và cập nhật quan hệ cha mẹ, vợ chồng, con cái theo đúng mạch của từng nhánh.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Thêm dữ liệu mới</h4>
                                        <ol>
                                            <li>Chọn đúng cây gia phả đang làm việc trước khi thêm người mới.</li>
                                            <li>Nếu cây còn trống, thêm thành viên đầu tiên để tạo gốc cây.</li>
                                            <li>Khi thêm con, thêm vợ chồng hoặc gắn người có sẵn, hãy bắt đầu từ đúng node liên quan.</li>
                                            <li>Nhập đủ họ tên, giới tính và thông tin cốt lõi trước khi lưu.</li>
                                            <li>Sau khi lưu, kiểm tra lại vị trí người mới trong cây để chắc quan hệ đã đúng.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Tra cứu và điều hướng</h4>
                                        <ul>
                                            <li>Dùng ô tìm kiếm khi chỉ cần tìm một người cụ thể theo họ tên.</li>
                                            <li>Dùng bộ lọc đời hoặc chi họ khi cây lớn để tránh rối màn hình.</li>
                                            <li>Kéo thả để di chuyển sơ đồ, phóng to hoặc thu nhỏ khi cần.</li>
                                            <li>Bấm vào từng node để mở chi tiết thành viên và các thao tác liên quan.</li>
                                            <li>Dùng nút đưa về giữa cây khi bị lệch vị trí sau nhiều lần thao tác.</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="guide-note">Nếu chỉ muốn tìm người thì dùng tìm kiếm. Nếu muốn xem toàn bộ con cháu của một người thì dùng đúng nút <strong>Xem hậu duệ</strong>. Hai chế độ này phục vụ hai mục đích khác nhau.</div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-media">
                            <div class="guide-card-head"><span class="guide-index">4</span><h3 class="guide-card-title">Thư viện tư liệu</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Thư viện tư liệu dùng để lưu ảnh, video, giấy tờ, sắc phong và các hồ sơ liên quan tới thành viên hoặc sự kiện trong dòng họ. Phần này nên được cập nhật sau khi thông tin người và quan hệ đã đúng trong cây gia phả.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Quy trình thêm tư liệu</h4>
                                        <ol>
                                            <li>Tạo album mới hoặc chọn đúng album sẵn có trước khi tải tệp lên.</li>
                                            <li>Đặt tên rõ nghĩa để người khác nhìn vào là hiểu nội dung.</li>
                                            <li>Nhập mô tả ngắn nếu tư liệu liên quan tới lễ giỗ, năm sinh, năm mất hoặc một mốc sự kiện.</li>
                                            <li>Kiểm tra preview sau khi tải lên để chắc tệp không lỗi.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Cách sắp xếp nên dùng</h4>
                                        <ul>
                                            <li>Chia album theo chủ đề như ảnh thờ, giấy tờ, sự kiện, video, công đức.</li>
                                            <li>Nếu tư liệu gắn với một người cụ thể, nên ghi rõ tên và năm liên quan.</li>
                                            <li>Không tải nhiều bản trùng nhau nếu chưa thật sự cần giữ riêng từng phiên bản.</li>
                                            <li>Không nên xóa vội tệp cũ nếu đó là bản gốc duy nhất.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-users">
                            <div class="guide-card-head"><span class="guide-index">5</span><h3 class="guide-card-title">Quản lý người dùng</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Màn này dùng để tạo tài khoản, phân quyền, sửa thông tin và hỗ trợ người cùng làm dữ liệu truy cập đúng phần họ được phép dùng. Đây là nơi cần làm cẩn thận vì mọi quyền truy cập đều đi qua phần này.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Tạo và rà tài khoản</h4>
                                        <ul>
                                            <li>Nhập đầy đủ họ tên, tên đăng nhập và vai trò trước khi lưu.</li>
                                            <li>Chỉ tạo tài khoản khi đã xác định rõ người đó sẽ quản lý, biên tập hay chỉ tham gia nội bộ.</li>
                                            <li>Kiểm tra các tài khoản cũ lâu ngày không dùng để giảm rủi ro bảo mật.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Phân quyền đúng mức</h4>
                                        <ul>
                                            <li>Trưởng quản phả chỉ nên cấp cho người trực tiếp chịu trách nhiệm hệ thống.</li>
                                            <li>Biên tập phả phù hợp với người cập nhật cây gia phả và thư viện tư liệu thường xuyên.</li>
                                            <li>Thành viên họ tộc dùng cho các tài khoản truy cập nội bộ với quyền thấp hơn.</li>
                                            <li>Tài khoản không còn dùng nên chuyển về trạng thái không hoạt động ngay.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-security">
                            <div class="guide-card-head"><span class="guide-index">6</span><h3 class="guide-card-title">Bảo mật &amp; kiểm toán</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Phần này giúp theo dõi đăng nhập, hoạt động thay đổi dữ liệu và các dấu hiệu bất thường có thể ảnh hưởng tới độ tin cậy của gia phả. Đây là nơi trưởng quản phả nên xem định kỳ, nhất là sau các lần chỉnh sửa lớn.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Nên xem định kỳ</h4>
                                        <ol>
                                            <li>Xem các khối số liệu đầu trang để biết hôm nay có gì bất thường.</li>
                                            <li>Lọc theo mức rủi ro hoặc loại hành động để nhìn đúng nhóm log cần kiểm tra.</li>
                                            <li>Rà các lần đăng nhập thất bại liên tiếp hoặc các thay đổi dữ liệu hàng loạt.</li>
                                            <li>Đối chiếu thời gian thao tác với người phụ trách thực tế nếu thấy nghi ngờ.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Khi phát hiện bất thường</h4>
                                        <ul>
                                            <li>Đổi mật khẩu hoặc khóa tạm tài khoản liên quan nếu nghi có rò rỉ.</li>
                                            <li>Soát log trước và sau thời điểm phát sinh lỗi để tìm nguyên nhân.</li>
                                            <li>Thông báo cho người đang phụ trách dữ liệu để tránh sửa chồng lên lỗi.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-live">
                            <div class="guide-card-head"><span class="guide-index">7</span><h3 class="guide-card-title">Livestream dòng họ</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Livestream dùng cho họp họ trực tuyến, chia sẻ lễ giỗ hoặc gặp mặt con cháu từ xa. Giao diện đã đồng bộ với hệ thống gia phả nhưng vẫn cần dùng đúng quy trình để tránh lỗi âm thanh, hình ảnh và quyền truy cập.</p>
                                <div class="guide-grid">
                                    <div class="guide-box">
                                        <h4>Tạo và mở phòng</h4>
                                        <ol>
                                            <li>Nhập tiêu đề rõ ràng để người tham gia biết đúng buổi phát là gì.</li>
                                            <li>Cấp quyền camera, micro hoặc chia sẻ màn hình khi trình duyệt hỏi.</li>
                                            <li>Kiểm tra khung video, âm thanh và link tham gia trước khi mời người khác.</li>
                                            <li>Chỉ cấp quyền đặc biệt cho đúng người cần điều phối buổi phát.</li>
                                        </ol>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Khi đang phát</h4>
                                        <ul>
                                            <li>Theo dõi chat và danh sách người tham gia để nắm tình hình cuộc họp.</li>
                                            <li>Nếu chia sẻ màn hình, cửa sổ chọn màn hình là của trình duyệt chứ không phải lỗi của trang.</li>
                                            <li>Khi host rời phòng, buổi livestream có thể kết thúc cho cả phòng nên cần lưu ý trước khi thoát.</li>
                                            <li>Nên dùng mạng ổn định và tai nghe nếu buổi phát quan trọng.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <section class="guide-card" id="sec-process">
                            <div class="guide-card-head"><span class="guide-index">8</span><h3 class="guide-card-title">Quy trình nên làm khi cập nhật dữ liệu</h3></div>
                            <div class="guide-card-body">
                                <p class="guide-card-intro">Nếu cần làm cẩn thận và tránh sai sót, nên đi theo trình tự dưới đây thay vì cập nhật rời rạc từng nơi. Quy trình này đặc biệt hữu ích khi nhập nhiều thành viên hoặc chỉnh sửa một nhánh lớn.</p>
                                <div class="guide-process">
                                    <div class="guide-box"><h4>Bước 1</h4><p class="guide-card-intro" style="margin:0">Xem trang chủ nội bộ để nắm số liệu hiện tại và phần đang thiếu.</p></div>
                                    <div class="guide-box"><h4>Bước 2</h4><p class="guide-card-intro" style="margin:0">Chọn đúng cây gia phả rồi cập nhật thành viên và quan hệ trước.</p></div>
                                    <div class="guide-box"><h4>Bước 3</h4><p class="guide-card-intro" style="margin:0">Kiểm tra lại hiển thị của cây sau mỗi lượt sửa để chắc không phát sinh sai nhánh.</p></div>
                                    <div class="guide-box"><h4>Bước 4</h4><p class="guide-card-intro" style="margin:0">Bổ sung ảnh, video, hồ sơ và giấy tờ vào đúng album trong thư viện tư liệu.</p></div>
                                    <div class="guide-box"><h4>Bước 5</h4><p class="guide-card-intro" style="margin:0">Rà lại vai trò và trạng thái tài khoản nếu có thêm người cùng tham gia cập nhật.</p></div>
                                    <div class="guide-box"><h4>Bước 6</h4><p class="guide-card-intro" style="margin:0">Cuối cùng kiểm tra lại nhật ký bảo mật và dùng livestream khi cần trao đổi hoặc họp họ trực tuyến.</p></div>
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
                                            <li><strong>Không thấy người vừa thêm:</strong> kiểm tra lại bộ lọc tên, chi họ, đời hoặc mức zoom hiện tại.</li>
                                            <li><strong>Cây bị trống khi thao tác:</strong> dùng nút về giữa cây rồi kiểm tra xem đang bị kéo lệch quá xa hay không.</li>
                                            <li><strong>Không xem được hậu duệ:</strong> có thể người đó chưa có dữ liệu con cháu hoặc chưa được gắn quan hệ đúng.</li>
                                        </ul>
                                    </div>
                                    <div class="guide-box">
                                        <h4>Trong tư liệu và người dùng</h4>
                                        <ul>
                                            <li><strong>Không tải được video:</strong> kiểm tra loại file, dung lượng và xem trình duyệt có chặn upload không.</li>
                                            <li><strong>Preview bị lệch:</strong> tải lại trang bằng <strong>Ctrl + F5</strong> nếu vừa cập nhật giao diện hoặc tải tệp mới.</li>
                                            <li><strong>Không thấy menu người dùng:</strong> tài khoản hiện tại có thể chưa được cấp đúng vai trò.</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="guide-note">Khi thấy dữ liệu hiển thị bất thường sau một loạt chỉnh sửa, không nên sửa chồng tiếp ngay. Hãy kiểm tra lại cây, bộ lọc đang bật, vai trò tài khoản và nhật ký thay đổi để xác định đúng điểm phát sinh rồi mới tiếp tục xử lý.</div>
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
