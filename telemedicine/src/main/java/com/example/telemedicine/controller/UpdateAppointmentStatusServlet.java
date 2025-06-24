package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.example.telemedicine.model.Appointment.Status;
import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UpdateAppointmentStatusServlet
 */
@WebServlet("/update-status")
public class UpdateAppointmentStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        Doctor doctor = (Doctor)  session.getAttribute("user");

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String statusParam = request.getParameter("status");
            Status newStatus = Status.valueOf(statusParam.toUpperCase());

            boolean updated = appointmentService.updateStatusByDoctor(appointmentId, doctor.getId(), newStatus);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard?success=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=invalid_id");
        } catch (IllegalArgumentException e) {
            // invalid enum value for status
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=invalid_status");
        } catch (IllegalStateException e) {
            // not found or not authorized
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=unauthorized");
        } catch (SQLException e) {
            e.printStackTrace(); // use logger in production
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=server_error");
        }
    }
}
