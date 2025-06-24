package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.example.telemedicine.model.MedicalHistory;
import com.example.telemedicine.model.PatientReport;
import com.example.telemedicine.model.ReportHistoryLink;
import com.example.telemedicine.model.User;
import com.example.telemedicine.util.ReportGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/doctor/report/generate")
public class GenerateReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Ensure only logged‑in doctors can generate reports
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=not_authenticated");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }

        // 2) Parse patientId
        String pidStr = req.getParameter("patientId");
        int patientId;
        try {
            patientId = Integer.parseInt(pidStr);
        } catch (NumberFormatException | NullPointerException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing patientId");
            return;
        }

        // 3) Parse selected historyIds
        String[] historyIdsArr = req.getParameterValues("historyIds");
        if (historyIdsArr == null || historyIdsArr.length == 0) {
            // No visits selected—redirect back with an error message
            resp.sendRedirect(req.getContextPath()
                + "/doctor/report/form?patientId=" + patientId
                + "&error=noVisits");
            return;
        }
        List<Integer> historyIds;
        try {
            historyIds = Arrays.stream(historyIdsArr)
                               .map(Integer::parseInt)
                               .collect(Collectors.toList());
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid history selection");
            return;
        }

        // 4) Parse format
        String format = req.getParameter("format");
        if (format == null ||
            !(format.equalsIgnoreCase("PDF") || format.equalsIgnoreCase("HTML"))) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format");
            return;
        }

        try {
            // 5) Generate raw content
            byte[] data = ReportGenerator.generate(patientId, historyIds, format);

            // 6) Save in DB
            PatientReport rpt = new PatientReport();
            rpt.setPatientId(patientId);
            rpt.setGeneratedBy(user.getId());
            rpt.setGeneratedAt(LocalDateTime.now());
            rpt.setFormat(format.toUpperCase());
            rpt.setReportContent(data);
            rpt.save();

            // 7) Link each history entry
            int reportId = rpt.getId();
            for (int hid : historyIds) {
                ReportHistoryLink.link(reportId, hid);
            }

            // 8) Redirect to report list
            resp.sendRedirect(req.getContextPath()
                + "/doctor/report?patientId=" + patientId
                + "&success=generated");

        } catch (SQLException e) {
            throw new ServletException("Database error generating report", e);
        } catch (Exception e) {
            throw new ServletException("Unexpected error generating report", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Only doctors
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }

        // Show form
        String pid = req.getParameter("patientId");
        if (pid == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing patientId");
            return;
        }
        try {
            int patientId = Integer.parseInt(pid);
            List<MedicalHistory> historyList = MedicalHistory.findByPatient(patientId);
            req.setAttribute("historyList", historyList);
            req.setAttribute("patientId", patientId);
            req.getRequestDispatcher("/WEB-INF/views/dash/doctor/generateReportForm.jsp")
               .forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patientId");
        } catch (SQLException e) {
            throw new ServletException("Unable to load patient history", e);
        }
    }
}