package com.example.payment;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@SpringBootApplication
public class PaymentServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }
}

@RestController
class PaymentController {

    private final Map<String, Map<String, Object>> payments = new HashMap<>();

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "payment-service");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        return response;
    }

    @PostMapping("/process")
    public Map<String, Object> processPayment(@RequestBody Map<String, Object> paymentRequest) {
        String paymentId = UUID.randomUUID().toString();
        
        Map<String, Object> payment = new HashMap<>();
        payment.put("paymentId", paymentId);
        payment.put("userId", paymentRequest.get("userId"));
        payment.put("amount", paymentRequest.get("amount"));
        payment.put("currency", paymentRequest.getOrDefault("currency", "USD"));
        payment.put("status", "COMPLETED");
        payment.put("timestamp", System.currentTimeMillis());
        
        payments.put(paymentId, payment);
        
        return payment;
    }
}

