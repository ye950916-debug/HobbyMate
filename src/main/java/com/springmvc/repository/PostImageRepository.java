package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.PostImage;

public interface PostImageRepository {
	
	void insert(PostImage postImage);
	List<PostImage> findByPostId(long postId);
	void deleteByPostId(long postId);
	void deleteByImageId(long piId);
	PostImage findById(long imageId);
}
