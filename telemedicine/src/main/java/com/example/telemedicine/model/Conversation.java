package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.telemedicine.util.DatabaseUtil;

public class Conversation {
	private int id;
	private int patientId;
	private int doctorId;
	private Timestamp createdAt;

	// … getters & setters …

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getPatientId() {
		return patientId;
	}

	public void setPatientId(int patientId) {
		this.patientId = patientId;
	}

	public int getDoctorId() {
		return doctorId;
	}

	public void setDoctorId(int doctorId) {
		this.doctorId = doctorId;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	/** Create a new conversation (caller must know patientId & doctorId) */
	public int create() throws SQLException {
		String sql = "INSERT INTO conversation (patient_id, doctor_id) VALUES (?, ?) RETURNING id";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, patientId);
			ps.setInt(2, doctorId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					this.id = rs.getInt("id");
					return this.id;
				} else {
					throw new SQLException("Failed to create conversation.");
				}
			}
		}
	}

	/** Fetch all conversations for a given user (either patient or doctor) */
	public static List<Conversation> getConversations(int userId) throws SQLException {
        System.out.println("[DEBUG] getConversations called with userId=" + userId);
        String sql = "SELECT id, patient_id, doctor_id, created_at FROM conversation " +
                     "WHERE patient_id = ? OR doctor_id = ? ORDER BY created_at DESC";
        List<Conversation> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Conversation c = new Conversation();
                    c.setId(rs.getInt("id"));
                    c.setPatientId(rs.getInt("patient_id"));
                    c.setDoctorId(rs.getInt("doctor_id"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(c);
                }
            }
        }
        System.out.println("[DEBUG] getConversations result size=" + list.size());
        return list;
    }
	
	public static List<Conversation> findByDoctorId(int doctorId) throws SQLException {
	    String sql = """
	        SELECT id, patient_id, doctor_id, created_at
	          FROM conversation
	         WHERE doctor_id = ?
	      ORDER BY created_at DESC
	        """;
	    List<Conversation> list = new ArrayList<>();
	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, doctorId);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Conversation c = new Conversation();
	                c.setId(rs.getInt("id"));
	                c.setPatientId(rs.getInt("patient_id"));
	                c.setDoctorId(rs.getInt("doctor_id"));
	                c.setCreatedAt(rs.getTimestamp("created_at"));
	                list.add(c);
	            }
	        }
	    }
	    return list;
	}
	
	@Override
	public String toString() {
	    return "Conversation{" +
	           "id=" + id +
	           ", patientId=" + patientId +
	           ", doctorId=" + doctorId +
	           ", createdAt=" + createdAt +
	           '}';
	}
}
