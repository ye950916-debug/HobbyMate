package com.springmvc.service;

import java.util.List;

public interface ClubCategoryService {
	List<Integer> findCategoryiesByIds(int clubId);
	void deleteClubCategory(int clubId);
}
