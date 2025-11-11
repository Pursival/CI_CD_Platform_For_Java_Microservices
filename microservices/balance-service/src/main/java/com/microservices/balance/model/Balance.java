package com.microservices.balance.model;

import java.time.LocalDateTime;

public class Balance {
    private String userId;
    private Double amount;
    private String currency;
    private LocalDateTime lastUpdated;

    public Balance() {
    }

    public Balance(String userId, Double amount, String currency) {
        this.userId = userId;
        this.amount = amount;
        this.currency = currency;
        this.lastUpdated = LocalDateTime.now();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}

