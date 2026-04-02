
package com.example;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import com.fasterxml.jackson.databind.ObjectMapper;

import io.awspring.cloud.sns.core.SnsTemplate;
import io.awspring.cloud.sqs.support.converter.SqsMessagingMessageConverter;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.http.nio.netty.NettyNioAsyncHttpClient;
import software.amazon.awssdk.http.nio.netty.ProxyConfiguration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.sns.SnsAsyncClient;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sqs.SqsAsyncClient;
import software.amazon.awssdk.services.sqs.SqsClient;

@Configuration
@Profile("local")
public class AwsConfigLocal {

    @Value("${aws.accesskey}")
    private String accesskey;

    @Value("${aws.secretkey}")
    private String secretkey;

    @Value("${aws.region}")
    private String region;

    @Value("${proxy.host}")
    private String proxyHost;

    @Value("${proxy.port}")
    private int proxyPort;


    //@Bean
	public SqsMessagingMessageConverter sqsMessagingMessageConverter(ObjectMapper objectMapper) {
		SqsMessagingMessageConverter converter = new SqsMessagingMessageConverter();
		converter.setObjectMapper(objectMapper);
		return converter;
	}
	
    @Bean
    public AwsCredentialsProvider customAwsCredentials() {
        return StaticCredentialsProvider.create(AwsBasicCredentials.create(accesskey, secretkey));
    }

    @Bean
    public SqsClient sqsClient(AwsCredentialsProvider credentialsProvider) {
        return SqsClient.builder()
                .credentialsProvider(credentialsProvider)
                .region(Region.of(region))
                .build();
    }

    @Bean
    public SqsAsyncClient sqsAsyncClient(AwsCredentialsProvider credentialsProvider) {
        return SqsAsyncClient.builder()
                .credentialsProvider(credentialsProvider)
                .region(Region.of(region))
                .build();
    }

    @Bean
    public SnsClient snsClient(AwsCredentialsProvider credentialsProvider) {
        return SnsClient.builder()
        		.credentialsProvider(credentialsProvider)
        		.region(Region.of(region))
        		.build();
    }

    @Bean
    public SnsAsyncClient snsAsyncClient(AwsCredentialsProvider credentialsProvider) {
        return SnsAsyncClient.builder()
        		.credentialsProvider(credentialsProvider)
        		.region(Region.of(region))
        		.build();
    }

    //@Bean
    public SqsAsyncClient sqsAsyncClientWithProxy(AwsCredentialsProvider credentialsProvider) {
        return SqsAsyncClient.builder()
                .credentialsProvider(credentialsProvider)
                .region(Region.of(region))
				.httpClientBuilder(NettyNioAsyncHttpClient.builder()
						.proxyConfiguration(ProxyConfiguration.builder()
						.scheme("http")
	                    .host(proxyHost)
	                    .port(proxyPort)
	                    .build()))
                .build();
    }

    
    @Bean
    public S3Client s3Client(AwsCredentialsProvider credentialsProvider) {
        return S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(credentialsProvider)
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true) // This fixes the SSL error
                        .build())
                .build();
    }
    
    @Bean
    public S3AsyncClient s3AsyncClient(AwsCredentialsProvider credentialsProvider) {
        return S3AsyncClient.builder()
                .region(Region.of(region))
                .credentialsProvider(credentialsProvider)
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true) // This fixes the SSL error
                        .build())
                .build();
    }

    @Bean
    public SnsTemplate snsTemplate(SnsClient client) {
		return new SnsTemplate(client);
	}

}

