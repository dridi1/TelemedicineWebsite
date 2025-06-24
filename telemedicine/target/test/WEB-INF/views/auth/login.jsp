<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Virtual Health Companion</title>
    
    <!-- Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style><%@include file="/assets/css/auth/global-auth.css"%></style>
    <style><%@include file="/assets/css/auth/login.css"%></style>
    <style>
    .role-select {
	  margin-bottom: 1.5rem;
	}
	.role-select .form-label {
	  display: block;
	  margin-bottom: 0.5rem;
	  font-weight: 500;
	  font-size: 1rem;
	  color: #333;
	}
	    
    .role-select-icons {
	  display: flex;
	  justify-content: space-between;
	  margin-bottom: 1.5rem;
	}
	.role-select-icons .role-option {
	  flex: 1;
	  cursor: pointer;
	  text-align: center;
	  padding: 0.75rem;
	  border: 2px solid transparent;
	  border-radius: 0.5rem;
	  transition: border-color 0.2s, background-color 0.2s;
	}
	.role-select-icons .role-option + .role-option {
	  margin-left: 1rem;
	}
	.role-select-icons .role-option i {
	  font-size: 1.8rem;
	  display: block;
	  margin-bottom: 0.25rem;
	}
	.role-select-icons .role-option span {
	  display: block;
	  font-size: 0.9rem;
	  font-weight: 500;
	}
	.role-select-icons .role-option.active {
	  border-color: #0d6efd;
	  background-color: #e7f1ff;
	}
    </style>
    
    <script
      src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs"
      type="module"
    ></script>
</head>
<body>
    <div class="auth-card">
        <!-- Image Section -->
        <dotlottie-player
          src="https://lottie.host/6b0af365-9c5b-470d-98e7-8910276e0460/96wggdetft.lottie"
          background="transparent"
          speed="0.5"
          class="auth-image"
          loop
          autoplay
        ></dotlottie-player>
        
        <!-- Back Home Button (Top-Left Floating Style) -->
        <a href="/test" class="btn back-home-btn">
            <i class="material-icons">arrow_back</i> Home
        </a>
                
        <!-- Form Section -->
        <div class="auth-form">
            <h2>Welcome Back</h2>
            <p>Sign in to continue to your Virtual Health Companion</p>
            <!-- Login Form -->
            <form action="login" method="POST">
                <!-- Role Selection -->
                <div class="role-select">
                
	                <label class="form-label"><strong> Log As: </strong></label>
	                <div class="role-select-icons">
					  <div class="role-option active" data-role="PATIENT">
					    <i class="fas fa-user-injured"></i>
					    <span>Patient</span>
					  </div>
					  <div class="role-option" data-role="DOCTOR">
					    <i class="fas fa-user-md"></i>
					    <span>Doctor</span>
					  </div>
					  <div class="role-option" data-role="ADMIN">
					    <i class="fas fa-user-shield"></i>
					    <span>Admin</span>
					  </div>
					</div>
					<input type="hidden" name="role" id="role" value="PATIENT" required>
				</div>
                <!-- Email Field -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="material-icons">email</i>
                        </span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                </div>

                <!-- Password Field -->
                <div class="mb-4 position-relative">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="material-icons">lock</i>
                        </span>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                        <i class="material-icons password-toggle" onclick="togglePassword()">visibility_off</i>
                    </div>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="d-flex justify-content-between mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label" for="remember">Remember me</label>
                    </div>
                    <a href="forgot-password.jsp" class="text-decoration-none">Forgot password?</a>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary w-100 mb-3">Sign In</button>
                
				<!-- Error/Warning Message -->
		        <c:if test="${not empty error}">
		            <div class="alert alert-danger" role="alert">
		                <c:choose>
		                    <c:when test="${error == 'invalid_credentials'}">
		                        Invalid email or password.
		                    </c:when>
		                    <c:when test="${error == 'role_mismatch'}">
		                        Please login as the correct user type.
		                    </c:when>
		                    <c:when test="${error == 'unauthorized'}">
		                        You are not authorized to access this page.
		                    </c:when>
		                    <c:otherwise>
		                        ${error}
		                    </c:otherwise>
		                </c:choose>
		            </div>
		        </c:if>
		        
		        <c:if test="${not empty warning}">
		            <div class="alert alert-warning" role="alert">
		                ${warning}
		            </div>
		        </c:if>
                <!-- Social Login -->
                <div class="separator">Or continue with</div>
                <div class="social-login">
                    <button type="button" class="btn btn-outline-secondary">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button type="button" class="btn btn-outline-secondary">
                        <i class="fab fa-facebook"></i> Facebook
                    </button>
                </div>

                <!-- Registration Link -->
                <div class="text-center mt-4">
                    Don't have an account? <a href="register" class="text-decoration-none">Sign up</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
	    document.querySelectorAll('.role-option').forEach(el => {
	        el.addEventListener('click', () => {
	          // 1) write the clicked role into the hidden input
	          document.getElementById('role').value = el.dataset.role;
	          // 2) toggle "active" class
	          document.querySelectorAll('.role-option').forEach(o => o.classList.remove('active'));
	          el.classList.add('active');
	        });
	      });
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.textContent = 'visibility';
            } else {
                passwordField.type = 'password';
                toggleIcon.textContent = 'visibility_off';
            }
        }
    </script>
</body>
</html>