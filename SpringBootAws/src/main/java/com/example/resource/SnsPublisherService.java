package com.example.resource;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

import org.springframework.stereotype.Service;

import com.example.model.UserTo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import software.amazon.awssdk.services.sns.SnsAsyncClient;
import software.amazon.awssdk.services.sns.model.MessageAttributeValue;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;

@Service
public class SnsPublisherService {

	private final SnsAsyncClient snsAsyncClient;
	private ObjectMapper objectMapper = new ObjectMapper();
	
	public SnsPublisherService(SnsAsyncClient snsClient) {
		this.snsAsyncClient = snsClient;
	}

	public void sendMessage(String topicArn, UserTo message) throws JsonProcessingException {
		
		Map<String, MessageAttributeValue> msgAttr = Map.of(
				"eventType",
				MessageAttributeValue.builder().dataType("String").stringValue("orderCreated").build(),
				"priority", 
				MessageAttributeValue.builder().dataType("String").stringValue("high").build());
		
		CompletableFuture<PublishResponse> publish = snsAsyncClient.publish(PublishRequest.builder()
				.topicArn(topicArn)
				.message(objectMapper.writeValueAsString(message))
				.messageAttributes(msgAttr )
				.build());
		
		publish.whenComplete((response, exception) -> {	
			if (exception != null) {
                System.err.println("Failed to publish message: " + exception.getMessage());
            } else {
                System.out.println("Message ASY published with ID: " + response.messageId());
            }
		});
	}
}
