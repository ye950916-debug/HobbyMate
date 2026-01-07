package com.springmvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springmvc.domain.Category;
import com.springmvc.service.CategoryService;

@Controller
@RequestMapping("/category")
public class CategoryController {
	
	@Autowired
	private CategoryService categoryService;
	
	// 대분류
	@GetMapping("/top")
	@ResponseBody
	public List<Category> getTopCategories(){
		return categoryService.getTopCategories();
	}
	
	// 중분류
    @GetMapping("/mid")
    @ResponseBody
    public List<Category> getMidCategories(@RequestParam int parentId) {
        return categoryService.getMidOrSubCategories(parentId);
    }

    // 소분류
    @GetMapping("/sub")
    @ResponseBody
    public List<Category> getSubCategories(@RequestParam int parentId) {
        return categoryService.getMidOrSubCategories(parentId);
    }
    
    @GetMapping("/all")
    @ResponseBody
    public List<Category> getAllCategories() {
        return categoryService.getAllCategories();
    }
    
    
    //=========================
    //   관리자용 기능
    //=========================
    
    //create
    //--------------------------------------
    //카테고리 추가
    @GetMapping("/admin/add")
    public String adminAdd() {
    	return "AdminAddCategoryForm";
    }
    
    
    @PostMapping("/admin/add")
    public String addCategory(@RequestParam("ctName") String ctName, @RequestParam(value="parentId", required=false) Integer parentId) {
    	categoryService.addCategory(ctName, parentId);
    	return "redirect:/category/admin/list";
    }
    
    //--------------------------------------
    
    //read
    //--------------------------------------
    //카테고리 항목 보기
    @GetMapping("/admin/list")
    public String adminList(Model model) {
    	List<Category> top = categoryService.getcategoriesByLevel(1);
    	List<Category> mid = categoryService.getcategoriesByLevel(2);
    	List<Category> sub = categoryService.getcategoriesByLevel(3);
    	
    	model.addAttribute("topList", top);
    	model.addAttribute("midList", mid);
    	model.addAttribute("subList", sub);
    	
    	return "AdminCategoryList";
    }
    
    //--------------------------------------
    
    //update
    //--------------------------------------
    //카테고리 수정
    @GetMapping("/admin/edit")
    public String adminEdit(@RequestParam("ctId") int categoryId, Model model) {
    	Category category = categoryService.getCategoryById(categoryId);
    	model.addAttribute("category", category);
    	
    	//중분류 or 소분류일때 top
    	if(category.getCtLevel() > 1) {
    		List<Category> topList = categoryService.getTopCategories();
    		model.addAttribute("topList", topList);
    		
    		//소분류일때 mid
    		if(category.getCtLevel() == 3) {
    			Category midCategory = categoryService.getCategoryById(category.getCtParentId());
    			Integer topId = midCategory.getCtParentId();
    			
    			model.addAttribute("parentTopId", topId);
    			
    			List<Category> midList = categoryService.getChildCategories(topId);
    			model.addAttribute("midList", midList);
    		}
    	}
    	
    	return "AdminCategoryUpdateForm";
    }
    
    @PostMapping("/admin/update")
    public String updateCategory(
    		@RequestParam("ctId") int ctId, 
    		@RequestParam("ctName") String ctName, 
    		@RequestParam(value="topId", required=false) Integer topId, 
    		@RequestParam(value="midId", required=false) Integer midId) {
    	
    	Category category = categoryService.getCategoryById(ctId);
    	int level = category.getCtLevel();
    	
    	Integer originalParentId = category.getCtParentId();
    	Integer newParentId = null;
    	
    	if(level == 1) {
    		newParentId = null;
    	} else if(level == 2) {
    		newParentId = topId;
    	} else if(level == 3) {
    		newParentId = midId;
    	}
    	
    	boolean parentChanged = false;
    	
    	if(originalParentId == null && newParentId != null){
    		parentChanged = true;
    	} else if(originalParentId != null && !originalParentId.equals(newParentId)) {
    		parentChanged = true;
    	}
    	
    	categoryService.updateCategory(ctId, ctName, newParentId, parentChanged);
    	
    	return "redirect:/category/admin/list";
    }
    
    //--------------------------------------
    
    //delete
    //--------------------------------------
    //카테고리 삭제
    @PostMapping("/admin/delete")
    public String deleteCategory(@RequestParam("ctId") int ctId) {
    	categoryService.deleteCategory(ctId);
    	return "redirect:/category/admin/list";
    }
    
}