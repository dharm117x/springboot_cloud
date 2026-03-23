package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.service.S3Service;

@Controller
@RequestMapping("/s3")
public class S3FileController {

    @Autowired
    private S3Service s3Service;
    
    // Automatically populates the dropdown in the UI on every request
    @ModelAttribute("buckets")
    public List<String> getBuckets() {
        return s3Service.getBuckets();
    }

    @GetMapping
    public String page() {
        return "s3bucket";
    }

    // Updated to accept a specific bucketName
    @GetMapping("/files")
    public String listFiles(@RequestParam("bucketName") String bucketName, Model model, RedirectAttributes ra) {
        try {
        	model.addAttribute("selectedBucket", bucketName);
            model.addAttribute("files", s3Service.getFiles(bucketName));
            model.addAttribute("selectedBucket", bucketName); // Keeps track of which bucket we are viewing
        } catch (Exception e) {
            ra.addFlashAttribute("message", "Error fetching files: " + e.getMessage());
            return "redirect:/s3";
        }
        return "s3bucket";
    }
    
    // Updated to accept bucketName from the form
    @PostMapping("/upload")
    public String uploadFile(@RequestParam("file") MultipartFile file, 
                             @RequestParam("bucketName") String bucketName, 
                             RedirectAttributes ra) {
        try {
            s3Service.uploadFile(bucketName, file);
            ra.addFlashAttribute("message", "Uploaded to " + bucketName + " successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("message", "Upload Failed: " + e.getMessage());
        }
        return "redirect:/s3";
    }

    // Updated to accept bucketName for download
    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadFile(@RequestParam("bucketName") String bucketName, 
                                               @RequestParam("fileName") String fileName) {
        try {
            byte[] data = s3Service.downloadFile(bucketName, fileName);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(data);
        } catch (Exception e) {
            return ResponseEntity.status(404).build();
        }
    }
    
    @GetMapping("/delete")
    public String deleteFile(@RequestParam("bucketName") String bucketName, 
                             @RequestParam("fileName") String fileName, 
                             RedirectAttributes ra) {
        try {
            s3Service.deleteFile(bucketName, fileName);
            ra.addFlashAttribute("message", "File '" + fileName + "' deleted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("message", "Delete Failed: " + e.getMessage());
        }
        // Redirect back to the file list for the same bucket
        return "redirect:/s3/files?bucketName=" + bucketName;
    }
}
