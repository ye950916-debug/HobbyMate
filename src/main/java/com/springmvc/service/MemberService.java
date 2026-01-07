package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Member;

public interface MemberService {
	
	List<Member> getAllMembers();
	List<Member> searchMembers(String keyword);
	Member getMemberById(String mId);
	void addMember(Member member);
	void updateMember(Member member);
	void deleteMember(String mId);
	void updateStatus(String mId, String status);
	Member findByPhone(String mPhone);
}
