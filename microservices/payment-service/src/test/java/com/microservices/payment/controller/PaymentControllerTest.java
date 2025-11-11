package com.microservices.payment.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.microservices.payment.model.PaymentRequest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class PaymentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testHealthEndpoint() throws Exception {
        mockMvc.perform(get("/api/payment/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"))
                .andExpect(jsonPath("$.service").value("payment-service"));
    }

    @Test
    void testProcessPayment() throws Exception {
        PaymentRequest request = new PaymentRequest("user123", 100.50, "USD", "Test payment");
        
        mockMvc.perform(post("/api/payment/process")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("user123"))
                .andExpect(jsonPath("$.amount").value(100.50))
                .andExpect(jsonPath("$.currency").value("USD"))
                .andExpect(jsonPath("$.status").value("COMPLETED"));
    }

    @Test
    void testGetPaymentHistory() throws Exception {
        // First create a payment
        PaymentRequest request = new PaymentRequest("user456", 50.0, "EUR", "Test payment");
        
        mockMvc.perform(post("/api/payment/process")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        // Then get payment history
        mockMvc.perform(get("/api/payment/history/user456"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }
}

