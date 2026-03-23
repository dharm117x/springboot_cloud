package com.example.service;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.Bucket;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Object;

@Service
public class S3Service {

    // Default bucket from properties (used if no bucket is selected)
    @Value("${aws.s3.bucket}")
    private String defaultBucketName;

    private final S3Client s3Client;

    public S3Service(S3Client s3Client) {
        this.s3Client = s3Client;
    }
    
    public List<String> getBuckets() {
        List<Bucket> buckets = s3Client.listBuckets().buckets();
        if (buckets == null || buckets.isEmpty()) {
            throw new RuntimeException("No S3 buckets found in this AWS account.");
        }
        return buckets.stream()
                .map(Bucket::name)
                .collect(Collectors.toList());
    }


    // Updated: Accept bucketName as parameter
    public List<String> getFiles(String bucketName) {
        ListObjectsV2Request listRequest = ListObjectsV2Request.builder()
                .bucket(bucketName)
                .build();
        return s3Client.listObjectsV2(listRequest)
                .contents().stream()
                .map(S3Object::key)
                .collect(Collectors.toList());
    }

    // Updated: Accept bucketName as parameter
    public void uploadFile(String bucketName, MultipartFile file) throws IOException {
        PutObjectRequest putRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(file.getOriginalFilename())
                .build();

        s3Client.putObject(putRequest, RequestBody.fromBytes(file.getBytes()));	
    }
    
    public void deleteFile(String bucketName, String key) {
        s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build());
    }

    // Updated: Accept bucketName as parameter
    public byte[] downloadFile(String bucketName, String key) {
        ResponseBytes<GetObjectResponse> objectBytes =
                s3Client.getObjectAsBytes(GetObjectRequest.builder()
                        .bucket(bucketName)
                        .key(key)
                        .build());
        return objectBytes.asByteArray();
    }
}
