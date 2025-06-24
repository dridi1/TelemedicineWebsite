package com.example.telemedicine.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.service.AppointmentService;
import com.example.telemedicine.service.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation for booking appointments, refactored to use AppointmentService
 */
@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        try {
        	
            Patient patient = (Patient) session.getAttribute("user");
            int patientId = patient.getId();
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            LocalDateTime appointmentDate = LocalDateTime.parse(request.getParameter("appointmentDate"));
            String symptoms = request.getParameter("symptoms");

            boolean booked = appointmentService.bookAppointment(patientId, doctorId, appointmentDate, symptoms);
            if (booked) {
            	 // send confirmation email
                String patientEmail = patient.getEmail();
                String patientName  = patient.getUsername();
                String doctorName   = Doctor.findById(doctorId).getUsername();
                // format LocalDateTime to a readable string
                String formattedDate = appointmentDate.format(DateTimeFormatter.ofPattern("EEEE, MMM d, yyyy 'at' h:mm a"));
                String link = request.getRequestURL().toString().replace("/book/appointment", "")
                               + "/patient/appointments"; // or a dedicated appointment detail URL

                try {
                    EmailService.sendAppointmentConfirmationEmail(
                        patientEmail, patientName, doctorName, formattedDate, link
                    );
                } catch (UnsupportedEncodingException ex) {
                    ex.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=booking");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=booking");
            }
        } catch (Exception e) {
            // log the exception
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=invalid");
        }
    }
}
