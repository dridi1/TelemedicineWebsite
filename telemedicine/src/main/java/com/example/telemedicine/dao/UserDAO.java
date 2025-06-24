//package com.example.telemedicine.dao;
//
//import com.example.telemedicine.model.User;
//import com.example.telemedicine.util.DatabaseUtil;
//import java.sql.*;
//
//public class UserDAO {
//	private static final String CREATE_USER_SQL = 
//	        "INSERT INTO users (username, password_hash, email, role, created_at) " +
//	        "VALUES (?, ?, ?, ?, ?) RETURNING id";
//
//	public int createUser(Connection conn, User user) throws SQLException {
//	        try (PreparedStatement stmt = conn.prepareStatement(CREATE_USER_SQL)) {
//	            
//	            stmt.setString(1, user.getUsername());
//	            stmt.setString(2, user.getPasswordHash());
//	            stmt.setString(3, user.getEmail());
//	            stmt.setString(4, user.getRole());
//	            stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
//	            
//	            try(ResultSet rs = stmt.executeQuery()){
//	            	if (rs.next()) {
//	            		return rs.getInt("id");
//	            	} else {
//	            		throw new SQLException("User creation failed");
//	            	}
//	            }
//	        }
//	}
//	
//
//    public User getUserByEmail(String email) throws SQLException {
//        String sql = "SELECT * FROM users WHERE email = ?";
//        try (Connection conn = DatabaseUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, email);
//            ResultSet rs = stmt.executeQuery();
//            
//            if (rs.next()) {
//                User user = new User();
//                user.setId(rs.getInt("id"));
//                user.setUsername(rs.getString("username"));
//                user.setPasswordHash(rs.getString("password_hash"));
//                user.setEmail(rs.getString("email"));
//                user.setRole(rs.getString("role"));
//                return user;
//            }
//            return null;
//        }
//    }
//}