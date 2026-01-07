package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Category;

public interface CategoryRepository {
	List<Category> getTopCategories();
	List<Category> getMidOrSubCategories(int parentId);
	List<Category> findCategoriesByIds(List<Integer> ctIds);
	List<Category> findCategoryWithParent(int subCategoryId);
	List<Category> getcategoriesByLevel(int ctLevel);
	void addCategory(String ctName, String ctCode, Integer parentId);
	String findLastTopLevelCode();
	String findCodeById(int ctId);
	String findLastChildCode(String parentCode);
	List<Category> getChildCategories(Integer parentId);
	void updateName(int ctId, String ctName);
	void updateParent(int ctId, Integer newparentId);
	void updateCode(int ctId, String newCtCode);
	void deleteCategory(int ctId);
	void deleteClubCategories(int ctId);
	void deleteMemberCategories(int ctId);
	
	List<Category> getAllCategories();
	Category getCategoryById(int ctId);
}
