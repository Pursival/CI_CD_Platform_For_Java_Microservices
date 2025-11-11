package com.microservices.payment.model;

public class PaymentRequest {
    private String userId;
    private Double amount;
    private String currency;
    private String description;

    public PaymentRequest() {
    }

    public PaymentRequest(String userId, Double amount, String currency, String description) {
        this.userId = userId;
        this.amount = amount;
        this.currency = currency;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

