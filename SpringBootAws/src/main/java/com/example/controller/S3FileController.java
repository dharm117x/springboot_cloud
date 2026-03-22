package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Controller
@RequestMapping("/s3")
public class S3FileController {

	@Autowired
	private S3Client s3Client;
	
	@Value("${aws.s3.bucket}")
	private String bucketName;

	@GetMapping
	public String page(Model model) {
		return "s3bucket";
	}

	@PostMapping("/upload")
	public String uploadFile(@RequestParam("file") MultipartFile file, RedirectAttributes ra){
		try {
			PutObjectRequest putRequest = PutObjectRequest.builder()
					.bucket(bucketName).key(file.getOriginalFilename())
					.build();

			s3Client.putObject(putRequest, RequestBody.fromBytes(file.getBytes()));
			ra.addFlashAttribute("message", "File uploaded successfully!");

		} catch (Exception e) {
			ra.addFlashAttribute("message", "File uploaded Failed!" + e.getMessage());
		}
		return "redirect:/s3";
	}

	@GetMapping("/download")
	public ResponseEntity<byte[]> downloadFile(@RequestParam("fileName") String fileName, RedirectAttributes ra) {
		try {
		GetObjectRequest getRequest = GetObjectRequest.builder().bucket(bucketName).key(fileName).build();

		ResponseBytes<GetObjectResponse> s3Object = s3Client.getObjectAsBytes(getRequest);
		ra.addFlashAttribute("message", "File Downloded successfully!");

		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
				.body(s3Object.asByteArray());
		}catch (Exception e) {
			ra.addFlashAttribute("message", "File Download Failed!" + e.getMessage());
		}
		
		return null;
	}
}
