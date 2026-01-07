package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Category;

public interface CategoryService {
	List<Category> getTopCategories();
	List<Category> getMidOrSubCategories(int parentId);
	List<Category> findCategoriesByIds(List<Integer> ctIds);
	List<Category> findCategoryWithParent(int subCategoryId);
	List<Category> getcategoriesByLevel(int ctLevel);
	void addCategory(String ctName, Integer parentId);
	List<Category> getChildCategories(Integer parentId);
	void updateCategory(int ctId, String ctName, Integer newParentId, boolean parentChanged);
	void deleteCategory(int ctId);

	public List<Category> getAllCategories();
	Category getCategoryById(int ctId);
}
