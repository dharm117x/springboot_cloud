package com.example.client;

import org.springframework.stereotype.Component;

import com.example.dto.OrderRequest;

@Component
public class InventoryClientFallback implements InventoryClient {
    @Override
    public boolean isStockAvailable(OrderRequest orderRequest) {
        // Default behavior: if inventory is down, assume out of stock (or true for "retry later")
        return true; 
    }
}
