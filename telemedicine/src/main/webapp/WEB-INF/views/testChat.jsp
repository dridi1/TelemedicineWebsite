<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MediBot AI - Telemedicine Assistant</title>
  <!-- Bootstrap & Fonts -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" />
  <style>
    /* Theme Variables */
    :root {
      --primary: #2563eb;
      --secondary: #3b82f6;
      --success: #22c55e;
      --danger: #ef4444;
      --background: #f8fafc;
      --surface: #ffffff;
      --muted: #f1f5f9;
      --text: #1e293b;
      --text-secondary: #64748b;
      --border: #e2e8f0;
      --shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      --btn-text-on-primary: #ffffff;
    }
    body.dark-mode {
      --background: #121212;
      --surface: #1E1E1E;
      --muted: #2C2C2C;
      --text: #E0E0E0;
      --text-secondary: #A0A0A0;
      --primary: #BB86FC;
      --secondary: #03DAC6;
      --success: #03DAC6;
      --danger: #CF6679;
      --border: #373737;
      --shadow: 0 2px 8px rgba(0, 0, 0, 0.7);
      --btn-text-on-primary: #121212;
    }
    *, *::before, *::after { box-sizing: border-box; }
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      font-family: 'Poppins', sans-serif;
      background: var(--background);
      color: var(--text);
    }
    .container-fluid { height: 100%; display: flex; }
	.container,
	.container-fluid,
	.container-lg,
	.container-md,
	.container-sm,
	.container-xl,
	.container-xxl {
	  padding-right: 0 !important;
	  padding-left: 0 !important;
	  margin-right: auto;
	  margin-left: auto;
	}
    /* Side Nav */
    nav {
      width: 72px;
      background: var(--surface);
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 1.5rem 0;
      border-right: 1px solid var(--border);
      box-shadow: 2px 0 var(--shadow);
    }
    nav button {
      background: none;
      border: none;
      color: var(--text-secondary);
      font-size: 1.75rem;
      cursor: pointer;
      margin-bottom: 2.5rem;
      transition: color 0.2s;
    }
    nav button:hover { color: var(--primary); }
    nav span {
      writing-mode: vertical-rl;
      transform: rotate(180deg);
      font-weight: bold;
      letter-spacing: 2px;
    }

    /* Main */
    .main { flex: 1; display: flex; flex-direction: column; }
    header {
      height: 60px;
      background: var(--surface);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 1rem;
      border-bottom: 1px solid var(--border);
    }
    header .title { font-size: 1.25rem; font-weight: 600; }
    header .controls { display: flex; align-items: center; gap: 1rem; }
    header .controls button#theme-toggle,
    header .controls a.login-link {
      background: var(--primary);
      color: var(--btn-text-on-primary);
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: background 0.2s;
      text-decoration: none;
    }
    header .controls button#theme-toggle:hover,
    header .controls a.login-link:hover { background: var(--secondary); }
    header .controls .user-menu {
      color: var(--text);
      background: none;
      padding: 0;
      border: none;
      font-size: 1rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      cursor: pointer;
    }
    header .avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background-size: cover;
      border: 2px solid var(--secondary);
    }

    /* Chat Window */
    .chat-window { flex: 1; padding: 1rem; overflow-y: auto; }
    .message { display: flex; margin-bottom: 1rem; }
    .message.bot { justify-content: flex-start; }
    .message.user { justify-content: flex-end; }
    .avatar { width: 36px; height: 36px; border-radius: 50%; background-size: cover; flex-shrink: 0; }
    .avatar-bot { background-image: url('<c:url value="/images/bot.png"/>'); }
    .avatar-user { background-image: url('<c:url value="/images/you.png"/>'); }
    .bubble {
      max-width: 60%;
      padding: 0.75rem 1rem;
      border-radius: 20px;
      box-shadow: var(--shadow);
      line-height: 1.4;
    }
    .message.bot .bubble { background: var(--surface); border-top-left-radius: 4px; }
    .message.user .bubble { background: var(--primary); color: var(--btn-text-on-primary); border-top-right-radius: 4px; }

    /* Input Bar */
    .input-bar {
      display: flex;
      align-items: center;
      padding: 0.75rem 1rem;
      background: var(--surface);
      border-top: 1px solid var(--border);
    }
    .input-bar input {
      flex: 1;
      border: 1px solid var(--border);
      padding: 0.75rem 1rem;
      border-radius: 30px;
      background: var(--muted);
      color: var(--text);
      font-size: 1rem;
      outline: none;
    }
    .input-bar .btn-icon {
      background: none;
      border: none;
      margin-left: 0.75rem;
      font-size: 1.5rem;
      cursor: pointer;
      color: var(--primary);
      transition: color 0.2s;
    }
    .input-bar .btn-icon:disabled { color: var(--text-secondary); cursor: default; }
    .input-bar .btn-icon:hover:not(:disabled) { color: var(--secondary); }

    /* Loading Dots */
    .loading-dots { display: flex; gap: 6px; }
    .loading-dots div {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--text-secondary);
      animation: bounce 1.4s infinite ease-in-out;
    }
    .loading-dots div:nth-child(2) { animation-delay: 0.2s; }
    .loading-dots div:nth-child(3) { animation-delay: 0.4s; }
    @keyframes bounce { 0%,80%,100% { transform: translateY(0); } 40% { transform: translateY(-6px); } }
  </style>
</head>
<body>
  <div class="container-fluid">
    <div class="main">
      <header>
        <div class="title">MediBot AI</div>
        <div class="controls">
          <!-- Theme Toggle -->
          <button id="theme-toggle" title="Toggle dark/light mode">Toggle Theme</button>
          <!-- User/Menu or Login -->
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <c:set var="initial" value="${fn:substring(sessionScope.user.username,0,1)}"/>
              <div class="dropdown">
                <button class="btn user-menu dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                  <span class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-weight:bold;line-height:32px;">${initial}</span>
                  ${sessionScope.user.username}
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                  <c:choose>
                    <c:when test="${fn:toLowerCase(sessionScope.userRole)=='doctor'}">
                      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a></li>
                    </c:when>
                    <c:otherwise>
                      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/dashboard">Dashboard</a></li>
                    </c:otherwise>
                  </c:choose>
                  <li><hr class="dropdown-divider"/></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
              </div>
            </c:when>
            <c:otherwise>
              <a href="<c:url value='/login'/>" class="login-link btn">Login</a>
            </c:otherwise>
          </c:choose>
        </div>
      </header>
      <div id="chat-container" class="chat-window">
        <div class="message bot">
          <div class="avatar avatar-bot"></div>
          <div class="bubble">
            <c:choose>
              <c:when test="${not empty sessionScope.user}">
                Hello, ${sessionScope.user.username}! Describe your symptoms and I’ll try to help.
              </c:when>
              <c:otherwise>
                Hello! Describe your symptoms and I’ll try to help.
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
      <form id="chat-form" class="input-bar">
        <input id="message-input" type="text" placeholder="Type your symptoms..." autocomplete="off" />
        <button type="submit" class="btn-icon" id="send-btn" disabled><span class="material-symbols-rounded">send</span></button>
      </form>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // theme toggle
    const themeToggle = document.getElementById('theme-toggle');
    themeToggle.addEventListener('click', () => { document.body.classList.toggle('dark-mode'); });

    const chatUrl = '<%= request.getContextPath() %>/chat-ui';
    const inputEl = document.getElementById('message-input');
    const sendBtn = document.getElementById('send-btn');
    inputEl.addEventListener('input', () => { sendBtn.disabled = inputEl.value.trim() === ''; });

    function showLoadingIndicator() {
      const container = document.getElementById('chat-container');
      const loadingMsg = document.createElement('div'); loadingMsg.className = 'message bot loading';
      const avatar = document.createElement('div'); avatar.className = 'avatar avatar-bot';
      const bubble = document.createElement('div'); bubble.className = 'bubble';
      bubble.innerHTML = '<div class="loading-dots"><div></div><div></div><div></div></div>';
      loadingMsg.append(avatar, bubble); container.appendChild(loadingMsg); container.scrollTop = container.scrollHeight;
      return loadingMsg;
    }

    function displayMessage(sender, text) {
      const container = document.getElementById('chat-container');
      const msgEl = document.createElement('div'); msgEl.classList.add('message', sender);
      const avatarDiv = document.createElement('div'); avatarDiv.className = 'avatar ' + (sender==='user'?'avatar-user':'avatar-bot');
      const bubble = document.createElement('div'); bubble.className='bubble'; bubble.textContent=text;
      if(sender==='user') msgEl.append(bubble, avatarDiv); else msgEl.append(avatarDiv, bubble);
      container.appendChild(msgEl); container.scrollTop=container.scrollHeight;
    }

    document.getElementById('chat-form').addEventListener('submit', async e => {
      e.preventDefault(); const msg=inputEl.value.trim(); if(!msg) return;
      displayMessage('user', msg); inputEl.value=''; sendBtn.disabled=true;
      const loadingEl=showLoadingIndicator();
      try {
        const resp=await fetch(chatUrl,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({message:msg})});
        if(!resp.ok) throw new Error(resp.status);
        const { reply }=await resp.json(); loadingEl.remove(); displayMessage('bot', reply);
      } catch(err) { loadingEl.remove(); displayMessage('bot','Sorry, something went wrong.'); console.error(err); }
    });
  </script>
</body>
</html>
