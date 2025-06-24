<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Appointments</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <!-- Include the global FullCalendar script -->
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
  <!-- Custom FullCalendar styling -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dash/navbar.css">
  <style>
    .dashboard {
      display: grid;
      grid-template-columns: 240px 1fr;
      min-height: 100vh;
    }
    /* Main Content */
    .main {
      padding: 2rem;
      max-width: 1200px;
      margin: 0 auto;
      width: 100%;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
    }
    .avatar {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      background: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
    }
    /* Appointments Grid */
    .appointments-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 1.5rem;
    }
    .appointment-card {
      background: white;
      border-radius: 1rem;
      padding: 1.5rem;
      box-shadow: var(--shadow);
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .appointment-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
    }
    .appointment-info h3 {
      color: var(--primary);
      margin-bottom: 0.5rem;
    }
    .appointment-meta {
      display: grid;
      gap: 0.75rem;
      margin: 1rem 0;
    }
    .appointment-meta p {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      color: #64748b;
    }
    .status-pill {
      display: inline-flex;
      align-items: center;
      padding: 0.25rem 0.75rem;
      border-radius: 999px;
      font-size: 0.875rem;
      font-weight: 500;
    }
    .status-pending { background: #fef9c3; color: #854d0e; }
    .status-confirmed { background: #dcfce7; color: #166534; }
    .status-cancelled { background: #fee2e2; color: #991b1b; }
    .cancel-btn {
      width: 100%;
      margin-top: 1rem;
      background: var(--danger);
      color: white;
      border: none;
      padding: 0.75rem;
      border-radius: 0.5rem;
      cursor: pointer;
      transition: opacity 0.2s;
    }
    .cancel-btn:hover {
      opacity: 0.9;
    }
    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 4rem;
      background: white;
      border-radius: 1rem;
      box-shadow: var(--shadow);
    }
    /* Alerts */
    .alert {
      padding: 1rem;
      border-radius: 0.5rem;
      margin-bottom: 1.5rem;
    }
    .alert-success {
      background: #dcfce7;
      color: #166534;
    }
    .alert-error {
      background: #fee2e2;
      color: #991b1b;
    }
    /* FullCalendar container styling */
    #calendar-container {
      max-width: 900px;
      margin: 2rem auto;
      background: white;
      border: 1px solid #ddd;
      border-radius: 0.5rem;
      box-shadow: var(--shadow);
      padding: 1rem;
    }
    /* Custom event styles */
    .fc-event.pending {
      background-color: #fef9c3 !important;
      border: none;
      color: #854d0e !important;
    }
    .fc-event.confirmed {
      background-color: #dcfce7 !important;
      border: none;
      color: #166534 !important;
    }
    .fc-event.cancelled {
      background-color: #fee2e2 !important;
      border: none;
      color: #991b1b !important;
    }
    @media (max-width: 768px) {
      .dashboard {
        grid-template-columns: 1fr;
      }
      .main {
        padding: 1.5rem;
      }
    }
    #darkModeToggle {
	  padding: 0.5rem 1rem;
	  border: none;
	  border-radius: 0.5rem;
	  background: var(--primary);
	  color: var(--btn-text-on-primary);
	  cursor: pointer;
	  transition: background 0.2s;
	  margin-right: 1rem;
	}
	
	#darkModeToggle:hover {
	  background: var(--secondary);
	}
  </style>
</head>
<body>
  <div class="dashboard">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" flush="true" />

    <!-- Main Content -->
    <main class="main">
      <div class="header">
        <div>
          <h1>Your Appointments</h1>
          <p class="text-muted">View and manage your appointments</p>
        </div>
        <div style="display: flex; align-items: center;">
          <!-- Dark Mode Toggle Button -->
          <button id="darkModeToggle" onclick="toggleDarkMode()">Toggle Dark Mode</button>
          <div class="avatar">
            <i class="fas fa-user"></i>
          </div>
        </div>
      </div>

      <c:choose>
        <c:when test="${not empty appointments}">
          <div class="appointments-grid">
            <c:forEach items="${appointments}" var="appointment">
              <div class="appointment-card">
                <h3>Dr. ${appointment.doctor.username}</h3>
                <div class="appointment-meta">
                  <p><i class="fas fa-stethoscope"></i> ${appointment.doctor.specialization}</p>
                  <p>
                    <i class="fas fa-clock"></i>
                    ${fn:substring(appointment.appointmentDate, 0, 10)}
                    at ${fn:substring(appointment.appointmentDate, 11, 16)}
                  </p>
                  <p><i class="fas fa-comment-medical"></i> ${appointment.symptoms}</p>
                </div>
                <div class="appointment-actions">
                  <span class="status-pill status-${appointment.status.name().toLowerCase()}">
                    ${appointment.status}
                  </span>
                  <c:if test="${appointment.status.name() != 'CANCELLED'}">
                    <form action="${pageContext.request.contextPath}/cancel-appointment" method="post">
                      <input type="hidden" name="appointmentId" value="${appointment.id}">
                      <button type="submit" class="cancel-btn" 
                              onclick="return confirm('Are you sure you want to cancel this appointment?')">
                        Cancel Appointment
                      </button>
                    </form>
                  </c:if>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-state">
            <p>No upcoming appointments</p>
            <a href="${pageContext.request.contextPath}/patient/dashboard" 
               class="btn-primary" 
               style="margin-top: 1rem; display: inline-block;">
              Book New Appointment
            </a>
          </div>
        </c:otherwise>
      </c:choose>

      <!-- Alerts -->
      <c:if test="${not empty param.success}">
        <div class="alert alert-success">
          <c:choose>
            <c:when test="${param.success == 'cancelled'}">
              ✔️ Appointment cancelled successfully
            </c:when>
          </c:choose>
        </div>
      </c:if>
      <c:if test="${not empty param.error}">
        <div class="alert alert-error">
          <c:choose>
            <c:when test="${param.error == 'unauthorized'}">
              ⚠️ Action not authorized
            </c:when>
            <c:otherwise>
              ⚠️ Error processing request
            </c:otherwise>
          </c:choose>
        </div>
      </c:if>

      <!-- Calendar Section -->
      <h2 style="margin-top:2rem;">Appointment Calendar</h2>
      <div id="calendar-container"></div>
    </main>
  </div>
	<script src="${pageContext.request.contextPath}/assets/js/dash/navbar.js"></script>
  <script>
//Dark Mode Toggling
  function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
  }
    // Build an array of events for FullCalendar.
    // Each event requires a title and start date.
    // We add a custom property for the status to style events accordingly.
    var events = [
      <c:forEach items="${appointments}" var="appointment" varStatus="status">
        {
          id: '${appointment.id}',
          title: 'Dr. ${appointment.doctor.username}',
          start: '${appointment.appointmentDate}',
          extendedProps: {
            fullDate: '${fn:substring(appointment.appointmentDate, 0, 10)}',
            status: '${appointment.status.name().toLowerCase()}'
          }
        }<c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
      var calendarEl = document.getElementById('calendar-container');
      var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        events: events,
        selectable: true,
        // Customize event display using eventContent callback.
        eventContent: function(arg) {
          // Create a container div.
          var containerEl = document.createElement('div');
          // Display the title in bold.
          var titleEl = document.createElement('div');
          titleEl.innerHTML = '<strong>' + arg.event.title + '</strong>';
          // Display the date from extendedProps.
          var dateEl = document.createElement('div');
          dateEl.innerHTML = arg.event.extendedProps.fullDate;
          containerEl.appendChild(titleEl);
          containerEl.appendChild(dateEl);
          return { domNodes: [ containerEl ] };
        },
        // Apply a tooltip and custom CSS classes based on appointment status.
        eventDidMount: function(info) {
          // Set a tooltip with additional info.
          info.el.title = info.event.title + ' on ' + info.event.extendedProps.fullDate;
          // Add custom CSS class for styling based on status.
          info.el.classList.add(info.event.extendedProps.status);
        },
        eventClick: function(info) {
          alert('Appointment: ' + info.event.title + ' on ' + info.event.extendedProps.fullDate);
        }
      });
      calendar.render();
    });
  </script>
</body>
</html>
