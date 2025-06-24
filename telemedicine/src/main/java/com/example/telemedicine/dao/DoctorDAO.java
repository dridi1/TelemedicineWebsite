//package com.example.telemedicine.dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//
//import com.example.telemedicine.model.Doctor;
//import com.example.telemedicine.util.DatabaseUtil;
//
//public class DoctorDAO {
//	
//	public int createDoctor(Connection conn, String license, String specialization, 
//        double consultationFee, int yearsOfExperience, 
//        String specialNotes, int userId) throws SQLException {
//			String sql = "INSERT INTO doctors (license_number, specialization, user_id, available, " +
//					"years_experience, consultation_fee, special_notes) " +
//					"VALUES (?, ?, ?, TRUE, ?, ?, ?) RETURNING id";
//			try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//				stmt.setString(1, license);
//				stmt.setString(2, specialization);
//				stmt.setInt(3, userId);
//				stmt.setInt(4, yearsOfExperience);
//				stmt.setDouble(5, consultationFee);
//				stmt.setString(6, specialNotes);
//				try (ResultSet rs = stmt.executeQuery()) {
//					if (rs.next()) {
//						int generatedId = rs.getInt("id");
//						System.out.println("Inserted doctor with ID: " + generatedId);
//						return generatedId;
//					} else {
//						throw new SQLException("Doctor creation failed, no ID obtained.");
//					}
//				}
//			}
//		}
//
//	
//	public Doctor getDoctorByUserId(int id) throws SQLException {
//		String sql = "SELECT "
//	            + "d.id AS doctor_id, "
//	            + "d.license_number, "
//	            + "d.specialization, "
//	            + "d.available, "
//	            + "d.rating, "
//	            + "d.reviews_count, "
//	            + "d.years_experience, "
//	            + "d.consultation_fee, "
//	            + "d.special_notes, "
//	            + "u.id AS user_id, "
//	            + "u.username, "
//	            + "u.email,"
//	            + "u.\"role\" "
//	            + "FROM doctors d "
//	            + "INNER JOIN users u ON d.user_id = u.id "
//	            + "WHERE u.id = ?";
//        
//        try (Connection conn = DatabaseUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setInt(1, id);
//            
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    Doctor doctor = new Doctor();
//                    doctor.setId(rs.getInt("user_id"));
//                    doctor.setUsername(rs.getString("username"));
//                    doctor.setEmail(rs.getString("email"));
//                    doctor.setRole(rs.getString("role"));
//                    
//                    doctor.setDoctor_id(rs.getInt("doctor_id"));
//                    doctor.setLicenseNumber(rs.getString("license_number"));
//                    doctor.setSpecialization(rs.getString("specialization"));
//                    doctor.setAvailable(rs.getBoolean("available"));
//                    doctor.setRating(rs.getDouble("rating"));
//                    doctor.setReviewsCount(rs.getInt("reviews_count"));
//                    doctor.setYearsOfExperience(rs.getInt("years_experience"));
//                    doctor.setConsultationFee(rs.getDouble("consultation_fee"));
//                    doctor.setSpecialNotes(rs.getString("special_notes"));
//                    
//                    return doctor;
//                }
//            }
//        }
//        return null;
//    }
//	public Doctor getDoctorById(int doctorId) throws SQLException {
//	    String sql = "SELECT "
//	            + "d.id AS doctor_id, "
//	            + "d.license_number, "
//	            + "d.specialization, "
//	            + "d.available, "
//	            + "d.rating, "
//	            + "d.reviews_count, "
//	            + "d.years_experience, "
//	            + "d.consultation_fee, "
//	            + "d.special_notes, "
//	            + "u.id AS user_id, "
//	            + "u.username, "
//	            + "u.email, "
//	            + "u.\"role\" "
//	            + "FROM doctors d "
//	            + "INNER JOIN users u ON d.user_id = u.id "
//	            + "WHERE d.id = ?";
//
//	    try (Connection conn = DatabaseUtil.getConnection();
//	         PreparedStatement stmt = conn.prepareStatement(sql)) {
//	        
//	        stmt.setInt(1, doctorId);
//	        
//	        try (ResultSet rs = stmt.executeQuery()) {
//	            if (rs.next()) {
//	                Doctor doctor = new Doctor();
//	                // Set user-related properties
//	                doctor.setId(rs.getInt("user_id"));
//	                doctor.setUsername(rs.getString("username"));
//	                doctor.setEmail(rs.getString("email"));
//	                doctor.setRole(rs.getString("role"));
//	                
//	                // Set doctor-specific properties
//	                doctor.setDoctor_id(rs.getInt("doctor_id"));
//	                doctor.setLicenseNumber(rs.getString("license_number"));
//	                doctor.setSpecialization(rs.getString("specialization"));
//	                doctor.setAvailable(rs.getBoolean("available"));
//	                doctor.setRating(rs.getDouble("rating"));
//	                doctor.setReviewsCount(rs.getInt("reviews_count"));
//	                doctor.setYearsOfExperience(rs.getInt("years_experience"));
//	                doctor.setConsultationFee(rs.getDouble("consultation_fee"));
//	                doctor.setSpecialNotes(rs.getString("special_notes"));
//	                
//	                return doctor;
//	            }
//	        }
//	    }
//	    return null;
//	}
//
//
//    public List<Doctor> getAllAvailableDoctors() {
//        List<Doctor> doctors = new ArrayList<>();
//        
//        String sql = """
//            SELECT d.id as doctor_id,
//                   d.license_number,
//                   d.specialization,
//                   d.available,
//                   d.rating,
//                   d.reviews_count,
//                   d.years_experience,
//                   d.consultation_fee,
//                   d.special_notes,
//                   u.id as user_id,
//                   u.username,
//                   u.email,
//                   u.role
//            FROM doctors d
//            JOIN users u ON d.user_id = u.id
//            WHERE d.available = TRUE
//        """;
//        
//        
//        try (Connection conn = DatabaseUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Doctor doctor = new Doctor();
//                    doctor.setId(rs.getInt("user_id"));
//                    doctor.setUsername(rs.getString("username"));
//                    doctor.setEmail(rs.getString("email"));
//                    doctor.setRole(rs.getString("role"));
//                    
//                    doctor.setDoctor_id(rs.getInt("doctor_id"));
//                    doctor.setLicenseNumber(rs.getString("license_number"));
//                    doctor.setSpecialization(rs.getString("specialization"));
//                    doctor.setAvailable(rs.getBoolean("available"));
//                    doctor.setRating(rs.getDouble("rating"));
//                    doctor.setReviewsCount(rs.getInt("reviews_count"));
//                    doctor.setYearsOfExperience(rs.getInt("years_experience"));
//                    doctor.setConsultationFee(rs.getDouble("consultation_fee"));
//                    doctor.setSpecialNotes(rs.getString("special_notes"));
//
//                    doctors.add(doctor);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        
//        return doctors;
//    }
//    // New method to get the count of available doctors
//    public int getAvailableDoctorsCount() {
//        String sql = "SELECT COUNT(*) AS doctor_count FROM doctors WHERE available = TRUE";
//        int count = 0;
//        
//        try (Connection conn = DatabaseUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql);
//             ResultSet rs = stmt.executeQuery()) {
//            
//            if (rs.next()) {
//                count = rs.getInt("doctor_count");
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        
//        return count;
//    }
//
//    /*public Map<String, Integer> getAppointmentStats(int doctorId) {
//        Map<String, Integer> stats = new HashMap<>();
//        String sql = "SELECT status, COUNT(*) FROM appointments WHERE doctor_id = ? GROUP BY status";
//        // Implementation similar to other DAO methods
//        return stats;
//    }*/
//}
