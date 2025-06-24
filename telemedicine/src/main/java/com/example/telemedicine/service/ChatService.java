package com.example.telemedicine.service;

import java.sql.SQLException;
import java.util.List;

import com.example.telemedicine.model.ChatMessage;
import com.example.telemedicine.model.Conversation;


public class ChatService {
    /**
     * Create a new conversation between patient and doctor.
     */
    public Conversation createConversation(int patientId, int doctorId) throws SQLException {
        Conversation conv = new Conversation();
        conv.setPatientId(patientId);
        conv.setDoctorId(doctorId);
        conv.create();
        return conv;
    }

    /**
     * Fetch conversations for a given user.
     */
    public List<Conversation> getConversations(int userId) throws SQLException {
        return Conversation.getConversations(userId);
    }

    public List<Conversation> getConversationsForDoctor(int doctorId) throws SQLException {
        return Conversation.findByDoctorId(doctorId);
    }

    /**
     * Save a chat message in a conversation.
     */
    public ChatMessage saveMessage(int conversationId, int senderId, String content) throws SQLException {
        ChatMessage msg = new ChatMessage();
        msg.setConversationId(conversationId);
        msg.setSenderId(senderId);
        msg.setContent(content);
        msg.create();
        return msg;
    }

    /**
     * Load all messages in a given conversation.
     */
    public List<ChatMessage> getMessages(int conversationId) throws SQLException {
        return ChatMessage.getMessages(conversationId);
    }
}