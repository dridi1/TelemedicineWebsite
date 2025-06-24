package com.example.telemedicine.controller;


import java.io.IOException;

import com.example.telemedicine.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/profile")
public class PatientProfileServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        //Integer userId = (Integer) session.getAttribute("userId");
        Patient patient = (Patient) session.getAttribute("user");
        System.out.println(patient);
		if (patient == null) {
		    session.setAttribute("errorMessage", "User profile not found");
		    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
		    return;
		}
		
		//request.setAttribute("user", user);
		request.setAttribute("patient", patient);
		request.getRequestDispatcher("/WEB-INF/views/dash/patient/profile.jsp").forward(request, response);
    }
}
