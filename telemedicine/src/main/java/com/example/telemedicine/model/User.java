package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.example.telemedicine.util.DatabaseUtil;

public class User {
	protected int id;
	protected String username;
	protected String passwordHash;
	protected String email;
	protected String role;

	// Constructors
	public User() {
	}

	public User(String username, String passwordHash, String email, String role) {
		this.username = username;
		this.passwordHash = passwordHash;
		this.email = email;
		this.role = role;
	}

	// Getters and Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	@Override
	public String toString() {
		return String.format("User{id=%d, username='%s', email='%s', role='%s'}", id, username, email, role);
	}

	// -------- Active Record CRUD --------

	public int create(Connection conn) throws SQLException {
		String sql = "INSERT INTO users (username, password_hash, email, role, created_at) "
				+ "VALUES (?, ?, ?, ?, ?) RETURNING id";
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			stmt.setString(2, passwordHash);
			stmt.setString(3, email);
			stmt.setString(4, role);
			stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("id");
				} else {
					throw new SQLException("Creating user failed, no ID obtained.");
				}
			}
		}
	}

	public boolean update() throws SQLException {
		if (id == 0)
			throw new IllegalStateException("Cannot update user without ID");
		String sql = "UPDATE users SET username=?, password_hash=?, email=?, role=? WHERE id=?";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			stmt.setString(2, passwordHash);
			stmt.setString(3, email);
			stmt.setString(4, role);
			stmt.setInt(5, id);
			return stmt.executeUpdate() == 1;
		}
	}

	public boolean delete() throws SQLException {
		if (id == 0)
			throw new IllegalStateException("Cannot delete user without ID");
		String sql = "DELETE FROM users WHERE id=?";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			return stmt.executeUpdate() == 1;
		}
	}

	public static String hashPassword(String pass) {
		return BCrypt.hashpw(pass, BCrypt.gensalt());
	}

	public static User findById(int searchId) throws SQLException {
		String sql = "SELECT * FROM users WHERE id = ?";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, searchId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					User u = new User();
					u.id = rs.getInt("id");
					u.username = rs.getString("username");
					u.passwordHash = rs.getString("password_hash");
					u.email = rs.getString("email");
					u.role = rs.getString("role");
					return u;
				}
			}
		}
		return null;
	}

	public static User findByEmail(String email) throws SQLException {
		String sql = "SELECT * FROM users WHERE email = ?";
		try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, email);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					User u = new User();
					u.id = rs.getInt("id");
					u.username = rs.getString("username");
					u.passwordHash = rs.getString("password_hash");
					u.email = rs.getString("email");
					u.role = rs.getString("role");
					return u;
				}
			}
		}
		return null;
	}

	public static List<User> findAll() throws SQLException {
		List<User> list = new ArrayList<>();
		String sql = "SELECT * FROM users";
		try (Connection conn = DatabaseUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				User u = new User();
				u.id = rs.getInt("id");
				u.username = rs.getString("username");
				u.passwordHash = rs.getString("password_hash");
				u.email = rs.getString("email");
				u.role = rs.getString("role");
				list.add(u);
			}
		}
		return list;
	}
}
