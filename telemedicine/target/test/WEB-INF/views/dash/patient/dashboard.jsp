<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDateTime,java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Patient Dashboard</title>
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <!-- DataTables CSS for enhanced tables -->
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
  
  <style>	/* Dark Mode Overrides */

	
	.dashboard {
	  display: grid;
	  grid-template-columns: 240px 1fr;
	  min-height: 100vh;
	}
	
	.main {
	  padding: 2rem;
	  max-width: 1700px;
	  margin: 0 auto;
	  width: 100%;
	}
	
	.header {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  margin-bottom: 2rem;
	}
	
	.header h1 {
	  font-size: 1.75rem;
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
	
	/* Dark Mode Toggle Button */
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
	
	/* Cards & Panels */
	.stats-card,
	.doctor-card,
	.no-doctors,
	.modal-content {
	  background: var(--surface);
	  border-radius: 1rem;
	  box-shadow: var(--shadow);
	}
	
	.stats-card {
	  padding: 1.5rem;
	  margin-bottom: 2rem;
	}
	
	.filters-container {
	  display: grid;
	  grid-template-columns: 1fr 200px;
	  gap: 1.5rem;
	  margin-bottom: 2rem;
	}
	
	/* Forms & Filters */
	.search-input,
	.specialization-filter,
	.form-input,
	textarea {
	  width: 100%;
	  padding: 0.75rem;
	  border: 1px solid var(--border);
	  border-radius: 0.5rem;
	  font-size: 1rem;
	  background: var(--muted);
	  color: var(--text);
	  transition: border-color 0.2s;
	}
	
	.specialization-filter {
	  /* dropdown arrow stays SVG */
	  background-image: url('data:image/svg+xml;charset=UTF-8,<svg width="16" height="16" xmlns="http://www.w3.org/2000/svg"><path fill="%2364784b" d="M4 6l4 4 4-4z"/></svg>');
	  background-repeat: no-repeat;
	  background-position: right 0.75rem center;
	  background-size: 16px;
	}
	
	.form-input:focus,
	textarea:focus {
	  outline: none;
	  border-color: var(--primary);
	  box-shadow: 0 0 0 2px rgba(37,99,235,0.1);
	}
	
	/* Doctor List */
	.doctors-list {
	  display: grid;
	  gap: 1rem;
	}
	
	.doctor-card {
	  overflow: hidden;
	  transition: all 0.2s ease;
	}
	
	.doctor-card:hover {
	  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
	  transform: translateY(-2px);
	}
	
	.doctor-card-content {
	  padding: 1.5rem;
	}
	
	.doctor-header {
	  display: flex;
	  gap: 1rem;
	  margin-bottom: 1.25rem;
	}
	
	.doctor-avatar {
	  width: 60px;
	  height: 60px;
	  border-radius: 50%;
	  background: var(--primary);
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  color: var(--btn-text-on-primary);
	  flex-shrink: 0;
	}
	
	.doctor-name {
	  font-size: 1.25rem;
	  font-weight: 600;
	  margin-bottom: 0.25rem;
	}
	
	.doctor-specialization {
	  color: var(--text-secondary);
	  font-size: 0.95rem;
	}
	
	.doctor-details {
	  display: grid;
	  grid-template-columns: repeat(2, 1fr);
	  gap: 1rem;
	  margin-bottom: 1.5rem;
	}
	
	@media (min-width: 768px) {
	  .doctor-details {
	    grid-template-columns: repeat(4, 1fr);
	  }
	
	  .doctor-card-content {
	    display: grid;
	    grid-template-columns: 1fr auto;
	    align-items: start;
	    gap: 1.5rem;
	  }
	}
	
	/* Detail Items */
	.detail-item {
	  display: flex;
	  flex-direction: column;
	  gap: 0.25rem;
	}
	
	.detail-label {
	  font-size: 0.875rem;
	  color: var(--text-secondary);
	}
	
	.detail-value {
	  font-weight: 500;
	}
	
	/* Ratings */
	.rating-display {
	  display: flex;
	  align-items: center;
	  gap: 0.25rem;
	}
	
	.rating-star {
	  color: #f59e0b;
	}
	
	.reviews-count {
	  font-size: 0.875rem;
	  color: var(--text-secondary);
	}
	
	/* Actions */
	.doctor-actions {
	  display: flex;
	  gap: 0.75rem;
	  flex-wrap: wrap;
	}
	
	@media (min-width: 768px) {
	  .doctor-actions {
	    flex-direction: column;
	  }
	}
	
	/* Availability Badge */
	.availability-badge {
	  padding: 0.25rem 0.75rem;
	  border-radius: 1rem;
	  font-size: 0.875rem;
	  font-weight: 500;
	  display: inline-block;
	}
	
	.available {
	  background: #dcfce7;
	  color: #166534;
	}
	
	.not-available {
	  background: #fee2e2;
	  color: #991b1b;
	}
	
	/* Buttons */
	.book-btn,
	.profile-btn,
	.btn-secondary,
	.confirm-btn {
	  padding: 0.5rem 1rem;
	  border-radius: 0.5rem;
	  font-weight: 500;
	  cursor: pointer;
	  transition: all 0.2s ease;
	  text-align: center;
	  min-width: 120px;
	}
	
	.book-btn {
	  background: var(--primary);
	  color: var(--btn-text-on-primary);
	  border: none;
	}
	
	.book-btn:hover:not(:disabled) {
	  background: var(--secondary);
	  transform: translateY(-1px);
	}
	
	.book-btn:disabled {
	  background: var(--surface) !important;
	  color: var(--text-secondary) !important;
	  cursor: not-allowed;
	  transform: none !important;
	}
	
	.profile-btn {
	  background: var(--surface);
	  color: var(--primary);
	  border: 1px solid var(--primary);
	  text-decoration: none;
	}
	
	.profile-btn:hover {
	  background: var(--muted);
	}
	
	.btn-secondary {
	  background: var(--muted);
	  color: var(--text);
	  padding: 0.75rem 1.5rem;
	  border: none;
	}
	
	.btn-secondary:hover {
	  background: var(--surface);
	}
	
	.confirm-btn {
	  background: var(--primary);
	  color: var(--btn-text-on-primary);
	  border: none;
	  padding: 0.75rem 1.5rem;
	  display: inline-flex;
	  align-items: center;
	  gap: 0.5rem;
	}
	
	.confirm-btn:hover {
	  background: var(--secondary);
	  transform: translateY(-1px);
	}
	
	.confirm-btn:active {
	  transform: translateY(0);
	}
	
	/* No Doctors Message */
	.no-doctors {
	  text-align: center;
	  padding: 3rem;
	  background: var(--surface);
	  border-radius: 1rem;
	  color: var(--text-secondary);
	}
	
	.no-doctors i {
	  font-size: 2.5rem;
	  margin-bottom: 1rem;
	  display: block;
	}
	
	/* Pagination */
	#paginationControls {
	  margin-top: 1.5rem;
	  text-align: center;
	}
	
	.pagination-btn {
	  padding: 0.5rem 0.75rem;
	  margin: 0 0.25rem;
	  border: 1px solid var(--border);
	  background: var(--surface);
	  color: var(--text);
	  border-radius: 0.25rem;
	  cursor: pointer;
	}
	
	.pagination-btn.active {
	  background: var(--primary);
	  color: var(--btn-text-on-primary);
	  border-color: var(--primary);
	}
	
	/* Modal Styles */
	.modal {
	  display: none;
	  position: fixed;
	  top: 0;
	  left: 0;
	  width: 100%;
	  height: 100%;
	  background: rgba(0,0,0,0.8);
	  z-index: 1000;
	  backdrop-filter: blur(4px);
	  animation: modalFadeIn 0.3s ease;
	}
	
	.modal.active {
	  display: block;
	}
	
	.modal-content {
	  background: var(--surface);
	  margin: 2rem auto;
	  padding: 2rem;
	  width: 90%;
	  max-width: 500px;
	  border-radius: 1rem;
	  box-shadow: var(--shadow);
	  position: relative;
	  transform: translateY(-50px);
	  opacity: 0;
	  animation: modalSlideIn 0.3s ease forwards;
	}
	
	.modal-header {
	  margin-bottom: 1.5rem;
	  padding-bottom: 1rem;
	  border-bottom: 1px solid var(--border);
	}
	
	.modal-title {
	  font-size: 1.5rem;
	  color: var(--primary);
	  margin: 0;
	}
	
	.close {
	  position: absolute;
	  right: 1.5rem;
	  top: 1.5rem;
	  font-size: 1.5rem;
	  color: var(--text);
	  cursor: pointer;
	  transition: color 0.2s;
	}
	
	.close:hover {
	  color: var(--primary);
	}
	
	/* Form Actions */
	.form-actions {
	  display: flex;
	  gap: 1rem;
	  justify-content: flex-end;
	  margin-top: 2rem;
	}
	
	/* Animations */
	@keyframes modalSlideIn {
	  to {
	    transform: translateY(0);
	    opacity: 1;
	  }
	}
	
	@keyframes modalFadeIn {
	  from {
	    backdrop-filter: blur(0);
	  }
	  to {
	    backdrop-filter: blur(4px);
	  }
	}
	
	/* Responsive Adjustments */
	@media (max-width: 768px) {
	  .dashboard {
	    grid-template-columns: 1fr;
	  }
	
	  .main {
	    padding: 1.5rem;
	  }
	
	  .filters-container {
	    grid-template-columns: 1fr;
	  }
	
	  .doctor-card-content {
	    display: block;
	  }
	
	  .doctor-actions {
	    flex-direction: row;
	    margin-top: 1rem;
	  }
	}

  </style>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dash/navbar.css">
</head>
<body>
  <div class="dashboard">
  <jsp:include page="/WEB-INF/views/components/navbar.jsp" flush="true" />	
    <!-- Main Content Area -->
    <main class="main">
      <div class="header">
        <div>
          <h1>Welcome, ${patient.username}</h1>
          <p>Hope you're doing well</p>
        </div>
        <div style="display: flex; align-items: center;">
          <!-- Dark Mode Toggle Button -->
          <button id="darkModeToggle" onclick="toggleDarkMode()">Toggle Dark Mode</button>
          <div class="avatar">
            <i class="fas fa-user"></i>
          </div>
        </div>
      </div>
		
      <!-- Stats Card -->
      <div class="stats-card">
        <h3>Available Doctors: ${doctorsCount}</h3>
        <p>Specialists ready for consultation</p>
      </div>

      <!-- Alert Messages -->
      <c:if test="${not empty param.success}">
        <div class="alert alert-success">
          Appointment booked successfully! 
          <a href="${pageContext.request.contextPath}/patient/appointments">View Appointments</a>
        </div>
      </c:if>
      <c:if test="${not empty param.error}">
        <div class="alert alert-error">
          ${param.error == 'invalid_date' ? 'Please select a future date/time' : 
            param.error == 'conflict' ? 'Time slot already booked' : 
            'Error booking appointment. Please try again.'}
        </div>
      </c:if>

      <!-- Filters Section -->
      <div class="filters-container">
        <input type="text" class="search-input" placeholder="Search doctors..." id="searchInput">
        <select class="specialization-filter" id="specializationFilter">
          <option value="">All Specializations</option>
        </select>
      </div>

      <!-- Doctors List -->
      <div class="doctors-list" id="doctorsList">
        <c:choose>
          <c:when test="${not empty doctors}">
            <c:forEach var="doctor" items="${doctors}">
              <div class="doctor-card" data-doctor-id="${doctor.id}">
                <div class="doctor-card-content">
                  <div class="doctor-info">
                    <div class="doctor-header">
                      <div class="doctor-avatar">
                        <i class="fas fa-user-md"></i>
                      </div>
                      <div>
                        <h3 class="doctor-name">${doctor.username}</h3>
                        <p class="doctor-specialization">${doctor.specialization}</p>
                      </div>
                    </div>
                    <div class="doctor-details">
                      <div class="detail-item">
                        <span class="detail-label">Rating</span>
                        <div class="detail-value rating-display">
                          <fmt:formatNumber value="${doctor.rating}" type="number" pattern="0.0"/>
                          <i class="fas fa-star rating-star"></i>
                          <span class="reviews-count">(${doctor.reviewsCount})</span>
                        </div>
                      </div>
                      <div class="detail-item">
                        <span class="detail-label">Experience</span>
                        <span class="detail-value">${doctor.yearsOfExperience} years</span>
                      </div>
                      <div class="detail-item">
                        <span class="detail-label">Fee</span>
                        <span class="detail-value">
                          <fmt:formatNumber value="${doctor.consultationFee}" type="number" pattern="0.00"/>
                        </span>
                      </div>
                      <div class="detail-item">
                        <span class="detail-label">Status</span>
                        <span class="availability-badge ${doctor.available ? 'available' : 'not-available'}">
                          ${doctor.available ? 'Available Now' : 'Offline'}
                        </span>
                      </div>
                    </div>
                  </div>
                  <div class="doctor-actions">
                    <button class="book-btn" ${doctor.available ? '' : 'disabled'}>
                      Book Appointment
                    </button>
                    <a href="${pageContext.request.contextPath}/doctor/profile?id=${doctor.id}" 
                       class="profile-btn">
                      View Profile
                    </a>
                  </div>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="no-doctors">
              <i class="fas fa-search"></i>
              <p>No doctors available matching your criteria</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Pagination Controls -->
      <div id="paginationControls"></div>
    </main>
  </div>

  <!-- Booking Modal -->
  <div id="bookingModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal()">&times;</span>
      <div class="modal-header">
        <h3 class="modal-title">Book Appointment</h3>
      </div>
      <form action="${pageContext.request.contextPath}/book-appointment" method="POST">
        <input type="hidden" id="modalDoctorId" name="doctorId">
        <div class="form-group">
          <label class="form-label" for="appointmentDate">Date & Time</label>
          <input type="datetime-local" id="appointmentDate" name="appointmentDate" class="form-input" required 
                 min="<%= LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) %>">
        </div>
        <div class="form-group">
          <label class="form-label" for="symptoms">Symptoms</label>
          <textarea name="symptoms" id="symptoms" rows="4" class="form-input" placeholder="Describe your symptoms..." required></textarea>
        </div>
        <div class="form-actions">
          <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
          <button type="submit" class="confirm-btn">Confirm Booking</button>
        </div>
      </form>
    </div>
  </div>

  <!-- jQuery and DataTables Scripts -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/dash/navbar.js"></script>
  <script>
    // Dark Mode Toggling
    function toggleDarkMode() {
      document.body.classList.toggle('dark-mode');
    }

    $(document).ready(function() {
      // Filter and Pagination Setup
      var doctors = document.querySelectorAll('.doctor-card');
      
      // Populate specialization filter dynamically
      var specializations = new Set();
      doctors.forEach(function(doctor) {
        var spec = doctor.querySelector('.doctor-specialization').textContent.trim();
        if (spec !== "") {
          specializations.add(spec);
        }
      });
      
      specializations.forEach(function(spec) {
        $('#specializationFilter').append('<option value="'+ spec +'">'+ spec +'</option>');
      });
      
      // Filtering functionality
      function filterDoctors() {
        var searchTerm = $('#searchInput').val().toLowerCase();
        var specialization = $('#specializationFilter').val();
        
        doctors.forEach(function(doctor) {
          var doctorName = doctor.querySelector('.doctor-name').textContent.toLowerCase();
          var doctorSpec = doctor.querySelector('.doctor-specialization').textContent;
          var matchesSearch = doctorName.includes(searchTerm);
          var matchesSpecialization = specialization === "" || doctorSpec === specialization;
          
          doctor.style.display = matchesSearch && matchesSpecialization ? '' : 'none';
        });
        updatePagination();
      }
      
      $('#searchInput, #specializationFilter').on('keyup change', filterDoctors);
      updatePagination();
    });
    
    // Pagination code
    const itemsPerPage = 3;
    let currentPage = 1;
    
    function updatePagination() {
      const filteredCards = Array.from(document.querySelectorAll('.doctor-card'))
                                .filter(card => card.style.display !== 'none');
      const paginationContainer = document.getElementById('paginationControls');
      const existingNoResults = document.querySelector('.no-doctors-filtered');
      if(existingNoResults) {
          existingNoResults.remove();
      }
      if(filteredCards.length === 0) {
          paginationContainer.innerHTML = '';
          return;
      }
      const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
      paginationContainer.innerHTML = '';
      if(currentPage > totalPages){
          currentPage = 1;
      }
      for(let i = 1; i <= totalPages; i++){
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.className = 'pagination-btn';
        if(i === currentPage) {
          btn.classList.add('active');
        }
        btn.addEventListener('click', function(){
          currentPage = i;
          showPage(filteredCards, currentPage);
          document.querySelectorAll('.pagination-btn').forEach(function(b){
            b.classList.remove('active');
          });
          btn.classList.add('active');
        });
        paginationContainer.appendChild(btn);
      }
      showPage(filteredCards, currentPage);
    }
    
    function showPage(items, page) {
      items.forEach(item => item.style.display = 'none');
      const start = (page - 1) * itemsPerPage;
      const end = start + itemsPerPage;
      items.slice(start, end).forEach(item => item.style.display = '');
    }
    
    // Modal functionality
    function openModal(doctorId) {
      const modal = document.getElementById('bookingModal');
      document.getElementById('modalDoctorId').value = doctorId;
      modal.style.display = 'block';
      document.body.classList.add('modal-open');
      modal.classList.add('active');
    }
    
    function closeModal() {
      const modal = document.getElementById('bookingModal');
      modal.style.display = 'none';
      document.body.classList.remove('modal-open');
      modal.classList.remove('active');
    }
    
    // Event delegation for booking buttons
    document.addEventListener('click', function(e) {
      if (e.target.closest('.book-btn')) {
        e.preventDefault();
        const card = e.target.closest('.doctor-card');
        const doctorId = card.dataset.doctorId;
        if (doctorId) {
          openModal(doctorId);
        }
      }
    });
    
    window.addEventListener('click', function(event) {
      const modal = document.getElementById('bookingModal');
      if (event.target === modal || event.target.classList.contains('close')) {
        closeModal();
      }
    });
    
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape' && document.body.classList.contains('modal-open')) {
        closeModal();
      }
    });
  </script>
</body>
</html>
