package co.com.bancodebogota.app.mapper;

import co.com.bancodebogota.app.dto.CurrierDto;
import co.com.bancodebogota.app.model.Currier;

public interface CurrierMapper {

	Currier mapCurrierEntity (CurrierDto currierDto) ;
	
}
