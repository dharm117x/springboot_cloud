package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.model.OrderTo;
import com.example.service.OrderService;

@Controller
@RequestMapping("/orders")
public class OrderController {
    
    private final OrderService orderService;
    public OrderController(OrderService orderService) { this.orderService = orderService; }


    @GetMapping
    public String getAllOrders(ModelMap model) {
        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("order", new OrderTo()); // Add an empty order for the form
        return "orders";
    }

    @GetMapping("/edit/{id}")
    public String editOrder(@PathVariable("id") String id, ModelMap model) {
        OrderTo order = orderService.getAllOrders().stream()
                .filter(o -> o.getId().equals(id)).findFirst().orElse(new OrderTo());
        model.addAttribute("order", order); // The selected order to edit
        model.addAttribute("orders", orderService.getAllOrders()); // Still need the list
        return "orders"; // Stay on the same page
    }

    @PostMapping("/update") // Changed to Post for easier form handling
    public String updateOrder(OrderTo orderTo) {
        // If ID exists, service should update; if null, service should create
        orderService.updateOrder(orderTo.getId(), orderTo); 
        return "redirect:/orders";
    }

    @GetMapping("/delete/{id}") // Changed to Get so a simple <a> tag works
    public String deleteOrder(@PathVariable("id") String id) {
        orderService.deleteOrder(id);
        return "redirect:/orders";
    }
}
