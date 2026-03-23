<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="livestreamCssUrl" value="/admin/livestream/livestream.css?v=20260227v3"/>
<c:url var="livestreamJsUrl" value="/admin/livestream/livestream.js?v=20260227v18"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Livestream dòng họ</title>
    <link rel="stylesheet" href="${livestreamCssUrl}">
</head>
<body class="livestream-page">
<div class="main-content livestream-theme">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <script type="text/javascript">
                try { ace.settings.check('breadcrumbs', 'fixed') } catch (e) {}
            </script>
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
                <li class="active">Livestream</li>
            </ul>
        </div>

        <div class="page-content">
            <div id="lsEntryScreen" class="ls-entry">
                <div class="ls-entry-card">
                    <h2 class="ls-entry-title">Phòng livestream dòng họ</h2>
                    <p class="ls-entry-subtitle">Khởi tạo hoặc tham gia buổi truyền trực tuyến để kết nối con cháu theo cùng phong cách trang nghiêm của gia phả.</p>
                    <div class="ls-entry-actions">
                        <button id="btnEntryCreate" type="button" class="ls-btn ls-btn-success ls-entry-btn">
                            <i class="fa fa-plus-circle"></i> Tạo phòng
                        </button>
                        <button id="btnEntryJoin" type="button" class="ls-btn ls-btn-primary ls-entry-btn">
                            <i class="fa fa-sign-in"></i> Tham gia
                        </button>
                    </div>
                    <div id="entrySetupBlock" class="ls-entry-setup ls-hidden">
                        <div class="ls-row">
                            <div>
                                <label class="ls-label" for="entryTitle">Tiêu đề livestream</label>
                                <input id="entryTitle" class="ls-input" placeholder="Nhập tiêu đề livestream"/>
                            </div>
                            <div>
                                <label class="ls-label" for="entryBranchId">Chi nhánh</label>
                                <select id="entryBranchId" class="ls-select"></select>
                            </div>
                        </div>
                        <div class="ls-entry-setup-actions">
                            <button id="btnEntryStartLive" type="button" class="ls-btn ls-btn-success">
                                <i class="fa fa-play"></i> Bắt đầu buổi phát
                            </button>
                        </div>
                    </div>
                    <div id="entryJoinBlock" class="ls-entry-join ls-hidden">
                        <label class="ls-label" for="entryJoinUrl">Nhập link tham gia</label>
                        <div class="ls-inline-group">
                            <input id="entryJoinUrl" class="ls-input" placeholder="/admin/livestream?livestreamId=..."/>
                            <button id="btnEntryJoinSubmit" type="button" class="ls-btn ls-btn-warning">
                                <i class="fa fa-arrow-right"></i> Vào phòng
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="lsMainScreen" class="ls-layout ls-hidden">
                <div class="ls-left">
                    <div class="ls-card ls-player">
                        <video id="remoteVideo" autoplay playsinline></video>
                        <video id="localVideo" autoplay muted playsinline></video>

                        <div class="ls-player-overlay-top">
                            <div class="ls-overlay-left">
                                <span class="ls-live-badge"><span class="ls-dot"></span>TRỰC TIẾP</span>
                                <span class="ls-watch-badge"><i class="fa fa-eye"></i><span id="participantCount">0</span> Đang xem</span>
                            </div>
                        </div>

                        <div class="ls-player-controls">
                            <div class="ls-controls-row">
                                <div class="ls-controls-left">
                                    <button id="btnToggleCamera" type="button" class="ls-icon-btn" title="Camera"><i class="fa fa-video-camera"></i></button>
                                    <button id="btnToggleMic" type="button" class="ls-icon-btn" title="Micro"><i class="fa fa-microphone"></i></button>
                                    <button id="btnShareScreen" type="button" class="ls-icon-btn" title="Chia sẻ màn hình"><i class="fa fa-desktop"></i></button>
                                    <span class="ls-live-chip"><span class="ls-dot-red">●</span> LIVE</span>
                                </div>
                                <div class="ls-controls-right">
                                    <button id="btnFullscreen" type="button" class="ls-icon-btn" title="Toàn màn hình"><i class="fa fa-arrows-alt"></i></button>
                                    <button id="btnLeaveLive" type="button" class="ls-icon-btn" title="Rời phòng"><i class="fa fa-sign-out"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ls-card ls-info">
                        <div class="ls-info-head">
                            <div>
                                <h1 id="lsDisplayTitle" class="ls-title">Lễ Giỗ Tổ Dòng Họ Nguyễn - Năm 2026</h1>
                                <p class="ls-subtitle ls-hidden">Chưa bắt đầu livestream</p>
                            </div>
                            <button id="btnOpenPermission" type="button" class="ls-permission-btn"><i class="fa fa-cog"></i> Cài đặt phân quyền</button>
                        </div>

                        <div class="ls-badges">
                            <span id="lsStatusBadge" class="ls-badge ls-badge-status ls-status-ended"><i class="fa fa-circle"></i> ENDED</span>
                            <span id="lsAccessBadge" class="ls-badge ls-badge-access"><i class="fa fa-lock"></i> Quyền truy cập: Nội bộ dòng họ</span>
                            <span id="lsSecurityBadge" class="ls-badge ls-badge-security"><i class="fa fa-shield"></i> Chế độ bảo mật cao</span>
                        </div>
                        <div id="lsHostSharePanel" class="ls-host-share ls-hidden">
                            <label class="ls-label" for="lsRoomLink">Liên kết phòng</label>
                            <div class="ls-inline-group">
                                <input id="lsRoomLink" class="ls-input" readonly placeholder="Liên kết phòng sẽ xuất hiện khi đang live"/>
                                <button id="btnCopyRoom" type="button" class="ls-btn ls-btn-light">Sao chép link</button>
                            </div>
                        </div>
                        <div id="lsStatusText" class="ls-status" aria-live="polite"></div>

                    </div>
                </div>

                <div class="ls-right">
                    <div class="ls-card ls-sidebar">
                        <div class="ls-tabs">
                            <button id="tabChat" type="button" class="ls-tab active"><i class="fa fa-comment-o"></i> Trò chuyện</button>
                            <button id="tabParticipants" type="button" class="ls-tab"><i class="fa fa-users"></i> Người tham gia</button>
                        </div>

                        <div id="chatPanel" class="ls-chat-panel">
                            <div id="chatList" class="ls-chat-list"></div>
                            <div id="chatEmpty" class="ls-chat-empty">Chưa có tin nhắn. Hãy bắt đầu cuộc trò chuyện.</div>
                        </div>

                        <div id="participantsPanel" class="ls-participants-panel ls-hidden">
                            <div id="participantsEmpty" class="ls-chat-empty">Chưa có người tham gia.</div>
                            <div id="participantsList" class="ls-participants-list"></div>
                        </div>

                        <div class="ls-composer">
                            <div class="ls-composer-row">
                                <input id="chatInput" class="ls-composer-input" placeholder="Nhập tin nhắn..."/>
                                <button id="btnSendChat" type="button" class="ls-send-btn" title="Gửi tin nhắn">
                                    <i class="fa fa-paper-plane-o"></i>
                                </button>
                            </div>
                            <div class="ls-composer-foot">
                                <div class="ls-composer-icons">
                                    <button type="button" class="ls-emoji-btn" data-emoji="😀" title="Mặt cười">😀</button>
                                    <button type="button" class="ls-emoji-btn" data-emoji="❤️" title="Trái tim">❤️</button>
                                    <button type="button" class="ls-emoji-btn" data-emoji="👍" title="Thích">👍</button>
                                    <button type="button" class="ls-emoji-btn" data-emoji="😂" title="Cười">😂</button>
                                    <button type="button" class="ls-emoji-btn" data-emoji="🎉" title="Chúc mừng">🎉</button>
                                    <button type="button" class="ls-emoji-btn" data-emoji="🙏" title="Cảm ơn">🙏</button>
                                </div>
                                <span>Nhấn Enter để gửi</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="permissionModal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content ls-modal-content">
            <div class="modal-header">
                <button id="btnClosePermission" type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Cài đặt phân quyền livestream</h4>
            </div>
            <div class="modal-body">
                <div class="ls-modal-group">
                    <label class="ls-label" for="permChatMode">Quyền chat</label>
                    <select id="permChatMode" class="ls-select">
                        <option value="all">Tất cả người tham gia</option>
                        <option value="host">Chỉ chủ phòng</option>
                        <option value="off">Tắt chat</option>
                    </select>
                </div>
                <div class="ls-modal-group">
                    <label class="ls-label" for="permScope">Phạm vi truy cập</label>
                    <select id="permScope" class="ls-select" disabled>
                        <option value="branch">Nội bộ dòng họ</option>
                    </select>
                </div>
                <div class="ls-modal-group">
                    <label class="ls-label" for="permSecurity">Mức bảo mật</label>
                    <select id="permSecurity" class="ls-select">
                        <option value="high">Cao</option>
                        <option value="normal">Tiêu chuẩn</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelPermission" type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                <button id="btnSavePermission" type="button" class="btn btn-primary">Lưu cài đặt</button>
            </div>
        </div>
    </div>
</div>

<div id="lsToastStack" class="ls-toast-stack" aria-live="polite" aria-atomic="true"></div>

<script>
    window.LIVESTREAM_ICE_SERVERS = ${livestreamIceServersJson};
</script>
<script src="${livestreamJsUrl}"></script>
</body>
</html>
