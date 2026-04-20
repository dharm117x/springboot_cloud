package com.example;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import io.awspring.cloud.sns.core.SnsTemplate;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.sns.SnsAsyncClient;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sqs.SqsAsyncClient;
import software.amazon.awssdk.services.sqs.SqsClient;

@Configuration
@Profile("!local")
public class AwsConfig {
	
    @Bean
    public S3Client s3Client() {
        return S3Client.builder()
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true) // This fixes the SSL error
                        .build())
                .build();
    }
    
    @Bean
    public S3AsyncClient s3AsyncClient() {
        return S3AsyncClient.builder()
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true) // This fixes the SSL error
                        .build())
                .build();
    }
    
    @Bean
    public SqsClient sqsClient() {
        return SqsClient.builder()
                .build();
    }

    @Bean
    public SqsAsyncClient sqsAsyncClient() {
        return SqsAsyncClient.builder()
                .build();
    }
    
    @Bean
    public SnsClient snsClient() {
        return SnsClient.builder()
        		.build();
    }

    @Bean
    public SnsAsyncClient snsAsyncClient() {
        return SnsAsyncClient.builder()
        		.build();
    }

    @Bean
    public SnsTemplate snsTemplate(SnsClient client) {
		return new SnsTemplate(client);
	}

}
