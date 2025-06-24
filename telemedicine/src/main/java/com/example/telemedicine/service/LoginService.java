package com.example.telemedicine.service;

import org.mindrot.jbcrypt.BCrypt;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;
import com.example.telemedicine.model.User;

public class LoginService {
	
	
	/**
	 * Authenticates a user by email, password, and expected role.
	 * Returns a Doctor or Patient instance when appropriate, or base User for other roles.
	 */
    public static User authenticate(String email, String password, String role) throws Exception {
        User user = User.findByEmail(email);
        
        
        if (user == null || !BCrypt.checkpw(password, user.getPasswordHash())) {
            throw new Exception("invalid_credentials");
        }
        
        // Defensive check: Ensure the stored role is not null before comparing.
        if (user.getRole() == null) {
            throw new Exception("role_not_set");
        }
        
        // Compare in a null-safe manner.
        if (!role.equalsIgnoreCase(user.getRole())) {
            throw new Exception("role_mismatch");
        }
        
        // Now, based on role, return a fully populated subclass instance.
        switch (user.getRole().toUpperCase()) {
            case "DOCTOR":
                // Assuming doctorDao.getDoctorByUserId returns a Doctor instance 
                // that includes the user attributes along with doctor-specific details.
                return Doctor.findById(user.getId());
            case "PATIENT":
                // Similarly, getPatientByUserId returns a Patient instance.
                return Patient.findById(user.getId());
            default:
                // For roles without a dedicated subclass (e.g., ADMIN), return the base user object.
                return user;
        }
    }
}
