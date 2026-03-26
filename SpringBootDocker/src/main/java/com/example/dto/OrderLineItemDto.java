package com.example.dto;
public record OrderLineItemDto(
    String skuCode,
    Double price,
    Integer quantity
) {}

// dto/OrderResponse.java
