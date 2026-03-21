package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.model.MessageModel;
import com.example.model.OrderTo;
import com.example.model.UserTo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.awspring.cloud.sns.core.SnsTemplate;
import io.awspring.cloud.sqs.operations.SqsTemplate;

@Controller
@RequestMapping("/message")
public class MessagingController {
	

	private final SnsTemplate snsTemplate;
	private final SqsTemplate sqsTemplate;
	private final ObjectMapper objectMapper; 

	public MessagingController(SnsTemplate snsTemplate, SqsTemplate sqsTemplate, ObjectMapper objectMapper) {
		this.snsTemplate = snsTemplate;
		this.sqsTemplate = sqsTemplate;
		this.objectMapper = objectMapper;
	}

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
			String jsonToSend = "{}";
			if ("SNS".equalsIgnoreCase(messageModel.getDestinationType())) {
				snsTemplate.sendNotification("my-topic", messageModel.getContent(), "Subject Line");
			} else {
				if ("USER".equals(messageModel.getDataType())) {
					jsonToSend = getMessage(messageModel, UserTo.class);
					sqsTemplate.send("my-user-queue", jsonToSend);
				} else {
					jsonToSend = getMessage(messageModel, OrderTo.class);
					sqsTemplate.send("my-order-queue", jsonToSend);
				}
			}
			ra.addFlashAttribute("status", "Message sent successfully!");
		} catch (Exception e) {
			ra.addFlashAttribute("status", "Message sent Failed!");
		}

		return "redirect:/message";
	}

	private <T> String getMessage(MessageModel messageModel, Class<T> type) 
	        throws JsonProcessingException {

		T payload = objectMapper.readValue(messageModel.getContent(), type);
	    return objectMapper.writeValueAsString(payload);
	}


}
