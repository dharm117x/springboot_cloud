package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.MessageModel;
import com.example.service.SnsSqsService;

@Controller
@RequestMapping("/message")
public class MessagingController {
	
	@Autowired
	private SnsSqsService snsSqsService;
	

	@ModelAttribute("model")
	public MessageModel initModel() {
		MessageModel messageModel = new MessageModel();
		messageModel.setDataType("USER");
		messageModel.setDestinationType("SQS");
		return messageModel;
	}

	@GetMapping
	public String page(Model model) {
		
		return "message";
	}

	@PostMapping("/produce")
	public String produceMessage(@ModelAttribute("model") MessageModel messageModel, RedirectAttributes ra) {
		try {
			if ("SNS".equals(messageModel.getDestinationType())) {
				snsSqsService.sendSNSMessage(messageModel);
			} else {
				snsSqsService.sendSQSMessage(messageModel);
			}
			
			ra.addFlashAttribute("status", "Message sent successfully!");
		} catch (Exception e) {
			ra.addFlashAttribute("status", "Message sent Failed!");
		}

		return "redirect:/message";
	}

}
