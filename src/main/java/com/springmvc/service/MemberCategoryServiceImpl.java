package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.repository.MemberCategoryRepository;

@Service
public class MemberCategoryServiceImpl implements MemberCategoryService {
	
	@Autowired
	private MemberCategoryRepository memberCategoryRepository;
	
	@Override
	public void add(String mId, int ctId) {
		memberCategoryRepository.insertMemberCategory(mId, ctId);
	}

	@Override
	public List<Integer> getCategoriesByMember(String mId) {
		return memberCategoryRepository.getCategoryIdsByMemberId(mId);
	}

	@Override
	public void deleteAll(String mId) {
		memberCategoryRepository.deleteAll(mId);
		
	}
	
	

}
