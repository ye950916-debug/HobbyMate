package com.springmvc.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.springmvc.domain.PostImage;

public interface PostImageService {
	
	void insert(long postId, List<MultipartFile> imageFiles);
	List<PostImage> findByPostId(long postId);
	void deleteByPostId(long postId);
	void deleteImage(long imageId, long postId);
}
