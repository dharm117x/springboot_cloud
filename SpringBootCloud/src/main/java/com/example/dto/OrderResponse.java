package com.example.dto;

import java.util.List;

public record OrderResponse(
    String orderNumber,
    String status,
    List<OrderLineItemDto> items,
    String message
) {}