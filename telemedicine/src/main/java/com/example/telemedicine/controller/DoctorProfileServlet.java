package com.example.telemedicine.controller;

import java.io.IOException;

import com.example.telemedicine.model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/doctor/profile")
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get doctor ID from request parameters
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing doctor ID");
                return;
            }

            int doctorId = Integer.parseInt(idParam);
            
            // Fetch doctor from database
            Doctor doctor = Doctor.findById(doctorId);
            System.out.println(doctor);
            
            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found");
                return;
            }
            
            // Set doctor in request attributes
            request.setAttribute("doctor", doctor);
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/dash/doctor/profile.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving doctor details");
            e.printStackTrace(); // Consider using a logger instead
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}