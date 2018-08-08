package co.com.bancodebogota.app.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import co.com.bancodebogota.app.dto.CurrierDto;
import co.com.bancodebogota.app.mapper.CurrierMapper;
import co.com.bancodebogota.app.model.Currier;
import co.com.bancodebogota.app.model.repository.CurrierRepository;

@Service
public class CurrierProxy {

	@Autowired
	private CurrierRepository authorizeRepository;
	
	@Autowired
	private CurrierMapper authorizeMapper;

	public ResponseEntity<ObjectNode> saveCheckCustomer(CurrierDto currierDto) {
		Currier authorizeAnswer = authorizeRepository.save(authorizeMapper.mapCurrierEntity(currierDto));
		if (authorizeAnswer != null && authorizeAnswer.getId() != null) {
			return createResponseEntity(HttpStatus.OK, "Process Succes", authorizeAnswer.getId());
		} else {
			return createResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR, "Process Fail", null);
		}
	}

	private ResponseEntity<ObjectNode> createResponseEntity(HttpStatus status, String detailError,
			Integer codeProcess) {
		ObjectMapper objectMapper = new ObjectMapper();
		ObjectNode responseFormat = objectMapper.createObjectNode();
		responseFormat.put("statusDesc", detailError);
		responseFormat.put("codeProcess", codeProcess);
		return new ResponseEntity<>(responseFormat, status);
	}

}