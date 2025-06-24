<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - Virtual Health Companion</title>
  
  <!-- Dependencies -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  
  <style><%@include file="/assets/css/auth/global-auth.css"%></style>
  <style><%@include file="/assets/css/auth/signup.css"%></style>
    
  
  <!-- Lottie Player for animated illustration -->
  <script src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs" type="module"></script>
</head>
<body>
  <div class="auth-card">
    <a href="home" class="btn back-home-btn">
      <i class="material-icons">arrow_back</i> Home
    </a>
    
    <div class="auth-form">
      <h2>Create Account</h2>
      <p>Sign up to join Virtual Health Companion</p>

      <!-- Error Message -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
          ${error}
        </div>
      </c:if>

      <!-- Role Selection -->
      <div class="row mb-4">
        <div class="col-md-6">
          <div class="role-card" onclick="selectRole('PATIENT')" id="patientCard">
            <div class="text-center">
              <i class="material-icons role-icon text-primary">personal_injury</i>
              <h5>Patient</h5>
              <p class="text-muted">Register as a patient</p>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="role-card" onclick="selectRole('DOCTOR')" id="doctorCard">
            <div class="text-center">
              <i class="material-icons role-icon text-success">medical_services</i>
              <h5>Doctor</h5>
              <p class="text-muted">Register as a healthcare provider</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Form Container (Hidden by Default) -->
      <div id="formContainer" style="display: none;">
        <form action="register" method="POST">
          <input type="hidden" name="role" id="selectedRole" value="" required>

          <!-- Common Fields -->
          <div class="row mb-3">
            <div class="col">
              <input type="text" class="form-control" name="firstName" placeholder="First name" required>
            </div>
            <div class="col">
              <input type="text" class="form-control" name="lastName" placeholder="Last name" required>
            </div>
          </div>

          <div class="mb-3">
            <input type="email" class="form-control" name="email" placeholder="Email address" required>
          </div>

          <div class="mb-3">
            <input type="password" class="form-control" name="password" placeholder="Password" required>
          </div>

          <!-- Dynamic Fields -->
          <div class="dynamic-fields" id="patientFields" style="display: none;">
            <div class="row mb-3">
              <div class="col">
                <label>Date of Birth</label>
                <input type="date" class="form-control" name="dob">
              </div>
              <div class="col">
                <label>Gender</label>
                <select class="form-select" name="gender">
                  <option value="MALE">Male</option>
                  <option value="FEMALE">Female</option>
                  <option value="OTHER">Other</option>
                </select>
              </div>
            </div>
          </div>

          <div class="dynamic-fields" id="doctorFields" style="display: none;">
			  <div class="row mb-3">
			    <div class="col">
			      <label>License Number</label>
			      <input type="text" class="form-control" name="license">
			    </div>
			    <div class="col">
			      <label>Specialization</label>
			      <input type="text" class="form-control" name="specialization">
			    </div>
			  </div>
			  <div class="row mb-3">
			    <div class="col">
			      <label>Consultation Fee</label>
			      <input type="number" step="0.01" class="form-control" name="consultationFee" placeholder="e.g., 50.00">
			    </div>
			    <div class="col">
			      <label>Years of Experience</label>
			      <input type="number" class="form-control" name="yearsOfExperience" placeholder="e.g., 10">
			    </div>
			  </div>
			  <div class="row mb-3">
			    <div class="col">
			      <label>Special Notes/Highlights</label>
			      <textarea class="form-control" name="specialNotes" rows="2" placeholder="Languages, achievements, etc."></textarea>
			    </div>
			  </div>
			</div>


          <button type="submit" class="btn btn-primary w-100 mb-3">Sign Up</button>
          
          <div class="text-center mt-4">
            Already have an account? <a href="login" class="text-decoration-none">Sign in</a>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function selectRole(role) {
      // Show the form container
      document.getElementById('formContainer').style.display = 'block';
      
      // Update the selected role
      document.getElementById('selectedRole').value = role;
      
      // Update card styles
      document.querySelectorAll('.role-card').forEach(card => {
        card.classList.remove('active');
      });
      document.getElementById(role.toLowerCase() + 'Card').classList.add('active');
      
      // Show/hide role-specific fields
      document.getElementById('patientFields').style.display = 
        role === 'PATIENT' ? 'block' : 'none';
      document.getElementById('doctorFields').style.display = 
        role === 'DOCTOR' ? 'block' : 'none';
      
      // Toggle required attributes
      toggleRequiredFields(role);
    }

    function toggleRequiredFields(role) {
      const patientFields = document.querySelectorAll('#patientFields input, #patientFields select');
      const doctorFields = document.querySelectorAll('#doctorFields input');
      
      patientFields.forEach(field => field.required = role === 'PATIENT');
      doctorFields.forEach(field => field.required = role === 'DOCTOR');
    }

    // Initialize by hiding all fields
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('formContainer').style.display = 'none';
      document.getElementById('patientFields').style.display = 'none';
      document.getElementById('doctorFields').style.display = 'none';
    });
  </script>
</body>
</html>