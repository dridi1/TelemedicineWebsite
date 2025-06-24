package com.example.telemedicine.controller;  // 👈 Must match your package

import com.example.telemedicine.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            response.getWriter().println("Database connection successful!");
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
            response.getWriter().println("Database connection failed: " + e.getMessage());
        }
    }
}