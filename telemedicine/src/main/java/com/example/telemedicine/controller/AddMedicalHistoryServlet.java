package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.MedicalHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddMedicalHistoryServlet
 */
@WebServlet("/doctor/medical-history/add")
public class AddMedicalHistoryServlet extends HttpServlet {
  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	    throws ServletException, IOException {
	  String patientIdParam = req.getParameter("patientId");
	  if (patientIdParam != null) {
	    // make it available to your JSP as ${patientId}
	    req.setAttribute("patientId", Integer.parseInt(patientIdParam));
	  }
	  req.getRequestDispatcher("/WEB-INF/views/dash/patient/addMedicalHistory.jsp")
	     .forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	    throws ServletException, IOException {

	  Doctor doctor = (Doctor) req.getSession().getAttribute("user");
	  if (doctor == null) {
	    // not logged in or session expired
	    resp.sendRedirect(req.getContextPath() + "/login");
	    return;
	  }

	  // 1) Pull and validate visitDate
	  String visitDateParam = req.getParameter("visitDate");
	  if (visitDateParam == null || visitDateParam.isBlank()) {
	    req.setAttribute("error", "Visit date/time is required.");
	    // re‑expose patientId for the form
	    req.setAttribute("patientId", req.getParameter("patientId"));
	    req.getRequestDispatcher("/WEB-INF/views/dash/patient/addMedicalHistory.jsp")
	       .forward(req, resp);
	    return;
	  }

	  try {
	    MedicalHistory mh = new MedicalHistory();
	    mh.setDoctorId(doctor.getId());

	    // 2) Parse patientId
	    String pid = req.getParameter("patientId");
	    mh.setPatientId(Integer.parseInt(pid));

	    // 3) Now safely parse visitDate
	    LocalDateTime visitDate = LocalDateTime.parse(
	        visitDateParam,
	        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
	    );
	    mh.setVisitDate(visitDate);

	    // 4) The rest of your fields
	    mh.setChiefComplaint(req.getParameter("chiefComplaint"));
	    mh.setHpi(            req.getParameter("hpi"));
	    mh.setRos(            req.getParameter("ros"));
	    mh.setDiagnosis(      req.getParameter("diagnosis"));
	    mh.setIcdCode(        req.getParameter("icdCode"));
	    mh.setPrescription(   req.getParameter("prescription"));
	    mh.setPlan(           req.getParameter("plan"));
	    mh.setNotes(          req.getParameter("notes"));

	    // 5) Save and redirect
	    mh.save();
	    resp.sendRedirect(req.getContextPath() + "/doctor/dashboard?msg=historyAdded");

	  } catch (NumberFormatException nfe) {
	    throw new ServletException("Invalid patientId", nfe);
	  } catch (SQLException sqle) {
	    throw new ServletException(sqle);
	  }
	}

}
