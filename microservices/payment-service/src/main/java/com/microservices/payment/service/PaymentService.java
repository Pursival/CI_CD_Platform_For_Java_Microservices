package com.microservices.payment.service;

import com.microservices.payment.model.Payment;
import com.microservices.payment.model.PaymentRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PaymentService {

    // In-memory storage for demo purposes
    private final Map<String, Payment> payments = new HashMap<>();
    private final WebClient webClient;

    public PaymentService() {
        this.webClient = WebClient.builder().build();
    }

    public Payment processPayment(PaymentRequest request) {
        // Create payment
        Payment payment = new Payment();
        payment.setId(UUID.randomUUID().toString());
        payment.setUserId(request.getUserId());
        payment.setAmount(request.getAmount());
        payment.setCurrency(request.getCurrency());
        payment.setStatus("COMPLETED");
        payment.setTimestamp(LocalDateTime.now());
        payment.setDescription(request.getDescription());

        // Store payment
        payments.put(payment.getId(), payment);

        // In real scenario, we would call Balance Service to update balance
        // updateBalanceService(request.getUserId(), request.getAmount());

        return payment;
    }

    public List<Payment> getPaymentHistory(String userId) {
        return payments.values().stream()
                .filter(p -> p.getUserId().equals(userId))
                .sorted(Comparator.comparing(Payment::getTimestamp).reversed())
                .collect(Collectors.toList());
    }

    public Payment getPayment(String paymentId) {
        return payments.get(paymentId);
    }

    // Method to call Balance Service (for demonstration)
    private void updateBalanceService(String userId, Double amount) {
        // This would make a REST call to balance-service
        // webClient.post()
        //     .uri("http://balance-service:8083/api/balance/update")
        //     .bodyValue(Map.of("userId", userId, "amount", amount))
        //     .retrieve()
        //     .bodyToMono(Void.class)
        //     .block();
    }
}

