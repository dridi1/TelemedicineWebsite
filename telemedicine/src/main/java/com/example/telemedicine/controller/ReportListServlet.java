package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.PatientReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/doctor/report")
public class ReportListServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {
	    

	    String pid = req.getParameter("patientId");
	    if (pid == null) {
	        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing patientId");
	        return;
	    }
	    int patientId = Integer.parseInt(pid);

	    try {
	        List<PatientReport> reports = PatientReport.findByPatient(patientId);
	        req.setAttribute("reportList", reports);
	        req.getRequestDispatcher("/WEB-INF/views/dash/doctor/reportList.jsp")
	           .forward(req, resp);
	    } catch (SQLException e) {
	        throw new ServletException(e);
	    }
	}
}