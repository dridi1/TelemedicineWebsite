package com.example.telemedicine.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.UUID;

import com.example.telemedicine.model.User;
import com.example.telemedicine.service.EmailService;
import com.example.telemedicine.service.RegistrationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RegistrationService registrationService = new RegistrationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = firstName + " " + lastName;
        String password = request.getParameter("password");
        String email    = request.getParameter("email");
        String role     = request.getParameter("role");

        String hashedPassword = User.hashPassword(password);

        try {
            if ("PATIENT".equalsIgnoreCase(role)) {
                LocalDate dob = LocalDate.parse(request.getParameter("dob"));
                registrationService.registerPatient(username, email, hashedPassword, role,
                        dob, request.getParameter("gender"));
            } else if ("DOCTOR".equalsIgnoreCase(role)) {
                registrationService.registerDoctor(username, email, hashedPassword, role,
                        request.getParameter("license"),
                        request.getParameter("specialization"),
                        Double.parseDouble(request.getParameter("consultationFee")),
                        Integer.parseInt(request.getParameter("yearsOfExperience")),
                        request.getParameter("specialNotes"));
            } else {
                request.setAttribute("error", "Invalid role selected.");
                request.getRequestDispatcher("/WEB-INF/views/notok.jsp").forward(request, response);
                return;
            }

            // Generate a verification token and link
            String token = UUID.randomUUID().toString();
            // TODO: persist this token associated with the user for later verification
            String verificationLink = request.getScheme() + "://" +
                    request.getServerName() + ":" + request.getServerPort() +
                    request.getContextPath() + "/verify?token=" + token;

            // Send welcome email with verification link
            try {
                EmailService.sendWelcomeEmail(email, firstName, verificationLink);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }

            response.sendRedirect(request.getContextPath() + "/login?success=registered");

        } catch (DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/register?error=invalid_date");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(request, response);
        }
    }
}
