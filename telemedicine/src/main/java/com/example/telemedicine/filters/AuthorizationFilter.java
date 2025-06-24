//package com.example.telemedicine.filters;
//
//import java.io.IOException;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//@WebFilter("/*") // Apply this filter to all requests
//public class AuthorizationFilter implements Filter {
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // Initialization code if needed.
//    }
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//        
//        HttpServletRequest request = (HttpServletRequest) req;
//        HttpServletResponse response = (HttpServletResponse) res;
//        HttpSession session = request.getSession(false);
//        
//        // Publicly accessible URIs (login, register, static resources, etc.)
//        String loginURI = request.getContextPath() + "/login";
//        String registerURI = request.getContextPath() + "/register";
//        String homeURI = request.getContextPath() + "/";
//        String chatUi = request.getContextPath() + "/chat-ui";
//        String chatApi = request.getContextPath() + "/chat";
//        String aboutus = request.getContextPath() + "/aboutus";
//        boolean isStaticResource = request.getRequestURI().contains("/assets/");
//        
//        // Allow access to public pages
//        if (request.getRequestURI().equals(loginURI) ||
//            request.getRequestURI().equals(registerURI) ||
//            request.getRequestURI().equals(homeURI) ||
//            request.getRequestURI().equals(chatUi) ||
//            request.getRequestURI().equals(chatApi) ||
//            request.getRequestURI().equals(aboutus) ||
//            isStaticResource) {
//            chain.doFilter(req, res);
//            return;
//        }
//        
//        // Check for a valid session and user role
//        if (session == null || session.getAttribute("user") == null) {
//            // Not logged in, redirect to login
//            response.sendRedirect(loginURI);
//            return;
//        }
//        
//        // Get the user role from session
//        String userRole = (String) session.getAttribute("userRole");
//        String requestURI = request.getRequestURI();
//
//        // Define access rules (customize as needed)
//        if (requestURI.contains("/patient-dashboard") && !"PATIENT".equals(userRole)) {
//            response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        } else if(requestURI.contains("/doctor-profile") && !"PATIENT".equals(userRole)){
//        	response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        }else if(requestURI.contains("/patient-conversations") && !"PATIENT".equals(userRole)){
//        	response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        } else if (requestURI.contains("/patient-chat") && !"PATIENT".equals(userRole)) {
//            response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        }else if (requestURI.contains("/doctor-dashboard") && !"DOCTOR".equals(userRole)) {
//            response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        }else if (requestURI.contains("/doctor-chat") && !"DOCTOR".equals(userRole)) {
//            response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        } else if (requestURI.contains("/admin") && !"ADMIN".equals(userRole)) {
//            response.sendRedirect(loginURI + "?error=unauthorized");
//            return;
//        }
//        
//        // User is authenticated and authorized; proceed with the request.
//        chain.doFilter(req, res);
//    }
//
//    @Override
//    public void destroy() {
//        // Cleanup code if needed.
//        System.out.println("AuthorizationFilter destroyed.");
//    }
//}
