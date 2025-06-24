package com.example.telemedicine.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;

import com.example.telemedicine.model.PatientReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/doctor/report/download")
public class DownloadReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // **public no-arg constructor** (optional, compiler provides one by default)
    public DownloadReportServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        int reportId;
        try {
            reportId = Integer.parseInt(idParam);
        } catch (NumberFormatException | NullPointerException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report id");
            return;
        }

        try {
            PatientReport rpt = PatientReport.findById(reportId);
            if (rpt == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found");
                return;
            }

            String fmt = rpt.getFormat().toLowerCase();      // "pdf" or "html"
            byte[] data = rpt.getReportContent();            // raw bytes

            // set correct content type
            if ("pdf".equals(fmt)) {
                resp.setContentType("application/pdf");
            } else {
                resp.setContentType("text/html");
            }

            // build filename with timestamp
            String timestamp = rpt.getGeneratedAt()
                                  .format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmm"));
            String filename = String.format("report_%d_%s.%s", reportId, timestamp, fmt);

            resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            resp.setContentLength(data.length);

            resp.getOutputStream().write(data);
            resp.getOutputStream().flush();
        } catch (SQLException e) {
            throw new ServletException("Database error fetching report", e);
        }
    }
}
