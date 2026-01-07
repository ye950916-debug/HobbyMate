package com.springmvc.domain;

import java.time.LocalDateTime;

public class ClubMember {
	private int cmCId;					//club 아이디
	private String cmMId;				//member 아이디
	private String cmRole;				//모임 내에서 역할
	private LocalDateTime cmJoinDate;	//모임 가입 날짜
	private String cmStatus;			//모임에서의 활동 상태
	

	
	//생성자
	public ClubMember(int cmCId, String cmMId, String cmRole, LocalDateTime cmJoinDate, String cmStatus) {
		super();
		this.cmCId = cmCId;
		this.cmMId = cmMId;
		this.cmRole = cmRole;
		this.cmJoinDate = cmJoinDate;
		this.cmStatus = cmStatus;
	}
	
	public ClubMember() {
		super();
	}

	
	//getter setter
	
	public int getCmCId() {
		return cmCId;
	}

	public void setCmCId(int cmCId) {
		this.cmCId = cmCId;
	}

	public String getCmMId() {
		return cmMId;
	}

	public void setCmMId(String cmMId) {
		this.cmMId = cmMId;
	}

	public String getCmRole() {
		return cmRole;
	}

	public void setCmRole(String cmRole) {
		this.cmRole = cmRole;
	}

	public LocalDateTime getCmJoinDate() {
		return cmJoinDate;
	}

	public void setCmJoinDate(LocalDateTime cmJoinDate) {
		this.cmJoinDate = cmJoinDate;
	}

	public String getCmStatus() {
		return cmStatus;
	}

	public void setCmStatus(String cmStatus) {
		this.cmStatus = cmStatus;
	}

	
	//toString
	@Override
	public String toString() {
		return "ClubMember [cmCId=" + cmCId + ", cmMId=" + cmMId + ", cmRole=" + cmRole + ", cmJoinDate=" + cmJoinDate
				+ ", cmStatus=" + cmStatus + "]";
	}
	
}
