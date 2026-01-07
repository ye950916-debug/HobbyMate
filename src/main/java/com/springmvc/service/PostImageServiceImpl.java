package com.springmvc.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.springmvc.domain.PostImage;
import com.springmvc.repository.PostImageRepository;

@Service
public class PostImageServiceImpl implements PostImageService {
	
    private final PostImageRepository postImageRepository;
    private final ServletContext servletContext;

    public PostImageServiceImpl(
            PostImageRepository postImageRepository,
            ServletContext servletContext) {
        this.postImageRepository = postImageRepository;
        this.servletContext = servletContext;
    }

	@Override
	public void insert(long postId, List<MultipartFile> imageFiles) {
		if (imageFiles == null || imageFiles.size() == 0) {
			return;
		}
		
		String path = servletContext.getRealPath("/resources/images/hobbylog");
		System.out.println(path);
		
		File dir = new File(path);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		for (int i = 0; i < imageFiles.size(); i++) {
			MultipartFile file = imageFiles.get(i);
			
			if (file != null && !file.isEmpty()) {
				
				String original = file.getOriginalFilename();
				System.out.println("원본 이미지 이름: " + original);
				
				String ext = "";
				if (original != null && original.contains(".")) {
					String[] parts = original.split("\\.");
					ext = parts[parts.length -1];
				}
				String saveName = ext.isEmpty()
						? UUID.randomUUID().toString()
						: UUID.randomUUID().toString() + "." + ext;
				
				System.out.println("저장될 랜덤 이름: " + saveName);
				
				File saveFile = new File(path, saveName);
				
				try {
					file.transferTo(saveFile);
				} catch (Exception e) {
					throw new RuntimeException("이미지 업로드 실패!", e);
				}
				
				PostImage img = new PostImage();
				img.setPostId(postId);
				img.setPiName(saveName);
				img.setPiOrder(i + 1);
				
				postImageRepository.insert(img);
			}
		}
	}

	@Override
	public List<PostImage> findByPostId(long postId) {
		return postImageRepository.findByPostId(postId);
	}

	@Override
	public void deleteByPostId(long postId) {
		postImageRepository.deleteByPostId(postId);
	}

	@Override
	public void deleteImage(long imageId, long postId) {
		
		PostImage img = postImageRepository.findById(imageId);
		
		if (img == null) {
			return;
		}
	
		
		if (img.getPostId() != postId) {
			return;
		}
		
		postImageRepository.deleteByImageId(imageId);		
	}

}
