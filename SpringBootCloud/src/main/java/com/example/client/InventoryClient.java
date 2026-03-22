package com.example.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.example.dto.OrderRequest;

@FeignClient(name = "inventory-service", fallback = InventoryClientFallback.class)
public interface InventoryClient {
	
    @PostMapping("/api/inventory/validate")
    boolean isStockAvailable(@RequestBody OrderRequest orderRequest);
}
