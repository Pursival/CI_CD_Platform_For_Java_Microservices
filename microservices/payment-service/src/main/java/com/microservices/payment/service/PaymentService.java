package com.microservices.payment.service;

import com.microservices.payment.model.Payment;
import com.microservices.payment.model.PaymentRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PaymentService {

    private static final Logger logger = LoggerFactory.getLogger(PaymentService.class);

    // In-memory storage for demo purposes
    private final Map<String, Payment> payments = new HashMap<>();
    private final WebClient webClient;
    private final String balanceServiceUrl;

    public PaymentService(
            WebClient.Builder webClientBuilder,
            @Value("${services.balance.url:http://localhost:8083}") String balanceServiceUrl) {
        this.webClient = webClientBuilder.build();
        this.balanceServiceUrl = balanceServiceUrl;
        logger.info("PaymentService initialized with Balance Service URL: {}", balanceServiceUrl);
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

        // Call Balance Service to update balance
        try {
            updateBalanceService(request.getUserId(), -request.getAmount());
            logger.info("Balance updated successfully for user: {}", request.getUserId());
        } catch (Exception e) {
            logger.error("Failed to update balance for user: {}. Error: {}", request.getUserId(), e.getMessage());
            // Payment is still processed even if balance update fails
            // In production, you might want to handle this differently (e.g., rollback)
        }

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

    /**
     * Calls Balance Service to update user balance
     * @param userId User ID
     * @param amount Amount to update (negative for deduction, positive for addition)
     */
    private void updateBalanceService(String userId, Double amount) {
        try {
            String url = balanceServiceUrl + "/api/balance/update";
            logger.debug("Calling Balance Service: {} with userId: {}, amount: {}", url, userId, amount);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("userId", userId);
            requestBody.put("amount", amount);

            webClient.post()
                    .uri(url)
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(Void.class)
                    .block();

            logger.info("Successfully updated balance for user: {} with amount: {}", userId, amount);
        } catch (Exception e) {
            logger.error("Error calling Balance Service for user: {}. Error: {}", userId, e.getMessage(), e);
            throw new RuntimeException("Failed to update balance: " + e.getMessage(), e);
        }
    }
}

