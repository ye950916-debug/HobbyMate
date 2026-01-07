package com.springmvc.repository;

import java.util.List;

public interface MemberCategoryRepository {
	
	void insertMemberCategory(String mId, int ctId);
	List<Integer> getCategoryIdsByMemberId(String mId);
	void deleteAll(String mId);
	List<Integer> getMemberCategoryIds(String memberId);
}
