package com.example.model;

import java.io.Serializable;

public class OrderTo implements Serializable {

	private static final long serialVersionUID = 1L;

	private String id;
	private String userId;
	private String product;
	private Integer quantity;
	private Double total;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProduct() {
		return product;
	}

	public void setProduct(String product) {
		this.product = product;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("OrderTo [id=");
		builder.append(id);
		builder.append(", userId=");
		builder.append(userId);
		builder.append(", product=");
		builder.append(product);
		builder.append(", quantity=");
		builder.append(quantity);
		builder.append(", total=");
		builder.append(total);
		builder.append("]");
		return builder.toString();
	}
	
}
