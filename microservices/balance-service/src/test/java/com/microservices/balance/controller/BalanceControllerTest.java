package com.microservices.balance.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.microservices.balance.model.BalanceUpdateRequest;
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
class BalanceControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testHealthEndpoint() throws Exception {
        mockMvc.perform(get("/api/balance/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"))
                .andExpect(jsonPath("$.service").value("balance-service"));
    }

    @Test
    void testGetBalance() throws Exception {
        mockMvc.perform(get("/api/balance/user123"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("user123"))
                .andExpect(jsonPath("$.amount").exists())
                .andExpect(jsonPath("$.currency").exists());
    }

    @Test
    void testCreateBalance() throws Exception {
        mockMvc.perform(post("/api/balance/create")
                .param("userId", "newuser"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("newuser"))
                .andExpect(jsonPath("$.amount").value(100.0))
                .andExpect(jsonPath("$.currency").value("USD"));
    }

    @Test
    void testUpdateBalance() throws Exception {
        // First create a balance
        mockMvc.perform(post("/api/balance/create")
                .param("userId", "testuser"))
                .andExpect(status().isOk());

        // Then update it
        BalanceUpdateRequest request = new BalanceUpdateRequest("testuser", 50.0);
        
        mockMvc.perform(post("/api/balance/update")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("testuser"))
                .andExpect(jsonPath("$.amount").value(150.0));
    }

    @Test
    void testGetAllBalances() throws Exception {
        mockMvc.perform(get("/api/balance/all"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isMap());
    }
}

