package com.springmvc.domain;

import java.time.LocalDateTime;

public class ClubDetail {
	private int cId;
	private String cName;
	private String cDescription;
	private LocalDateTime cCreateDate;
	private String cFounderId;
	private int cMaxMembers;
	private int cMemberCount;
	private String cLocation;
	private String cSiDo;
	private String cSiDoCode;
	private String cGuGun;
	private String cGuGunCode;
	private String cDong;
	private String cDongCode;
	private String cMainPlace;
	private String cMainImageName;
	private Integer subId;
	private String subName;
	private Integer midId;
	private String midName;
	private Integer largeId;
	private String largeName;
	private String leaderId;
	
	
	//생성자

	public ClubDetail() {}

	public ClubDetail(int cId, String cName, String cDescription, LocalDateTime cCreateDate, String cFounderId,
			int cMaxMembers, int cMemberCount, String cLocation, String cSiDo, String cSiDoCode, String cGuGun,
			String cGuGunCode, String cDong, String cDongCode, String cMainPlace, String cMainImageName, Integer subId,
			String subName, Integer midId, String midName, Integer largeId, String largeName, String leaderId) {
		super();
		this.cId = cId;
		this.cName = cName;
		this.cDescription = cDescription;
		this.cCreateDate = cCreateDate;
		this.cFounderId = cFounderId;
		this.cMaxMembers = cMaxMembers;
		this.cMemberCount = cMemberCount;
		this.cLocation = cLocation;
		this.cSiDo = cSiDo;
		this.cSiDoCode = cSiDoCode;
		this.cGuGun = cGuGun;
		this.cGuGunCode = cGuGunCode;
		this.cDong = cDong;
		this.cDongCode = cDongCode;
		this.cMainPlace = cMainPlace;
		this.cMainImageName = cMainImageName;
		this.subId = subId;
		this.subName = subName;
		this.midId = midId;
		this.midName = midName;
		this.largeId = largeId;
		this.largeName = largeName;
		this.leaderId = leaderId;
	}




	//getter setter


	public int getcId() {
		return cId;
	}

	public void setcId(int cId) {
		this.cId = cId;
	}


	public String getcName() {
		return cName;
	}


	public void setcName(String cName) {
		this.cName = cName;
	}


	public String getcDescription() {
		return cDescription;
	}


	public void setcDescription(String cDescription) {
		this.cDescription = cDescription;
	}


	public LocalDateTime getcCreateDate() {
		return cCreateDate;
	}


	public void setcCreateDate(LocalDateTime cCreateDate) {
		this.cCreateDate = cCreateDate;
	}


	public String getcFounderId() {
		return cFounderId;
	}


	public void setcFounderId(String cFounderId) {
		this.cFounderId = cFounderId;
	}


	public int getcMaxMembers() {
		return cMaxMembers;
	}


	public void setcMaxMembers(int cMaxMembers) {
		this.cMaxMembers = cMaxMembers;
	}


	public int getcMemberCount() {
		return cMemberCount;
	}


	public void setcMemberCount(int cMemberCount) {
		this.cMemberCount = cMemberCount;
	}


	public String getcLocation() {
		return cLocation;
	}


	public void setcLocation(String cLocation) {
		this.cLocation = cLocation;
	}


	public String getcSiDo() {
		return cSiDo;
	}


	public void setcSiDo(String cSiDo) {
		this.cSiDo = cSiDo;
	}


	public String getcSiDoCode() {
		return cSiDoCode;
	}


	public void setcSiDoCode(String cSiDoCode) {
		this.cSiDoCode = cSiDoCode;
	}


	public String getcGuGun() {
		return cGuGun;
	}


	public void setcGuGun(String cGuGun) {
		this.cGuGun = cGuGun;
	}
	

	public String getcGuGunCode() {
		return cGuGunCode;
	}


	public void setcGuGunCode(String cGuGunCode) {
		this.cGuGunCode = cGuGunCode;
	}


	public String getcDong() {
		return cDong;
	}


	public void setcDong(String cDong) {
		this.cDong = cDong;
	}


	public String getcDongCode() {
		return cDongCode;
	}


	public void setcDongCode(String cDongCode) {
		this.cDongCode = cDongCode;
	}


	public String getcMainPlace() {
		return cMainPlace;
	}


	public String getcMainImageName() {
		return cMainImageName;
	}

	public void setcMainImageName(String cMainImageName) {
		this.cMainImageName = cMainImageName;
	}

	public void setcMainPlace(String cMainPlace) {
		this.cMainPlace = cMainPlace;
	}


	public Integer getSubId() {
		return subId;
	}


	public void setSubId(Integer subId) {
		this.subId = subId;
	}


	public String getSubName() {
		return subName;
	}


	public void setSubName(String subName) {
		this.subName = subName;
	}


	public Integer getMidId() {
		return midId;
	}


	public void setMidId(Integer midId) {
		this.midId = midId;
	}


	public String getMidName() {
		return midName;
	}


	public void setMidName(String midName) {
		this.midName = midName;
	}


	public Integer getLargeId() {
		return largeId;
	}


	public void setLargeId(Integer largeId) {
		this.largeId = largeId;
	}


	public String getLargeName() {
		return largeName;
	}


	public void setLargeName(String largeName) {
		this.largeName = largeName;
	}

	
	public String getLeaderId() {
		return leaderId;
	}


	public void setLeaderId(String leaderId) {
		this.leaderId = leaderId;
	}

	
	
	
	//toString
	@Override
	public String toString() {
		return "ClubDetail [cId=" + cId + ", cName=" + cName + ", cDescription=" + cDescription + ", cCreateDate="
				+ cCreateDate + ", cFounderId=" + cFounderId + ", cMaxMembers=" + cMaxMembers + ", cMemberCount="
				+ cMemberCount + ", cLocation=" + cLocation + ", cSiDo=" + cSiDo + ", cSiDoCode=" + cSiDoCode
				+ ", cGuGun=" + cGuGun + ", cGuGunCode=" + cGuGunCode + ", cDong=" + cDong + ", cDongCode=" + cDongCode
				+ ", cMainPlace=" + cMainPlace + ", cMainImageName=" + cMainImageName + ", subId=" + subId
				+ ", subName=" + subName + ", midId=" + midId + ", midName=" + midName + ", largeId=" + largeId
				+ ", largeName=" + largeName + ", leaderId=" + leaderId + "]";
	}


}
