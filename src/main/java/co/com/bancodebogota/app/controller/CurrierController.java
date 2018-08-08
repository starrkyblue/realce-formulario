package co.com.bancodebogota.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.node.ObjectNode;

import co.com.bancodebogota.app.dto.CurrierDto;
import co.com.bancodebogota.app.model.service.CurrierProxy;


@CrossOrigin
@RestController
public class CurrierController {
	
	@Autowired
	private CurrierProxy currierProxy;
	
	
	@PostMapping("/save-currier-customer")
	public ResponseEntity<ObjectNode> saveCheckCustomer(@RequestBody CurrierDto authorizeDto) {
		System.out.println(authorizeDto);
		return currierProxy.saveCheckCustomer(authorizeDto);
	}
	
	
	@GetMapping("/healthy")
	public String healthy() {
		return "OK HEALTHY";
	}
}
