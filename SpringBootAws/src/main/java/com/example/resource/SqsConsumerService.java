package com.example.resource;

import org.springframework.context.annotation.Configuration;

import com.example.model.UserDo;

import io.awspring.cloud.sqs.annotation.SqsListener;

@Configuration
public class SqsConsumerService {
	
	//@SqsListener(value = "my-queue")
	public void getData(String meassage) {
		System.out.println("String Message:" + meassage);
	}
	
	@SqsListener(value = "my-queue")
	public void getData(UserDo meassage) {
		System.out.println("Json Message:" + meassage);
	}
	
}
