//package com.example.telemedicine.dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Set;
//
//import com.example.telemedicine.model.Appointment;
//import com.example.telemedicine.model.Appointment.Status;
//import com.example.telemedicine.model.Doctor;
//import com.example.telemedicine.util.DatabaseUtil;
//
//public class AppointmentDAO {
//	public boolean createAppointment(Appointment appointment) {
//		String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, symptoms) VALUES (?, ?, ?, ?)";
//
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//			stmt.setInt(1, appointment.getPatientId());
//			stmt.setInt(2, appointment.getDoctorId());
//			stmt.setTimestamp(3, Timestamp.valueOf(appointment.getAppointmentDate()));
//			stmt.setString(4, appointment.getSymptoms());
//
//			return stmt.executeUpdate() > 0;
//		} catch (SQLException e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
//
//	public boolean updateStatus(int appointmentId, String newStatus) {
//		String sql = "UPDATE appointments SET status = ?::appointment_status WHERE id = ?";
//		System.out.println("updateStart");
//
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//			// Valider et normaliser le statut
//			String normalizedStatus = newStatus.toUpperCase();
//
//			// Vérifier les valeurs autorisées
//			if (!Set.of("PENDING", "CONFIRMED", "COMPLETED", "CANCELLED").contains(normalizedStatus)) {
//				return false;
//			}
//
//			stmt.setString(1, normalizedStatus);
//			stmt.setInt(2, appointmentId);
//
//			int rowsAffected = stmt.executeUpdate();
//			return rowsAffected > 0;
//
//		} catch (SQLException e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
//
//	public List<Appointment> getAppointmentsByPatient(int patientId) throws SQLException {
//		List<Appointment> appointments = new ArrayList<>();
//
//		// Requête SQL modifiée avec jointure
//		String sql = "SELECT " + "a.id, a.appointment_date, a.symptoms, a.status, a.created_at, "
//				+ "d.id AS doctor_id, d.specialization, " + "u.username, u.email " + "FROM appointments a "
//				+ "INNER JOIN doctors d ON a.doctor_id = d.id " + "INNER JOIN users u ON d.user_id = u.id "
//				+ "WHERE a.patient_id = ? " + "ORDER BY a.appointment_date DESC";
//
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//			stmt.setInt(1, patientId);
//
//			try (ResultSet rs = stmt.executeQuery()) {
//				while (rs.next()) {
//					// Création du rendez-vous
//					Appointment appointment = mapAppointment(rs);
//
//					// Création du médecin associé
//					Doctor doctor = mapDoctor(rs);
//
//					appointment.setDoctor(doctor);
//
//					appointments.add(appointment);
//				}
//			}
//		} catch (SQLException e) {
//			System.out.println("Error fetching appointments for patient ID: " + patientId + e);
//			throw e;
//		}
//
//		return appointments;
//	}
//
//	public List<Appointment> getAppointmentsByDoctor(int doctorId) throws SQLException {
//		List<Appointment> appointments = new ArrayList<>();
//
//		String sql = "SELECT a.id, a.appointment_date, a.symptoms, a.status, a.created_at, "
//				+ "u.username AS patient_name, p.date_of_birth, p.gender " + "FROM appointments a "
//				+ "INNER JOIN patients p ON a.patient_id = p.id " + "INNER JOIN users u ON p.user_id = u.id " // Added
//																												// join
//																												// with
//																												// users
//																												// table
//				+ "WHERE a.doctor_id = ? " + "ORDER BY a.appointment_date DESC";
//
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//			stmt.setInt(1, doctorId);
//
//			try (ResultSet rs = stmt.executeQuery()) {
//				while (rs.next()) {
//					Appointment appointment = mapAppointment(rs);
//					appointment.setPatientName(rs.getString("patient_name"));
//					appointments.add(appointment);
//				}
//			}
//		}
//		return appointments;
//	}
//
//	// Méthode helper pour mapper un rendez-vous
//	private Appointment mapAppointment(ResultSet rs) throws SQLException {
//		Appointment appointment = new Appointment();
//		appointment.setId(rs.getInt("id"));
//		appointment.setAppointmentDate(
//				rs.getTimestamp("appointment_date") != null ? rs.getTimestamp("appointment_date").toLocalDateTime()
//						: null);
//		appointment.setSymptoms(rs.getString("symptoms"));
//		appointment.setStatus(Status.valueOf(rs.getString("status").toUpperCase()));
//		appointment.setCreatedAt(
//				rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
//		return appointment;
//	}
//
//	// Méthode helper pour mapper un médecin
//	private Doctor mapDoctor(ResultSet rs) throws SQLException {
//		Doctor doctor = new Doctor();
//		doctor.setDoctor_id(rs.getInt("doctor_id"));
//		doctor.setSpecialization(rs.getString("specialization"));
//		doctor.setUsername(rs.getString("username"));
//		doctor.setEmail(rs.getString("email"));
//		return doctor;
//	}
//
//	public boolean isAppointmentValidForDoctor(int appointmentId, int doctorId) {
//		String sql = "SELECT COUNT(*) FROM appointments WHERE id = ? AND doctor_id = ?";
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//			stmt.setInt(1, appointmentId);
//			stmt.setInt(2, doctorId); // Use doctor_id from doctors table
//			ResultSet rs = stmt.executeQuery();
//			return rs.next() && rs.getInt(1) > 0;
//		} catch (SQLException e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
//
//	public boolean isAppointmentValidForPatient(int appointmentId, int patientId) {
//		String sql = "SELECT COUNT(*) FROM appointments WHERE id = ? AND patient_id = ?";
//		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//			stmt.setInt(1, appointmentId);
//			stmt.setInt(2, patientId);
//			ResultSet rs = stmt.executeQuery();
//			return rs.next() && rs.getInt(1) > 0;
//		} catch (SQLException e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
//}