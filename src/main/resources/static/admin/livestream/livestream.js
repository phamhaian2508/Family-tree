﻿﻿﻿﻿﻿﻿﻿(function () {
  var LIVE_ID = null;
  var SOCKET = null;
  var SELF_SESSION_ID = null;
  var HOST_SESSION_ID = null;
  var CAN_HOST = false;
  var LOCAL_STREAM = null;
  var SCREEN_STREAM = null;
  var IS_SHARING_SCREEN = false;
  var IS_ENDING_LIVE = false;
  var IS_LEAVING_ROOM = false;
  var CAM_ENABLED = false;
  var MIC_ENABLED = false;
  var PEERS = {};
  var PARTICIPANTS = 0;
  var PARTICIPANT_NAMES = {};
  var PERMISSION_STORAGE_KEY = "livestream.permission.settings";
  var PERMISSIONS = { chatMode: "all", scope: "branch", security: "high" };
  var DEFAULT_ICE_SERVERS = [
    { urls: "stun:stun.l.google.com:19302" },
    { urls: "stun:stun1.l.google.com:19302" }
  ];
  var RTC_CONFIG = { iceServers: resolveIceServers() };
  var AUDIO_CONSTRAINTS = { echoCancellation: true, noiseSuppression: true, autoGainControl: true };
  var AUTO_START_SCREEN_ON_WELCOME = false;
  var DRAG_STATE = { active: false, offsetX: 0, offsetY: 0 };
  var LIVE_STATUS_CODE = 0;
  var REMOTE_VIEW_MODE = "fit";
  var LIVE_STARTED_AT = null;
  var LIVE_TIME_TIMER = null;
  var FALLBACK_VIDEO_TRACK = null;
  var FALLBACK_VIDEO_STREAM = null;
  var COMPOSITE_CANVAS = null;
  var COMPOSITE_CTX = null;
  var COMPOSITE_STREAM = null;
  var COMPOSITE_TRACK = null;
  var COMPOSITE_TIMER = null;
  var REMOTE_VIEWER_STREAM = null;

  function $(id) { return document.getElementById(id); }

  function resolveIceServers() {
    var configured = (window && window.LIVESTREAM_ICE_SERVERS) || null;
    if (!Array.isArray(configured) || !configured.length) return DEFAULT_ICE_SERVERS;
    var normalized = configured.filter(function (item) {
      return item && typeof item === "object" && !!item.urls;
    }).map(function (item) {
      var server = { urls: item.urls };
      if (item.username) server.username = item.username;
      if (item.credential) server.credential = item.credential;
      if (item.credentialType) server.credentialType = item.credentialType;
      return server;
    });
    return normalized.length ? normalized : DEFAULT_ICE_SERVERS;
  }

  function getMediaErrorMessage(err, actionLabel) {
    if (!err) return actionLabel + " thất bại.";
    var name = err.name || "";
    if (name === "NotAllowedError" || name === "PermissionDeniedError") {
      return "Trình duyệt chưa cấp quyền " + actionLabel + ".";
    }
    if (name === "NotFoundError" || name === "DevicesNotFoundError") {
      return "Không tìm thấy thiết bị cho " + actionLabel + ".";
    }
    if (name === "NotReadableError" || name === "TrackStartError") {
      return "Thiết bị đang bận hoặc bị chặn khi " + actionLabel + ".";
    }
    if (name === "OverconstrainedError" || name === "ConstraintNotSatisfiedError") {
      return "Thiết bị không đáp ứng cấu hình khi " + actionLabel + ".";
    }
    if (name === "SecurityError") {
      return "Trang web cần HTTPS để " + actionLabel + ".";
    }
    return actionLabel + " thất bại: " + (err.message || name || "Unknown error");
  }

  function hasTurnServer(iceServers) {
    if (!Array.isArray(iceServers)) return false;
    return iceServers.some(function (s) {
      if (!s || !s.urls) return false;
      var urls = Array.isArray(s.urls) ? s.urls : [s.urls];
      return urls.some(function (u) { return String(u || "").indexOf("turn:") === 0 || String(u || "").indexOf("turns:") === 0; });
    });
  }
  function escapeHtml(str) {
    return String(str || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/\"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function setRemoteVideoBlack() {
    var remoteVideo = $("remoteVideo");
    if (!remoteVideo) return;
    REMOTE_VIEWER_STREAM = null;
    remoteVideo.srcObject = null;
    remoteVideo.removeAttribute("src");
    remoteVideo.load();
  }

  function ensureFallbackVideoTrack() {
    if (FALLBACK_VIDEO_TRACK && FALLBACK_VIDEO_TRACK.readyState === "live") return FALLBACK_VIDEO_TRACK;
    var canvas = document.createElement("canvas");
    canvas.width = 640;
    canvas.height = 360;
    var ctx = canvas.getContext("2d");
    if (ctx) {
      ctx.fillStyle = "#000000";
      ctx.fillRect(0, 0, canvas.width, canvas.height);
    }
    FALLBACK_VIDEO_STREAM = canvas.captureStream(5);
    FALLBACK_VIDEO_TRACK = FALLBACK_VIDEO_STREAM.getVideoTracks()[0] || null;
    return FALLBACK_VIDEO_TRACK;
  }

  function stopCompositeShareTrack() {
    if (COMPOSITE_TIMER) {
      clearInterval(COMPOSITE_TIMER);
      COMPOSITE_TIMER = null;
    }
    if (COMPOSITE_STREAM) {
      COMPOSITE_STREAM.getTracks().forEach(function (t) { t.stop(); });
    }
    COMPOSITE_CANVAS = null;
    COMPOSITE_CTX = null;
    COMPOSITE_STREAM = null;
    COMPOSITE_TRACK = null;
  }

  function ensureCompositeShareTrack(screenTrack, camTrack) {
    if (!screenTrack || !camTrack) return null;
    if (COMPOSITE_TRACK && COMPOSITE_TRACK.readyState === "live") return COMPOSITE_TRACK;

    COMPOSITE_CANVAS = document.createElement("canvas");
    COMPOSITE_CANVAS.width = 1280;
    COMPOSITE_CANVAS.height = 720;
    COMPOSITE_CTX = COMPOSITE_CANVAS.getContext("2d");

    var screenVideo = document.createElement("video");
    screenVideo.autoplay = true;
    screenVideo.muted = true;
    screenVideo.playsInline = true;
    screenVideo.srcObject = new MediaStream([screenTrack]);
    screenVideo.play().catch(function () {});

    var camVideo = document.createElement("video");
    camVideo.autoplay = true;
    camVideo.muted = true;
    camVideo.playsInline = true;
    camVideo.srcObject = new MediaStream([camTrack]);
    camVideo.play().catch(function () {});

    COMPOSITE_STREAM = COMPOSITE_CANVAS.captureStream(24);
    COMPOSITE_TRACK = COMPOSITE_STREAM.getVideoTracks()[0] || null;
    COMPOSITE_TIMER = setInterval(function () {
      if (!COMPOSITE_CTX) return;
      COMPOSITE_CTX.fillStyle = "#000";
      COMPOSITE_CTX.fillRect(0, 0, COMPOSITE_CANVAS.width, COMPOSITE_CANVAS.height);
      try {
        COMPOSITE_CTX.drawImage(screenVideo, 0, 0, COMPOSITE_CANVAS.width, COMPOSITE_CANVAS.height);
      } catch (e) {}

      var pipW = Math.round(COMPOSITE_CANVAS.width * 0.25);
      var pipH = Math.round(pipW * 9 / 16);
      var pipX = COMPOSITE_CANVAS.width - pipW - 20;
      var pipY = COMPOSITE_CANVAS.height - pipH - 20;
      try {
        COMPOSITE_CTX.drawImage(camVideo, pipX, pipY, pipW, pipH);
      } catch (e) {}
    }, 1000 / 24);

    return COMPOSITE_TRACK;
  }

  function getPreferredOutboundVideoTrack() {
    if (IS_SHARING_SCREEN && SCREEN_STREAM) {
      var screenTrack = SCREEN_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });
      if (screenTrack) {
        var camTrack = CAM_ENABLED && LOCAL_STREAM
          ? LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; })
          : null;
        if (camTrack) return ensureCompositeShareTrack(screenTrack, camTrack);
        stopCompositeShareTrack();
        return screenTrack;
      }
    }
    if (LOCAL_STREAM) {
      var camTrack = LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });
      if (camTrack) {
        stopCompositeShareTrack();
        return camTrack;
      }
    }
    stopCompositeShareTrack();
    return ensureFallbackVideoTrack();
  }

  function applyRemoteViewMode() {
    var player = document.querySelector(".ls-player");
    var btn = $("btnToggleFitMode");
    if (player) player.classList.toggle("fill", REMOTE_VIEW_MODE === "fill");
    if (btn) {
      var isFill = REMOTE_VIEW_MODE === "fill";
      btn.textContent = isFill ? "FILL" : "FIT";
      btn.classList.toggle("active", isFill);
      btn.title = isFill ? "Đang lấp đầy khung (có thể bị cắt)" : "Đang hiển thị toàn bộ màn hình chia sẻ";
    }
  }

  function toggleRemoteViewMode() {
    REMOTE_VIEW_MODE = REMOTE_VIEW_MODE === "fit" ? "fill" : "fit";
    applyRemoteViewMode();
  }

  function formatClockTime(date) {
    var d = date instanceof Date ? date : new Date(date);
    if (isNaN(d.getTime())) return "--:--";
    var h = String(d.getHours()).padStart(2, "0");
    var m = String(d.getMinutes()).padStart(2, "0");
    return h + ":" + m;
  }

  function formatDateTimeVN(date) {
    var d = date instanceof Date ? date : new Date(date);
    if (isNaN(d.getTime())) return "--:--:--, --/--/----";
    var hh = String(d.getHours()).padStart(2, "0");
    var mm = String(d.getMinutes()).padStart(2, "0");
    var ss = String(d.getSeconds()).padStart(2, "0");
    var dd = String(d.getDate()).padStart(2, "0");
    var mo = String(d.getMonth() + 1).padStart(2, "0");
    var yy = d.getFullYear();
    return hh + ":" + mm + ":" + ss + ", " + dd + "/" + mo + "/" + yy;
  }

  function formatDuration(ms) {
    var totalSec = Math.max(0, Math.floor(ms / 1000));
    var h = Math.floor(totalSec / 3600);
    var m = Math.floor((totalSec % 3600) / 60);
    var s = totalSec % 60;
    if (h > 0) return String(h).padStart(2, "0") + ":" + String(m).padStart(2, "0") + ":" + String(s).padStart(2, "0");
    return String(m).padStart(2, "0") + ":" + String(s).padStart(2, "0");
  }

  function resolveStartedAt(data) {
    if (!data) return null;
    var raw = data.startedAt;
    if (raw == null) raw = data.startTime;
    if (raw == null) raw = data.createdAt;
    if (raw == null) raw = data.createdDate;
    if (raw == null) return null;
    if (typeof raw === "number") return raw;
    var ts = new Date(raw).getTime();
    return isNaN(ts) ? null : ts;
  }

  function stopLiveTimeTicker() {
    if (LIVE_TIME_TIMER) {
      clearInterval(LIVE_TIME_TIMER);
      LIVE_TIME_TIMER = null;
    }
  }

  function renderLiveSubtitle() {
    var subtitle = document.querySelector(".ls-subtitle");
    var durationBadge = $("lsLiveDurationBadge");
    if (!subtitle) return;
    if (!LIVE_STARTED_AT) {
      subtitle.textContent = "Chưa bắt đầu livestream";
      if (durationBadge) durationBadge.innerHTML = '<i class="fa fa-clock-o"></i> 00:00';
      return;
    }
    var start = new Date(LIVE_STARTED_AT);
    var elapsed = formatDuration(Date.now() - start.getTime());
    subtitle.textContent = "Bắt đầu lúc " + formatDateTimeVN(start);
    if (durationBadge) durationBadge.innerHTML = '<i class="fa fa-clock-o"></i> ' + elapsed;
  }

  function startLiveTimeTicker() {
    stopLiveTimeTicker();
    renderLiveSubtitle();
    LIVE_TIME_TIMER = setInterval(renderLiveSubtitle, 1000);
  }

  function refreshParticipantCount() {
    setParticipantCount(Object.keys(PARTICIPANT_NAMES).length);
  }

  function updateRoleBasedUI() {
    var hostOnlyIds = ["btnToggleCamera", "btnToggleMic", "btnShareScreen", "btnEndLive", "btnOpenPermission"];
    hostOnlyIds.forEach(function (id) {
      var el = $(id);
      if (el) el.classList.toggle("ls-hidden", !CAN_HOST);
    });
    updateHostShareUI();
    updateChatComposerUI();
  }

  function updateChatComposerUI() {
    var input = $("chatInput");
    var sendBtn = $("btnSendChat");
    var emojiButtons = document.querySelectorAll(".ls-emoji-btn");
    if (!input || !sendBtn) return;
    var canChat = canCurrentUserChat();
    input.disabled = !canChat;
    sendBtn.disabled = !canChat;
    emojiButtons.forEach(function (btn) { btn.disabled = !canChat; });
    if (!canChat) {
      input.placeholder = PERMISSIONS.chatMode === "off" ? "Chat đã tắt bởi host" : "Chỉ host được phép chat";
    } else {
      input.placeholder = "Nhập tin nhắn...";
    }
  }

  function updateHostShareUI() {
    var panel = $("lsHostSharePanel");
    if (panel) panel.classList.toggle("ls-hidden", !CAN_HOST);
    var copyBtn = $("btnCopyRoom");
    var roomLink = $("lsRoomLink");
    if (copyBtn) copyBtn.disabled = !CAN_HOST || !roomLink || !(roomLink.value || "").trim();
  }

  function updateLocalPreviewVisibility() {
    var localVideo = $("localVideo");
    if (!localVideo) return;
    var hasLiveCam = !!(LOCAL_STREAM && LOCAL_STREAM.getVideoTracks().some(function (t) { return t.readyState === "live"; }));
    localVideo.style.display = (CAN_HOST && IS_SHARING_SCREEN && CAM_ENABLED && hasLiveCam) ? "block" : "none";
    if (localVideo.style.display === "none") {
      localVideo.style.left = "";
      localVideo.style.top = "";
      localVideo.style.right = "14px";
      localVideo.style.bottom = "14px";
    }
  }

  function syncHostMainAndOverlayVideo() {
    if (!CAN_HOST) return;
    var remoteVideo = $("remoteVideo");
    var localVideo = $("localVideo");
    if (!remoteVideo || !localVideo) return;

    var screenTrack = SCREEN_STREAM && SCREEN_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });
    var camTrack = LOCAL_STREAM && LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });

    if (IS_SHARING_SCREEN && screenTrack) {
      remoteVideo.srcObject = new MediaStream([screenTrack]);
      localVideo.srcObject = (CAM_ENABLED && camTrack) ? new MediaStream([camTrack]) : null;
      updateLocalPreviewVisibility();
      return;
    }

    if (CAM_ENABLED && camTrack) {
      remoteVideo.srcObject = new MediaStream([camTrack]);
      localVideo.srcObject = null;
      updateLocalPreviewVisibility();
      return;
    }

    localVideo.srcObject = null;
    updateLocalPreviewVisibility();
    setRemoteVideoBlack();
  }

  function initDraggableLocalVideo() {
    var localVideo = $("localVideo");
    var player = document.querySelector(".ls-player");
    if (!localVideo || !player) return;

    function moveWithinPlayer(clientX, clientY) {
      var playerRect = player.getBoundingClientRect();
      var left = clientX - playerRect.left - DRAG_STATE.offsetX;
      var top = clientY - playerRect.top - DRAG_STATE.offsetY;
      var maxLeft = player.clientWidth - localVideo.offsetWidth;
      var maxTop = player.clientHeight - localVideo.offsetHeight;
      if (left < 0) left = 0;
      if (top < 0) top = 0;
      if (left > maxLeft) left = maxLeft;
      if (top > maxTop) top = maxTop;
      localVideo.style.left = left + "px";
      localVideo.style.top = top + "px";
    }

    localVideo.addEventListener("pointerdown", function (e) {
      if (localVideo.style.display === "none") return;
      DRAG_STATE.active = true;
      var localRect = localVideo.getBoundingClientRect();
      DRAG_STATE.offsetX = e.clientX - localRect.left;
      DRAG_STATE.offsetY = e.clientY - localRect.top;
      localVideo.setPointerCapture(e.pointerId);
      localVideo.style.right = "auto";
      localVideo.style.bottom = "auto";
      e.preventDefault();
    });

    localVideo.addEventListener("pointermove", function (e) {
      if (!DRAG_STATE.active) return;
      moveWithinPlayer(e.clientX, e.clientY);
    });

    function endDrag(e) {
      if (!DRAG_STATE.active) return;
      DRAG_STATE.active = false;
      try { localVideo.releasePointerCapture(e.pointerId); } catch (err) {}
    }

    localVideo.addEventListener("pointerup", endDrag);
    localVideo.addEventListener("pointercancel", endDrag);

    localVideo.addEventListener("mousedown", function (e) {
      if (localVideo.style.display === "none") return;
      DRAG_STATE.active = true;
      var localRect = localVideo.getBoundingClientRect();
      DRAG_STATE.offsetX = e.clientX - localRect.left;
      DRAG_STATE.offsetY = e.clientY - localRect.top;
      localVideo.style.right = "auto";
      localVideo.style.bottom = "auto";
      e.preventDefault();
    });

    document.addEventListener("mousemove", function (e) {
      if (!DRAG_STATE.active) return;
      moveWithinPlayer(e.clientX, e.clientY);
    });

    document.addEventListener("mouseup", function () {
      DRAG_STATE.active = false;
    });
  }

  function setStatusText(message, isError) {
    var el = $("lsStatusText");
    if (!el) return;
    el.textContent = message || "";
    el.style.color = isError ? "#dc2626" : "#475569";
  }

  function showToast(message, type, title) {
    var stack = $("lsToastStack");
    if (!stack || !message) return;
    var tone = type || "info";
    var icon = tone === "error" ? "fa-exclamation-circle" : (tone === "success" ? "fa-check-circle" : "fa-info-circle");
    var heading = title || (tone === "error" ? "Thông báo lỗi" : (tone === "success" ? "Thao tác thành công" : "Thông báo"));
    var toast = document.createElement("div");
    toast.className = "ls-toast ls-toast-" + tone;
    toast.innerHTML =
      '<span class="ls-toast-icon"><i class="fa ' + icon + '"></i></span>' +
      '<div class="ls-toast-body">' +
      '  <div class="ls-toast-title">' + escapeHtml(heading) + '</div>' +
      '  <div class="ls-toast-message">' + escapeHtml(message) + '</div>' +
      '</div>' +
      '<button type="button" class="ls-toast-close" aria-label="Đóng">&times;</button>';
    stack.appendChild(toast);

    var removeToast = function () {
      if (!toast.parentNode) return;
      toast.classList.remove("is-visible");
      window.setTimeout(function () {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
      }, 180);
    };

    var closeBtn = toast.querySelector(".ls-toast-close");
    if (closeBtn) closeBtn.addEventListener("click", removeToast);

    window.requestAnimationFrame(function () {
      toast.classList.add("is-visible");
    });

    window.setTimeout(removeToast, tone === "error" ? 5000 : 3600);
  }

  function setStatusBadge(status) {
    var badge = $("lsStatusBadge");
    if (!badge) return;
    var normalized = (status || "ENDED").toUpperCase();
    badge.classList.remove("ls-status-live", "ls-status-ended");
    badge.classList.add(normalized === "LIVE" ? "ls-status-live" : "ls-status-ended");
    badge.innerHTML = '<i class="fa fa-circle"></i> ' + normalized;
    LIVE_STATUS_CODE = normalized === "LIVE" ? 1 : 0;
  }

  function isLiveStatus(data) {
    if (!data) return false;
    if (typeof data.statusCode === "number") return Number(data.statusCode) === 1;
    return String(data.status || "").toUpperCase() === "LIVE";
  }

  function loadPermissions() {
    try {
      var raw = localStorage.getItem(PERMISSION_STORAGE_KEY);
      if (raw) {
        var parsed = JSON.parse(raw);
        PERMISSIONS.chatMode = parsed.chatMode || "all";
        PERMISSIONS.security = parsed.security || "high";
      }
    } catch (e) {}
    PERMISSIONS.scope = "branch";
  }

  function savePermissions() {
    try {
      localStorage.setItem(PERMISSION_STORAGE_KEY, JSON.stringify(PERMISSIONS));
    } catch (e) {}
    applyPermissionToUI();
  }

  function applyPermissionToUI() {
    PERMISSIONS.scope = "branch";
    if ($("lsAccessBadge")) $("lsAccessBadge").innerHTML = '<i class="fa fa-lock"></i> Quyền truy cập: Nội bộ dòng họ';
    if ($("lsSecurityBadge")) $("lsSecurityBadge").innerHTML = '<i class="fa fa-shield"></i> Chế độ bảo mật ' + (PERMISSIONS.security === "high" ? "cao" : "tiêu chuẩn");
    updateChatComposerUI();
  }

  function openPermissionModal() {
    $("permChatMode").value = PERMISSIONS.chatMode;
    $("permScope").value = "branch";
    $("permSecurity").value = PERMISSIONS.security;
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) window.jQuery("#permissionModal").modal("show");
  }

  function closePermissionModal() {
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) window.jQuery("#permissionModal").modal("hide");
  }

  function canCurrentUserChat() {
    if (PERMISSIONS.chatMode === "off") return false;
    return !(PERMISSIONS.chatMode === "host" && !CAN_HOST);
  }

  function setParticipantCount(count) {
    PARTICIPANTS = Math.max(0, Number(count || 0));
    if ($("participantCount")) $("participantCount").textContent = String(PARTICIPANTS);
  }

  function renderParticipants() {
    var listEl = $("participantsList");
    var emptyEl = $("participantsEmpty");
    if (!listEl || !emptyEl) return;
    var ids = Object.keys(PARTICIPANT_NAMES);
    if (!ids.length) {
      listEl.innerHTML = "";
      emptyEl.style.display = "block";
      return;
    }
    emptyEl.style.display = "none";
    listEl.innerHTML = ids.map(function (sid) {
      var name = escapeHtml(PARTICIPANT_NAMES[sid] || "Thành viên");
      var initials = name.split(" ").filter(Boolean).slice(-2).map(function (v) { return v.charAt(0); }).join("").toUpperCase();
      var isHost = HOST_SESSION_ID && sid === HOST_SESSION_ID;
      return '<div class="ls-participant-item"><div class="ls-participant-left"><span class="ls-participant-avatar">' +
        (initials || "TV") + '</span><span class="ls-participant-name">' + name +
        '</span></div><div class="ls-participant-meta"><span class="ls-online-dot"></span><span class="ls-role-tag ' +
        (isHost ? "host" : "member") + '">' + (isHost ? "Host" : "Member") + "</span></div></div>";
    }).join("");
  }

  function appendChatMessage(name, text, time, isHost) {
    var chatList = $("chatList");
    var emptyEl = $("chatEmpty");
    if (!chatList) return;
    if (emptyEl) emptyEl.style.display = "none";
    var safeName = escapeHtml(name || "Thành viên");
    var initials = safeName.split(" ").filter(Boolean).slice(-2).map(function (v) { return v.charAt(0); }).join("").toUpperCase();
    var role = isHost ? '<span class="ls-chat-role">ADMIN</span>' : '';
    var item = document.createElement("div");
    item.className = "ls-chat-item";
    item.innerHTML = '<div class="ls-chat-avatar">' + (initials || "TV") + '</div><div class="ls-chat-body"><div class="ls-chat-head"><span class="ls-chat-name ' +
      (isHost ? "host" : "") + '">' + safeName + '</span>' + role + '<span class="ls-chat-time">' + escapeHtml(time || "") +
      '</span></div><div class="ls-chat-bubble">' + escapeHtml(text || "") + "</div></div>";
    chatList.appendChild(item);
    chatList.scrollTop = chatList.scrollHeight;
  }

  function clearChatMessages() {
    var chatList = $("chatList");
    var emptyEl = $("chatEmpty");
    if (chatList) chatList.innerHTML = "";
    if (emptyEl) emptyEl.style.display = "block";
  }

  async function readApiError(res, fallback) {
    if (res.status === 401) return "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.";
    var text = "";
    try { text = await res.text(); } catch (e) {}
    if (!text) return fallback;
    if (text.indexOf("<html") !== -1 || text.indexOf("<!DOCTYPE") !== -1) return fallback;
    return text;
  }

  async function loadBranches() {
    try {
      var res = await fetch("/api/branch");
      if (!res.ok) return;
      var branches = await res.json();
      var select = $("lsBranchId");
      var entrySelect = $("entryBranchId");
      if (!Array.isArray(branches)) return;
      var html = branches.map(function (b) { return '<option value="' + b.id + '">' + (b.name || ("Chi nhánh " + b.id)) + "</option>"; }).join("");
      if (select) select.innerHTML = html;
      if (entrySelect) entrySelect.innerHTML = html;
    } catch (e) {}
  }

  function getQueryParam(name) { return new URLSearchParams(window.location.search).get(name); }

  function parseLivestreamIdFromUrl(rawUrl) {
    if (!rawUrl) return null;
    try {
      var u = new URL(rawUrl, window.location.origin);
      var id = u.searchParams.get("livestreamId");
      return id ? Number(id) : null;
    } catch (e) { return null; }
  }

  function showMainScreen() {
    var entry = $("lsEntryScreen");
    var main = $("lsMainScreen");
    if (entry) entry.classList.add("ls-hidden");
    if (main) main.classList.remove("ls-hidden");
  }

  function showEntryScreen() {
    var entry = $("lsEntryScreen");
    var main = $("lsMainScreen");
    if (entry) entry.classList.remove("ls-hidden");
    if (main) main.classList.add("ls-hidden");
  }

  async function joinByUrlInput(rawUrl) {
    function showJoinError(message) {
      setStatusText(message, true);
      showToast(message, "error", "Không thể vào phòng");
    }
    var id = parseLivestreamIdFromUrl((rawUrl || "").trim());
    if (!id) { showJoinError("URL livestream không hợp lệ."); return; }
    try {
      var data = await watchLiveById(id);
      if (!isLiveStatus(data)) {
        showJoinError("Liên kết phòng không tồn tại hoặc livestream đã kết thúc.");
        return;
      }
      showMainScreen();
      applyLiveData(data);
      connectSocket(data.livestreamId || id);
      setStatusText("Đã vào phòng livestream.", false);
    } catch (e) {
      showJoinError("Liên kết phòng không tồn tại hoặc livestream đã kết thúc.");
    }
  }

  function applyLiveData(data) {
    if (!data) return;
    var previousLiveId = LIVE_ID ? String(LIVE_ID) : "";
    var incomingLiveId = data.livestreamId ? String(data.livestreamId) : previousLiveId;
    if (previousLiveId && incomingLiveId && previousLiveId !== incomingLiveId) clearChatMessages();
    LIVE_ID = data.livestreamId || LIVE_ID;
    var startedAt = resolveStartedAt(data);
    if (startedAt) LIVE_STARTED_AT = startedAt;
    else if (!isLiveStatus(data)) LIVE_STARTED_AT = null;
    $("lsDisplayTitle").textContent = data.title || "Phòng livestream";
    if ($("lsTitle")) $("lsTitle").value = data.title || "";
    if (data.branchId && $("lsBranchId")) $("lsBranchId").value = String(data.branchId);
    if (data.roomLink) {
      var fullLink = /^https?:\/\//i.test(data.roomLink) ? data.roomLink : (window.location.origin + data.roomLink);
      if ($("lsRoomLink")) $("lsRoomLink").value = fullLink;
      if ($("lsJoinUrl")) $("lsJoinUrl").value = fullLink;
    } else if (!isLiveStatus(data)) {
      if ($("lsRoomLink")) $("lsRoomLink").value = "";
      if ($("lsJoinUrl")) $("lsJoinUrl").value = "";
    }
    setStatusBadge(data.status);
    updateRoleBasedUI();
    if (isLiveStatus(data)) startLiveTimeTicker();
    else {
      stopLiveTimeTicker();
      renderLiveSubtitle();
    }
  }

  async function startLiveRoom(customTitle, customBranchId) {
    var title = typeof customTitle === "string" ? customTitle : (($("lsTitle") ? $("lsTitle").value : "") || "");
    var branchId = customBranchId != null ? customBranchId : Number(($("lsBranchId") ? $("lsBranchId").value : 0) || 0);
    var payload = { title: title.trim(), branchId: Number(branchId || 0) };
    if (!payload.branchId) { setStatusText("Vui lòng chọn chi nhánh.", true); return; }
    var res = await fetch("/api/livestream/start", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(payload) });
    if (!res.ok) throw new Error(await readApiError(res, "Bắt đầu livestream thất bại."));
    var data = await res.json();
    var nextLiveId = data && data.livestreamId ? String(data.livestreamId) : "";
    var currentLiveId = LIVE_ID ? String(LIVE_ID) : "";
    if (nextLiveId && nextLiveId !== currentLiveId) clearChatMessages();
    applyLiveData(data);
    return data;
  }

  async function watchLiveById(id) {
    var url = "/api/livestream/watch";
    if (id) url += "?livestreamId=" + encodeURIComponent(id);
    var res = await fetch(url);
    if (!res.ok) throw new Error(await readApiError(res, "Không thể xem phòng này."));
    return await res.json();
  }

  async function loadCurrentLive() {
    var res = await fetch("/api/livestream/live");
    if (!res.ok) throw new Error(await readApiError(res, "Không có livestream đang hoạt động."));
    return await res.json();
  }

  async function endLiveById(id) {
    var res = await fetch("/api/livestream/" + encodeURIComponent(id) + "/end", { method: "PUT" });
    if (!res.ok) throw new Error(await readApiError(res, "Kết thúc livestream thất bại."));
    return await res.json();
  }

  async function ensureLocalMedia() {
    if (LOCAL_STREAM) return LOCAL_STREAM;
    LOCAL_STREAM = await navigator.mediaDevices.getUserMedia({ video: true, audio: AUDIO_CONSTRAINTS });
    applyLocalTrackStates();
    updateLocalPreviewVisibility();
    updateMediaButtons();
    return LOCAL_STREAM;
  }

  function applyLocalTrackStates() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getVideoTracks().forEach(function (t) { t.enabled = CAM_ENABLED; });
    LOCAL_STREAM.getAudioTracks().forEach(function (t) { t.enabled = MIC_ENABLED; });
  }

  async function ensureCameraTrack() {
    if (!LOCAL_STREAM) await ensureLocalMedia();
    var current = LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });
    if (current) return current;
    var camStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
    var camTrack = camStream.getVideoTracks()[0];
    if (!camTrack) return null;
    LOCAL_STREAM.addTrack(camTrack);
    return camTrack;
  }

  function stopCameraTrack() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getVideoTracks().forEach(function (t) { t.stop(); LOCAL_STREAM.removeTrack(t); });
  }

  function updateMediaButtons() {
    if ($("btnToggleCamera")) $("btnToggleCamera").classList.toggle("active", CAM_ENABLED);
    if ($("btnToggleMic")) $("btnToggleMic").classList.toggle("active", MIC_ENABLED);
  }

  function stopLocalMedia() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getTracks().forEach(function (t) { t.stop(); });
    LOCAL_STREAM = null;
    stopCompositeShareTrack();
    CAM_ENABLED = false;
    MIC_ENABLED = false;
    $("localVideo").srcObject = null;
    updateLocalPreviewVisibility();
    updateMediaButtons();
  }

  function replaceOutgoingVideoTrack(track) {
    Object.keys(PEERS).forEach(function (sid) {
      var pc = PEERS[sid];
      if (!pc) return;
      var sender = pc.getSenders().find(function (s) { return s.track && s.track.kind === "video"; });
      if (sender) sender.replaceTrack(track || null);
    });
  }

  function syncOutgoingAudioTrack() {
    var audioTrack = LOCAL_STREAM
      ? LOCAL_STREAM.getAudioTracks().find(function (t) { return t.readyState === "live"; })
      : null;
    Object.keys(PEERS).forEach(function (sid) {
      var pc = PEERS[sid];
      if (!pc) return;
      var sender = pc.getSenders().find(function (s) { return s.track && s.track.kind === "audio"; });
      if (audioTrack) {
        if (sender) {
          try { sender.replaceTrack(audioTrack); } catch (e) {}
        } else if (LOCAL_STREAM) {
          try { pc.addTrack(audioTrack, LOCAL_STREAM); } catch (e) {}
        }
      } else if (sender) {
        try { sender.replaceTrack(null); } catch (e) {}
      }
    });
  }

  async function renegotiateAllPeers() {
    var peerIds = Object.keys(PEERS);
    for (var i = 0; i < peerIds.length; i++) {
      try { await createOfferFor(peerIds[i]); } catch (e) {}
    }
  }

  async function stopScreenShare(internalStop) {
    if (!IS_SHARING_SCREEN) return;
    if (SCREEN_STREAM) {
      SCREEN_STREAM.getTracks().forEach(function (t) { t.stop(); });
      SCREEN_STREAM = null;
    }
    IS_SHARING_SCREEN = false;
    stopCompositeShareTrack();
    replaceOutgoingVideoTrack(getPreferredOutboundVideoTrack());
    $("btnShareScreen").classList.remove("active");
    syncHostMainAndOverlayVideo();
    if (!internalStop) setStatusText("Đã dừng chia sẻ màn hình.", false);
  }

  async function toggleScreenShare() {
    if (!CAN_HOST) { setStatusText("Chỉ chủ phòng mới có thể chia sẻ màn hình.", true); return; }
    if (IS_SHARING_SCREEN) { await stopScreenShare(false); return; }
    SCREEN_STREAM = await navigator.mediaDevices.getDisplayMedia({ video: true, audio: false });
    var screenTrack = SCREEN_STREAM.getVideoTracks()[0];
    if (!screenTrack) { setStatusText("Không có track màn hình.", true); return; }
    IS_SHARING_SCREEN = true;
    replaceOutgoingVideoTrack(getPreferredOutboundVideoTrack());
    syncHostMainAndOverlayVideo();
    $("btnShareScreen").classList.add("active");
    setStatusText("Đang chia sẻ màn hình.", false);
    screenTrack.onended = function () { stopScreenShare(true); };
  }

  function sendSignal(type, target, payload) {
    if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) return;
    SOCKET.send(JSON.stringify({ type: type, target: target, payload: payload || {} }));
  }

  async function createPeerConnection(peerId, asHostOfferer) {
    var pc = new RTCPeerConnection(RTC_CONFIG);
    PEERS[peerId] = pc;
    pc.onicecandidate = function (event) { if (event.candidate) sendSignal("ice", peerId, { candidate: event.candidate }); };
    pc.oniceconnectionstatechange = function () {
      var st = pc.iceConnectionState;
      if (st === "failed") {
        setStatusText("Kết nối media thất bại. Kiểm tra TURN/Firewall (3478, 5349, UDP relay).", true);
      } else if (st === "disconnected") {
        setStatusText("Kết nối media bị gián đoạn.", true);
      }
    };
    pc.onconnectionstatechange = function () {
      var st = pc.connectionState;
      if (st === "failed") {
        setStatusText("Peer connection failed. Kiểm tra cấu hình TURN và mạng.", true);
      }
    };
    pc.ontrack = function (event) {
      if (CAN_HOST) return;
      var remoteVideo = $("remoteVideo");
      if (!remoteVideo) return;
      if (!REMOTE_VIEWER_STREAM) REMOTE_VIEWER_STREAM = new MediaStream();
      if (event.track && !REMOTE_VIEWER_STREAM.getTracks().some(function (t) { return t.id === event.track.id; })) {
        REMOTE_VIEWER_STREAM.addTrack(event.track);
      }
      remoteVideo.srcObject = REMOTE_VIEWER_STREAM;
      try { remoteVideo.play(); } catch (e) {}
    };
    if (asHostOfferer) {
      var videoTrack = getPreferredOutboundVideoTrack();
      if (videoTrack) pc.addTrack(videoTrack, (IS_SHARING_SCREEN && SCREEN_STREAM) ? SCREEN_STREAM : (LOCAL_STREAM || FALLBACK_VIDEO_STREAM));
      if (LOCAL_STREAM) {
        LOCAL_STREAM.getAudioTracks().forEach(function (track) {
          if (track.readyState === "live") pc.addTrack(track, LOCAL_STREAM);
        });
      }
    }
    return pc;
  }

  async function createOfferFor(viewerSessionId) {
    var pc = PEERS[viewerSessionId] || await createPeerConnection(viewerSessionId, true);
    var preferredVideoTrack = getPreferredOutboundVideoTrack();
    if (preferredVideoTrack) replaceOutgoingVideoTrack(preferredVideoTrack);
    syncOutgoingAudioTrack();
    var offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    sendSignal("offer", viewerSessionId, { sdp: offer });
  }

  async function handleOffer(fromSessionId, payload) {
    if (CAN_HOST) return;
    HOST_SESSION_ID = fromSessionId;
    if (!PARTICIPANT_NAMES[fromSessionId]) PARTICIPANT_NAMES[fromSessionId] = "Chủ phòng";
    renderParticipants();
    var pc = PEERS[fromSessionId] || await createPeerConnection(fromSessionId, false);
    await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
    var answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    sendSignal("answer", fromSessionId, { sdp: answer });
  }

  async function handleAnswer(fromSessionId, payload) {
    var pc = PEERS[fromSessionId];
    if (!pc) return;
    await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
  }

  async function handleIce(fromSessionId, payload) {
    var pc = PEERS[fromSessionId] || PEERS[HOST_SESSION_ID];
    if (!pc || !payload || !payload.candidate) return;
    try { await pc.addIceCandidate(new RTCIceCandidate(payload.candidate)); } catch (e) {}
  }

  function connectSocket(livestreamId) {
    if (!livestreamId) { setStatusText("Không tìm thấy livestreamId.", true); return; }
    if (SOCKET && SOCKET.readyState === WebSocket.OPEN) return;
    var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
    SOCKET = new WebSocket(protocol + window.location.host + "/ws/live?livestreamId=" + encodeURIComponent(livestreamId));

    SOCKET.onopen = function () { setStatusText("Đã kết nối realtime.", false); };
    SOCKET.onmessage = async function (event) {
      var msg = JSON.parse(event.data || "{}");
      var type = msg.type;
      if (type === "welcome") {
        SELF_SESSION_ID = msg.sessionId;
        CAN_HOST = !!msg.canHost;
        HOST_SESSION_ID = msg.hostSessionId || null;
        if (CAN_HOST && !HOST_SESSION_ID) HOST_SESSION_ID = SELF_SESSION_ID;
        PARTICIPANT_NAMES[SELF_SESSION_ID] = msg.displayName || "Bạn";
        if (HOST_SESSION_ID && !PARTICIPANT_NAMES[HOST_SESSION_ID]) PARTICIPANT_NAMES[HOST_SESSION_ID] = "Chủ phòng";
        refreshParticipantCount();
        renderParticipants();
        updateLocalPreviewVisibility();
        syncHostMainAndOverlayVideo();
        updateRoleBasedUI();
        setStatusText("Đã vào phòng. " + (CAN_HOST ? "Chế độ chủ phòng." : "Chế độ người xem."), false);
        if (CAN_HOST && AUTO_START_SCREEN_ON_WELCOME) {
          AUTO_START_SCREEN_ON_WELCOME = false;
          try { await toggleScreenShare(); } catch (e) { setStatusText(getMediaErrorMessage(e, "chia sẻ màn hình"), true); }
        }
        return;
      }
      if (type === "participant-joined") {
        if (msg.sessionId) PARTICIPANT_NAMES[msg.sessionId] = msg.displayName || "Thành viên";
        refreshParticipantCount();
        renderParticipants();
        if (CAN_HOST && msg.sessionId && msg.sessionId !== SELF_SESSION_ID) {
          try { await createOfferFor(msg.sessionId); }
          catch (e) { setStatusText("Không thể gửi luồng hình ảnh tới người xem mới.", true); }
        }
        return;
      }
      if (type === "participant-left") {
        if (msg.sessionId && PARTICIPANT_NAMES[msg.sessionId]) delete PARTICIPANT_NAMES[msg.sessionId];
        refreshParticipantCount();
        renderParticipants();
        var sid = msg.sessionId;
        if (sid && PEERS[sid]) { PEERS[sid].close(); delete PEERS[sid]; }
        return;
      }
      if (type === "host-left") {
        if (HOST_SESSION_ID && PARTICIPANT_NAMES[HOST_SESSION_ID]) delete PARTICIPANT_NAMES[HOST_SESSION_ID];
        HOST_SESSION_ID = null;
        refreshParticipantCount();
        renderParticipants();
        if (!CAN_HOST) {
          showToast("Livestream đã kết thúc. Chủ phòng đã rời khỏi phòng.", "info", "Phòng đã kết thúc");
          setStatusText("Livestream đã kết thúc.", false);
          await leaveRoom({ forceEnded: true, skipEndRequest: true });
          return;
        }
        setStatusText("Chủ phòng đã rời.", true);
        setRemoteVideoBlack();
        return;
      }
      if (type === "offer") { await handleOffer(msg.from, msg.payload); return; }
      if (type === "answer") { await handleAnswer(msg.from, msg.payload); return; }
      if (type === "ice") { await handleIce(msg.from, msg.payload); return; }
      if (type === "chat") appendChatMessage(msg.displayName || "Thành viên", msg.text || "", msg.time || "", !!(HOST_SESSION_ID && msg.sessionId === HOST_SESSION_ID));
    };
    SOCKET.onclose = function () {
      if (IS_ENDING_LIVE) { setStatusText("Livestream đã kết thúc. Kết nối realtime đóng.", false); IS_ENDING_LIVE = false; }
      else if (IS_LEAVING_ROOM) { setStatusText("Đã rời phòng livestream.", false); IS_LEAVING_ROOM = false; }
      else setStatusText("Mất kết nối realtime.", true);
    };
    SOCKET.onerror = function () { setStatusText("Lỗi kết nối realtime.", true); };
  }

  async function leaveRoom(options) {
    options = options || {};
    var forceEnded = !!options.forceEnded;
    var skipEndRequest = !!options.skipEndRequest;
    if (forceEnded) {
      IS_ENDING_LIVE = true;
    } else if (CAN_HOST && LIVE_ID && LIVE_STATUS_CODE === 1 && !skipEndRequest) {
      try {
        var endData = await endLiveById(LIVE_ID);
        applyLiveData(endData);
        IS_ENDING_LIVE = true;
      } catch (e) {
        setStatusText(e.message || "Không thể kết thúc livestream.", true);
        return;
      }
    } else {
      IS_LEAVING_ROOM = true;
    }
    if (SOCKET) { SOCKET.close(); SOCKET = null; }
    Object.keys(PEERS).forEach(function (sid) { PEERS[sid].close(); delete PEERS[sid]; });
    if (IS_SHARING_SCREEN) stopScreenShare(true);
    stopLocalMedia();
    setRemoteVideoBlack();
    HOST_SESSION_ID = null;
    SELF_SESSION_ID = null;
    CAN_HOST = false;
    PARTICIPANT_NAMES = {};
    refreshParticipantCount();
    renderParticipants();
    updateMediaButtons();
    updateRoleBasedUI();
    showEntryScreen();
    stopLiveTimeTicker();
    LIVE_STARTED_AT = null;
    renderLiveSubtitle();
    syncHostMainAndOverlayVideo();
  }

  function sendChat() {
    var input = $("chatInput");
    var text = (input.value || "").trim();
    if (!text) return;
    if (!canCurrentUserChat()) {
      if (PERMISSIONS.chatMode === "off") setStatusText("Chat đã bị tắt bởi cài đặt phân quyền.", true);
      else setStatusText("Chỉ chủ phòng mới được chat theo cài đặt hiện tại.", true);
      return;
    }
    if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) { setStatusText("Vui lòng vào phòng trước khi chat.", true); return; }
    SOCKET.send(JSON.stringify({ type: "chat", text: text }));
    input.value = "";
  }

  function initQuickEmojiButtons() {
    var input = $("chatInput");
    if (!input) return;
    var emojiButtons = document.querySelectorAll(".ls-emoji-btn[data-emoji]");
    if (!emojiButtons || !emojiButtons.length) return;
    emojiButtons.forEach(function (btn) {
      btn.addEventListener("click", function () {
        var emoji = btn.getAttribute("data-emoji") || "";
        if (!emoji) return;
        var current = input.value || "";
        input.value = current ? (current + " " + emoji) : emoji;
        input.focus();
      });
    });
  }

  function initTabs() {
    $("tabChat").addEventListener("click", function () {
      $("tabChat").classList.add("active");
      $("tabParticipants").classList.remove("active");
      $("chatPanel").classList.remove("ls-hidden");
      $("participantsPanel").classList.add("ls-hidden");
    });
    $("tabParticipants").addEventListener("click", function () {
      $("tabParticipants").classList.add("active");
      $("tabChat").classList.remove("active");
      $("participantsPanel").classList.remove("ls-hidden");
      $("chatPanel").classList.add("ls-hidden");
    });
  }

  function openCreateSetup() {
    $("entrySetupBlock").classList.remove("ls-hidden");
    $("entryJoinBlock").classList.add("ls-hidden");
    if ($("entryTitle")) $("entryTitle").focus();
  }

  function openJoinSetup() {
    $("entryJoinBlock").classList.remove("ls-hidden");
    $("entrySetupBlock").classList.add("ls-hidden");
    if ($("entryJoinUrl")) $("entryJoinUrl").focus();
  }

  (async function init() {
    initDraggableLocalVideo();
    setRemoteVideoBlack();
    applyRemoteViewMode();
    renderLiveSubtitle();
    initTabs();
    loadPermissions();
    applyPermissionToUI();
    await loadBranches();
    updateMediaButtons();
    renderParticipants();
    updateRoleBasedUI();
    initQuickEmojiButtons();

    if (!hasTurnServer(RTC_CONFIG.iceServers)) {
      setStatusText("Cảnh báo: chưa có TURN server, livestream khác mạng có thể lỗi.", true);
    }

    showEntryScreen();
    $("btnEntryCreate").addEventListener("click", openCreateSetup);
    $("btnEntryJoin").addEventListener("click", openJoinSetup);
    $("btnEntryStartLive").addEventListener("click", async function () {
      try {
        var entryTitle = ($("entryTitle").value || "").trim();
        var entryBranchId = Number($("entryBranchId").value || 0);
        if (!entryBranchId) { setStatusText("Vui lòng chọn chi nhánh.", true); return; }
        if ($("lsTitle")) $("lsTitle").value = entryTitle;
        if ($("lsBranchId")) $("lsBranchId").value = String(entryBranchId);
        var data = await startLiveRoom(entryTitle, entryBranchId);
        AUTO_START_SCREEN_ON_WELCOME = true;
        showMainScreen();
        connectSocket(data.livestreamId);
        setStatusText("Đã tạo livestream. Hãy chọn màn hình để chia sẻ.", false);
      } catch (e) {
        setStatusText(e.message || "Bắt đầu livestream thất bại.", true);
      }
    });
    $("btnEntryJoinSubmit").addEventListener("click", async function () {
      try { await joinByUrlInput($("entryJoinUrl").value || ""); }
      catch (e) { setStatusText(e.message || "Không thể vào phòng theo URL.", true); }
    });
    $("entryJoinUrl").addEventListener("keydown", async function (e) {
      if (e.key !== "Enter") return;
      try { await joinByUrlInput($("entryJoinUrl").value || ""); }
      catch (err) { setStatusText(err.message || "Không thể vào phòng theo URL.", true); }
    });

    $("btnOpenPermission").addEventListener("click", openPermissionModal);
    $("btnClosePermission").addEventListener("click", closePermissionModal);
    $("btnCancelPermission").addEventListener("click", closePermissionModal);
    $("btnSavePermission").addEventListener("click", function () {
      PERMISSIONS.chatMode = $("permChatMode").value;
      PERMISSIONS.scope = "branch";
      PERMISSIONS.security = $("permSecurity").value;
      savePermissions();
      closePermissionModal();
      setStatusText("Đã lưu cài đặt phân quyền.", false);
    });

    var roomIdFromQuery = getQueryParam("livestreamId");
    if (roomIdFromQuery) {
      try {
        var dataFromQuery = await watchLiveById(roomIdFromQuery);
        showMainScreen();
        applyLiveData(dataFromQuery);
        connectSocket(dataFromQuery.livestreamId || roomIdFromQuery);
      } catch (e) {
        setStatusText(e.message || "Không thể mở phòng.", true);
      }
    }

    if ($("btnStartLive")) {
      $("btnStartLive").addEventListener("click", async function () {
        try {
          var data = await startLiveRoom();
          AUTO_START_SCREEN_ON_WELCOME = true;
          connectSocket(data.livestreamId);
          setStatusText("Đã tạo livestream. Hãy chọn màn hình để chia sẻ.", false);
        } catch (e) {
          setStatusText(e.message || "Bắt đầu livestream thất bại.", true);
        }
      });
    }

    if ($("btnWatchLive")) {
      $("btnWatchLive").addEventListener("click", async function () {
        if (LIVE_STATUS_CODE === 0) { setStatusText("Livestream đang ở status = 0, không thể tham gia.", true); return; }
        try {
          var data = await watchLiveById(LIVE_ID);
          if (!isLiveStatus(data)) { setStatusText("Livestream đã kết thúc (status = 0).", true); return; }
          applyLiveData(data);
          connectSocket(data.livestreamId || LIVE_ID);
        } catch (e) {
          setStatusText(e.message || "Không thể xem phòng này.", true);
        }
      });
    }

    if ($("btnLoadCurrentLive")) {
      $("btnLoadCurrentLive").addEventListener("click", async function () {
        try {
          var current = await loadCurrentLive();
          if (!isLiveStatus(current)) { setStatusText("Không có phòng status = 1 để tham gia.", true); return; }
          applyLiveData(current);
          connectSocket(current.livestreamId);
        } catch (e) {
          setStatusText(e.message || "Không có livestream đang hoạt động.", true);
        }
      });
    }

    if ($("btnJoinByUrl") && $("lsJoinUrl")) {
      $("btnJoinByUrl").addEventListener("click", async function () {
        try { await joinByUrlInput($("lsJoinUrl").value || ""); }
        catch (e) { setStatusText(e.message || "Không thể vào phòng theo URL.", true); }
      });
    }

    $("btnToggleCamera").addEventListener("click", async function () {
      try {
        if (!CAN_HOST) { setStatusText("Chỉ chủ phòng có thể điều khiển camera/mic.", true); return; }
        if (CAM_ENABLED) {
          CAM_ENABLED = false;
          stopCameraTrack();
          replaceOutgoingVideoTrack(getPreferredOutboundVideoTrack());
          syncHostMainAndOverlayVideo();
          updateMediaButtons();
          return;
        }
        CAM_ENABLED = true;
        var camTrack = await ensureCameraTrack();
        if (!camTrack) { CAM_ENABLED = false; updateMediaButtons(); return; }
        replaceOutgoingVideoTrack(getPreferredOutboundVideoTrack());
        syncHostMainAndOverlayVideo();
        applyLocalTrackStates();
        updateMediaButtons();
      } catch (e) { setStatusText(getMediaErrorMessage(e, "bật camera"), true); }
    });

    $("btnToggleMic").addEventListener("click", async function () {
      try {
        if (!CAN_HOST) { setStatusText("Chỉ chủ phòng có thể điều khiển camera/mic.", true); return; }
        if (!LOCAL_STREAM) await ensureLocalMedia();
        MIC_ENABLED = !MIC_ENABLED;
        applyLocalTrackStates();
        syncOutgoingAudioTrack();
        if (MIC_ENABLED) await renegotiateAllPeers();
        updateMediaButtons();
      } catch (e) { setStatusText(getMediaErrorMessage(e, "bật micro"), true); }
    });

    $("btnShareScreen").addEventListener("click", async function () {
      try { await toggleScreenShare(); } catch (e) { setStatusText(getMediaErrorMessage(e, "chia sẻ màn hình"), true); }
    });
    $("btnFullscreen").addEventListener("click", async function () {
      var player = document.querySelector(".ls-player");
      if (!player) return;
      try {
        if (document.fullscreenElement) await document.exitFullscreen();
        else await player.requestFullscreen();
      } catch (e) {}
    });
    if ($("btnToggleFitMode")) $("btnToggleFitMode").addEventListener("click", toggleRemoteViewMode);

    $("btnLeaveLive").addEventListener("click", async function () {
      if (!window.confirm("Bạn có chắc muốn rời phòng livestream không?")) return;
      await leaveRoom();
    });

    if ($("btnCopyRoom") && $("lsRoomLink")) {
      $("btnCopyRoom").addEventListener("click", async function () {
        var roomLink = $("lsRoomLink").value || "";
        if (!roomLink) return;
        try { await navigator.clipboard.writeText(roomLink); setStatusText("Đã sao chép liên kết phòng.", false); }
        catch (e) { setStatusText("Không thể sao chép liên kết phòng.", true); }
      });
    }

    $("btnSendChat").addEventListener("click", sendChat);
    $("chatInput").addEventListener("keydown", function (e) { if (e.key === "Enter") sendChat(); });
  })();
})();
