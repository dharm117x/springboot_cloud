
package com.example;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.http.nio.netty.NettyNioAsyncHttpClient;
import software.amazon.awssdk.http.nio.netty.ProxyConfiguration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sns.SnsAsyncClient;
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

}

