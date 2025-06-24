<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.time.LocalDateTime,java.time.format.DateTimeFormatter"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Doctor Dashboard - Telemedicine</title>
<!-- Intro.js CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" />
<!-- Custom Intro.js Styles -->
<style>
.introjs-tooltip {
	background: rgba(30, 144, 255, 0.8);
	color: #fff;
	border-radius: 12px;
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
	padding: 20px;
}

.introjs-button {
	background: rgba(255, 255, 255, 0.15);
	color: #fff;
	font-weight: bold;
	border: 2px solid #fff;
	border-radius: 50px;
	padding: 8px 24px;
	transition: all 0.3s ease;
	text-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
	backdrop-filter: blur(5px);
}

.introjs-button:hover, .introjs-button:focus {
	background: #fff;
	color: #1e90ff;
	text-shadow: none;
}

.introjs-disabled, .introjs-disabled:hover, .introjs-disabled:focus {
	opacity: 0.5;
	cursor: not-allowed;
	border-color: #fff;
}

.introjs-arrow {
	border: 10px solid transparent;
}

.introjs-arrow.top {
	border-bottom-color: rgba(30, 144, 255, 0.8);
}

.introjs-arrow.bottom {
	border-top-color: rgba(30, 144, 255, 0.8);
}

.introjs-arrow.left {
	border-right-color: rgba(30, 144, 255, 0.8);
}

.introjs-arrow.right {
	border-left-color: rgba(30, 144, 255, 0.8);
}

.introjs-skipbutton {
	background: transparent;
	color: #ffffffcc;
	border: none;
	font-size: 0.85rem;
	font-weight: 500;
	margin-right: auto;
	padding: 6px 12px;
	cursor: pointer;
	text-decoration: underline;
	transition: color 0.3s ease;
}

.introjs-skipbutton:hover {
	color: #cce7ff;
}

.introjs-tooltipbuttons {
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 8px;
}
</style>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet" />
<script src="https://unpkg.com/lucide@latest"></script>
<script src="https://cdn.tailwindcss.com"></script>
<script>
    tailwind.config = { theme: { extend: { colors: { primary: '#2563eb', secondary: '#3b82f6', accent: '#8b5cf6', success: '#22c55e', warning: '#f59e0b', danger: '#ef4444' }, animation: { 'fade-in': 'fadeIn 0.5s ease-in-out' }, keyframes: { fadeIn: { '0%': { opacity: 0 }, '100%': { opacity: 1 } } } } } };
  </script>
</head>
<body class="bg-gray-50"
	data-intro="Welcome to your Telemedicine Dashboard! Let me guide you through all the features."
	data-step="1">
	<div class="flex min-h-screen">
		<!-- Sidebar -->
		<aside
			class="hidden md:flex md:flex-col bg-white w-64 border-r border-gray-200 h-screen sticky top-0"
			data-intro="Use the sidebar to navigate between sections like Schedule, Profile, and Chat."
			data-step="2">
			<div class="p-6">
				<div class="flex items-center gap-2 mb-8"
					data-intro="This is your Telemedicine brand/logo." data-step="3">
					<i data-lucide="stethoscope" class="text-primary w-6 h-6"></i> <span
						class="text-xl font-semibold text-primary">Telemedicine</span>
				</div>
				<nav class="space-y-1">
					<a href="${pageContext.request.contextPath}/doctor/dashboard"
						class="flex items-center gap-3 px-4 py-3 rounded-lg bg-blue-50 text-primary font-medium border-l-4 border-primary"
						data-intro="Dashboard is your home base for key metrics and quick access."
						data-step="4"> <i data-lucide="home" class="w-5 h-5"></i>
						Dashboard
					</a> <a href="${pageContext.request.contextPath}/schedule"
						class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200"
						data-intro="Check and manage your schedule here." data-step="5">
						<i data-lucide="calendar" class="w-5 h-5"></i> Schedule
					</a> <a href="${pageContext.request.contextPath}/profile"
						class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200"
						data-intro="View and edit your profile details." data-step="6">
						<i data-lucide="user" class="w-5 h-5"></i> Profile
					</a> <a href="${pageContext.request.contextPath}/settings"
						class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200"
						data-intro="Adjust your preferences and settings." data-step="7">
						<i data-lucide="settings" class="w-5 h-5"></i> Settings
					</a> <a href="${pageContext.request.contextPath}/doctor/chat"
						class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200"
						data-intro="Access your patient chats here." data-step="8"> <i
						data-lucide="message-circle" class="w-5 h-5"></i> Chat
					</a>
					<div class="pt-6 mt-6 border-t border-gray-200">
						<a href="${pageContext.request.contextPath}/logout"
							class="flex items-center gap-3 px-4 py-3 text-gray-600 rounded-lg hover:bg-gray-100 transition-all duration-200"
							data-intro="Click here to logout of your account." data-step="9">
							<i data-lucide="log-out" class="w-5 h-5"></i> Logout
						</a>
					</div>
				</nav>
			</div>
		</aside>

		<!-- Main Content -->
		<main class="flex-1 p-6 lg:p-8">
			<div
				class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8">
				<div>
					<h1 class="text-2xl font-bold text-gray-800"
						data-intro="Here’s your personalized greeting." data-step="10">Welcome,
						Dr. ${sessionScope.user.username}</h1>
					<p class="text-gray-600"
						data-intro="This gives you an overview of your dashboard."
						data-step="11">Overview of your schedule and patient
						interactions</p>
				</div>
				<div class="mt-4 md:mt-0">
					<button id="startTour" class="introjs-button"
						data-intro="Click here anytime to restart the tour."
						data-step="12">Start Tour</button>
				</div>
			</div>

			<c:if test="${not empty successMessage}">
				<div
					class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded animate-fade-in"
					data-intro="Any success messages will appear here." data-step="13">
					<p>${successMessage}</p>
				</div>
			</c:if>

			<!-- Statistics Cards -->
			<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8"
				data-intro="Quick stats to keep you informed at a glance."
				data-step="14">
				<div
					class="bg-blue-50 border-blue-200 p-6 rounded-lg shadow-sm border"
					data-intro="Shows number of today's appointments." data-step="15">
					<div class="flex items-center justify-between">
						<div>
							<h3 class="text-gray-700 font-medium mb-1">Today's
								Appointments</h3>
							<p class="text-3xl font-bold">${todayScheduleCount}</p>
						</div>
						<div class="p-3 rounded-full bg-white shadow-sm">
							<i data-lucide="clock" class="text-blue-500 w-5 h-5"></i>
						</div>
					</div>
				</div>
				<div
					class="bg-indigo-50 border-indigo-200 p-6 rounded-lg shadow-sm border"
					data-intro="Number of upcoming appointments beyond today."
					data-step="16">
					<div class="flex items-center justify-between">
						<div>
							<h3 class="text-gray-700 font-medium mb-1">Upcoming
								Appointments</h3>
							<p class="text-3xl font-bold">${fn:length(appointments)}</p>
						</div>
						<div class="p-3 rounded-full bg-white shadow-sm">
							<i data-lucide="user-check" class="text-indigo-500 w-5 h-5"></i>
						</div>
					</div>
				</div>
				<div
					class="bg-purple-50 border-purple-200 p-6 rounded-lg shadow-sm border"
					data-intro="Count of recent patient chats." data-step="17">
					<div class="flex items-center justify-between">
						<div>
							<h3 class="text-gray-700 font-medium mb-1">Recent Chats</h3>
							<p class="text-3xl font-bold">${fn:length(recentChats)}</p>
						</div>
						<div class="p-3 rounded-full bg-white shadow-sm">
							<i data-lucide="message-square" class="text-purple-500 w-5 h-5"></i>
						</div>
					</div>
				</div>
			</div>

			<!-- Today's Appointments -->
			<section class="mb-8"
				data-intro="Your detailed schedule for today is shown here."
				data-step="18">
				<h2 class="text-xl font-semibold text-gray-800 mb-4"
					data-intro="Section title for today's schedule." data-step="19">Today's
					Schedule</h2>
				<div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4"
					data-intro="Each card represents an appointment." data-step="20">
					<c:choose>
						<c:when test="${not empty todaySchedule}">
							<c:forEach items="${todaySchedule}" var="apt">
								<div
									class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow duration-200"
									data-intro="Appointment card with patient details, status, date/time, symptoms, and status update."
									data-step="21">
									<div
										class="p-4 ${apt.status == 'PENDING' ? 'bg-yellow-50 border-yellow-200' : apt.status == 'CONFIRMED' ? 'bg-blue-50 border-blue-200' : apt.status == 'COMPLETED' ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'} border-b"
										data-intro="Patient name and status badge." data-step="22">
										<div class="flex justify-between items-center">
											<div class="flex items-center gap-2">
												<div
													class="w-8 h-8 bg-white rounded-full flex items-center justify-center">
													<i data-lucide="user" class="text-gray-600 w-4 h-4"></i>
												</div>
												<h3 class="font-medium text-gray-800"
													data-intro="This is the patient's name.">
													${apt.patientName}</h3>
											</div>
											<div
												class="flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${apt.status == 'PENDING' ? 'text-yellow-700' : apt.status == 'CONFIRMED' ? 'text-blue-700' : apt.status == 'COMPLETED' ? 'text-green-700' : 'text-red-700'}"
												data-intro="Current status of the appointment."
												data-step="23">
												<i
													data-lucide="${apt.status == 'PENDING' ? 'alert-circle' : apt.status == 'CONFIRMED' ? 'check-circle-2' : apt.status == 'COMPLETED' ? 'check-circle-2' : 'x-circle'}"
													class="w-4 h-4"></i> <span>${apt.status}</span>
											</div>
										</div>
									</div>
									<div class="p-4">
										<div class="grid grid-cols-1 gap-3">
											<div class="flex items-center gap-2"
												data-intro="Appointment date." data-step="24">
												<i data-lucide="calendar" class="text-gray-400 w-4 h-4"></i>
												<span class="text-sm text-gray-600">${fn:substring(apt.appointmentDate, 0, 10)}</span>
											</div>
											<div class="flex items-center gap-2"
												data-intro="Appointment time." data-step="25">
												<i data-lucide="clock" class="text-gray-400 w-4 h-4"></i> <span
													class="text-sm text-gray-600">${fn:substring(apt.appointmentDate, 11, 16)}</span>
											</div>
											<div class="flex items-start gap-2 mt-1"
												data-intro="Symptoms or reason for visit." data-step="26">
												<i data-lucide="file-text"
													class="text-gray-400 w-4 h-4 mt-0.5"></i> <span
													class="text-sm text-gray-600">${apt.symptoms}</span>
											</div>
										</div>
										<form
											action="${pageContext.request.contextPath}/update-status"
											method="POST" class="mt-4"
											data-intro="Form to update the status of the appointment."
											data-step="27">
											<input type="hidden" name="appointmentId" value="${apt.id}" />
											<div class="flex flex-col gap-2">
												<label class="text-sm font-medium text-gray-600"
													data-intro="Label for the status dropdown." data-step="28">Update
													Status</label>
												<div class="flex gap-2">
													<select name="status"
														class="flex-1 text-sm rounded-lg border border-gray-300 bg-white py-2 px-3 shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-shadow duration-200"
														data-intro="Choose a new status here." data-step="29">
														<option value="PENDING"
															${apt.status == 'PENDING' ? 'selected' : ''}>Pending</option>
														<option value="CONFIRMED"
															${apt.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
														<option value="COMPLETED"
															${apt.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
														<option value="CANCELLED"
															${apt.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
													</select>
													<button type="submit"
														class="bg-primary text-white rounded-lg px-4 py-2 text-sm font-medium hover:bg-primary/90 transition-colors duration-200"
														data-intro="Click to save your status update."
														data-step="30">Update</button>
												</div>
											</div>
										</form>
										
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div
								class="col-span-full bg-white rounded-lg p-6 shadow-sm border border-gray-200 text-center"
								data-intro="Message shown when no appointments today."
								data-step="31">
								<p class="text-gray-500">No appointments scheduled for today</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</section>
-
			<!-- Upcoming Appointments -->
			<section class="mb-8"
			         data-intro="Overview of all upcoming appointments."
			         data-step="32">
			  <h2 class="text-xl font-semibold text-gray-800 mb-4"
			      data-intro="Section title for upcoming appointments."
			      data-step="33">
			    Upcoming Appointments
			  </h2>
			  <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4"
			       data-intro="Cards for each upcoming appointment."
			       data-step="34">
			    <c:choose>
			      <c:when test="${not empty appointments}">
			        <c:forEach items="${appointments}" var="apt">
			          <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow duration-200"
			               data-intro="Upcoming appointment card with details and status."
			               data-step="35">
			            
			            <!-- Header: patient name + status -->
			            <div class="flex justify-between items-center p-4 border-b border-gray-100">
			              <div class="flex items-center gap-2">
			                <div class="w-8 h-8 bg-white rounded-full flex items-center justify-center">
			                  <i data-lucide="user" class="text-gray-600 w-4 h-4"></i>
			                </div>
			                <h3 class="font-medium text-gray-800"
			                    data-intro="This is the patient's name."
			                    data-step="36">
			                  ${apt.patientName}
			                </h3>
			              </div>
			              <div class="flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium
			                          ${apt.status == 'PENDING'   ? 'text-yellow-700' :
			                            apt.status == 'CONFIRMED' ? 'text-blue-700'   :
			                            apt.status == 'COMPLETED' ? 'text-green-700'  :
			                                                         'text-red-700'}"
			                   data-intro="Current status of the appointment."
			                   data-step="37">
			                <i data-lucide="
			                  ${apt.status == 'PENDING'   ? 'alert-circle'    :
			                    apt.status == 'CONFIRMED' ? 'check-circle-2'  :
			                    apt.status == 'COMPLETED' ? 'check-circle-2'  :
			                                               'x-circle'}"
			                   class="w-4 h-4"></i>
			                <span>${apt.status}</span>
			              </div>
			            </div>
			            
			            <!-- Body: date, time, symptoms -->
			            <div class="p-4">
			              <div class="grid grid-cols-1 gap-3">
			                <div class="flex items-center gap-2"
			                     data-intro="Appointment date."
			                     data-step="38">
			                  <i data-lucide="calendar" class="text-gray-400 w-4 h-4"></i>
			                  <span class="text-sm text-gray-600">
			                    ${fn:substring(apt.appointmentDate, 0, 10)}
			                  </span>
			                </div>
			                <div class="flex items-center gap-2"
			                     data-intro="Appointment time."
			                     data-step="39">
			                  <i data-lucide="clock" class="text-gray-400 w-4 h-4"></i>
			                  <span class="text-sm text-gray-600">
			                    ${fn:substring(apt.appointmentDate, 11, 16)}
			                  </span>
			                </div>
			                <div class="flex items-start gap-2 mt-1"
			                     data-intro="Symptoms or reason for visit."
			                     data-step="40">
			                  <i data-lucide="file-text" class="text-gray-400 w-4 h-4 mt-0.5"></i>
			                  <span class="text-sm text-gray-600">${apt.symptoms}</span>
			                </div>
			              </div>
			              
			              <!-- Status update form -->
			              <form action="${pageContext.request.contextPath}/update-status"
			                    method="POST"
			                    class="mt-4"
			                    data-intro="Form to update the status of the appointment."
			                    data-step="41">
			                <input type="hidden" name="appointmentId" value="${apt.id}" />
			                <div class="flex flex-col gap-2">
			                  <label class="text-sm font-medium text-gray-600"
			                         data-intro="Label for the status dropdown."
			                         data-step="42">
			                    Update Status
			                  </label>
			                  <div class="flex gap-2">
			                    <select name="status"
			                            class="flex-1 text-sm rounded-lg border border-gray-300 bg-white py-2 px-3 shadow-sm
			                                   focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent
			                                   transition-shadow duration-200"
			                            data-intro="Choose a new status here."
			                            data-step="43">
			                      <option value="PENDING"   ${apt.status == 'PENDING'   ? 'selected' : ''}>Pending</option>
			                      <option value="CONFIRMED" ${apt.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
			                      <option value="COMPLETED" ${apt.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
			                      <option value="CANCELLED" ${apt.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
			                    </select>
			                    <button type="submit"
			                            class="bg-primary text-white rounded-lg px-4 py-2 text-sm font-medium
			                                   hover:bg-primary/90 transition-colors duration-200"
			                            data-intro="Click to save your status update."
			                            data-step="44">
			                      Update
			                    </button>
			                  </div>
			                </div>
			              </form>
			              <!-- Add Medical History button -->
						  <form action="${pageContext.request.contextPath}/doctor/medical-history/add"
						        method="post"
						        class="mt-4">
						    <input type="hidden" name="patientId" value="${apt.patientId}" />
						    <button type="submit"
						            class="bg-secondary text-white rounded-lg px-4 py-2 text-sm font-medium hover:bg-secondary/90 transition-colors duration-200">
						      Add Medical History
						    </button>
						  </form>
						  <!-- Add Medical History button -->
						  <form action="${pageContext.request.contextPath}/doctor/report/generate?patientId=${apt.patientId}"
						        method="post"
						        class="mt-4">
						    <button type="submit"
						            class="bg-secondary text-white rounded-lg px-4 py-2 text-sm font-medium hover:bg-secondary/90 transition-colors duration-200">
						      record
						    </button>
						  </form>
			            </div>
			
			          </div> <!-- /.appointment card -->
			        </c:forEach>
			      </c:when>
			      <c:otherwise>
			        <div class="col-span-full bg-white rounded-lg p-6 shadow-sm border border-gray-200 text-center"
			             data-intro="Message when no upcoming appointments."
			             data-step="45">
			          <p class="text-gray-500">No upcoming appointments scheduled</p>
			        </div>
			      </c:otherwise>
			    </c:choose>
			  </div>
			</section>


			<!-- Recent Conversations -->
			<section data-intro="Your recent patient chat history appears here."
				data-step="37">
				<h2 class="text-xl font-semibold text-gray-800 mb-4"
					data-intro="Section title for recent conversations." data-step="38">Recent
					Conversations</h2>
				<div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4"
					data-intro="Cards showing recent chat threads." data-step="39">
					<c:choose>
						<c:when test="${not empty recentChats}">
							<c:forEach items="${recentChats}" var="chat">
								<div
									class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow duration-200"
									data-intro="Individual conversation card with latest message."
									data-step="40">
									<div class="p-4">
										<div class="flex items-center gap-3 mb-3"
											data-intro="Shows patient avatar and name." data-step="41">
											<div
												class="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center text-purple-600 font-medium">
												${fn:substring(chat.patientName, 0, 1)}</div>
											<div class="flex-1">
												<h3 class="font-medium text-gray-800">${chat.patientName}</h3>
												<div class="flex items-center text-xs text-gray-500"
													data-intro="Timestamp of the last message." data-step="42">
													<i data-lucide="clock" class="w-3 h-3 mr-1"></i> <span>${chat.time}</span>
												</div>
											</div>
										</div>
										<div class="bg-gray-50 rounded-lg p-3 mb-3"
											data-intro="Snippet of the latest patient message."
											data-step="43">
											<p class="text-sm text-gray-600">${chat.lastPatientMessage}</p>
										</div>
										<div class="flex justify-end">
											<a
												href="${pageContext.request.contextPath}/doctor/chat?conversationId=${chat.id}"
												class="flex items-center gap-1 text-sm text-primary font-medium hover:text-primary/80 transition-colors"
												data-intro="Click to continue this chat thread."
												data-step="44"> <span>Continue Chat</span> <i
												data-lucide="arrow-right" class="w-4 h-4"></i>
											</a>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div
								class="col-span-full bg-white rounded-lg p-6 shadow-sm border border-gray-200 text-center"
								data-intro="Message when no recent conversations."
								data-step="45">
								<p class="text-gray-500">No recent conversations</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</section>
		</main>
	</div>

	<!-- Intro.js Script -->
	<script
		src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>
	<script>
    lucide.createIcons();
    document.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', (e) => {
        const status = e.target.querySelector('select[name="status"]').value;
        const currentStatus = e.target.querySelector('select[name="status"]').getAttribute('data-current');
        if (status === currentStatus) { e.preventDefault(); alert('No status change detected!'); }
        else if (!confirm(`Change status to ${status}?`)) { e.preventDefault(); }
      });
    });
    document.getElementById('startTour').addEventListener('click', () => {
      introJs().setOptions({ showBullets:true, showProgress:true, skipLabel:'Skip tour', nextLabel:'Next', prevLabel:'Back', doneLabel:'Done' }).start();
    });
    if (!localStorage.getItem('dashboardTour')) { introJs().start(); localStorage.setItem('dashboardTour','seen'); }
  </script>
</body>
</html>