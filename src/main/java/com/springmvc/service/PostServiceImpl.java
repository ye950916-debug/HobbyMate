package com.springmvc.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springmvc.domain.Post;
import com.springmvc.repository.ClubMemberRepository;
import com.springmvc.repository.MemberRepository;
import com.springmvc.repository.PostImageRepository;
import com.springmvc.repository.PostRepository;

@Service
public class PostServiceImpl implements PostService {
	
	@Autowired
	private PostRepository postRepository;
	
	@Autowired
	private ClubMemberRepository cmRepository;
	
	@Autowired
	private PostImageRepository postImageRepository;
	
	@Autowired
	private MemberRepository memberRepository;
	
	// 게시글 목록 조회
	@Override
	public List<Post> getPostsByClubId(int clubId) {
		return postRepository.getPostsByClubId(clubId);
	}
	
	// 게시글 저장
	@Override
	@Transactional
	public void savePost(Post post, String memberId) {
		
		postRepository.savePost(post);
		
		if ("HOBBYLOG".equals(post.getPostType())) {
	        memberRepository.increaseLogCount(memberId);
	    }
	}
	
	// 게시글 상세조회
	@Override
	@Transactional
	public Post getPostDetail(long postId, String memberId) {
		
		// 1. 게시글 상세 정보를 먼저 조회
		Post post = postRepository.getPostById(postId);
		
		if (post == null) {
            return null; // 게시글이 없으면 null 반환
        }
		
		int clubId = post.getPostCId();
        
        // 2. 현재 사용자가 해당 모임의 승인된 회원인지 확인
        if (!cmRepository.isApprovedMember(clubId, memberId)) {
            return null; // 승인된 회원이 아니면 null 반환 (접근 권한 없음)
        }
        
        // 3. 권한 확인 완료 > 조회수 증가
        postRepository.incrementViewCount(postId);
        
        // 4. 조회수가 증가된 최신 데이터로 게시글을 다시 조회하여 반환
        return postRepository.getPostById(postId); 
	}
	
	// 조회수 증가 없이 게시글 정보 조회(수정/삭제 권한 체크)
	@Override
	public Post getPostById(long postId) {
		return postRepository.getPostById(postId); 
	}
	
	// 게시글 수정 데이터 db 저장
	@Override
	public void updatePost(Post post) {
		postRepository.updatePost(post);
	}
	
	// 게시글 삭제
	@Override
	public void deletePost(long postId, String memberId) {
		postRepository.deletePost(postId, memberId);
	}
	
	@Override
	public boolean existsHobbyLog(int eventNo, String memberId) {
	    return postRepository.existsHobbyLog(eventNo, memberId);
	}
	
	 @Override
	    public List<Post> getHobbyLogsByMemberAndDateRange(String memberId, LocalDateTime start, LocalDateTime end) {
	        return postRepository.getHobbyLogsByMemberAndDateRange(memberId, start, end);
	 }
	 
	 @Override
	 public List<Post> getMonthlyHobbyLogs(String memberId, LocalDateTime monthStart, LocalDateTime monthEnd) {
		 return postRepository.getMonthlyHobbyLogs(memberId, monthStart, monthEnd);
	 }
	
	 @Override
	    public Post getHobbyLogById(long postId) {
	        return postRepository.getHobbyLogById(postId);
	    }
	 
	 @Override
	 public Long findHobbyLogId(int eventNo, String mId) {
	     return postRepository.findHobbyLogId(eventNo, mId);
	 }
	 
	 @Override
	    @Transactional
	    public void deleteHobbyLogsByMember(String memberId) {

	        // 1️⃣ 회원이 작성한 하비로그 ID 목록 조회
	        List<Long> hobbyLogIds =
	                postRepository.findHobbyLogIdsByMember(memberId);

	        if (hobbyLogIds == null || hobbyLogIds.isEmpty()) {
	            return; // 하비로그 없으면 끝
	        }

	        // 2️⃣ 하비로그에 딸린 이미지 삭제
	        for(int i = 0; i < hobbyLogIds.size(); i++) {
	        	Long postId = hobbyLogIds.get(i);
	        	postImageRepository.deleteByPostId(postId);
	        }
	        
	        // 3️⃣ 하비로그 삭제
	        postRepository.deleteHobbyLogsByMember(memberId);
	    }
}
