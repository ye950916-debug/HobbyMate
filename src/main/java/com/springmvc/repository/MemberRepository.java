package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Member;

public interface MemberRepository {
	
	List<Member> getAllMembers();
	List<Member> searchMembers(String keyword);
	Member getMemberById(String mId);
	void addMember(Member member);
	void updateMember (Member member);
	void deleteMember(String mId);
	void updateStatus(String mId, String status);
	Member findByPhone (String mPhone);
	void increaseLogCount(String memberId);
	int getLogCount(String memberId);
}
