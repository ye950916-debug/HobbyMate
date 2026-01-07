package com.springmvc.domain;

public class Category {
	
	private int ctId;
	private String ctCode;
	private String ctName;
	private int ctLevel;
	private Integer ctParentId;
	
	public Category() {}

	public Category(int ctId, String ctCode, String ctName, int ctLevel, Integer ctParentId) {
		super();
		this.ctId = ctId;
		this.ctCode = ctCode;
		this.ctName = ctName;
		this.ctLevel = ctLevel;
		this.ctParentId = ctParentId;
	}

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	public String getCtCode() {
		return ctCode;
	}

	public void setCtCode(String ctCode) {
		this.ctCode = ctCode;
	}

	public String getCtName() {
		return ctName;
	}

	public void setCtName(String ctName) {
		this.ctName = ctName;
	}

	public int getCtLevel() {
		return ctLevel;
	}

	public void setCtLevel(int ctLevel) {
		this.ctLevel = ctLevel;
	}

	public Integer getCtParentId() {
		return ctParentId;
	}

	public void setCtParentId(Integer ctParentId) {
		this.ctParentId = ctParentId;
	}

	@Override
	public String toString() {
		return "Category [ctId=" + ctId + ", ctCode=" + ctCode + ", ctName=" + ctName + ", ctLevel=" + ctLevel
				+ ", ctParentId=" + ctParentId + "]";
	}

	
	
	

}
