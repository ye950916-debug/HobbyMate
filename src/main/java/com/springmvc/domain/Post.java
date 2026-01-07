package com.springmvc.domain;

import java.time.LocalDateTime;

public class Post {
	private long postId;
	private int postCId;
	private String postMId;
	private String postTitle;
	private String postContent;
	private LocalDateTime postCreatedDate;
	private LocalDateTime postUpdatedDate;
	private LocalDateTime postDeletedDate; 
	private int postViewCount;
	private String postStatus;
	
	private String postType; // p_type (NORMAL, NOTICE, HOBBYLOG)
	private Integer postEventNo;
	private LocalDateTime scheduleStartTime;
	private String scheduleTitle;
	private LocalDateTime scheduleEndTime;
	private int startDayIndex;
	private int spanDays;
	
	
	
	//생성자
	public Post() {
		super();
	}
	
	public Post(long postId, int postCId, String postMId, String postTitle, String postContent,
	        LocalDateTime postCreatedDate, LocalDateTime postUpdatedDate, LocalDateTime postDeletedDate,
	        int postViewCount, String postStatus, String postType, Integer postEventNo, LocalDateTime scheduleStartTime,
	        String scheduleTitle, LocalDateTime scheduleEndTime, int startDayIndex, int spanDays) {

	    this.postId = postId;
	    this.postCId = postCId;
	    this.postMId = postMId;
	    this.postTitle = postTitle;
	    this.postContent = postContent;
	    this.postCreatedDate = postCreatedDate;
	    this.postUpdatedDate = postUpdatedDate;
	    this.postDeletedDate = postDeletedDate;
	    this.postViewCount = postViewCount;
	    this.postStatus = postStatus;
	    this.postType = postType;
	    this.postEventNo = postEventNo;
	    this.scheduleStartTime = scheduleStartTime;
	    this.scheduleTitle = scheduleTitle;
	    this.scheduleEndTime = scheduleEndTime;
	    this.startDayIndex = startDayIndex;
	    this.spanDays = spanDays;
	}



	//getter setter
	public long getPostId() {
		return postId;
	}

	public void setPostId(long postId) {
		this.postId = postId;
	}

	public int getPostCId() {
		return postCId;
	}

	public void setPostCId(int postCId) {
		this.postCId = postCId;
	}

	public String getPostMId() {
		return postMId;
	}

	public void setPostMId(String postMId) {
		this.postMId = postMId;
	}

	public String getPostTitle() {
		return postTitle;
	}

	public void setPostTitle(String postTitle) {
		this.postTitle = postTitle;
	}

	public String getPostContent() {
		return postContent;
	}

	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}

	public LocalDateTime getPostCreatedDate() {
		return postCreatedDate;
	}

	public void setPostCreatedDate(LocalDateTime postCreatedDate) {
		this.postCreatedDate = postCreatedDate;
	}

	public LocalDateTime getPostUpdatedDate() {
		return postUpdatedDate;
	}

	public void setPostUpdatedDate(LocalDateTime postUpdatedDate) {
		this.postUpdatedDate = postUpdatedDate;
	}

	public LocalDateTime getPostDeletedDate() {
		return postDeletedDate;
	}

	public void setPostDeletedDate(LocalDateTime postDeletedDate) {
		this.postDeletedDate = postDeletedDate;
	}

	public int getPostViewCount() {
		return postViewCount;
	}

	public void setPostViewCount(int postViewCount) {
		this.postViewCount = postViewCount;
	}

	public String getPostStatus() {
		return postStatus;
	}

	public void setPostStatus(String postStatus) {
		this.postStatus = postStatus;
	}
	
	public String getPostType() {
	    return postType;
	}

	public void setPostType(String postType) {
	    this.postType = postType;
	}

	public Integer getPostEventNo() {
		return postEventNo;
	}

	public void setPostEventNo(Integer postEventNo) {
		this.postEventNo = postEventNo;
	}

	public LocalDateTime getScheduleStartTime() {
		return scheduleStartTime;
	}

	public void setScheduleStartTime(LocalDateTime scheduleStartTime) {
		this.scheduleStartTime = scheduleStartTime;
	}
	
	public String getScheduleTitle() {
		return scheduleTitle;
	}

	public void setScheduleTitle(String scheduleTitle) {
		this.scheduleTitle = scheduleTitle;
	}

	public LocalDateTime getScheduleEndTime() {
		return scheduleEndTime;
	}

	public void setScheduleEndTime(LocalDateTime scheduleEndTime) {
		this.scheduleEndTime = scheduleEndTime;
	}

	public int getStartDayIndex() {
		return startDayIndex;
	}

	public void setStartDayIndex(int startDayIndex) {
		this.startDayIndex = startDayIndex;
	}

	public int getSpanDays() {
		return spanDays;
	}

	public void setSpanDays(int spanDays) {
		this.spanDays = spanDays;
	}

	@Override
	public String toString() {
		return "Post [postId=" + postId + ", postCId=" + postCId + ", postMId=" + postMId + ", postTitle=" + postTitle
				+ ", postContent=" + postContent + ", postCreatedDate=" + postCreatedDate + ", postUpdatedDate="
				+ postUpdatedDate + ", postDeletedDate=" + postDeletedDate + ", postViewCount=" + postViewCount
				+ ", postStatus=" + postStatus + ", postType=" + postType + ", postEventNo=" + postEventNo
				+ ", scheduleStartTime=" + scheduleStartTime + ", scheduleTitle=" + scheduleTitle + ", scheduleEndTime="
				+ scheduleEndTime + ", startDayIndex=" + startDayIndex + ", spanDays=" + spanDays + "]";
	}

	
}
