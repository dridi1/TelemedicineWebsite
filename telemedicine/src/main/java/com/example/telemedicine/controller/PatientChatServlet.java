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
 * Handles patient's chat view: lists all doctor conversations and opens a selected one.
 * URL: /patient-chat?conversationId={id}&otherId={doctorId}
 */
@WebServlet("/patient/chat")
public class PatientChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ChatService chatService = new ChatService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        // 1. Identify patient
        Patient patient = (Patient) session.getAttribute("user");
        int patientId = patient.getId();

        // 2. Read params: conversationId (switch) or otherId (new)
        String convParam  = req.getParameter("conversationId");
        String otherParam = req.getParameter("otherId");
        Integer selectedConvId = null;

        try {
            // If conversationId passed, use it
            if (convParam != null) {
                try {
                    selectedConvId = Integer.valueOf(convParam);
                } catch (NumberFormatException ignored) {
                }
            }
            // else if otherId passed, find or create a new conversation
            else if (otherParam != null) {
                int doctorId = Integer.parseInt(otherParam);
                // search for existing
                for (Conversation c : chatService.getConversations(patientId)) {
                    if (c.getDoctorId() == doctorId) {
                        selectedConvId = c.getId();
                        break;
                    }
                }
                // none found: create
                if (selectedConvId == null) {
                    Conversation c = new Conversation();
                    c.setPatientId(patientId);
                    c.setDoctorId(doctorId);
                    selectedConvId = c.create();
                }
            }

            // 3. Load all conversations for this patient
            List<Conversation> conversations = chatService.getConversations(patientId);

            // 4. Determine active conversation: param or default to first
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
                selectedConvId = activeConv.getId();
            }

            // 5. Map each conversationId -> Doctor
            Map<Integer, Doctor> doctorMap = new HashMap<>();
            for (Conversation c : conversations) {
                Doctor doc = Doctor.findById(c.getDoctorId());
                doctorMap.put(c.getId(), doc);
            }

            // 6. Extract active doctor's name
            String doctorName = "";
            if (activeConv != null) {
                Doctor d = doctorMap.get(activeConv.getId());
                if (d != null) {
                    doctorName = d.getUsername();
                }
            }

            // 7. Pass allDoctors for modal listing
            List<Doctor> allDoctors = Doctor.findAllAvailable();
            req.setAttribute("allDoctors", allDoctors);

            // 8. Set attributes for JSP
            req.setAttribute("conversations",   conversations);
            req.setAttribute("conversationId",  selectedConvId);
            req.setAttribute("Id",              patientId);
            req.setAttribute("doctorName",      doctorName);
            req.setAttribute("doctorMap",       doctorMap);

            // 9. Forward to the patient-chat JSP
            RequestDispatcher rd = req.getRequestDispatcher(
                "/WEB-INF/views/dash/patient/chat.jsp"
            );
            rd.forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Unable to load patient conversations", e);
        }
    }
}
