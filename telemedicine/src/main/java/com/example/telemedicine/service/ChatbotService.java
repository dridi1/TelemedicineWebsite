package com.example.telemedicine.service;

import java.io.IOException;
import java.io.StringReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;

public class ChatbotService {
    // point this to your FastAPI formatted endpoint
    private static final String FORMATTED_URL = "http://localhost:8000/predict/formatted";
    private final HttpClient client = HttpClient.newHttpClient();

    /**
     * Calls FastAPI /predict/formatted with {"texts":[text]}
     * and returns the first human‑readable diagnosis string.
     */
    public String predictFormatted(String text) {
        // 1) build payload: {"texts":[ text ]}
        JsonArray textsArray = Json.createArrayBuilder()
                                   .add(text)
                                   .build();
        JsonObject reqJson = Json.createObjectBuilder()
                                 .add("texts", textsArray)
                                 .build();
        String reqBody = reqJson.toString();

        // 2) send POST
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(FORMATTED_URL))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(reqBody))
            .build();

        try {
            HttpResponse<String> resp =
                client.send(req, HttpResponse.BodyHandlers.ofString());
            if (resp.statusCode() != 200) {
                throw new RuntimeException("Formatted API error: " + resp.statusCode());
            }

            // 3) parse as JSON array of strings
            try (JsonReader jr = Json.createReader(new StringReader(resp.body()))) {
                var arr = jr.readArray();
                if (arr == null || arr.isEmpty()) {
                    throw new RuntimeException("No formatted reply in response");
                }
                // return the first human‑readable sentence
                return arr.getString(0);
            }
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("Error calling formatted API", e);
        }
    }
}
