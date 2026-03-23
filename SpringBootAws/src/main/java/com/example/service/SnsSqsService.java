package com.example.service;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.model.MessageModel;
import com.example.model.OrderTo;
import com.example.model.UserTo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.awspring.cloud.sns.core.SnsNotification;
import io.awspring.cloud.sns.core.SnsTemplate;
import io.awspring.cloud.sqs.operations.SqsTemplate;
import software.amazon.awssdk.services.sns.SnsAsyncClient;
import software.amazon.awssdk.services.sns.model.MessageAttributeValue;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;

@Service
public class SnsSqsService {
	
	@Value("${sns.topic-arn}")
    private String topicArn;

	@Autowired
	private SnsTemplate snsTemplate;
	@Autowired
	private SqsTemplate sqsTemplate;
	@Autowired
	private SnsAsyncClient snsAsyncClient;
	@Autowired
	private ObjectMapper objectMapper;
	
	
	public void sendSQSMessage(MessageModel messageModel) throws JsonProcessingException {
		if ("USER".equals(messageModel.getDataType())) {
			String jsonToSend = getMessage(messageModel, UserTo.class);
			sqsTemplate.send("my-user-queue", jsonToSend);
		} else {
			String jsonToSend = getMessage(messageModel, OrderTo.class);
			sqsTemplate.send("my-order-queue", jsonToSend);
		}
	}
	
	public void sendSNSMessage(MessageModel messageModel) throws JsonProcessingException {
		if ("USER".equals(messageModel.getDataType())) {
			String jsonToSend = getMessage(messageModel, UserTo.class);
			sendSnsMessageByClinet(topicArn, jsonToSend, "UserType");
		} else {
			String jsonToSend = getMessage(messageModel, OrderTo.class);
			sendSnsMessageByTemplaate1(jsonToSend, "OrderType");
		}
	}
	
	public void sendSnsMessageByTemplaate1(String jsonMessage, String type) {
		SnsNotification<String> notification = SnsNotification.builder(jsonMessage).header("eventType", type).build();
		snsTemplate.sendNotification("my-topic", notification);
	}

	public void sendSnsMessageByTemplaate2(String jsonMessage, String type) {
		snsTemplate.convertAndSend("my-topic", jsonMessage, Map.of("eventType", type));
	}
	
	public void sendSnsMessageByClinet(String topicArn, String message, String type) throws JsonProcessingException {
		Map<String, MessageAttributeValue> msgAttr = Map.of(
				"eventType",
				MessageAttributeValue.builder().dataType("String").stringValue(type).build());
		CompletableFuture<PublishResponse> publish = snsAsyncClient.publish(PublishRequest.builder()
				.topicArn(topicArn)
				.message(message)
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
	
	private <T> String getMessage(MessageModel messageModel, Class<T> type) throws JsonProcessingException {
		T payload = objectMapper.readValue(messageModel.getContent(), type);
	    return objectMapper.writeValueAsString(payload);
	}

}
