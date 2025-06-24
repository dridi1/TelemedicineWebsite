package com.example.telemedicine.model;

import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import com.example.telemedicine.util.DatabaseUtil;

/**
 * Active-record style model for medical_history table
 */
public class MedicalHistory {
    private int id;
    private int patientId;
    private Integer doctorId;
    private LocalDateTime visitDate;
    private String chiefComplaint;
    private String hpi;
    private String ros;
    private String diagnosis;
    private String icdCode;
    private String prescription;
    private String plan;
    private String notes;
    private LocalDateTime createdAt;

    // Getters and setters omitted for brevity...
    
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

	public Integer getDoctorId() {
		return doctorId;
	}

	public void setDoctorId(Integer doctorId) {
		this.doctorId = doctorId;
	}

	public LocalDateTime getVisitDate() {
		return visitDate;
	}

	public void setVisitDate(LocalDateTime visitDate) {
		this.visitDate = visitDate;
	}

	public String getChiefComplaint() {
		return chiefComplaint;
	}

	public void setChiefComplaint(String chiefComplaint) {
		this.chiefComplaint = chiefComplaint;
	}

	public String getHpi() {
		return hpi;
	}

	public void setHpi(String hpi) {
		this.hpi = hpi;
	}

	public String getRos() {
		return ros;
	}

	public void setRos(String ros) {
		this.ros = ros;
	}

	public String getDiagnosis() {
		return diagnosis;
	}

	public void setDiagnosis(String diagnosis) {
		this.diagnosis = diagnosis;
	}

	public String getIcdCode() {
		return icdCode;
	}

	public void setIcdCode(String icdCode) {
		this.icdCode = icdCode;
	}

	public String getPrescription() {
		return prescription;
	}

	public void setPrescription(String prescription) {
		this.prescription = prescription;
	}

	public String getPlan() {
		return plan;
	}

	public void setPlan(String plan) {
		this.plan = plan;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
	public Date getVisitDateAsDate() {
        return Date.from(
            visitDate.atZone(ZoneId.systemDefault())
                     .toInstant()
        );
    }

	/**
     * Persists this instance to the DB. If id==0, inserts; otherwise updates.
     */
    public void save() throws SQLException {
        if (this.id == 0) insert();
        else update();
    }

    private void insert() throws SQLException {
        String sql = """
            INSERT INTO medical_history
              (patient_id, doctor_id, visit_date, chief_complaint, hpi, ros,
               diagnosis, icd_code, prescription, plan, notes)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)
            RETURNING id, created_at
            """;
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, patientId);
            if (doctorId == null) p.setNull(2, Types.INTEGER);
            else p.setInt(2, doctorId);
            p.setTimestamp(3, Timestamp.valueOf(visitDate));
            p.setString(4, chiefComplaint);
            p.setString(5, hpi);
            p.setString(6, ros);
            p.setString(7, diagnosis);
            p.setString(8, icdCode);
            p.setString(9, prescription);
            p.setString(10, plan);
            p.setString(11, notes);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    this.id = rs.getInt("id");
                    this.createdAt = rs.getTimestamp("created_at")
                                         .toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
                }
            }
        }
    }

    private void update() throws SQLException {
        String sql = """
            UPDATE medical_history SET
              doctor_id=?, visit_date=?, chief_complaint=?, hpi=?, ros=?,
              diagnosis=?, icd_code=?, prescription=?, plan=?, notes=?
            WHERE id=?
            """;
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            if (doctorId == null) p.setNull(1, Types.INTEGER);
            else p.setInt(1, doctorId);
            p.setTimestamp(2, Timestamp.valueOf(visitDate));
            p.setString(3, chiefComplaint);
            p.setString(4, hpi);
            p.setString(5, ros);
            p.setString(6, diagnosis);
            p.setString(7, icdCode);
            p.setString(8, prescription);
            p.setString(9, plan);
            p.setString(10, notes);
            p.setInt(11, id);
            p.executeUpdate();
        }
    }

    public static List<MedicalHistory> findByPatient(int patientId) throws SQLException {
        String sql = "SELECT * FROM medical_history WHERE patient_id=? ORDER BY visit_date DESC";
        List<MedicalHistory> results = new ArrayList<>();
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, patientId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    results.add(mapRow(rs));
                }
            }
        }
        return results;
    }

    private static MedicalHistory mapRow(ResultSet rs) throws SQLException {
        MedicalHistory mh = new MedicalHistory();
        mh.id = rs.getInt("id");
        mh.patientId = rs.getInt("patient_id");
        int did = rs.getInt("doctor_id");
        if (!rs.wasNull()) mh.doctorId = did;
        mh.visitDate = rs.getTimestamp("visit_date").toLocalDateTime();
        mh.chiefComplaint = rs.getString("chief_complaint");
        mh.hpi = rs.getString("hpi");
        mh.ros = rs.getString("ros");
        mh.diagnosis = rs.getString("diagnosis");
        mh.icdCode = rs.getString("icd_code");
        mh.prescription = rs.getString("prescription");
        mh.plan = rs.getString("plan");
        mh.notes = rs.getString("notes");
        mh.createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        return mh;
    }
}