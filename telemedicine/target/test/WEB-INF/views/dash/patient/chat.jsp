<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Chat with Dr. <c:out value="${doctorName}" /></title>

<!-- Google Font -->
<link
	href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap"
	rel="stylesheet" />

<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<!-- Navbar CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/dash/navbar.css" />

<!-- Chat & Dashboard Styles -->
<%-- Updated CSS for improved doctor list and chat dimensions --%>
<style>
/*─────────────────────────────────────────────────────────────────────────────
  2. LAYOUT CONTAINERS
─────────────────────────────────────────────────────────────────────────────*/
/* Main dashboard wrapper */
.dashboard {
  display: flex;
  margin: 3rem auto 0;
  max-width: 1200px;
  height: calc(100vh - 150px);
  border-radius: 12px;
  overflow: hidden;
  background-color: #fff;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

/* Fixed sidebar */
.sidebar-container {
  position: fixed;
  top: 0; left: 0;
  width: 240px;
  height: 100vh;
  background-color: #fff;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

/* Main content to the right of sidebar */
.main-content {
  position: relative;
  flex: 1;
  margin-left: 240px;
  width: calc(100% - 240px);
  height: 100vh;
  padding: 20px;
  overflow-y: auto;
}

/*─────────────────────────────────────────────────────────────────────────────
  3. NEW MESSAGE BUTTON
─────────────────────────────────────────────────────────────────────────────*/
.new-msg-container {
  position: absolute;
  top: 1rem;
  right: 1rem;
  z-index: 200;
}

.btn-new-chat {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.6rem 1rem;
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 0.95rem;
  font-weight: 500;
  box-shadow: 0 3px 8px rgba(37, 99, 235, 0.25);
  cursor: pointer;
  transition: background 0.2s, transform 0.1s;
}
.btn-new-chat i {
  font-size: 1rem;
}
.btn-new-chat:hover {
  background: #1e40af;
  transform: translateY(-1px);
}
.btn-new-chat:active {
  transform: translateY(0);
}

/*─────────────────────────────────────────────────────────────────────────────
  4. DOCTOR LIST (SIDEBAR)
─────────────────────────────────────────────────────────────────────────────*/
/* Container */
.doclist {
  flex: 0 0 280px;
  display: flex;
  flex-direction: column;
  background: #fff;
  border-right: 1px solid #e5e7eb;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
}

/* Search box */
.doc-search {
  padding: 1rem;
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}
#doctorSearch {
  width: 100%;
  padding: 0.75rem 1rem;
  font-size: 0.95rem;
  color: #374151;
  background: #fff;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  transition: 0.2s;
}
#doctorSearch:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}
#doctorSearch::placeholder {
  color: #94a3b8;
}

/* List styling */
#doctorList {
  flex: 1;
  list-style: none;
  overflow-y: auto;
}
#doctorList .item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem;
  border-bottom: 1px solid #f1f5f9;
  cursor: pointer;
  transition: 0.2s;
}
#doctorList .item:hover {
  background-color: #f8fafc;
}
#doctorList .item.active {
  background-color: #eff6ff;
  border-left: 3px solid #2563eb;
}

/* Doctor entry */
#doctorList .info {
  display: flex;
  align-items: center;
  flex: 1;
}
#doctorList .doctor-avatar {
  width: 45px; height: 45px;
  border-radius: 50%;
  background: #e0f2fe;
  color: #0284c7;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 1.1rem;
  margin-right: 12px;
}
#doctorList .doctor-details .name {
  font-weight: 600;
  font-size: 1rem;
  color: #1e293b;
  margin-bottom: 4px;
}
#doctorList .doctor-details .specialty {
  font-size: 0.85rem;
  color: #64748b;
}

/* Chat button */
#doctorList .btn-chat {
  flex-shrink: 0;
  padding: 0.5rem 1rem;
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 500;
  box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
  transition: 0.2s;
}
#doctorList .btn-chat:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
}
#doctorList .btn-chat:active {
  transform: translateY(0);
}

/* Empty state */
#doctorList .empty {
  padding: 2rem;
  text-align: center;
  color: #94a3b8;
  font-size: 0.95rem;
}

/*─────────────────────────────────────────────────────────────────────────────
  5. MAIN CHAT PANEL
─────────────────────────────────────────────────────────────────────────────*/
/* Chat panel container */
.main {
  display: flex;
  flex-direction: column;
  flex: 1 1 auto;
  background: #FEFEFF;
  border-radius: 12px;
  box-shadow: -5px 0 15px rgba(0, 0, 0, 0.05);
}

/* Header */
.header {
  flex: 0 0 70px;
  padding: 1.25rem 1.5rem;
  border-bottom: 2px solid #E8E9EF;
  display: flex;
  align-items: center;
  border-radius: 12px 12px 0 0;
}
.header h1 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #131E40;
}
.header .doctor-status {
  display: flex;
  align-items: center;
  margin-left: 10px;
}
.header .status-indicator {
  width: 10px; height: 10px;
  background: #22c55e;
  border-radius: 50%;
  margin-right: 5px;
}
.header .status-text {
  font-size: 0.85rem;
  color: #64748b;
}

/* Chat messages container */
.chat-area {
  flex: 1;
  padding: 1.5rem;
  background: #F8F9FB;
  border-radius: 0 0 12px 12px;
  overflow-y: auto;
}

/* Message row */
.chat-msg,
.chat-msg-owner {
  display: flex;
  align-items: flex-start;
  margin-bottom: 1.5rem;
  max-width: 85%;
}
.chat-msg { margin-right: auto; }
.chat-msg-owner {
  flex-direction: row-reverse;
  margin-left: auto;
}

/* Avatar bump-up */
.chat-msg .chat-smg-img,
.chat-msg-owner .chat-smg-img {
  position: relative;
  top: 55px;                /* tweak this value */
  align-self: flex-start;   /* override flex-end */
}
.chat-smg-img {
  flex: 0 0 40px;
  height: 40px;
  border-radius: 50%;
  background: #ECE8FC;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  color: #5242A2;
  box-shadow: 0 2px 5px rgba(82, 66, 162, 0.15);
}
.chat-msg-owner .chat-smg-img {
  background: #DEF6FC;
  color: #2EBDC2;
  margin-left: 1rem;
}
.chat-msg .chat-smg-img {
  margin-right: 1rem;
}

/* Message content stack */
.chat-msg-content {
  display: flex;
  flex-direction: column;
  max-width: 100%;
  /* align-items: flex-end for owner rows */
}
.chat-msg-owner .chat-msg-content {
  align-items: flex-end;
}

/* Author name */
.chat-msg-author {
  font-size: 0.85rem;
  font-weight: 600;
  color: #131E40;
  margin-bottom: 0.25rem;
}

/* Bubble */
.chat-msg-text {
  background: #fff;
  border: 1px solid #E8E9EF;
  border-radius: 16px 16px 16px 0;
  padding: 1rem 1.25rem;
  font-size: 0.95rem;
  line-height: 1.5;
  color: #4b5563;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
}
.chat-msg-owner .chat-msg-text {
  background: #2563EB;
  border-color: #2563EB;
  color: #fff;
  border-radius: 16px 16px 0 16px;
  box-shadow: 0 2px 5px rgba(37, 99, 235, 0.2);
}

/* Timestamp below bubble */
.chat-msg-time {
  font-size: 0.75rem;
  color: #94a3b8;
  margin-top: 0.5rem;
  text-align: right;
}

/* Attachment box */
.chat-file-box {
  display: flex;
  align-items: center;
  margin-top: 1rem;
  padding: 1rem;
  background: #fff;
  border: 1px solid #E8E9EF;
  border-radius: 10px;
  box-shadow: 0 5px 10px rgba(150, 158, 179, 0.1);
  max-width: 320px;
}
.chat-file-box .box-file img {
  width: 50px;
  padding: 10px;
  background: #DAF0E4;
  border-radius: 10px;
}
.chat-file-box .box-file-name {
  flex: 1;
  padding: 0 1rem;
  font-size: 0.9rem;
  color: #4b5563;
}
.chat-file-box .box-file-name .file-size {
  display: block;
  margin-top: 4px;
  font-size: 0.8rem;
  color: #94a3b8;
}
.chat-file-box .box-file-icon a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-left: 0.5rem;
  width: 36px; height: 36px;
  background: transparent;
  border: 1px solid #e2e8f0;
  border-radius: 50%;
  transition: 0.2s;
}
.chat-file-box .box-file-icon a:hover {
  background: #f1f5f9;
  border-color: #2563eb;
  color: #2563eb;
}

/*─────────────────────────────────────────────────────────────────────────────
  6. CHAT INPUT FOOTER
─────────────────────────────────────────────────────────────────────────────*/
.chat-area-footer {
  display: flex;
  align-items: center;
  padding: 1rem 1.5rem;
  background: #FEFEFF;
  border-top: 2px solid #E8E9EF;
}
.chat-area-footer input {
  flex: 1;
  padding: 0.75rem 1.25rem;
  margin: 0 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 24px;
  background: #f8fafc;
  font-size: 1rem;
  color: #4b5563;
  transition: 0.2s;
}
.chat-area-footer input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}
.chat-area-footer .btn-link,
.chat-area-footer .btn-primary {
  width: 42px; height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: 0.2s;
}
.chat-area-footer .btn-link {
  color: #64748b;
  font-size: 1.25rem;
}
.chat-area-footer .btn-link:hover {
  background: #f1f5f9;
  color: #2563eb;
}
.chat-area-footer .btn-primary {
  background: #2563eb;
  color: #fff;
  border: none;
  box-shadow: 0 2px 5px rgba(37, 99, 235, 0.2);
}
.chat-area-footer .btn-primary:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
}

/*─────────────────────────────────────────────────────────────────────────────
  7. MODAL DIALOG FOR NEW CHAT
─────────────────────────────────────────────────────────────────────────────*/
.modal {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  justify-content: center;
  align-items: center;
  z-index: 200;
}
.modal-content {
  position: relative;
  width: 90%;
  max-width: 480px;
  padding: 1.5rem;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
}
.close {
  position: absolute;
  top: 0.5rem; right: 0.75rem;
  font-size: 1.25rem;
  cursor: pointer;
}
.modal-list {
  margin-top: 1rem;
  list-style: none;
  max-height: 300px;
  overflow-y: auto;
}
.modal-list li {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: 0.2s;
}
.modal-list li:hover {
  background: #f5f5f5;
}
.modal-list .avatar {
  width: 40px; height: 40px;
  border-radius: 50%;
  margin-right: 0.75rem;
  background: #e0f2fe;
  color: #0284c7;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}
.modal-list .name {
  font-weight: 500;
  color: #1e293b;
}

/*─────────────────────────────────────────────────────────────────────────────
  8. MEDIA QUERIES
─────────────────────────────────────────────────────────────────────────────*/
/* Slightly narrower dashboard */
@media (max-width: 1200px) {
  .dashboard {
    max-width: 95%;
  }
}

/* Tablet / small desktop */
@media (max-width: 768px) {
  body {
    flex-direction: column;
  }

  .sidebar-container {
    position: fixed;
    bottom: 0; top: auto;
    width: 100%;
    height: 60px;
  }
  .main-content {
    margin-left: 0;
    height: calc(100vh - 60px);
    margin-bottom: 60px;
    padding: 10px;
  }
  .dashboard {
    flex-direction: column;
    height: calc(100vh - 80px);
  }
  .doclist {
    border-right: none;
    border-bottom: 1px solid #e5e7eb;
    height: 40%;
  }
  .main {
    flex: 1;
    border-radius: 0 0 12px 12px;
  }
}

/* Mobile */
@media (max-width: 640px) {
  .dashboard {
    flex-direction: column;
  }
  .doclist {
    height: 50vh;
  }
  .main {
    height: 50vh;
  }
}

</style>
</head>

<body>
  <!-- Sidebar on the left -->
  <div class="sidebar-container">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" flush="true" />
  </div>
  
  <!-- Main content area -->
  <div class="main-content">
  <div class="new-msg-container">
      <button id="newMsgBtn" class="btn-new-chat" onclick="openDoctorModal()">
        <i class="fas fa-plus"></i> New Message
      </button>
    </div>
     <div id="doctorModal" class="modal" onclick="closeDoctorModal()">
      <div class="modal-content" onclick="event.stopPropagation()">
        <span class="close" onclick="closeDoctorModal()">&times;</span>
        <h3>Select a Doctor to Chat</h3>
        <ul class="modal-list">
          <c:forEach var="doc" items="${allDoctors}">
            <li onclick="startChat(${doc.id})">
              <div class="avatar">${fn:substring(doc.username,0,1)}</div>
              <div class="name">${doc.username}</div>
            </li>
          </c:forEach>
        </ul>
      </div>
    </div>
    <div class="dashboard">
      <!-- Doctor list -->
      <div class="doclist">
        <!-- Search bar -->
        <div class="doc-search">
          <input type="text" id="doctorSearch" placeholder="🔍 Search doctors..." />
        </div>
        <ul class="list" id="doctorList">
		  <c:forEach var="conv" items="${conversations}">
		    <!-- pick the right Doctor from your map -->
		    <c:set var="doc" value="${doctorMap[conv.id]}" />
		
		    <li class="item ${conv.id == conversationId ? 'active' : ''}"
		        data-name="${fn:toLowerCase(doc.username)}">
		      <div class="info">
		        <div class="doctor-avatar">${fn:substring(doc.username, 0, 1)}</div>
		        <div class="doctor-details">
		          <span class="name">${doc.username}</span>
		        </div>
		      </div>
		      <button class="btn-chat"
		        onclick="location.href='${pageContext.request.contextPath}/patient/chat?conversationId=${conv.id}'">
		        Chat
		      </button>
		    </li>
		  </c:forEach>
		
		  <c:if test="${empty conversations}">
		    <li class="empty">
		      <i class="fas fa-user-md" style="font-size:2rem;color:#cbd5e1;margin-bottom:1rem;"></i>
		      <p>No conversations yet.</p>
		    </li>
		  </c:if>
		</ul>
      </div>
      
      <!-- Main chat panel -->
      <div class="main">
        <div class="header">
          <h1>
            Chat with Dr.
            <c:out value="${doctorName}" />
          </h1>
          <div class="doctor-status">
            <div class="status-indicator"></div>
            <span class="status-text">Online</span>
          </div>
        </div>

        <div class="chat-area" id="chat-window">
          <!-- messages are appended here via JS -->
        </div>

        <div class="chat-area-footer">
          <button class="btn btn-link">
            <i class="fas fa-paperclip"></i>
          </button>
          <input id="msg-input" type="text" placeholder="Type your message…" />
          <button id="send-btn" class="btn btn-primary">
            <i class="fas fa-paper-plane"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
	<!-- Navbar JS -->
	<script
		src="${pageContext.request.contextPath}/assets/js/dash/navbar.js"></script>

	<!-- Chat WebSocket & render logic -->
	<script>
  // ─── Global helpers ────────────────────────────────────────────────

  // 0) base path for building URLs
  const BASE = '${pageContext.request.contextPath}';

  // 1) These must live at top‐level so your inline onclick="…" sees them:
  function openDoctorModal() {
    document.getElementById('doctorModal').style.display = 'flex';
  }
  function closeDoctorModal() {
    document.getElementById('doctorModal').style.display = 'none';
  }
  function startChat(doctorId) {
    // Redirect to server with otherId, which your servlet will handle
    window.location.href = BASE + '/patient/chat?otherId=' + doctorId;
  }

  // ─── Main wiring ─────────────────────────────────────────────────

  let me, convId, chatWin, socket;

  document.addEventListener('DOMContentLoaded', () => {
    // 2) Initialize chat context
    me      = Number('${Id}');
    convId  = Number('${conversationId}');
    chatWin = document.getElementById('chat-window');

    // 3) WebSocket
    const proto = location.protocol === 'https:' ? 'wss://' : 'ws://';
    socket = new WebSocket(proto + location.host + BASE + '/ws/chat/' + convId + '/' + me);
    socket.addEventListener('message', e => renderMessage(JSON.parse(e.data)));

    // 4) Load history
    fetch(BASE + '/messages?conversationId=' + convId)
      .then(r => r.json())
      .then(arr => arr.forEach(renderMessage));

    // 5) Send handlers
    const input   = document.getElementById('msg-input');
    const sendBtn = document.getElementById('send-btn');

    sendBtn.addEventListener('click', () => {
      const txt = input.value.trim();
      if (!txt) return;
      socket.send(JSON.stringify({ content: txt }));
      input.value = '';
    });
    input.addEventListener('keypress', e => {
      if (e.key === 'Enter') {
        e.preventDefault();
        sendBtn.click();
      }
    });

    // 6) Live search
    document.getElementById('doctorSearch').addEventListener('input', e => {
      const term = e.target.value.toLowerCase();
      document.querySelectorAll('#doctorList .item').forEach(li => {
        li.style.display = !term || li.dataset.name.includes(term) ? '' : 'none';
      });
    });
  });

  // ─── Render messages ───────────────────────────────────────────────

  function renderMessage(m) {
  const you  = m.senderId === me;
  const wrap = document.createElement('div');
  wrap.className = you ? 'chat-msg-owner' : 'chat-msg';

  // avatar
  const av = document.createElement('div');
  av.className = 'chat-smg-img';
  av.textContent = you ? 'Y' : 'D';

  // content wrapper
  const ctn = document.createElement('div');
  ctn.className = 'chat-msg-content';

  // author line (optional)
  const author = document.createElement('div');
  author.className = 'chat-msg-author';
  author.textContent = you ? 'You' : 'Dr. ' + '${doctorName}';
  ctn.appendChild(author);

  // message bubble
  const bubble = document.createElement('div');
  bubble.className = 'chat-msg-text';
  bubble.innerHTML = m.content.replace(
    /(https?:\/\/[^\s]+)/g,
    `<a href="$1" target="_blank" style="color:${you?'white':'#2563eb'};text-decoration:underline;">$1</a>`
  );
  ctn.appendChild(bubble);

  // now timestamp _underneath_
  const tm = document.createElement('div');
  tm.className = 'chat-msg-time';
  const date = new Date(m.sentAt);
  tm.textContent = date.toLocaleTimeString([], { hour:'2-digit', minute:'2-digit' });
  ctn.appendChild(tm);

  wrap.append(av, ctn);
  chatWin.append(wrap);
  chatWin.scrollTop = chatWin.scrollHeight;
}

</script>

</body>
</html>
