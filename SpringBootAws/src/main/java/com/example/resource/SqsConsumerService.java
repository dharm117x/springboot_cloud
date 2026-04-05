package com.example.resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Service;

import com.example.model.OrderTo;
import com.example.model.UserTo;
import com.example.service.OrderService;

import io.awspring.cloud.sqs.annotation.SqsListener;

@Service
public class SqsConsumerService {
    private static final Logger LOG = LoggerFactory.getLogger(SqsConsumerService.class);
    
    private final OrderService orderService;
    
	public SqsConsumerService(OrderService orderService) {
		this.orderService = orderService;
	}
	
	//@SqsListener("my-queue")
	public void getStringData(String payload, @Header(value = "SenderId", required = false) String senderId) {
	    LOG.info("JSON Object: " + payload);
	    LOG.info("From: " + senderId);
	}	
	
	@SqsListener("my-user-queue")
	public void getUSerData(UserTo payload, @Header(value = "SenderId", required = false) String senderId) {
	    LOG.info("JSON Object: " + payload);
	    LOG.info("From: " + senderId);
	}	
	
	@SqsListener("my-order-queue")
	public void getOrderData(OrderTo payload, @Header(value = "SenderId", required = false) String senderId) {
		LOG.info("JSON Object: " + payload);
	    try {
	    	if(payload.getTotal() <=0) {
	    		throw new RuntimeException("Amount should not be negetive");
	    	}
		} catch (Exception e) {
			LOG.error("Error", e, e.getMessage());
			throw e;
		}
	    orderService.updateOrder(null, payload);
	}
}
