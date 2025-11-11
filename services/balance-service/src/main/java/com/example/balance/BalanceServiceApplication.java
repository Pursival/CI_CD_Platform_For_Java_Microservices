package com.example.balance;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
public class BalanceServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(BalanceServiceApplication.class, args);
    }
}

@RestController
class BalanceController {

    private final Map<String, Double> balances = new HashMap<>();

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "balance-service");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        return response;
    }

    @GetMapping("/balance/{userId}")
    public Map<String, Object> getBalance(@PathVariable String userId) {
        Double balance = balances.getOrDefault(userId, 0.0);
        
        Map<String, Object> response = new HashMap<>();
        response.put("userId", userId);
        response.put("balance", balance);
        response.put("currency", "USD");
        
        return response;
    }

    @PostMapping("/balance/{userId}")
    public Map<String, Object> updateBalance(@PathVariable String userId, @RequestBody Map<String, Double> request) {
        Double currentBalance = balances.getOrDefault(userId, 0.0);
        Double amount = request.getOrDefault("amount", 0.0);
        Double newBalance = currentBalance + amount;
        
        balances.put(userId, newBalance);
        
        Map<String, Object> response = new HashMap<>();
        response.put("userId", userId);
        response.put("previousBalance", currentBalance);
        response.put("amount", amount);
        response.put("newBalance", newBalance);
        response.put("currency", "USD");
        
        return response;
    }
}

