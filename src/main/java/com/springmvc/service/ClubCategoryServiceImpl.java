package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.repository.ClubCategoryRepository;

@Service
public class ClubCategoryServiceImpl implements ClubCategoryService {
	
	@Autowired
	private ClubCategoryRepository clubCategoryRepository;
	
	@Override
	public List<Integer> findCategoryiesByIds(int clubId) {
		return clubCategoryRepository.findCategoryiesByIds(clubId);
	}
	
	@Override
	public void deleteClubCategory(int clubId) {
		clubCategoryRepository.deleteClubCategory(clubId);
	}

}
