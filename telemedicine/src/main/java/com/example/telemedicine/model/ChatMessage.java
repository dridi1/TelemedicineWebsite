package com.example.telemedicine.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.telemedicine.util.DatabaseUtil;

public class ChatMessage {
    private int id;
    private int conversationId;
    private int senderId;
    private String content;
    private Timestamp sentAt;
    
    

    // … getters & setters …

    public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getConversationId() {
		return conversationId;
	}

	public void setConversationId(int conversationId) {
		this.conversationId = conversationId;
	}

	public int getSenderId() {
		return senderId;
	}

	public void setSenderId(int senderId) {
		this.senderId = senderId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getSentAt() {
		return sentAt;
	}

	public void setSentAt(Timestamp sentAt) {
		this.sentAt = sentAt;
	}

	/** Persist this message to the DB */
    public void create() throws SQLException {
        String sql = 
          "INSERT INTO chat_message (conversation_id, sender_id, content) "
        + "VALUES (?, ?, ?) RETURNING id, sent_at";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            ps.setInt(2, senderId);
            ps.setString(3, content);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.id = rs.getInt("id");
                    this.sentAt = rs.getTimestamp("sent_at");
                } else {
                    throw new SQLException("Failed to send message.");
                }
            }
        }
    }

    /** Load all messages in a conversation, oldest first */
    public static List<ChatMessage> getMessages(int conversationId) throws SQLException {
        String sql =
          "SELECT id, sender_id, content, sent_at "
        + "FROM chat_message "
        + "WHERE conversation_id = ? "
        + "ORDER BY sent_at ASC";
        List<ChatMessage> msgs = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage m = new ChatMessage();
                    m.setId(rs.getInt("id"));
                    m.setConversationId(conversationId);
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setContent(rs.getString("content"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    msgs.add(m);
                }
            }
        }
        return msgs;
    }
}
