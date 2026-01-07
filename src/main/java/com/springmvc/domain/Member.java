package com.springmvc.domain;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

public class Member {
	private String mId;
	private String mPw;
	private String mName;
	private int mAge;
	private String mGender;
	private String mPhone;
	private String mAddress;	//전체 주소
	private String mSiDo;		//시도
	private String mGuGun;		//구군
	private String mDong;		//읍면동
	private String mRole;
	private LocalDateTime mJoinDate;
	private MultipartFile mProfileImage;
	private String mProfileImageName;
	private String mStatus;
	private int mLogCount;
	
	
	
	public Member() {}	

	public Member(String mId, String mPw, String mName, int mAge, String mGender, String mPhone, String mAddress,
			String mSiDo, String mGuGun, String mDong, String mRole, LocalDateTime mJoinDate,
			MultipartFile mProfileImage, String mProfileImageName, String mStatus, int mLogCount) {
		super();
		this.mId = mId;
		this.mPw = mPw;
		this.mName = mName;
		this.mAge = mAge;
		this.mGender = mGender;
		this.mPhone = mPhone;
		this.mAddress = mAddress;
		this.mSiDo = mSiDo;
		this.mGuGun = mGuGun;
		this.mDong = mDong;
		this.mRole = mRole;
		this.mJoinDate = mJoinDate;
		this.mProfileImage = mProfileImage;
		this.mProfileImageName = mProfileImageName;
		this.mStatus = mStatus;
		this.mLogCount = mLogCount;
	}
	
	



	public String getmId() {
		return mId;
	}


	public void setmId(String mId) {
		this.mId = mId;
	}


	public String getmPw() {
		return mPw;
	}


	public void setmPw(String mPw) {
		this.mPw = mPw;
	}


	public String getmName() {
		return mName;
	}


	public void setmName(String mName) {
		this.mName = mName;
	}


	public int getmAge() {
		return mAge;
	}


	public void setmAge(int mAge) {
		this.mAge = mAge;
	}


	public String getmGender() {
		return mGender;
	}


	public void setmGender(String mGender) {
		this.mGender = mGender;
	}


	public String getmPhone() {
		return mPhone;
	}


	public void setmPhone(String mPhone) {
		this.mPhone = mPhone;
	}


	public String getmAddress() {
		return mAddress;
	}


	public void setmAddress(String mAddress) {
		this.mAddress = mAddress;
	}
	
	public String getmSiDo() {
		return mSiDo;
	}
	
	public void setmSiDo(String mSiDo) {
		this.mSiDo = mSiDo;
	}
	
	public String getmGuGun() {
		return mGuGun;
	}
	
	public void setmGuGun(String mGuGun) {
		this.mGuGun = mGuGun;
	}
	
	public String getmDong() {
		return mDong;
	}
	
	public void setmDong(String mDong) {
		this.mDong = mDong;
	}

	public String getmRole() {
		return mRole;
	}

	public void setmRole(String mRole) {
		this.mRole = mRole;
	}

	public LocalDateTime getmJoinDate() {
		return mJoinDate;
	}

	public void setmJoinDate(LocalDateTime mJoinDate) {
		this.mJoinDate = mJoinDate;
	}

	public MultipartFile getmProfileImage() {
		return mProfileImage;
	}

	public void setmProfileImage(MultipartFile mProfileImage) {
		this.mProfileImage = mProfileImage;
	}

	public String getmProfileImageName() {
		return mProfileImageName;
	}

	public void setmProfileImageName(String mProfileImageName) {
		this.mProfileImageName = mProfileImageName;
	}

	public String getmStatus() {
		return mStatus;
	}


	public void setmStatus(String mStatus) {
		this.mStatus = mStatus;
	}
	
	
	public int getmLogCount() {
		return mLogCount;
	}

	public void setmLogCount(int mLogCount) {
		this.mLogCount = mLogCount;
	}

	
	
	
	
	@Override
	public String toString() {
		return "Member [mId=" + mId + ", mPw=" + mPw + ", mName=" + mName + ", mAge=" + mAge + ", mGender=" + mGender
				+ ", mPhone=" + mPhone + ", mAddress=" + mAddress + ", mSiDo=" + mSiDo + ", mGuGun=" + mGuGun
				+ ", mDong=" + mDong + ", mRole=" + mRole + ", mJoinDate=" + mJoinDate + ", mProfileImage="
				+ mProfileImage + ", mProfileImageName=" + mProfileImageName + ", mStatus=" + mStatus + ", mLogCount="
				+ mLogCount + "]";
	}

	

}
