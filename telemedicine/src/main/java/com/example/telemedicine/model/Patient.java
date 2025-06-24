package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.example.telemedicine.util.DatabaseUtil;

public class Patient extends User {
    private LocalDate dateOfBirth;
    private String gender;

    // Constructors
    public Patient() {
        super();
    }

    public Patient(String username, String passwordHash, String email, String role,
                   LocalDate dateOfBirth, String gender) {
        super(username, passwordHash, email, role);
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
    }

    // Getters and Setters
    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }
    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    @Override
    public String toString() {
        return String.format("Patient{%s, dateOfBirth=%s, gender='%s'}", 
                             super.toString(), dateOfBirth, gender);
    }

    // -------- Active Record CRUD --------

    /**
     * Creates both a User and Patient record in one transaction.
     */
    public void create() throws SQLException {
        String userSql = "INSERT INTO users (username, password_hash, email, role, created_at) " +
                         "VALUES (?, ?, ?, ?, ?) RETURNING id";
        String patientSql = "INSERT INTO patients (user_id, date_of_birth, gender) " +
                            "VALUES (?, ?, ?)";
        Connection conn = DatabaseUtil.getConnection();
        try {
            conn.setAutoCommit(false);

            // Insert User
            int newUserId;
            try (PreparedStatement userStmt = conn.prepareStatement(userSql)) {
                userStmt.setString(1, getUsername());
                userStmt.setString(2, getPasswordHash());
                userStmt.setString(3, getEmail());
                userStmt.setString(4, getRole());
                userStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                try (ResultSet rs = userStmt.executeQuery()) {
                    if (!rs.next()) {
                    	throw new SQLException("Creating user failed, no ID obtained.");
                    }
                    newUserId = rs.getInt("id");
                    setId(newUserId);
                }
            }

            // Insert Patient
            try (PreparedStatement patStmt = conn.prepareStatement(patientSql)) {
                patStmt.setInt(1, newUserId);
                patStmt.setDate(2, Date.valueOf(dateOfBirth));
                patStmt.setString(3, gender);

                int rows = patStmt.executeUpdate();
                if (rows != 1) {
                    throw new SQLException("Creating patient failed, affected rows: " + rows);
                }
            }

            conn.commit();
        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    /** Updates both User and Patient records in one transaction */
    public boolean update() throws SQLException {
        if (getId() == 0) {
            throw new IllegalStateException("Cannot update Patient without a valid user ID");
        }
        String updateUserSql = "UPDATE users SET username=?, password_hash=?, email=?, role=? WHERE id=?";
        String updatePatientSql = "UPDATE patients SET date_of_birth=?, gender=? WHERE user_id=?";
        Connection conn = DatabaseUtil.getConnection();
        try {
            conn.setAutoCommit(false);

            // Update user
            try (PreparedStatement userStmt = conn.prepareStatement(updateUserSql)) {
                userStmt.setString(1, getUsername());
                userStmt.setString(2, getPasswordHash());
                userStmt.setString(3, getEmail());
                userStmt.setString(4, getRole());
                userStmt.setInt(5, getId());
                if (userStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Update patient
            try (PreparedStatement patStmt = conn.prepareStatement(updatePatientSql)) {
                patStmt.setDate(1, Date.valueOf(dateOfBirth));
                patStmt.setString(2, gender);
                patStmt.setInt(3, getId());
                if (patStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    /** Deletes Patient and corresponding User in one transaction */
    public boolean delete() throws SQLException {
        if (getId() == 0) {
            throw new IllegalStateException("Cannot delete Patient without both IDs");
        }
        String deletePatientSql = "DELETE FROM patients WHERE user_id=?";
        String deleteUserSql = "DELETE FROM users WHERE id=?";
        Connection conn = DatabaseUtil.getConnection();
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement patStmt = conn.prepareStatement(deletePatientSql)) {
                patStmt.setInt(1, getId());
                if (patStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }
            try (PreparedStatement userStmt = conn.prepareStatement(deleteUserSql)) {
                userStmt.setInt(1, getId());
                if (userStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    /** Finds a Patient by its user ID */
    public static Patient findById(int userId) throws SQLException {
        String sql = "SELECT u.id AS user_id, u.username, u.password_hash, u.email, u.role, " +
                     "p.date_of_birth, p.gender " +
                     "FROM users u JOIN patients p ON u.id = p.user_id WHERE u.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Patient p = new Patient();
                    p.setId(rs.getInt("user_id"));
                    p.setUsername(rs.getString("username"));
                    p.setPasswordHash(rs.getString("password_hash"));
                    p.setEmail(rs.getString("email"));
                    p.setRole(rs.getString("role"));
                    p.setDateOfBirth(rs.getDate("date_of_birth").toLocalDate());
                    p.setGender(rs.getString("gender"));
                    return p;
                }
            }
        }
        return null;
    }

    /** Retrieves all Patients */
    public static List<Patient> findAllPatients() throws SQLException {
    	List<Patient> patients = new ArrayList<>();
        String sql = "SELECT u.id AS user_id, u.username, u.password_hash, u.email, u.role, " +
                     "p.date_of_birth, p.gender " +
                     "FROM users u JOIN patients p ON u.id = p.user_id";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("user_id"));
                p.setUsername(rs.getString("username"));
                p.setPasswordHash(rs.getString("password_hash"));
                p.setEmail(rs.getString("email"));
                p.setRole(rs.getString("role"));
                p.setDateOfBirth(rs.getDate("date_of_birth").toLocalDate());
                p.setGender(rs.getString("gender"));
                patients.add(p);
            }
        }
        return patients;
    }
}
