package co.com.bancodebogota.app.mapper.impl;

import org.springframework.stereotype.Service;

import co.com.bancodebogota.app.dto.CurrierDto;
import co.com.bancodebogota.app.mapper.CurrierMapper;
import co.com.bancodebogota.app.model.Currier;

@Service
public class CurrierMapperImpl implements CurrierMapper{

	public Currier mapCurrierEntity (CurrierDto currierDto) {	
		Currier currierEntity = new Currier();
		currierEntity.setAddress(currierDto.getAddress());
		currierEntity.setCustomerId(currierDto.getCustomerId());
		currierEntity.setTypeAddress(currierDto.getTypeAddress());
		currierEntity.setTypeCreditCard(currierDto.getTypeCreditCard());
		return currierEntity;
	}
}
