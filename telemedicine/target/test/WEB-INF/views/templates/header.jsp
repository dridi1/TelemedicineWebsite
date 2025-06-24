<%@ page import="java.util.Calendar" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<nav class="navbar navbar-expand-lg navbar-light fixed-top" style="
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    z-index: 1000;
">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">
      <img src="assets/img/medical-logo-svgrepo-com.svg" alt="Logo" width="50" height="50">
      <span class="fw-bold text-primary fs-4">Virtual Health</span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <!-- flex alignment ensures every li is centered vertically -->
      <ul class="navbar-nav ms-auto gap-3 align-items-center">
        <li class="nav-item">
          <a class="nav-link hover-underline" href="#hero">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link hover-underline" href="#features">Features</a>
        </li>
        <li class="nav-item">
          <a class="nav-link hover-underline" href="aboutus">AboutUs</a>
        </li>
        <li class="nav-item">
          <a class="nav-link hover-underline" href="#testimonials">Testimonials</a>
        </li>

        <!-- not logged in -->
        <c:if test="${empty sessionScope.user}">
          <li class="nav-item">
            <a class="nav-link hover-underline" href="login">Login</a>
          </li>
          <li class="nav-item">
            <a id="register-btn" class="btn btn-primary px-4" href="register">Get Started</a>
          </li>
        </c:if>

        <!-- logged in -->
		
		<c:if test="${not empty sessionScope.user}">
		  <c:set var="initial" value="${fn:substring(sessionScope.user.username, 0, 1)}"/>
		  <li class="nav-item dropdown">
		    <a class="nav-link dropdown-toggle d-flex align-items-center"
		       href="#" id="userMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
		      <%--
		      <c:choose>
		        <c:when test="${not empty sessionScope.user.avatarFilename}">
		          <img src="${pageContext.request.contextPath}/assets/img/avatars/${sessionScope.user.avatarFilename}"
		               class="rounded-circle me-2"
		               style="width:32px; height:32px;"
		               alt="Avatar">
		        </c:when>
		        <c:otherwise>
		          <span class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center me-2"
		                style="width:32px; height:32px; font-weight:bold; line-height:32px;">
		            ${initial}
		          </span>
		        </c:otherwise>
		      </c:choose>
		      
		       --%> 
		      
		      <span class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center me-2"
		                style="width:32px; height:32px; font-weight:bold; line-height:32px;">
		            ${initial}
		          </span>
		
		      ${sessionScope.user.username}
		    </a>
		    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
		      <c:choose>
		        <c:when test="${fn:toLowerCase(sessionScope.userRole) eq 'doctor'}">
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a></li>
		        </c:when>
		        <c:otherwise>
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/dashboard">Dashboard</a></li>
		        </c:otherwise>
		      </c:choose>
		      <li><hr class="dropdown-divider"></li>
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
		    </ul>
		  </li>
		</c:if>
      </ul>
    </div>
  </div>
</nav>
