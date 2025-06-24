package com.example.telemedicine.controller;

import com.example.telemedicine.model.ChatMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Returns JSON array of ChatMessage history for a given conversation.
 * Example: GET /messages?conversationId=2
 */
@WebServlet("/messages")
public class MessagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String convParam = req.getParameter("conversationId");
        if (convParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing conversationId");
            return;
        }

        int convId;
        try {
            convId = Integer.parseInt(convParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid conversationId");
            return;
        }

        try {
            // Load messages (oldest first)
            List<ChatMessage> history = ChatMessage.getMessages(convId);

            // Build JSON array
            JSONArray arr = new JSONArray();
            for (ChatMessage m : history) {
                JSONObject o = new JSONObject();
                o.put("id",            m.getId());
                o.put("conversationId", m.getConversationId());
                o.put("senderId",      m.getSenderId());
                o.put("content",       m.getContent());
                o.put("sentAt",        m.getSentAt().toInstant().toString());
                arr.put(o);
            }

            resp.setContentType("application/json");
            resp.getWriter().write(arr.toString());
        } catch (SQLException e) {
            throw new ServletException("Failed to load chat history", e);
        }
    }
}
