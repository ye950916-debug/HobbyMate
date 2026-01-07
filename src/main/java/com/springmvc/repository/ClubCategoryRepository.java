package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.ClubCategory;

public interface ClubCategoryRepository {
	void insertClubCategory(ClubCategory cc);
	List<Integer> findCategoryiesByIds(int clubId);
	void deleteByClubId(int clubId);
	void insertClubCategory(int clubId, int ctId);
	void deleteClubCategory(int clubId);
	List<Integer> getClubIdsByCategoryIds(List<Integer> ctIds);
}
