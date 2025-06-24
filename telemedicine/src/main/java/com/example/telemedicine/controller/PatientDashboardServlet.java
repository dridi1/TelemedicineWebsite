package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;



@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	// Get existing session (don't create new one if it doesn't exist)
        HttpSession session = request.getSession(false);
        
		
		Patient patient = (Patient) session.getAttribute("user");
		
		request.setAttribute("patient", patient);
		
		// Get list of doctors
		List<Doctor> doctors;
		try {
			doctors = Doctor.findAllDoctors();
			int doctorsCount = Doctor.getAvailableDoctorsCount();
			request.setAttribute("doctors", doctors);
			request.setAttribute("doctorsCount", doctorsCount);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		
		
		// Set data as request attribute
		
		
		// Forward to JSP
		request.getRequestDispatcher("/WEB-INF/views/dash/patient/dashboard.jsp")
		       .forward(request, response);
    }
}