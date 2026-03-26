package com.example.service;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.example.domain.Order;
import com.example.domain.OrderLineItems;
import com.example.domain.OrderStatus;
import com.example.dto.OrderLineItemDto;
import com.example.dto.OrderRequest;
import com.example.dto.OrderResponse;
import com.example.repository.OrderRepository;

import jakarta.transaction.Transactional;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    

    public OrderService(OrderRepository orderRepository) {
		this.orderRepository = orderRepository;
	}

	@Transactional
    public OrderResponse placeOrder(OrderRequest request) {
        List<OrderLineItems> lineItems = request.items().stream()
                .map(dto -> new OrderLineItems(null, dto.skuCode(), dto.price(), dto.quantity()))
                .toList();

        Order order = new Order();
        order.setOrderNumber(UUID.randomUUID().toString());
        order.setCustomerEmail(request.customerEmail());
        order.setOrderLineItemsList(lineItems);
        order.setStatus(OrderStatus.PLACED);
        orderRepository.save(order);
        return mapToResponse(order, "Order placed successfully!");
    }

    public List<OrderResponse> getAllOrders() {
        return orderRepository.findAll().stream()
                .map(order -> mapToResponse(order, "Retrieved"))
                .toList();
    }

    private OrderResponse mapToResponse(Order order, String message) {
        List<OrderLineItemDto> itemDtos = order.getOrderLineItemsList().stream()
                .map(item -> new OrderLineItemDto(item.getSkuCode(), item.getPrice(), item.getQuantity()))
                .toList();

        return new OrderResponse(
                order.getOrderNumber(),
                order.getStatus().toString(),
                itemDtos,
                message
        );
    }
}
