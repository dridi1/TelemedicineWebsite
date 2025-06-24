//package com.example.telemedicine.filters;
//
//import com.example.telemedicine.model.User;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//
//@WebFilter("/admin/*")
//public class AdminFilter implements Filter {
//	@Override
//	public void init(FilterConfig filterConfig) throws ServletException {
//	    // nothing to do
//	}
//    
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
//            throws IOException, ServletException {
//        
//    	HttpServletRequest request = (HttpServletRequest) req;
//    	HttpServletResponse response = (HttpServletResponse) res;
//		HttpSession session = request.getSession(false);
//        
//        boolean isAdmin = false;
//        
//        if (session != null) {
//            User user = (User) session.getAttribute("user");
//            if (user != null && "ADMIN".equals(user.getRole())) {
//                isAdmin = true;
//            }
//        }
//        
//        if (!isAdmin) {
//            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
//            return;
//        }
//        
//        chain.doFilter(request, response);
//    }
//    
//    @Override
//    public void destroy() {
//    	System.out.println("AuthorizationFilter destroyed admin");
//    }
//}