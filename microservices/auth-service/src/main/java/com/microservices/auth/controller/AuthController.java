package com.microservices.auth.controller;

import com.microservices.auth.model.AuthResponse;
import com.microservices.auth.model.LoginRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    // In-memory storage for demo purposes
    private final Map<String, String> tokens = new HashMap<>();

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "auth-service");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        // Simple validation - in production, this would check against a database
        if (request.getUsername() != null && request.getPassword() != null) {
            String token = UUID.randomUUID().toString();
            tokens.put(token, request.getUsername());
            
            AuthResponse response = new AuthResponse();
            response.setToken(token);
            response.setUsername(request.getUsername());
            response.setMessage("Login successful");
            
            return ResponseEntity.ok(response);
        }
        
        return ResponseEntity.badRequest().build();
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateToken(@RequestHeader("Authorization") String token) {
        Map<String, Object> response = new HashMap<>();
        
        if (tokens.containsKey(token)) {
            response.put("valid", true);
            response.put("username", tokens.get(token));
            return ResponseEntity.ok(response);
        }
        
        response.put("valid", false);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(@RequestHeader("Authorization") String token) {
        tokens.remove(token);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Logout successful");
        return ResponseEntity.ok(response);
    }
}

