//package com.example.telemedicine.dao;
//
//import java.sql.Connection;
//import java.sql.Date;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import com.example.telemedicine.model.Patient;
//import com.example.telemedicine.util.DatabaseUtil;
//
//public class PatientDAO {
//
//	    
//    public void createPatient(Connection conn, int userId, String dob, String gender) throws SQLException {
//        String sql = "INSERT INTO patients (user_id, date_of_birth, gender) " +
//                     "VALUES (?, ?, ?) RETURNING id";
//        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, userId);
//            stmt.setDate(2, Date.valueOf(dob));
//            stmt.setString(3, gender);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    int generatedId = rs.getInt("id");
//                    System.out.println("Inserted patient with ID: " + generatedId);
//                } else {
//                    throw new SQLException("Patient creation failed, no ID obtained.");
//                }
//            }
//        }
//    }
//	public Patient getPatientByUserId(int userId, String email, String username, String role) throws SQLException {
//        Patient patient = new Patient();
//        String sql = "SELECT * FROM patients WHERE user_id = ?";
//        
//        try (Connection conn = DatabaseUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setInt(1, userId);
//            ResultSet rs = stmt.executeQuery();
//            
//            if (rs.next()) {
//            	patient.setId(userId);
//            	patient.setEmail(email);
//            	patient.setUsername(username);
//            	patient.setRole(role);
//                patient.setPatient_id(rs.getInt("id"));
//                patient.setDateOfBirth(rs.getDate("date_of_birth").toLocalDate());
//                patient.setGender(rs.getString("gender"));
//            }
//        }
//        return patient;
//    }
//	
//	public boolean updatePatient(Patient patient) {
//	    // Update both users and patients tables in a transaction
//	    Connection conn = null;
//	    try {
//	        conn = DatabaseUtil.getConnection();
//	        conn.setAutoCommit(false); // Start transaction
//
//	        // 1. Update username in users table
//	        String updateUserSql = "UPDATE users SET username = ? WHERE id = ?";
//	        try (PreparedStatement userStmt = conn.prepareStatement(updateUserSql)) {
//	            userStmt.setString(1, patient.getUsername()); // From User object
//	            userStmt.setInt(2, patient.getId()); // User ID from Patient's User
//	            int userRows = userStmt.executeUpdate();
//	            
//	            if (userRows == 0) {
//	                conn.rollback();
//	                return false; // No user updated
//	            }
//	        }
//
//	        // 2. Update patient details in patients table
//	        String updatePatientSql = "UPDATE patients SET date_of_birth = ?, gender = ? WHERE user_id = ?";
//	        try (PreparedStatement patientStmt = conn.prepareStatement(updatePatientSql)) {
//	            patientStmt.setDate(1, java.sql.Date.valueOf(patient.getDateOfBirth()));
//	            patientStmt.setString(2, patient.getGender());
//	            patientStmt.setInt(3, patient.getId()); // Use user_id from Patient's User
//	            int patientRows = patientStmt.executeUpdate();
//	            
//	            if (patientRows == 0) {
//	                conn.rollback();
//	                return false; // No patient updated
//	            }
//	        }
//
//	        conn.commit();
//	        return true; // Both updates succeeded
//
//	    } catch (SQLException e) {
//	        if (conn != null) {
//	            try {
//	                conn.rollback(); // Rollback on error
//	            } catch (SQLException ex) {
//	                ex.printStackTrace();
//	            }
//	        }
//	        e.printStackTrace();
//	        return false;
//	    } finally {
//	        if (conn != null) {
//	            try {
//	                conn.setAutoCommit(true); // Reset auto-commit
//	                conn.close();
//	            } catch (SQLException e) {
//	                e.printStackTrace();
//	            }
//	        }
//	    }
//	}
//}
