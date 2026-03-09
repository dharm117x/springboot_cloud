package com.example;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.providers.AwsProfileRegionProvider;
import software.amazon.awssdk.regions.providers.AwsRegionProvider;

@Configuration
@Profile("!local")
public class AwsConfig {

	@Bean
	public AwsCredentialsProvider customAwsCredentialsProvider() {
		return DefaultCredentialsProvider.builder().build();
	}

	@Bean
	public AwsRegionProvider customRegionProvider() {
		return new AwsProfileRegionProvider();
	}

}
