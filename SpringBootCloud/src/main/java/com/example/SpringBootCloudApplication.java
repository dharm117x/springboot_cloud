package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients(basePackages = "com.example.client") 
public class SpringBootCloudApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootCloudApplication.class, args);
	}

}
