package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.MedicalHistory;
import com.example.telemedicine.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MedicalHistoryServlet
 */
@WebServlet("/patient/medical-history")
public class MedicalHistoryServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User)req.getSession().getAttribute("user");
        List<MedicalHistory> histories;
        System.out.println("history");
		try {
			histories = MedicalHistory.findByPatient(user.getId());
			req.setAttribute("historyList", histories);
	        req.getRequestDispatcher("/WEB-INF/views/dash/patient/medicalHistoryList.jsp")
	           .forward(req, resp);
		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
    }
}