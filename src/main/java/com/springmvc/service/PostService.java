package com.springmvc.service;

import java.time.LocalDateTime;
import java.util.List;

import com.springmvc.domain.Post;

public interface PostService {
	List<Post> getPostsByClubId(int clubId);
	void savePost(Post post, String memberId);
	Post getPostDetail(long postId, String memberId);
	Post getPostById(long postId);
	void updatePost(Post post);
	void deletePost(long postId, String memberId);
	boolean existsHobbyLog(int eventNo, String memberId);
	List<Post> getHobbyLogsByMemberAndDateRange(String memberId, LocalDateTime start, LocalDateTime end);
	List<Post> getMonthlyHobbyLogs(String memberId, LocalDateTime start, LocalDateTime end);
	Post getHobbyLogById(long postId);
	Long findHobbyLogId(int eventNo, String mId);
    void deleteHobbyLogsByMember(String memberId);
}
