package co.com.bancodebogota.app.model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "currier")
@NamedQuery(name = "Currier.findAll", query = "SELECT a FROM Currier a")
public class Currier implements Serializable {

	private static final long serialVersionUID = 1L; 

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Integer id;

	@Column(name = "customer_id")
	private Integer customerId;

	@Column(name = "address")
	private String address;
	
	@Column(name = "type_credit_card")
	private String typeCreditCard;

	@Column(name = "type_address")
	private String typeAddress;

	public Currier() {
		// default constructor
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTypeCreditCard() {
		return typeCreditCard;
	}

	public void setTypeCreditCard(String typeCreditCard) {
		this.typeCreditCard = typeCreditCard;
	}

	public String getTypeAddress() {
		return typeAddress;
	}

	public void setTypeAddress(String typeAddress) {
		this.typeAddress = typeAddress;
	}
	

}
