package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springmvc.domain.Category;
import com.springmvc.repository.CategoryRepository;

@Service
public class CategoryServiceImpl implements CategoryService {
	
	@Autowired
	private CategoryRepository categoryRepository;
	
	@Override
	public List<Category> getTopCategories() {
		return categoryRepository.getTopCategories();
	}
	
	@Override
	public List<Category> getMidOrSubCategories(int parentId) {
		return categoryRepository.getMidOrSubCategories(parentId);
	}
	
	@Override
	public List<Category> findCategoriesByIds(List<Integer> ctIds) {
		return categoryRepository.findCategoriesByIds(ctIds);
	}
	
	@Override
	public List<Category> findCategoryWithParent(int subCategoryId) {
		return categoryRepository.findCategoryWithParent(subCategoryId);
	}
	
	@Override
	public List<Category> getcategoriesByLevel(int ctLevel) {
		return categoryRepository.getcategoriesByLevel(ctLevel);
	}
	
	@Override
	@Transactional
	public void addCategory(String ctName, Integer parentId) {
		//ct_code를 생성
		String ctCode = generateCtCode(parentId);
		//repository에서 insert하기
		categoryRepository.addCategory(ctName, ctCode, parentId);
	}
	
	
	@Override
	public List<Category> getChildCategories(Integer parentId) {
		return categoryRepository.getChildCategories(parentId);
	}
	
	@Override
	@Transactional
	public void updateCategory(int ctId, String ctName, Integer newParentId, boolean parentChanged) {
		
		categoryRepository.updateName(ctId, ctName);
		
		//상위분류가 변경된 경우
		if(parentChanged) {
			//parentId 업데이트
			categoryRepository.updateParent(ctId, newParentId);
			//ct_code 업데이트
			String newCtCode = generateCtCode(newParentId);
			categoryRepository.updateCode(ctId, newCtCode);
			//하위분류들 ct_code 업데이트
			updateChildCtCodesUpdate(ctId, newCtCode);
		}
	}
	
	
	@Override
	@Transactional
	public void deleteCategory(int ctId) {
		//ClubCategory 테이블에서 해당 카테고리 정보 지우기
		categoryRepository.deleteClubCategories(ctId);
		//MemberCategory 테이블에서 해당 카테고리 정보 지우기
		categoryRepository.deleteMemberCategories(ctId);
		
		//대분류, 중분류 카테고리인 경우 하위 카테고리 삭제
		deleteChildrenCategory(ctId);
		
		categoryRepository.deleteCategory(ctId);
	}
	
	private void deleteChildrenCategory(int ctId) {
		//선택한 카테고리의 하위 카테고리들 가져오기
		List<Category> children = categoryRepository.getChildCategories(ctId);
		
		for(int i=0; i<children.size(); i++) {
			int childCtId = children.get(i).getCtId();
			
			categoryRepository.deleteClubCategories(childCtId);
			categoryRepository.deleteMemberCategories(childCtId);
			
			//중분류인 경우 하위 소분류 카테고리 먼저 삭제
			deleteChildrenCategory(childCtId);
			
			categoryRepository.deleteCategory(childCtId);
		}
	}
	
	
	
	
	
	@Override
	public List<Category> getAllCategories() {
		return categoryRepository.getAllCategories();
	}
	
	@Override
	public Category getCategoryById(int ctId) {
		return categoryRepository.getCategoryById(ctId);
	}
	
	
	
	
	
	
	private String generateCtCode(Integer parentId) {
		//대분류
		if(parentId == null) {
			String lastCode = categoryRepository.findLastTopLevelCode();
			
			int nextNumber = 1;
			if(lastCode != null) {
				nextNumber = Integer.parseInt(lastCode.substring(1)) + 1;
			}
			return String.format("C%03d", nextNumber);
		}
		
		//중분류 or 소분류
		String parentCode = categoryRepository.findCodeById(parentId);
		
		String lastChildCode = categoryRepository.findLastChildCode(parentCode);
		
		int nextNumber = 1;
		if(lastChildCode != null) {
			String[] parts = lastChildCode.split("_");
			String lastNumStr = parts[parts.length-1];
			nextNumber = Integer.parseInt(lastNumStr)+1;
		}
		
		return parentCode + "_" + String.format("%03d", nextNumber);
	}
	
	private void updateChildCtCodesUpdate(int parentId, String newParentCode) {
		List<Category> children = categoryRepository.getChildCategories(parentId);
		
		for(int i=0; i<children.size(); i++) {
			Category child = children.get(i);
			
			String lastChildCode = categoryRepository.findLastChildCode(newParentCode);
			
			int nextNumber = 1;
			if(lastChildCode != null) {
				String[] parts = lastChildCode.split("_");
				String lastNumStr = parts[parts.length-1];
				nextNumber = Integer.parseInt(lastNumStr)+1;
			}
			
			String childNewCode = newParentCode + "_" + String.format("%03d", nextNumber);
			
			categoryRepository.updateCode(child.getCtId(), childNewCode);
			
			//중분류인 경우 소분류까지 코드변경
			updateChildCtCodesUpdate(child.getCtId(), childNewCode);
		}
	}
}
