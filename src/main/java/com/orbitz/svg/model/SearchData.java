/**
 * 
 */
package com.orbitz.svg.model;

/**
 * @author adutta
 *
 */
public class SearchData {

	String hotelDate;
	String price;
	
	
	public SearchData(String hotelDate, String price) {
		super();
		this.hotelDate = hotelDate;
		this.price = price;
	}
	public String getHotelDate() {
		return hotelDate;
	}
	public void setHotelDate(String hotelDate) {
		this.hotelDate = hotelDate;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
}
