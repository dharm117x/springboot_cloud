package com.example.resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SnsConsumerService {

    @PostMapping("/sns/notification")
    public void receiveNotification(@RequestBody String payload) {
        System.out.println("Received SNS message: " + payload);
    }
}