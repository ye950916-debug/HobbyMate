package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Member;
import com.springmvc.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService{

	@Autowired
	private MemberRepository memberRepository;
	
	@Override
	public List<Member> getAllMembers() {
		 return memberRepository.getAllMembers();
	}

	@Override
	public List<Member> searchMembers(String keyword) {
		return memberRepository.searchMembers(keyword);
	}

	@Override
	public Member getMemberById(String mId) {
		return memberRepository.getMemberById(mId);
	}

	@Override
	public void addMember(Member member) {
		memberRepository.addMember(member);
		
	}

	@Override
	public void updateMember(Member member) {
		memberRepository.updateMember(member);
		
	}

	@Override
	public void deleteMember(String mId) {
		memberRepository.deleteMember(mId);
		
	}

	@Override
	public void updateStatus(String mId, String status) {
		memberRepository.updateStatus(mId, status);
		
	}

	@Override
	public Member findByPhone(String mPhone) {
		return memberRepository.findByPhone(mPhone);
	}
	
	
	
	

}
