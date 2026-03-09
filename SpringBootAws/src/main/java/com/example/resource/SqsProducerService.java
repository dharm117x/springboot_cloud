package com.example.resource;

import org.springframework.http.ResponseEntity;
import org.springframework.messaging.Message;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.model.UserDo;

import io.awspring.cloud.sqs.operations.SendResult;
import io.awspring.cloud.sqs.operations.SqsTemplate;

@RestController
@RequestMapping("/sqs")
public class SqsProducerService {
	
	private final SqsTemplate sqsTemplate;
	
	public SqsProducerService(SqsTemplate sqsTemplate) {
		this.sqsTemplate = sqsTemplate;
	}
	
	@PostMapping("/producer")
	public ResponseEntity<UserDo> producer(@RequestBody UserDo userDo) {
		SendResult<UserDo> result = sqsTemplate.send("my-queue", userDo);
		Message<UserDo> message = result.message();
		message.getHeaders().forEach((key, value) -> {
			System.out.println("Header Key: " + key + ", Value: " + value);
		});
		
		return ResponseEntity.ok(message.getPayload());
	}
	
	
}
