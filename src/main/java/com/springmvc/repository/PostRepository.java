package com.springmvc.repository;

import java.time.LocalDateTime;
import java.util.List;

import com.springmvc.domain.Post;

public interface PostRepository {
	List<Post> getPostsByClubId(int clubId);
	void savePost(Post post);
	Post getPostById(long postId);
	void incrementViewCount(long postId);
	void updatePost(Post post);
	void deletePost(long postId, String memberId);
	boolean existsHobbyLog(int eventNo, String memberId);
	List<Post> getHobbyLogsByMemberAndDateRange(String memberId, LocalDateTime start, LocalDateTime end);
	List<Post> getMonthlyHobbyLogs(String memberId, LocalDateTime monthStart, LocalDateTime monthEnd);
	Post getHobbyLogById(long postId);
	Long findHobbyLogId(int eventNo, String mId);
	List<Long> findHobbyLogIdsByMember(String memberId);
	void deleteHobbyLogsByMember(String memberId);
	void deletePostByClubId(int clubId);
}
