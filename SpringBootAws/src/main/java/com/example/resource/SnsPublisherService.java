package com.example.resource;

import java.util.concurrent.CompletableFuture;

import org.springframework.stereotype.Service;

import com.example.model.UserDo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import software.amazon.awssdk.services.sns.SnsAsyncClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;

@Service
public class SnsPublisherService {

	private final SnsAsyncClient snsAsyncClient;
	private ObjectMapper objectMapper = new ObjectMapper();
	
	public SnsPublisherService(SnsAsyncClient snsClient) {
		this.snsAsyncClient = snsClient;
	}

	public void sendMessage(String topicArn, UserDo message) throws JsonProcessingException {
		CompletableFuture<PublishResponse> publish = snsAsyncClient.publish(PublishRequest.builder()
				.topicArn(topicArn)
				.message(objectMapper.writeValueAsString(message))
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
