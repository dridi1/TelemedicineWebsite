package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.example.telemedicine.util.DatabaseUtil;

public class Appointment {
    private int id;
    private int patientId;
    private String patientName;
    private int doctorId;
    private LocalDateTime appointmentDate;
    private String symptoms;
    private Status status;
    private LocalDateTime createdAt;
    private Doctor doctor;

    public enum Status {
        PENDING, CONFIRMED, COMPLETED, CANCELLED
    }

    public Appointment() {
        this.status = Status.PENDING;
        this.createdAt = LocalDateTime.now();
    }

    public Appointment(int patientId, int doctorId, LocalDateTime appointmentDate, String symptoms) {
        this();
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.appointmentDate = appointmentDate;
        this.symptoms = symptoms;
    }

    /* ===== Getters & Setters ===== */

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public LocalDateTime getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(LocalDateTime appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    @Override
    public String toString() {
        DateTimeFormatter fmt = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        return String.format(
            "Appointment[ID=%d, PatientID=%d, DoctorID=%d, Date=%s, Status=%s]",
            id, patientId, doctorId,
            appointmentDate.format(fmt), status.name()
        );
    }

    /* ===== Active Record Methods ===== */

    public boolean save() {
        return (this.id == 0) ? insert() : update();
    }

    private boolean insert() {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, symptoms) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, doctorId);
            stmt.setTimestamp(3, Timestamp.valueOf(appointmentDate));
            stmt.setString(4, symptoms);

            int affected = stmt.executeUpdate();
            if (affected == 0) return false;
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    this.id = keys.getInt(1);
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean update() {
        String sql = "UPDATE appointments SET patient_id=?, doctor_id=?, appointment_date=?, symptoms=?, status=? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, doctorId);
            stmt.setTimestamp(3, Timestamp.valueOf(appointmentDate));
            stmt.setString(4, symptoms);
            stmt.setString(5, status.name());
            stmt.setInt(6, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(String newStatus) {
        String norm = newStatus.toUpperCase();
        if (!Set.of("PENDING", "CONFIRMED", "COMPLETED", "CANCELLED").contains(norm)) {
            return false;
        }
        this.status = Status.valueOf(norm);
        String sql = "UPDATE appointments SET status = ?::appointment_status WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, norm);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete() {
        if (id == 0) return false;
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Appointment findById(int appointmentId) throws SQLException {
        String sql = "SELECT * FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapAppointment(rs);
                }
            }
        }
        return null;
    }

    public static List<Appointment> findByPatient(int patientId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.username AS patient_name, " +
                     "d.user_id AS doctor_user_id, d.specialization, du.username AS doctor_username, du.email AS doctor_email " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.user_id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN doctors d ON a.doctor_id = d.user_id " +
                     "JOIN users du ON d.user_id = du.id " +
                     "WHERE a.patient_id = ? ORDER BY a.appointment_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = mapAppointment(rs);
                    appt.patientName = rs.getString("patient_name");
                    Doctor doc = new Doctor();
                    doc.setId(rs.getInt("doctor_user_id"));
                    doc.setSpecialization(rs.getString("specialization"));
                    doc.setUsername(rs.getString("doctor_username"));
                    doc.setEmail(rs.getString("doctor_email"));
                    appt.doctor = doc;
                    list.add(appt);
                }
            }
        }
        return list;
    }

    public static List<Appointment> findByDoctor(int doctorId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.username AS patient_name " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.user_id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "WHERE a.doctor_id = ? ORDER BY a.appointment_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = mapAppointment(rs);
                    appt.patientName = rs.getString("patient_name");
                    list.add(appt);
                }
            }
        }
        return list;
    }

    public static List<Appointment> findAll() throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.username AS patient_name, d.user_id AS doctor_user_id, du.username AS doctor_username " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.user_id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN doctors d ON a.doctor_id = d.user_id " +
                     "JOIN users du ON d.user_id = du.id " +
                     "ORDER BY a.appointment_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Appointment appt = mapAppointment(rs);
                appt.patientName = rs.getString("patient_name");
                Doctor doc = new Doctor();
                doc.setId(rs.getInt("doctor_user_id"));
                doc.setUsername(rs.getString("doctor_username"));
                appt.doctor = doc;
                list.add(appt);
            }
        }
        return list;
    }

    public boolean isValidForDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE id=? AND doctor_id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isValidForPatient(int patientId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE id=? AND patient_id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, patientId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private static Appointment mapAppointment(ResultSet rs) throws SQLException {
        Appointment appt = new Appointment();
        appt.id = rs.getInt("id");
        appt.patientId = rs.getInt("patient_id");
        appt.doctorId = rs.getInt("doctor_id");
        appt.appointmentDate = rs.getTimestamp("appointment_date").toLocalDateTime();
        appt.symptoms = rs.getString("symptoms");
        appt.status = Status.valueOf(rs.getString("status").toUpperCase());
        appt.createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        return appt;
    }
}
