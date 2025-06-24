/*package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.Appointment;
import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/doctor-appointments")
public class DoctorAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        Doctor doctor = (Doctor) session.getAttribute("user");

        try {
            List<Appointment> appointments = appointmentService.getAppointmentsForDoctor(doctor.getDoctor_id());
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/WEB-INF/views/dash/doctor-dashboard.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace(); // replace with a real logger in production
            response.sendRedirect(request.getContextPath() + "/doctor-dashboard?error=fetch");
        }
    }
}
*/