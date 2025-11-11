package com.microservices.balance.service;

import com.microservices.balance.model.Balance;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class BalanceService {

    // In-memory storage for demo purposes
    private final Map<String, Balance> balances = new HashMap<>();

    public Balance getBalance(String userId) {
        return balances.computeIfAbsent(userId, id -> {
            Balance balance = new Balance();
            balance.setUserId(id);
            balance.setAmount(0.0);
            balance.setCurrency("USD");
            balance.setLastUpdated(LocalDateTime.now());
            return balance;
        });
    }

    public Balance updateBalance(String userId, Double amount) {
        Balance balance = getBalance(userId);
        balance.setAmount(balance.getAmount() + amount);
        balance.setLastUpdated(LocalDateTime.now());
        return balance;
    }

    public Balance createBalance(String userId) {
        if (balances.containsKey(userId)) {
            return balances.get(userId);
        }

        Balance balance = new Balance();
        balance.setUserId(userId);
        balance.setAmount(100.0); // Initial balance
        balance.setCurrency("USD");
        balance.setLastUpdated(LocalDateTime.now());
        
        balances.put(userId, balance);
        return balance;
    }

    public Map<String, Balance> getAllBalances() {
        return new HashMap<>(balances);
    }
}

