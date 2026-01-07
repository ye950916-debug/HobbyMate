package com.springmvc.domain;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

public class Schedule {
	private int eventNo;                
    private String cId;              
    private String registerId;           
    private String eventTitle;         
    private String eventContent;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime startTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime endTime;
    private LocalDateTime createEventDate;
    private int peopleLimit;
    private String eventAddress;
    private String eventDetailAddress;
    private double latitude;
    private double longitude;
    private String sStatus;
	
    
    
    
	public Schedule() {}


	public Schedule(int eventNo, String cId, String registerId, String eventTitle, String eventContent,
			LocalDateTime startTime, LocalDateTime endTime, LocalDateTime createEventDate, int peopleLimit,
			String eventAddress, String eventDetailAddress, double latitude, double longitude, String sStatus) {
		super();
		this.eventNo = eventNo;
		this.cId = cId;
		this.registerId = registerId;
		this.eventTitle = eventTitle;
		this.eventContent = eventContent;
		this.startTime = startTime;
		this.endTime = endTime;
		this.createEventDate = createEventDate;
		this.peopleLimit = peopleLimit;
		this.eventAddress = eventAddress;
		this.eventDetailAddress = eventDetailAddress;
		this.latitude = latitude;
		this.longitude = longitude;
		this.sStatus = sStatus;
	}




	public int getEventNo() {
		return eventNo;
	}

	public void setEventNo(int eventNo) {
		this.eventNo = eventNo;
	}

	public String getcId() {
		return cId;
	}

	public void setcId(String cId) {
		this.cId = cId;
	}

	public String getRegisterId() {
		return registerId;
	}

	public void setRegisterId(String registerId) {
		this.registerId = registerId;
	}

	public String getEventTitle() {
		return eventTitle;
	}

	public void setEventTitle(String eventTitle) {
		this.eventTitle = eventTitle;
	}

	public String getEventContent() {
		return eventContent;
	}

	public void setEventContent(String eventContent) {
		this.eventContent = eventContent;
	}

	public LocalDateTime getStartTime() {
		return startTime;
	}

	public void setStartTime(LocalDateTime startTime) {
		this.startTime = startTime;
	}

	public LocalDateTime getEndTime() {
		return endTime;
	}

	public void setEndTime(LocalDateTime endTime) {
		this.endTime = endTime;
	}

	public LocalDateTime getCreateEventDate() {
		return createEventDate;
	}

	public void setCreateEventDate(LocalDateTime createEventDate) {
		this.createEventDate = createEventDate;
	}

	public int getPeopleLimit() {
		return peopleLimit;
	}

	public void setPeopleLimit(int peopleLimit) {
		this.peopleLimit = peopleLimit;
	}

	public String getEventAddress() {
		return eventAddress;
	}

	public void setEventAddress(String eventAddress) {
		this.eventAddress = eventAddress;
	}

	public String getEventDetailAddress() {
		return eventDetailAddress;
	}

	public void setEventDetailAddress(String eventDetailAddress) {
		this.eventDetailAddress = eventDetailAddress;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public String getsStatus() {
		return sStatus;
	}

	public void setsStatus(String sStatus) {
		this.sStatus = sStatus;
	}


	
	
	@Override
	public String toString() {
		return "Schedule [eventNo=" + eventNo + ", cId=" + cId + ", registerId=" + registerId + ", eventTitle="
				+ eventTitle + ", eventContent=" + eventContent + ", startTime=" + startTime + ", endTime=" + endTime
				+ ", createEventDate=" + createEventDate + ", peopleLimit=" + peopleLimit + ", eventAddress="
				+ eventAddress + ", eventDetailAddress=" + eventDetailAddress + ", latitude=" + latitude
				+ ", longitude=" + longitude + ", sStatus=" + sStatus + "]";
	}



}
