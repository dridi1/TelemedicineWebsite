package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.example.telemedicine.model.Appointment;
import com.example.telemedicine.model.ChatMessage;
import com.example.telemedicine.model.Conversation;
import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.service.AppointmentService;
import com.example.telemedicine.service.ChatService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AppointmentService appointmentService = new AppointmentService();
    private final ChatService chatService             = new ChatService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Doctor doctor = (Doctor) session.getAttribute("user");
        int doctorId  = doctor.getId();

        try {
            // 1) Fetch all appointments for this doctor
            List<Appointment> allApts = appointmentService.getAppointmentsForDoctor(doctorId);

            // 2) Split into “today” vs “upcoming”
            LocalDate today = LocalDate.now();
            List<Appointment> todaySchedule = allApts.stream()
                .filter(a -> a.getAppointmentDate().toLocalDate().equals(today))
                .collect(Collectors.toList());
            List<Appointment> upcoming = allApts.stream()
                .filter(a -> a.getAppointmentDate().toLocalDate().isAfter(today))
                .collect(Collectors.toList());

            // 3) Quick‐Stats
            request.setAttribute("todayScheduleCount", todaySchedule.size());

            // 4) Expose lists for JSP
            request.setAttribute("todaySchedule", todaySchedule);
            request.setAttribute("appointments",   upcoming);

            // 5) Recent conversations & last message
            List<Conversation> convos = chatService.getConversationsForDoctor(doctorId);
            List<Map<String,Object>> recentChats = new ArrayList<>();

         // inside your doGet(), replacing the loop you had:
            for (Conversation convo : convos) {
                List<ChatMessage> msgs = chatService.getMessages(convo.getId());
                // find last patient‐sent message by scanning backwards
                ChatMessage lastPatientMsg = null;
                for (int i = msgs.size() - 1; i >= 0; i--) {
                    ChatMessage m = msgs.get(i);
                    if (m.getSenderId() == convo.getPatientId()) {
                        lastPatientMsg = m;
                        break;
                    }
                }
                if (lastPatientMsg == null) continue;

                Map<String,Object> chatInfo = new HashMap<>();
                chatInfo.put("patientName", Patient.findById(convo.getPatientId()).getUsername());        // assume you have this
                chatInfo.put("lastPatientMessage", lastPatientMsg.getContent());
                chatInfo.put("time", lastPatientMsg.getSentAt()
                                     .toLocalDateTime().toLocalTime().toString());
                chatInfo.put("id", lastPatientMsg.getConversationId());
                recentChats.add(chatInfo);
            }
            request.setAttribute("recentChats", recentChats);


            // 6) Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/dash/doctor/dashboard.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace(); // TODO: use a logger
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=fetch");
        }
    }
}
