package com.microservices.balance.controller;

import com.microservices.balance.model.Balance;
import com.microservices.balance.model.BalanceUpdateRequest;
import com.microservices.balance.service.BalanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/balance")
public class BalanceController {

    @Autowired
    private BalanceService balanceService;

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "balance-service");
        response.put("timestamp", String.valueOf(System.currentTimeMillis()));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<Balance> getBalance(@PathVariable String userId) {
        Balance balance = balanceService.getBalance(userId);
        return ResponseEntity.ok(balance);
    }

    @PostMapping("/update")
    public ResponseEntity<Balance> updateBalance(@RequestBody BalanceUpdateRequest request) {
        Balance balance = balanceService.updateBalance(request.getUserId(), request.getAmount());
        return ResponseEntity.ok(balance);
    }

    @PostMapping("/create")
    public ResponseEntity<Balance> createBalance(@RequestParam String userId) {
        Balance balance = balanceService.createBalance(userId);
        return ResponseEntity.ok(balance);
    }

    @GetMapping("/all")
    public ResponseEntity<Map<String, Balance>> getAllBalances() {
        Map<String, Balance> balances = balanceService.getAllBalances();
        return ResponseEntity.ok(balances);
    }
}

