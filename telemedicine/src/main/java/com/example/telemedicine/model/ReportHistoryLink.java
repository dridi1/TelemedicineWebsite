package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.example.telemedicine.util.DatabaseUtil;

public class ReportHistoryLink {
	public static void link(int reportId, int historyId) throws SQLException {
        String sql = "INSERT INTO report_history_link(report_id, history_id) VALUES (?,?) ON CONFLICT DO NOTHING";
        try (Connection c = DatabaseUtil.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, reportId);
            p.setInt(2, historyId);
            p.executeUpdate();
        }
    }
}
	
	
	


