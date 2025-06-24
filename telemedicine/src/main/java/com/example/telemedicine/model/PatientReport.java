package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.example.telemedicine.util.DatabaseUtil;

/**
 * Active-record style model for patient_report table
 */
public class PatientReport {
	private int id;
	private int patientId;
	private int generatedBy;
	private LocalDateTime generatedAt;
	private String format;
	private byte[] reportContent;

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

	public int getGeneratedBy() {
		return generatedBy;
	}

	public void setGeneratedBy(int generatedBy) {
		this.generatedBy = generatedBy;
	}

	public LocalDateTime getGeneratedAt() {
		return generatedAt;
	}

	public void setGeneratedAt(LocalDateTime generatedAt) {
		this.generatedAt = generatedAt;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public byte[] getReportContent() {
		return reportContent;
	}

	public void setReportContent(byte[] reportContent) {
		this.reportContent = reportContent;
	}

	public void save() throws SQLException {
		if (id == 0)
			insert();
		else
			updateContent();
	}
	public Date getGeneratedAtAsDate() {
        return Date.from(
            generatedAt.atZone(ZoneId.systemDefault())
                       .toInstant()
        );
    }

	private void insert() throws SQLException {
		String sql = """
				INSERT INTO patient_report
				  (patient_id, generated_by, generated_at, format, report_content)
				VALUES (?,?,?,?,?)
				RETURNING id, generated_at
				""";
		try (Connection c = DatabaseUtil.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
			p.setInt(1, patientId);
			p.setInt(2, generatedBy);
			p.setTimestamp(3, Timestamp.valueOf(generatedAt));
			p.setString(4, format);
			p.setBytes(5, reportContent);
			try (ResultSet rs = p.executeQuery()) {
				if (rs.next()) {
					this.id = rs.getInt("id");
					this.generatedAt = rs.getTimestamp("generated_at").toLocalDateTime();
				}
			}
		}
	}

	private void updateContent() throws SQLException {
		String sql = "UPDATE patient_report SET report_content=? WHERE id=?";
		try (Connection c = DatabaseUtil.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
			p.setBytes(1, reportContent);
			p.setInt(2, id);
			p.executeUpdate();
		}
	}

	public static List<PatientReport> findByPatient(int patientId) throws SQLException {
		String sql = "SELECT id, patient_id, generated_by, generated_at, format FROM patient_report WHERE patient_id=? ORDER BY generated_at DESC";
		List<PatientReport> list = new ArrayList<>();
		try (Connection c = DatabaseUtil.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
			p.setInt(1, patientId);
			try (ResultSet rs = p.executeQuery()) {
				while (rs.next()) {
					PatientReport rpt = new PatientReport();
					rpt.id = rs.getInt("id");
					rpt.patientId = rs.getInt("patient_id");
					rpt.generatedBy = rs.getInt("generated_by");
					rpt.generatedAt = rs.getTimestamp("generated_at").toLocalDateTime();
					rpt.format = rs.getString("format");
					list.add(rpt);
				}
			}
		}
		return list;
	}

	public static byte[] fetchContent(int reportId) throws SQLException {
		String sql = "SELECT report_content FROM patient_report WHERE id=?";
		try (Connection c = DatabaseUtil.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
			p.setInt(1, reportId);
			try (ResultSet rs = p.executeQuery()) {
				if (rs.next())
					return rs.getBytes("report_content");
			}
		}
		return null;
	}
	/** Find the full report (metadata + content) by ID. */
    public static PatientReport findById(int reportId) throws SQLException {
        String sql = "SELECT * FROM patient_report WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                PatientReport rpt = new PatientReport();
                rpt.setId(rs.getInt("id"));
                rpt.setPatientId(rs.getInt("patient_id"));
                rpt.setGeneratedBy(rs.getInt("generated_by"));
                Timestamp ts = rs.getTimestamp("generated_at");
                rpt.setGeneratedAt(ts.toLocalDateTime());
                rpt.setFormat(rs.getString("format"));
                rpt.setReportContent(rs.getBytes("report_content"));
                return rpt;
            }
        }
    }
}