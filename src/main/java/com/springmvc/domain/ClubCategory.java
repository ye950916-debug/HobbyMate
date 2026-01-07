package com.springmvc.domain;

public class ClubCategory {
	
	private int cctId;
	private int cId;
	private int ctId;
	
	public ClubCategory() {}

	public ClubCategory(int cctId, int cId, int ctId) {
		super();
		this.cctId = cctId;
		this.cId = cId;
		this.ctId = ctId;
	}

	public int getCctId() {
		return cctId;
	}

	public void setCctId(int cctId) {
		this.cctId = cctId;
	}

	public int getcId() {
		return cId;
	}

	public void setcId(int cId) {
		this.cId = cId;
	}

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	@Override
	public String toString() {
		return "ClubCategory [cctId=" + cctId + ", cId=" + cId + ", ctId=" + ctId + "]";
	}
	
	

}
