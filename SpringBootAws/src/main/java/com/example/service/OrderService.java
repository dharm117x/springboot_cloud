package com.example.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.example.model.OrderTo;

@Service
public class OrderService {
	private static final Logger LOG = LoggerFactory.getLogger(OrderService.class);

	private final JdbcTemplate jdbcTemplate;

	public OrderService(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	public List<OrderTo> getAllOrders() {
		LOG.info("Fetching all orders from the database");
		List<OrderTo> list = jdbcTemplate.query("SELECT * FROM orders", (rs, rowNum) -> {
			OrderTo order = new OrderTo();
			order.setId(rs.getString("id"));
			order.setUserId(rs.getString("user_id"));
			order.setProduct(rs.getString("product"));
			order.setQuantity(rs.getInt("quantity"));
			order.setTotal(rs.getDouble("total"));
			return order;
		});

		return list;
	}

	public void deleteOrder(String id) {
		LOG.info("Deleting order with id: {}", id);
		int update = jdbcTemplate.update("DELETE FROM orders WHERE id = ?", id);
		if (update > 0) {
			LOG.info("Order with id {} deleted successfully", id);
		} else {
			LOG.warn("No order found with id {}", id);
		}
	}

	public void updateOrder(String id, OrderTo orderTo) {
		LOG.info("Updating order with id: {}", id);
		if (id == null) {
			LOG.info("Creating new order for product: {}", orderTo.getProduct());
			int insert = jdbcTemplate.update(
					"INSERT INTO orders (id, user_id, product, quantity, total) VALUES (?, ?, ?, ?, ?)", orderTo.getId(), orderTo.getUserId(),
					orderTo.getProduct(), orderTo.getQuantity(), orderTo.getTotal());
			if (insert > 0) {
				LOG.info("New order created successfully for product: {}", orderTo.getProduct());
			} else {
				LOG.error("Failed to create new order for product: {}", orderTo.getProduct());
			}
			return;
		} else {
			int update = jdbcTemplate.update("UPDATE orders SET product = ?, quantity = ?, total = ? WHERE id = ?",
					orderTo.getProduct(), orderTo.getQuantity(), orderTo.getTotal(), id);
			if (update > 0) {
				LOG.info("Order with id {} updated successfully", id);
			} else {
				LOG.warn("No order found with id {}", id);
			}
		}
	}

}