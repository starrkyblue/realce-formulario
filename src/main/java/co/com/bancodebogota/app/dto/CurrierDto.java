package co.com.bancodebogota.app.dto;

public class CurrierDto {
	
	private Integer customerId;
	
	private String address;
	
	private String typeCreditCard;

	private String typeAddress;

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
