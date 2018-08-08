package co.com.bancodebogota.app.model.repository;


import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import co.com.bancodebogota.app.model.Currier;


public interface CurrierRepository extends CrudRepository<Currier, String> {

	@Query("select a from Currier a ")
	Currier getCurrier();
}
