package com.example.telemedicine.controller;

import java.io.IOException;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.model.User;
import com.example.telemedicine.service.LoginService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 

        try {
            User user = LoginService.authenticate(email, password, role);
            
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            // Store subclass-specific data in the session
            if (user instanceof Patient) {
                Patient patient = (Patient) user;
                session.setAttribute("user", patient); // Store Patient object
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else if (user instanceof Doctor) {
                Doctor doctor = (Doctor) user;
                System.out.println(doctor);
                session.setAttribute("user", doctor); // Store Doctor object
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else if ("ADMIN".equals(user.getRole())) {
                session.setAttribute("user", user); // Base User for Admin
                request.getRequestDispatcher("/WEB-INF/views/dash/admin/dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/views/notok.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
