package com.example.resource;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.handler.annotation.Header;

import com.example.model.OrderTo;
import com.example.model.UserTo;

import io.awspring.cloud.sqs.annotation.SqsListener;

@Configuration
public class SqsConsumerService {
	
	//@SqsListener("my-queue")
	public void getStringData(String payload, @Header(value = "SenderId", required = false) String senderId) {
	    System.out.println("JSON Object: " + payload);
	    System.out.println("From: " + senderId);
	}	
	
	@SqsListener("my-user-queue")
	public void getUSerData(UserTo payload, @Header(value = "SenderId", required = false) String senderId) {
	    System.out.println("JSON Object: " + payload);
	    System.out.println("From: " + senderId);
	}	
	
	@SqsListener("my-order-queue")
	public void getOrderData(OrderTo payload, @Header(value = "SenderId", required = false) String senderId) {
	    System.out.println("JSON Object: " + payload);
	    System.out.println("From: " + senderId);
	}	
	
}
