package com.example.telemedicine.model;

import com.example.telemedicine.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Doctor extends User {
	private String licenseNumber;
	private String specialization;
	private boolean available;
	private double rating;
	private int reviewsCount;
	private int yearsOfExperience;
	private double consultationFee;
	private String specialNotes;

	// Constructors
	public Doctor() {
		super();
	}

	public Doctor(String username, String passwordHash, String email, String role, String licenseNumber,
			String specialization, boolean available, double rating, int reviewsCount, int yearsOfExperience,
			double consultationFee, String specialNotes) {
		super(username, passwordHash, email, role);
		this.licenseNumber = licenseNumber;
		this.specialization = specialization;
		this.available = available;
		this.rating = rating;
		this.reviewsCount = reviewsCount;
		this.yearsOfExperience = yearsOfExperience;
		this.consultationFee = consultationFee;
		this.specialNotes = specialNotes;
	}

	// Getters and Setters
	public String getLicenseNumber() {
		return licenseNumber;
	}

	public void setLicenseNumber(String licenseNumber) {
		this.licenseNumber = licenseNumber;
	}

	public String getSpecialization() {
		return specialization;
	}

	public void setSpecialization(String specialization) {
		this.specialization = specialization;
	}

	public boolean isAvailable() {
		return available;
	}

	public void setAvailable(boolean available) {
		this.available = available;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public int getReviewsCount() {
		return reviewsCount;
	}

	public void setReviewsCount(int reviewsCount) {
		this.reviewsCount = reviewsCount;
	}

	public int getYearsOfExperience() {
		return yearsOfExperience;
	}

	public void setYearsOfExperience(int yearsOfExperience) {
		this.yearsOfExperience = yearsOfExperience;
	}

	public double getConsultationFee() {
		return consultationFee;
	}

	public void setConsultationFee(double consultationFee) {
		this.consultationFee = consultationFee;
	}

	public String getSpecialNotes() {
		return specialNotes;
	}

	public void setSpecialNotes(String specialNotes) {
		this.specialNotes = specialNotes;
	}

	@Override
	public String toString() {
		return String.format(
		        "Doctor[%s, user_id=%d, licenseNumber='%s', specialization='%s', available=%b, rating=%.1f, reviewsCount=%d, yearsOfExperience=%d, consultationFee=%.2f, specialNotes='%s']",
		        super.toString(),
		        getId(),                       // your int PK
		        licenseNumber,                 // String
		        specialization,                // String
		        available,                     // boolean
		        rating,                        // double
		        reviewsCount,                  // int
		        yearsOfExperience,             // int
		        consultationFee,               // double
		        specialNotes                   // String
		    );
	}

	// -------- Active Record CRUD --------

	/**
	 * Creates both a User and Doctor record in one transaction.
	 */
	public void create() throws SQLException {
	    String userSql =
	      "INSERT INTO users (username, password_hash, email, role, created_at) " +
	      "VALUES (?, ?, ?, ?, ?) RETURNING id";

	    // no RETURNING here:
	    String doctorSql =
	      "INSERT INTO doctors (license_number, specialization, user_id, available, years_experience, consultation_fee, special_notes) " +
	      "VALUES (?, ?, ?, ?, ?, ?, ?)";

	    Connection conn = DatabaseUtil.getConnection();
	    try {
	        conn.setAutoCommit(false);

	        // 1) Insert user → get its id
	        try (PreparedStatement ps = conn.prepareStatement(userSql)) {
	            ps.setString(1, getUsername());
	            ps.setString(2, getPasswordHash());
	            ps.setString(3, getEmail());
	            ps.setString(4, getRole());
	            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

	            try (ResultSet rs = ps.executeQuery()) {
	                if (!rs.next()) {
	                    throw new SQLException("Creating user failed, no ID obtained.");
	                }
	                setId(rs.getInt(1));
	            }
	        }

	        // 2) Insert doctor → get generated user_id back as the PK
	        int newUserId;
	        try (PreparedStatement ps = conn.prepareStatement(doctorSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
	            ps.setString(1, licenseNumber);
	            ps.setString(2, specialization);
	            ps.setInt(3, getId());           // user_id FK
	            ps.setBoolean(4, available);
	            ps.setInt(5, yearsOfExperience);
	            ps.setDouble(6, consultationFee);
	            ps.setString(7, specialNotes);

	            if (ps.executeUpdate() != 1) {
	                throw new SQLException("Creating doctor failed, no row inserted.");
	            }
	            try (ResultSet keys = ps.getGeneratedKeys()) {
	                if (!keys.next()) {
	                    throw new SQLException("Creating doctor failed, no ID obtained.");
	                }
	                newUserId = keys.getInt(1);
	                setId(newUserId);    // your Doctor object still uses setId() on the User base class
	            }
	        }

	        // 3) Pull back rating & reviews_count by user_id (not id)
	        String fetchSql = "SELECT rating, reviews_count FROM doctors WHERE user_id = ?";
	        try (PreparedStatement ps = conn.prepareStatement(fetchSql)) {
	            ps.setInt(1, newUserId);
	            try (ResultSet rs = ps.executeQuery()) {
	                if (rs.next()) {
	                    this.rating       = rs.getDouble("rating");
	                    this.reviewsCount = rs.getInt   ("reviews_count");
	                }
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



	/**
	 * Updates both User and Doctor records in one transaction.
	 */
	public boolean update() throws SQLException {
		if (getId() == 0) {
			throw new IllegalStateException("Cannot update Doctor without both IDs");
		}
		String updateUserSql = "UPDATE users SET username=?, password_hash=?, email=?, role=? WHERE id=?";
		String updateDoctorSql = "UPDATE doctors SET license_number=?, specialization=?, available=?, years_experience=?, consultation_fee=?, special_notes=? WHERE user_id=?";
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);

			// Update users
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

			// Update doctors
			try (PreparedStatement docStmt = conn.prepareStatement(updateDoctorSql)) {
				docStmt.setString(1, licenseNumber);
				docStmt.setString(2, specialization);
				docStmt.setBoolean(3, available);
				docStmt.setInt(4, yearsOfExperience);
				docStmt.setDouble(5, consultationFee);
				docStmt.setString(6, specialNotes);
				docStmt.setInt(7, getId());
				if (docStmt.executeUpdate() == 0) {
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

	/**
	 * Deletes Doctor and corresponding User record in one transaction.
	 */
	public boolean delete() throws SQLException {
		if (getId() == 0) {
			throw new IllegalStateException("Cannot delete Doctor without both IDs");
		}
		String deleteDoctorSql = "DELETE FROM doctors WHERE user_id=?";
		String deleteUserSql = "DELETE FROM users WHERE id=?";
		Connection conn = DatabaseUtil.getConnection();
		try {
			conn.setAutoCommit(false);

			try (PreparedStatement docStmt = conn.prepareStatement(deleteDoctorSql)) {
				docStmt.setInt(1, getId());
				if (docStmt.executeUpdate() == 0) {
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

	/**
	 * Finds a Doctor by user ID.
	 */
	public static Doctor findById(int userId) throws SQLException {
		String sql = "SELECT u.id AS user_id, u.username, u.password_hash, u.email, u.role, "
				+ "d.license_number, d.specialization, d.available, d.rating, d.reviews_count, d.years_experience, d.consultation_fee, d.special_notes "
				+ "FROM users u JOIN doctors d ON u.id = d.user_id WHERE u.id = ?";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, userId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					Doctor d = new Doctor();
					d.setId(rs.getInt("user_id"));
					d.username = rs.getString("username");
					d.passwordHash = rs.getString("password_hash");
					d.email = rs.getString("email");
					d.role = rs.getString("role");
					d.licenseNumber = rs.getString("license_number");
					d.specialization = rs.getString("specialization");
					d.available = rs.getBoolean("available");
					d.rating = rs.getDouble("rating");
					d.reviewsCount = rs.getInt("reviews_count");
					d.yearsOfExperience = rs.getInt("years_experience");
					d.consultationFee = rs.getDouble("consultation_fee");
					d.specialNotes = rs.getString("special_notes");
					return d;
				}
			}
		}
		return null;
	}

	/**
	 * Retrieves all available doctors.
	 */
	public static List<Doctor> findAllAvailable() throws SQLException {
		List<Doctor> list = new ArrayList<>();
		String sql = "SELECT u.id AS user_id, u.username, u.password_hash, u.email, u.role, "
				+ "d.license_number, d.specialization, d.available, d.rating, d.reviews_count, d.years_experience, d.consultation_fee, d.special_notes "
				+ "FROM users u JOIN doctors d ON u.id = d.user_id WHERE d.available = TRUE";
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Doctor d = new Doctor();
				d.setId(rs.getInt("user_id"));
				d.username = rs.getString("username");
				d.passwordHash = rs.getString("password_hash");
				d.email = rs.getString("email");
				d.role = rs.getString("role");
				d.licenseNumber = rs.getString("license_number");
				d.specialization = rs.getString("specialization");
				d.available = rs.getBoolean("available");
				d.rating = rs.getDouble("rating");
				d.reviewsCount = rs.getInt("reviews_count");
				d.yearsOfExperience = rs.getInt("years_experience");
				d.consultationFee = rs.getDouble("consultation_fee");
				d.specialNotes = rs.getString("special_notes");
				list.add(d);
			}
		}
		return list;
	}

	/**
	 * Retrieves all doctors.
	 */
	public static List<Doctor> findAllDoctors() throws SQLException {
		List<Doctor> list = new ArrayList<>();
		String sql = "SELECT u.id AS user_id, u.username, u.password_hash, u.email, u.role, "
				+ "d.license_number, d.specialization, d.available, d.rating, d.reviews_count, d.years_experience, d.consultation_fee, d.special_notes "
				+ "FROM users u JOIN doctors d ON u.id = d.user_id";
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Doctor d = new Doctor();
				d.setId(rs.getInt("user_id"));
				d.username = rs.getString("username");
				d.passwordHash = rs.getString("password_hash");
				d.email = rs.getString("email");
				d.role = rs.getString("role");
				d.licenseNumber = rs.getString("license_number");
				d.specialization = rs.getString("specialization");
				d.available = rs.getBoolean("available");
				d.rating = rs.getDouble("rating");
				d.reviewsCount = rs.getInt("reviews_count");
				d.yearsOfExperience = rs.getInt("years_experience");
				d.consultationFee = rs.getDouble("consultation_fee");
				d.specialNotes = rs.getString("special_notes");
				list.add(d);
			}
		}
		return list;
	}

	/**
	 * @return number of available doctors
	 */
	public static int getAvailableDoctorsCount() {
		String sql = "SELECT COUNT(*) AS doctor_count FROM doctors WHERE available = TRUE";
		int count = 0;
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			if (rs.next()) {
				count = rs.getInt("doctor_count");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
}
