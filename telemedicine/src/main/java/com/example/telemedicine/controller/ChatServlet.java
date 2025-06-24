package com.example.telemedicine.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;

import com.example.telemedicine.service.ChatbotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chat-ui")
public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ChatbotService svc = new ChatbotService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/testChat.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
        // 1) Parse incoming JSON
        JsonObject inputJson;
        try (JsonReader jr = Json.createReader(req.getReader())) {
            inputJson = jr.readObject();
        }

        // 2) Extract the user's message
        String userText = inputJson.getString("message", null);
        if (userText == null || userText.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No message provided");
            return;
        }

        // 3) Call the formatted‑endpoint service
        String formattedReply;
        try {
            formattedReply = svc.predictFormatted(userText);
        } catch (Exception e) {
            throw new ServletException("AI service error", e);
        }

        // 4) Send back JSON: { "reply": "..." }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            JsonObject jsonResp = Json.createObjectBuilder()
                                      .add("reply", formattedReply)
                                      .build();
            out.print(jsonResp.toString());
        }
    }

    // Support CORS for AJAX
    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin",  req.getHeader("Origin"));
        resp.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}
