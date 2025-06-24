package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.example.telemedicine.model.Patient;
import com.example.telemedicine.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class CancelAppointmentServlet
 */
@WebServlet("/cancel-appointment")
public class CancelAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            Patient patient = (Patient) session.getAttribute("user");
            int patientId = patient.getId();

            boolean cancelled = appointmentService.cancelAppointment(appointmentId, patientId);
            if (cancelled) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=cancel_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=invalid_id");
        } catch (IllegalStateException e) {
            // handles not found or unauthorized
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=unauthorized");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=server_error");
        }
    }
}
