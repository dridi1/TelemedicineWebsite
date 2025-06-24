<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Virtual Health Companion</title>

  <!-- Custom CSS -->
  <style><%@ include file="/assets/css/index.css" %></style>

  <!-- Bootstrap CSS & Icons -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    rel="stylesheet"
  />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    rel="stylesheet"
  />
  <link
    href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap"
    rel="stylesheet"
  />

  <!-- Intro.js CSS -->
  <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css"
  />

  <!-- Intro.js Custom Styles -->
  <style>
	/* Main tooltip style */
	.introjs-tooltip {
	  background: rgba(30, 144, 255, 0.8); /* Transparent blue */
	  color: #ffffff;
	  border-radius: 12px;
	  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
	  padding: 20px;
	}
	
	/* Button base */
	.introjs-button {
	  background-color: rgba(255, 255, 255, 0.15); /* soft white background */
	  color: #ffffff;
	  font-weight: bold;
	  border: 2px solid #ffffff;
	  border-radius: 50px;
	  padding: 8px 24px;
	  transition: all 0.3s ease;
	  text-shadow: 0 0 2px rgba(0,0,0,0.6); /* makes text crisp */
	  backdrop-filter: blur(5px); /* for cool glassmorphism effect */
	}
	
	/* On hover */
	.introjs-button:hover, .introjs-button:focus {
	  background-color: #ffffff;
	  color: #1e90ff; /* DodgerBlue */
	  text-shadow: none;
	}
	
	/* Disabled button */
	.introjs-disabled, .introjs-disabled:hover, .introjs-disabled:focus {
	  opacity: 0.5;
	  cursor: not-allowed;
	  border-color: #ffffff;
	}
	
	/* Arrows */
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
	
	/* Skip button style */
	.introjs-skipbutton {
	  background: transparent;
	  color: #ffffffcc; /* slightly faded white */
	  border: none;
	  font-size: 0.85rem;
	  font-weight: 500;
	  margin-right: auto; /* Pushes it to the left */
	  padding: 6px 12px;
	  cursor: pointer;
	  text-decoration: underline;
	  transition: color 0.3s ease;
	}
	
	/* Hover effect */
	.introjs-skipbutton:hover {
	  color: #cce7ff;
	}
	
	/* Buttons container fix */
	.introjs-tooltipbuttons {
	  display: flex;
	  align-items: center;
	  justify-content: flex-end;
	  gap: 8px; /* space between buttons */
	}
	</style>


</head>
<body>
  <%@ include file="/WEB-INF/views/templates/header.jsp" %>

  <!-- User menu (if logged in) -->
  <c:if test="${not empty sessionScope.user}">
    <c:set var="initial" value="${fn:substring(sessionScope.user.username,0,1)}"/>
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle d-flex align-items-center"
         href="#" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
        <span class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center me-2"
              style="width:32px;height:32px;font-weight:bold;line-height:32px;">
          ${initial}
        </span>
        ${sessionScope.user.username}
      </a>
      <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
        <c:choose>
          <c:when test="${fn:toLowerCase(sessionScope.userRole)=='doctor'}">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a></li>
          </c:when>
          <c:otherwise>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/dashboard">Dashboard</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </li>
  </c:if>

  <!-- Welcome Modal & Tour only if NOT logged in -->
  <c:if test="${empty sessionScope.user}">
    <div class="modal fade" id="welcomeModal" tabindex="-1" aria-labelledby="welcomeModalLabel">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="welcomeModalLabel">Welcome!</h5>
          </div>
          <div class="modal-body">
            Are you new here? Let us give you a quick tour!
          </div>
          <div class="modal-footer">
            <button type="button" id="tour-yes" class="btn btn-primary">Yes</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          </div>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Hero Section (skip in tour) -->
  <div id="hero" class="hero-section nunito-header position-relative" style="min-height:100vh;">
    <script type="module" src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs"></script>
    <dotlottie-player
      src="https://lottie.host/6cbb7979-586e-452a-b35a-3884f76ff84e/13ZnuXVk61.lottie"
      background="transparent" speed="0.5"
      style="position:absolute;width:100%;height:100%;top:0;left:0;"
      loop autoplay>
    </dotlottie-player>
    <div class="hero-overlay"></div>
    <div class="container position-relative" style="z-index:2; min-height:100vh;">
      <div class="row align-items-center" style="min-height:100vh;">
        <div class="col-md-7 text-center text-md-start">
          <h1 class="display-4 fw-bold mb-4">Your Virtual Health Companion</h1>
          <p class="lead mb-4">Empowering you with secure, reliable, and AI-powered healthcare at your fingertips.</p>
          <a id="register-btn" href="register" class="btn btn-lg btn-danger rounded-pill px-5 py-3">Get Started</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Features Section -->
  <section id="features" class="py-5 bg-light">
    <div class="container">
      <h2 class="text-center mb-5 fw-bold text-primary">Why Choose Our Platform?</h2>
      <div class="row g-4">
        <div class="col-md-4" id="feature-diagnostics">
          <div class="card h-100 shadow-lg p-4">
            <div class="card-body text-center">
              <span class="material-icons text-success fs-1 mb-3">health_and_safety</span>
              <h3 class="card-title mb-3">AI-Powered Diagnostics</h3>
              <p class="card-text">Precision-driven insights with cutting-edge ML models.</p>
            </div>
          </div>
        </div>
        <div class="col-md-4" id="feature-security">
          <div class="card h-100 shadow-lg p-4">
            <div class="card-body text-center">
              <span class="material-icons text-danger fs-1 mb-3">security</span>
              <h3 class="card-title mb-3">Unmatched Security</h3>
              <p class="card-text">Military-grade encryption keeps your data safe.</p>
            </div>
          </div>
        </div>
        <div class="col-md-4" id="feature-cloud">
          <div class="card h-100 shadow-lg p-4">
            <div class="card-body text-center">
              <span class="material-icons text-info fs-1 mb-3">cloud_queue</span>
              <h3 class="card-title mb-3">Cloud Access</h3>
              <p class="card-text">View records anytime, anywhere, on any device.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Testimonials Section -->
  <section id="testimonials" class="py-5">
    <div class="container">
      <h2 class="text-center mb-5 fw-bold text-primary">What Our Users Say</h2>
      <div class="row g-4 align-items-center">
        <div class="col-md-6" id="testimonial-card">
          <div class="card h-100 shadow p-4">
            <div class="card-body text-center">
              <h4 class="card-title text-secondary mb-3">Dr. Jane Doe</h4>
              <p class="card-text">“This platform revolutionized telemedicine for our practice.”</p>
            </div>
          </div>
        </div>
        <div class="col-md-6 text-center" id="testimonial-animation">
          <img
            src="https://assets2.lottiefiles.com/packages/lf20_hi95bvmx/doctor.json"
            alt="Doctor animation"
            class="img-fluid"
            style="max-height:300px;"
          />
        </div>
      </div>
    </div>
  </section>

  <!-- Chat Bubble -->
  <div class="chat-bubble" id="chat-bubble">
    <a href="<c:url value='/chat-ui'/>" class="chat-link">
      <div class="chat-icon"><i class="material-icons">medical_services</i></div>
      <span class="chat-pulse"></span>
    </a>
  </div>

  <%@ include file="/WEB-INF/views/templates/footer.jsp" %>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <!-- Intro.js JS -->
  <script src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>

  <c:if test="${empty sessionScope.user}">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        // Show welcome modal
        const welcomeModal = new bootstrap.Modal(document.getElementById('welcomeModal'));
        welcomeModal.show();

        // Define tour steps skipping the hero
        const steps = [
          {
            element: '#register-btn',
            intro: 'Click here to sign up and start exploring all our features!'
          },
          {
            element: '#feature-diagnostics',
            intro: 'Our AI-Powered Diagnostics deliver fast, accurate health insights.'
          },
          {
            element: '#feature-security',
            intro: 'We secure your data with military-grade encryption at rest and in transit.'
          },
          {
            element: '#feature-cloud',
            intro: 'Access your records on any device—your health goes wherever you go.'
          },
          {
            element: '#testimonial-card',
            intro: 'Read real feedback—our users love how we transformed their practice.'
          },
          {
            element: '#testimonial-animation',
            intro: 'Watch this friendly animation that shows how easy our interface is.'
          },
          {
            element: '#chat-bubble',
            intro: 'Need help? Click this chat icon anytime to connect with our support team.'
          }
        ];

        // Start tour on confirmation
        document.getElementById('tour-yes').addEventListener('click', () => {
          welcomeModal.hide();
          introJs()
            .setOptions({
              steps,
              showStepNumbers: false,
              nextLabel: 'Next →',
              prevLabel: '← Back',
              skipLabel: 'Skip',
              doneLabel: 'Got It!'
            })
            .start();
        });
      });
    </script>
  </c:if>

  <!-- Smooth-scroll -->
  <script>
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', e => {
        e.preventDefault();
        document.querySelector(anchor.getAttribute('href'))
          .scrollIntoView({ behavior: 'smooth' });
      });
    });
  </script>
</body>
</html>
