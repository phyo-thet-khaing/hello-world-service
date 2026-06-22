package com.ptk.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldServiceController {
	
	@GetMapping("/helloworld")
	public String index()
	{
		return "helloworld-service";
	}
}
