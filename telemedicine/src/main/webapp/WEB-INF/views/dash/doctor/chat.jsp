<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Chat with Patient <c:out value="${patientName}"/></title>

  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet" />
  <!-- Lucide Icons -->
  <script src="https://unpkg.com/lucide@latest"></script>
  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#2563eb',
            secondary: '#3b82f6',
            accent: '#8b5cf6',
            success: '#22c55e',
            warning: '#f59e0b',
            danger: '#ef4444',
          }
        },
      },
    }
  </script>
</head>
<body class="flex h-screen overflow-hidden bg-gray-100 font-sans">
  <!-- Sidebar: collapsed on small screens to icon-only -->
  <aside class="flex flex-col fixed top-0 left-0 h-full w-16 md:w-64 bg-white shadow-lg">
    <div class="flex items-center justify-center md:justify-start p-6">
      <i data-lucide="stethoscope" class="text-primary w-6 h-6"></i>
      <span class="hidden md:inline text-xl font-semibold text-primary ml-2">Telemedicine</span>
    </div>
    <nav class="space-y-1 flex-1 overflow-y-auto">
      <a href="${pageContext.request.contextPath}/doctor/dashboard" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 rounded-lg bg-blue-50 text-primary font-medium border-l-4 border-primary">
        <i data-lucide="home" class="w-5 h-5"></i>
        <span class="hidden md:inline">Dashboard</span>
      </a>
      <a href="${pageContext.request.contextPath}/schedule" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition duration-200">
        <i data-lucide="calendar" class="w-5 h-5"></i>
        <span class="hidden md:inline">Schedule</span>
      </a>
      <a href="${pageContext.request.contextPath}/profile" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition duration-200">
        <i data-lucide="user" class="w-5 h-5"></i>
        <span class="hidden md:inline">Profile</span>
      </a>
      <a href="${pageContext.request.contextPath}/settings" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition duration-200">
        <i data-lucide="settings" class="w-5 h-5"></i>
        <span class="hidden md:inline">Settings</span>
      </a>
      <a href="${pageContext.request.contextPath}/doctor/chat" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition duration-200">
        <i data-lucide="message-circle" class="w-5 h-5"></i>
        <span class="hidden md:inline">Chat</span>
      </a>
    </nav>
    <div class="p-4 border-t border-gray-200">
      <a href="${pageContext.request.contextPath}/logout" 
         class="flex items-center justify-center md:justify-start gap-0 md:gap-3 px-0 md:px-4 py-3 text-gray-600 rounded-lg hover:bg-gray-100 transition duration-200">
        <i data-lucide="log-out" class="w-5 h-5"></i>
        <span class="hidden md:inline">Logout</span>
      </a>
    </div>
  </aside>

  <!-- Main Content (offset by collapsed or expanded sidebar) -->
  <div class="flex flex-1 ml-16 md:ml-64 p-4">
    <div class="flex flex-1 h-full max-w-5xl mx-auto bg-white rounded-lg shadow-lg overflow-hidden">

      <!-- Patient List -->
      <div class="flex flex-col w-72 bg-white border-r border-gray-200 overflow-y-auto">
        <div class="p-4 bg-gray-50 border-b">
          <input type="text" id="doctorSearch" placeholder="🔍 Search patients..."
                 class="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary" />
        </div>
        <ul id="doctorList" class="flex-1 overflow-y-auto">
          <c:forEach var="conv" items="${conversations}">
            <c:set var="pat" value="${patientMap[conv.id]}" />
            <li class="flex items-center justify-between p-4 border-b hover:bg-gray-50 ${conv.id == param.conversationId ? 'bg-blue-50 border-l-4 border-primary' : ''}" data-name="${fn:toLowerCase(pat.username)}">
              <div class="flex items-center">
                <div class="flex-shrink-0 w-10 h-10 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center font-bold text-lg mr-3">
                  ${fn:substring(pat.username,0,1)}
                </div>
                <div class="flex flex-col">
                  <span class="text-gray-800 font-semibold">${pat.username}</span>
                </div>
              </div>
              <button onclick="location.href='${pageContext.request.contextPath}/doctor/chat?conversationId=${conv.id}'"
                      class="px-4 py-2 bg-primary text-white rounded-lg shadow hover:bg-blue-600 transition duration-200">
                Chat
              </button>
            </li>
          </c:forEach>
          <c:if test="${empty conversations}">
            <li class="flex flex-col items-center justify-center p-8 text-gray-400">
              <i data-lucide="user-minus" class="w-8 h-8 mb-4"></i>
              <p>No patients yet.</p>
            </li>
          </c:if>
        </ul>
      </div>

      <!-- Chat Panel -->
      <div class="flex flex-col flex-1 bg-white">
        <!-- Header -->
        <div class="flex items-center justify-between h-16 px-6 border-b border-gray-200 bg-white">
          <h1 class="text-xl font-semibold text-gray-800">Chat with Patient <c:out value="${patientName}"/></h1>
          <div class="flex items-center text-sm text-gray-500 ml-2">
            <span class="w-2 h-2 bg-green-500 rounded-full mr-1"></span>
            Online
          </div>
        </div>

        <!-- Messages -->
        <div id="chat-window" class="flex-1 p-6 bg-gray-50 overflow-y-auto">
          <!-- messages injected here -->
        </div>

        <!-- Footer -->
        <div class="flex items-center h-16 px-6 border-t border-gray-200 bg-white">
          <button class="text-gray-500 hover:text-primary transition duration-200">
            <i data-lucide="paperclip" class="w-5 h-5"></i>
          </button>
          <input id="msg-input" type="text" placeholder="Type your message…"
                 class="flex-1 h-10 mx-4 px-4 bg-gray-100 rounded-full border border-gray-200 focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary" />
          <button id="send-btn" class="bg-primary w-10 h-10 rounded-full flex items-center justify-center shadow hover:bg-blue-600 transition duration-200">
            <i data-lucide="send" class="w-5 h-5 text-white"></i>
          </button>
        </div>
      </div>

    </div>
  </div>

  <script>
    lucide.createIcons();
    document.addEventListener('DOMContentLoaded', function() {
      const me     = Number('${Id}');
      const convId = Number('${conversationId}');
      const ctx    = '${pageContext.request.contextPath}';
      const chatWin= document.getElementById('chat-window');
      const input  = document.getElementById('msg-input');
      const sendBtn= document.getElementById('send-btn');

      const proto = location.protocol==='https:'?'wss://':'ws://';
      const socket= new WebSocket(proto + location.host + ctx + '/ws/chat/' + convId + '/' + me);
      socket.addEventListener('message', e => renderMessage(JSON.parse(e.data)));

      fetch(ctx + '/messages?conversationId=' + convId)
        .then(r => r.json())
        .then(arr => arr.forEach(renderMessage))
        .catch(console.error);

      sendBtn.addEventListener('click', ()=>{
        const txt = input.value.trim(); if(!txt) return;
        socket.send(JSON.stringify({content:txt}));
        input.value = '';
      });
      input.addEventListener('keypress', e=>{if(e.key==='Enter'){e.preventDefault(); sendBtn.click();}});

      function renderMessage(m) {
        const you  = m.senderId === me;
        const wrap = document.createElement('div');
        wrap.className = 'flex mb-6 max-w-3/4 ' + (you ? 'self-end flex-row-reverse' : 'self-start');

        const av = document.createElement('div');
        av.className = 'w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center font-bold text-lg ' + (you ? 'bg-teal-100 text-teal-600 ml-4' : 'bg-indigo-100 text-indigo-600 mr-4');
        av.textContent = you ? 'D' : 'P';
        wrap.appendChild(av);

        const ctn = document.createElement('div');
        ctn.className = 'flex flex-col';

        const author = document.createElement('div');
        author.className = 'text-sm font-semibold text-gray-700 mb-1 ' + (you ? 'text-right' : 'text-left');
        author.textContent = you ? 'You' : '${patientName}';
        ctn.appendChild(author);

        const bubble = document.createElement('div');
        bubble.className = 'inline-block p-4 rounded-2xl border ' + (you ? 'bg-primary border-primary text-white' : 'bg-white border-gray-200 text-gray-700');
        bubble.innerHTML = m.content.replace(/(https?:\/\/[^\s]+)/g, `<a href="$1" target="_blank" class="underline" style="color:${you?'white':'#2563eb'};">$1</a>`);
        ctn.appendChild(bubble);

        const timeDiv = document.createElement('div');
        timeDiv.className = 'text-xs text-gray-500 mt-2 ' + (you ? 'text-right' : 'text-left');
        timeDiv.textContent = new Date(m.sentAt).toLocaleTimeString([], { hour:'2-digit', minute:'2-digit' });
        ctn.appendChild(timeDiv);

        wrap.appendChild(ctn);
        chatWin.appendChild(wrap);
        chatWin.scrollTop = chatWin.scrollHeight;
      }

      document.getElementById('doctorSearch').addEventListener('input', function(e) {
        const term = e.target.value.trim().toLowerCase();
        document.querySelectorAll('#doctorList li').forEach(li => {
          const name = li.getAttribute('data-name');
          li.classList.toggle('hidden', term && !name.includes(term));
        });
      });
    });
  </script>
</body>
</html>
