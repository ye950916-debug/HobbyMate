package com.springmvc.domain;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

public class PostImage {
	
	private long piId;
    private long postId;
    private String piName;
    private int piOrder;
    private LocalDateTime piCreatedDate;
    private MultipartFile imageFile;
    
    public PostImage() {}
	
    
    public PostImage(long piId, long postId, String piName, int piOrder, LocalDateTime piCreatedDate,
			MultipartFile imageFile) {
		super();
		this.piId = piId;
		this.postId = postId;
		this.piName = piName;
		this.piOrder = piOrder;
		this.piCreatedDate = piCreatedDate;
		this.imageFile = imageFile;
	}


	public long getPiId() {
		return piId;
	}


	public void setPiId(long piId) {
		this.piId = piId;
	}


	public long getPostId() {
		return postId;
	}


	public void setPostId(long postId) {
		this.postId = postId;
	}


	public String getPiName() {
		return piName;
	}


	public void setPiName(String piName) {
		this.piName = piName;
	}


	public int getPiOrder() {
		return piOrder;
	}


	public void setPiOrder(int piOrder) {
		this.piOrder = piOrder;
	}


	public LocalDateTime getPiCreatedDate() {
		return piCreatedDate;
	}


	public void setPiCreatedDate(LocalDateTime piCreatedDate) {
		this.piCreatedDate = piCreatedDate;
	}


	public MultipartFile getImageFile() {
		return imageFile;
	}


	public void setImageFile(MultipartFile imageFile) {
		this.imageFile = imageFile;
	}


	@Override
	public String toString() {
		return "PostImage [piId=" + piId + ", postId=" + postId + ", piName=" + piName + ", piOrder=" + piOrder
				+ ", piCreatedDate=" + piCreatedDate + ", imageFile=" + imageFile + "]";
	}
    
    
    
    

}


