package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.Appointment;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private AppointmentService appointmentService = new AppointmentService();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		Patient patient = (Patient) session.getAttribute("user");
		System.out.println(patient);
		try {
			List<Appointment> appointments = appointmentService.getAppointmentsForPatient(patient.getId());
			request.setAttribute("appointments", appointments);
			request.getRequestDispatcher("/WEB-INF/views/dash/patient/appointments.jsp").forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace(); // consider using a logger
			// on error, you can redirect or set an error attribute and forward
			response.sendRedirect(request.getContextPath() + "/patient/dashboard?error=fetch");
		}
	}
}
