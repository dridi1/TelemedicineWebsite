<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="sidebar">
  <a href="${pageContext.request.contextPath}/" class="brand">
    Telemedicine
  </a>
  <nav>
    <ul class="nav-menu">
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link">
          <i class="fas fa-home"></i> Dashboard
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/appointments" class="nav-link">
          <i class="fas fa-calendar-check"></i> Appointments
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/chat" class="nav-link">
          <i class="fas fa-comments"></i> Conversations
        </a>
      </li>
      <!-- Chat with MediBot -->
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/chat-ui" class="nav-link">
          <i class="fas fa-robot"></i> Chat with MediBot
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/profile" class="nav-link">
          <i class="fas fa-user"></i> Profile
        </a>
      </li>
      <li class="nav-item">
        <a href="#" class="nav-link">
          <i class="fas fa-cog"></i> Settings
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link">
          <i class="fas fa-sign-out-alt"></i> Logout
        </a>
      </li>
    </ul>
  </nav>
  <c:if test="${not empty sessionScope.user}">
    <div class="sidebar-footer">
      <i class="fas fa-user-circle"></i>
      <span class="sidebar-username">${sessionScope.user.username}</span>
    </div>
  </c:if>
</aside>
