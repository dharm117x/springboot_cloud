package com.example.resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.UserTo;
import com.fasterxml.jackson.core.JsonProcessingException;

import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;

@RestController
@RequestMapping("/sns")
public class SnsProducerService {

	@Value("${sns.topic-arn}")
    private String topicArn;

    private final SnsClient snsClient;
    private final SnsPublisherService snsPublisherService;

	public SnsProducerService(SnsClient snsClient, SnsPublisherService snsPublisherService) {
		this.snsClient = snsClient;
		this.snsPublisherService = snsPublisherService;
	}

	@PostMapping("/publish")
	public ResponseEntity<String> publishMessage(String message) {
		PublishRequest request = PublishRequest.builder().topicArn(topicArn).message(message).build();

		PublishResponse response = snsClient.publish(request);
		System.out.println("Message published with ID: " + response.messageId());
		return ResponseEntity.ok("Message published with ID: " + response.messageId());
	}
	
	
    @PostMapping("/producer")
    public ResponseEntity<UserTo> publishAsyncMessage(@RequestBody UserTo userTo) throws JsonProcessingException {
        snsPublisherService.sendMessage(topicArn, userTo);
        return ResponseEntity.ok(userTo);
    }

}