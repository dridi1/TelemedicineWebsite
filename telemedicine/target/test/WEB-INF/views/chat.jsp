<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MediBot AI - Telemedicine Assistant</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
/* --- Your CSS styles --- */
.back-home-btn {
	position: absolute;
	top: 2rem;
	left: 2rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 0.75rem 1.5rem;
	border-radius: 2rem;
	background: var(--secondary-color);
	color: var(--text-color);
	text-decoration: none;
	transition: all 0.2s ease;
	z-index: 1000;
}

.back-home-btn:hover {
	background: var(--secondary-hover-color);
}

.back-home-btn i {
	font-size: 1.25rem;
}

@media ( max-width : 768px) {
	.back-home-btn {
		top: 1rem;
		left: 1rem;
		padding: 0.5rem 1rem;
		font-size: 0.9rem;
	}
}

@import
	url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap')
	;

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Poppins", sans-serif;
}

:root {
	/* Dark mode colors */
	--text-color: #E3E3E3;
	--subheading-color: #828282;
	--placeholder-color: #A6A6A6;
	--primary-color: #242424;
	--secondary-color: #383838;
	--secondary-hover-color: #444;
	--medical-blue: #4285f4;
	--medical-red: #d96570;
}

.light_mode {
	/* Light mode colors */
	--text-color: #222;
	--subheading-color: #A0A0A0;
	--placeholder-color: #6C6C6C;
	--primary-color: #FFF;
	--secondary-color: #E9EEF6;
	--secondary-hover-color: #DBE1EA;
	--medical-blue: #1a73e8;
	--medical-red: #c5221f;
}

body {
	background: var(--primary-color);
	color: var(--text-color);
	min-height: 100vh;
}

.header {
	max-width: 980px;
	margin: 6vh auto 0;
	padding: 1rem;
}

.header .title {
	font-size: 3rem;
	background: linear-gradient(to right, var(--medical-red),
		var(--medical-blue));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	margin-bottom: 1rem;
}

.header .subtitle {
	font-size: 2rem;
	color: var(--subheading-color);
	font-weight: 500;
}

.chat-list {
	max-width: 980px;
	margin: 0 auto;
	padding: 2rem 1rem;
	height: 60vh;
	overflow-y: auto;
}

.message {
	display: flex;
	gap: 1.5rem;
	margin: 1.5rem 0;
}

.message.outgoing {
	justify-content: flex-end;
}

.message-content {
	max-width: 70%;
	padding: 1.25rem;
	border-radius: 1rem;
	background: var(--secondary-color);
}

.message.outgoing .message-content {
	background: var(--medical-blue);
	color: white;
}

.avatar {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
	flex-shrink: 0;
}

.typing-area {
	position: fixed;
	bottom: 0;
	left: 0;
	right: 0;
	padding: 1rem;
	background: var(--primary-color);
	border-top: 1px solid var(--secondary-color);
}

.input-wrapper {
	max-width: 980px;
	margin: 0 auto;
	position: relative;
}

.typing-input {
	width: 100%;
	padding: 1rem 4.5rem 1rem 1.5rem;
	border-radius: 2rem;
	border: none;
	background: var(--secondary-color);
	color: var(--text-color);
	font-size: 1rem;
}

.medical-actions {
	position: absolute;
	right: 0.5rem;
	top: 50%;
	transform: translateY(-50%);
	display: flex;
	gap: 0.5rem;
}

.action-button {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: var(--secondary-color);
	border: none;
	color: var(--text-color);
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
}

.action-button:hover {
	background: var(--secondary-hover-color);
}

.disclaimer-text {
	text-align: center;
	font-size: 0.85rem;
	color: var(--placeholder-color);
	margin-top: 1rem;
}

.user-profile {
	position: absolute;
	top: 2rem;
	right: 2rem;
	background: rgba(0, 0, 0, 0.6);
	padding: 0.75rem 1.5rem;
	border-radius: 1.5rem;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
	display: flex;
	align-items: center;
	gap: 1rem;
	z-index: 1050;
	transition: transform 0.3s ease, background-color 0.3s ease;
}

.user-profile:hover {
	background-color: rgba(0, 0, 0, 0.8);
}

.user-profile .material-symbols-rounded {
	font-size: 2.5rem;
	background: linear-gradient(45deg, #ff6a6a, #ffc371);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
}

.username-container {
	display: flex;
	flex-direction: column;
	justify-content: center;
}

.welcome-text {
	font-size: 0.85rem;
	color: #ccc;
}

.username {
	font-size: 1.2rem;
	font-weight: bold;
	color: #fff;
}

.persistent-choices {
	position: fixed;
	bottom: 120px;
	right: 20px;
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 1000;
}

.choice-btn {
	padding: 12px 20px;
	border-radius: 25px;
	border: none;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 10px;
	transition: transform 0.3s ease;
}

.options-container {
	display: flex;
	gap: 10px;
	margin-top: 15px;
	flex-wrap: wrap;
}

.chat-option {
	padding: 8px 16px;
	border-radius: 20px;
	border: 1px solid var(--medical-blue);
	background: transparent;
	color: var(--medical-blue);
	cursor: pointer;
	transition: all 0.2s ease;
}

.chat-option:hover {
	background: var(--medical-blue);
	color: white;
}

.message.error .message-content {
	background: var(--medical-red);
	color: white;
}

.loading-indicator {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 15px;
	background: var(--secondary-color);
	border-radius: 10px;
	margin: 10px 0;
}

.loading-bar {
	height: 4px;
	width: 30px;
	background: var(--text-color);
	animation: loading 1.5s infinite ease-in-out;
	border-radius: 2px;
}

@keyframes loading { 0%, 100% {
	transform: scaleX(0.5);}50%{transform:scaleX(1);}
}
</style>
<!-- Material Symbols -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
	<header class="header">
		<!-- Hard-coded user info for testing -->
		<div class="user-profile">
			<span class="material-symbols-rounded">account_circle</span>
			<div class="username-container">
				<span class="welcome-text">Welcome back,</span> <span
					class="username">Test User</span>
			</div>
		</div>
		<a href="index.jsp" class="btn back-home-btn"> <i
			class="material-symbols-rounded">arrow_back</i> Home
		</a>
		<h1 class="title">MediBot AI</h1>
		<p class="subtitle">Your Intelligent Health Assistant</p>
	</header>

	<!-- Persistent choice buttons -->
	<div class="persistent-choices">
		<button class="choice-btn medical-choice" data-choice-type="symptoms">
			<span class="material-symbols-rounded">sick</span> Describe Symptoms
		</button>
		<button class="choice-btn medical-choice" data-choice-type="scan">
			<span class="material-symbols-rounded">radiology</span> Upload Scan
		</button>
		<button class="choice-btn medical-choice" data-choice-type="doctor">
			<span class="material-symbols-rounded">personal_injury</span> Talk to
			Doctor
		</button>
	</div>

	<div class="chat-list" id="chat-container">
		<!-- Chat messages will appear here -->
	</div>

	<div class="typing-area">
		<form class="typing-form" id="chat-form">
			<div class="input-wrapper">
				<input type="text" placeholder="Describe your symptoms..."
					class="typing-input" id="message-input" required>
				<div class="medical-actions">
					<div class="action-button"
						onclick="document.getElementById('image-upload').click()">
						<span class="material-symbols-rounded">image</span>
					</div>
					<button class="action-button" type="submit">
						<span class="material-symbols-rounded">send</span>
					</button>
				</div>
			</div>
			<input type="file" id="image-upload" hidden
				accept="image/*,application/dicom">
		</form>
		<p class="disclaimer-text">Note: MediBot provides preliminary
			health insights and should not replace professional medical advice.</p>
	</div>

	<script>
  document.getElementById('chat-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    let messageInput = document.getElementById('message-input');
    let message = messageInput.value;
    
    // Construct the data to send. Adjust conversation_id as needed.
    let data = { sender: 'patient', message: message, conversation_id: 'session123' };
    
    // Use the context path dynamically to ensure the URL is correct.
    fetch('<%=request.getContextPath()%>/ChatServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    .then(response => {
      // Check if the response is OK (status in the range 200-299)
      if (!response.ok) {
        throw new Error('HTTP error, status = ' + response.status);
      }
      return response.json();
    })
    .then(result => {
      displayMessage('patient', message);
      displayMessage('bot', result.botResponse);
      messageInput.value = '';
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
  });

  function displayMessage(sender, message) {
    let chatContainer = document.getElementById('chat-container');
    let messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + (sender === 'patient' ? 'outgoing' : 'incoming');
    messageDiv.innerHTML = `<div class="message-content">${message}</div>`;
    chatContainer.appendChild(messageDiv);
  }
</script>



</body>
</html>
