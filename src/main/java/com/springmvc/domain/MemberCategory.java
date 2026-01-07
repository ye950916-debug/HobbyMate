package com.springmvc.domain;

public class MemberCategory {
	
	private int mctId;
	private String mId;
	private int ctId;
	
	public MemberCategory() {}

	public MemberCategory(int mctId, String mId, int ctId) {
		super();
		this.mctId = mctId;
		this.mId = mId;
		this.ctId = ctId;
	}

	public int getMctId() {
		return mctId;
	}

	public void setMctId(int mctId) {
		this.mctId = mctId;
	}

	public String getmId() {
		return mId;
	}

	public void setmId(String mId) {
		this.mId = mId;
	}

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	@Override
	public String toString() {
		return "MemberCategory [mctId=" + mctId + ", mId=" + mId + ", ctId=" + ctId + "]";
	}
	
	

}
