<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
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
            max-width: 800px;
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
		  color: var(--btn-text-on-primary);
		}
	
        
        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #475569;
        }

        input, select {
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.1);
        }

        .read-only {
            background: #f8fafc;
            cursor: not-allowed;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
        }

        .alert-success {
            background: #dcfce7;
            color: #16a34a;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--secondary);
        }

        .full-width {
            grid-column: 1 / -1;
        }

        @media (max-width: 768px) {
            .dashboard {
                grid-template-columns: 1fr;
            }
            .main {
                padding: 1.5rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
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
                <h1>Profile Settings</h1>
                <button id="darkModeToggle" onclick="toggleDarkMode()">Toggle Dark Mode</button>
		          <div class="avatar">
		            <i class="fas fa-user"></i>
		          </div>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>

            <!-- Profile Form -->
            <div class="profile-card">
                <form action="${pageContext.request.contextPath}/update-profile" method="post">
                    <div class="form-grid">
                        <!-- Personal Information -->
                        <div class="full-width">
                            <h2 class="section-title">Personal Information</h2>
                        </div>

                        <div class="form-group full-width">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" 
                                   value="${patient.username}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" value="${patient.email}" 
                                   class="read-only" readonly>
                        </div>

                        <div class="form-group">
                            <label for="dateOfBirth">Date of Birth</label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth"
                                   value="${patient.dateOfBirth}" 
                                   max="<%= java.time.LocalDate.now().minusYears(18) %>" required>
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male" ${patient.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${patient.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>

                        <!-- Security Section -->
                        <div class="full-width">
                            <h2 class="section-title">Security</h2>
                        </div>

                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword">
                        </div>

                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary full-width">
                        Save Changes
                    </button>
                </form>
            </div>
        </main>
    </div>
	<script src="${pageContext.request.contextPath}/assets/js/dash/navbar.js"></script>
    <script>
		 // Dark Mode Toggling
		    function toggleDarkMode() {
		      document.body.classList.toggle('dark-mode');
		    }

        // Add basic form validation
        document.querySelector('form').addEventListener('submit', (e) => {
            const newPassword = document.getElementById('newPassword').value;
            const currentPassword = document.getElementById('currentPassword').value;

            if ((newPassword && !currentPassword) || (!newPassword && currentPassword)) {
                e.preventDefault();
                alert('Both password fields must be filled to change password');
            }
        });
        
    </script>
</body>
</html>