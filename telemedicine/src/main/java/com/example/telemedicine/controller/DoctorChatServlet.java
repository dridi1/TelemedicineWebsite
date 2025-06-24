package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.telemedicine.model.Conversation;
import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.service.ChatService;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles doctor's chat view: lists all patient conversations and opens a selected one.
 * URL: /doctor-chat?conversationId={id}
 */
@WebServlet("/doctor/chat")
public class DoctorChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ChatService chatService = new ChatService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        int userId = (Integer) session.getAttribute("userId");
        Doctor doctor;
		try {
			doctor = Doctor.findById(userId);
		
        String convParam = req.getParameter("conversationId");
        Integer selectedConvId = null;
        if (convParam != null) {
            try {
                selectedConvId = Integer.valueOf(convParam);
            } catch (NumberFormatException e) {
                // ignore invalid param
            }
        }

        try {
            // Load all conversations for this doctor
            List<Conversation> conversations = chatService.getConversations(doctor.getId());
            // Determine active conversation: parameter or first in list
            Conversation activeConv = null;
            if (selectedConvId != null) {
                for (Conversation c : conversations) {
                    if (c.getId() == selectedConvId) {
                        activeConv = c;
                        break;
                    }
                }
            }
            if (activeConv == null && !conversations.isEmpty()) {
                activeConv = conversations.get(0);
            }

            // If no conversation exists, you might redirect or show empty state
            String patientName = "";
            Integer convId = null;
            if (activeConv != null) {
                convId = activeConv.getId();
                int patientId = activeConv.getPatientId();
                Patient pat = Patient.findById(patientId);
                if (pat != null) {
                    patientName = pat.getUsername();
                }
            }
            Map<Integer, Patient> patientMap = new HashMap<>();
            for (Conversation c : conversations) {
                Patient p = Patient.findById(c.getPatientId());
                patientMap.put(c.getId(), p);
            }

            // Set JSP attributes
            req.setAttribute("conversations", conversations);
            req.setAttribute("conversationId", convId);
            req.setAttribute("Id", doctor.getId());
            req.setAttribute("patientName", patientName);
            req.setAttribute("patientMap",       patientMap);

            // Forward to JSP
            RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/dash/doctor/chat.jsp");
            rd.forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Unable to load doctor conversations", e);
        }
        
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}    
    }
}
