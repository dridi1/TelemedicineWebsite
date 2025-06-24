package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

import com.example.telemedicine.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure that the session exists and that the user role is PATIENT
        HttpSession session = request.getSession(false);
        
        // Retrieve the patient object from session
        
        Patient patient = (Patient) session.getAttribute("user");
        
		// Set character encoding for proper handling of Unicode characters
		request.setCharacterEncoding("UTF-8");
		
		// Extract form parameters (assumes the form uses names: fullName, dateOfBirth, and gender)
		String username = request.getParameter("username");
		String dateOfBirthStr = request.getParameter("dateOfBirth"); // Expected format: yyyy-MM-dd
		String gender = request.getParameter("gender");
		
		// Convert the date string to a LocalDate
		LocalDate dateOfBirth = null;
		try {
		    dateOfBirth = LocalDate.parse(dateOfBirthStr);
		} catch (Exception e) {
		    // You might log the error or set a default/fallback date
		    e.printStackTrace();
		}
		
		// Update the patient object with the new values
		patient.setUsername(username);
		if (dateOfBirth != null) {
		    patient.setDateOfBirth(dateOfBirth);
		}
		patient.setGender(gender);
		
		// Use your DAO to update the patient in the database
		
		boolean updateSuccess;
		try {
			updateSuccess = patient.update();
			if (updateSuccess) {
			    session.setAttribute("patient", patient);
			    response.sendRedirect(request.getContextPath() + "/patient/profile?success=updated");
			} else {
			    response.sendRedirect(request.getContextPath() + "/patient/profile?error=update_failed");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// Redirect back to the profile page with a success or error message
		
        
    }
}
