package com.example.telemedicine.filters;

import java.io.IOException;

import com.example.telemedicine.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/doctor/*")
public class DoctorFilter implements Filter {
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	    // nothing to do
	}
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
    	HttpServletRequest request = (HttpServletRequest) req;
    	HttpServletResponse response = (HttpServletResponse) res;
		HttpSession session = request.getSession(false);
        
        boolean isDoctor = false;
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "DOCTOR".equals(user.getRole())) {
                isDoctor = true;
            }
        }
        
        if (!isDoctor) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    	System.out.println("AuthorizationFilter destroyed doctor");
    }
}