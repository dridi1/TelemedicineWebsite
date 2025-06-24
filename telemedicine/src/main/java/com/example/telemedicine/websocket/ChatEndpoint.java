package com.example.telemedicine.websocket;

import java.io.IOException;
import java.io.StringReader;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.json.Json;
import javax.json.JsonObject;

import com.example.telemedicine.model.ChatMessage;
import com.example.telemedicine.service.ChatService;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/ws/chat/{conversationId}/{userId}")
public class ChatEndpoint {
    // track all sessions per conversation
    private static final Map<Integer, Set<Session>> conversationSessions = new ConcurrentHashMap<>();

    // just new it up—no @Inject needed
    private final ChatService chatService = new ChatService();

    @OnOpen
    public void onOpen(Session session,
                       @PathParam("conversationId") int convId,
                       @PathParam("userId") int userId) {
        conversationSessions
          .computeIfAbsent(convId, k -> ConcurrentHashMap.newKeySet())
          .add(session);
    }

    @OnMessage
    public void onMessage(Session session,
                          @PathParam("conversationId") int convId,
                          @PathParam("userId") int senderId,
                          String messageText) throws IOException {
        // Parse JSON-P
        JsonObject in = Json.createReader(new StringReader(messageText)).readObject();
        String content = in.getString("content");
        
        System.out.println(content);

        try {
            // Persist via your service
            ChatMessage saved = chatService.saveMessage(convId, senderId, content);

            // Build response JSON
            JsonObject resp = Json.createObjectBuilder()
                .add("id", saved.getId())
                .add("conversationId", convId)
                .add("senderId", senderId)
                .add("content", saved.getContent())
                .add("sentAt", saved.getSentAt().toInstant().toString())
                .build();
            String payload = resp.toString();

            // Broadcast to everyone in this conversation
            for (Session s : conversationSessions.getOrDefault(convId, Collections.emptySet())) {
                s.getAsyncRemote().sendText(payload);
            }
        } catch (Exception e) {
            JsonObject err = Json.createObjectBuilder()
                                .add("error", e.getMessage())
                                .build();
            session.getAsyncRemote().sendText(err.toString());
        }
    }

    @OnClose
    public void onClose(Session session,
                        @PathParam("conversationId") int convId) {
        Set<Session> sessions = conversationSessions.get(convId);
        if (sessions != null) {
            sessions.remove(session);
            if (sessions.isEmpty()) {
                conversationSessions.remove(convId);
            }
        }
    }

    @OnError
    public void onError(Session session, Throwable t) {
        t.printStackTrace();
    }
}
