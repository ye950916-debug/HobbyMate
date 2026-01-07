package com.springmvc.repository;

import java.awt.print.Book;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Category;

@Repository
public class CategoryRepositoryImpl implements CategoryRepository {
	
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	
	@Override
	public List<Category> getTopCategories() {
		String sql = "SELECT * FROM CATEGORY WHERE ct_level=1 ORDER BY ct_name";
		
		return jdbcTemplate.query(sql, new CategoryRowMapper());
	}
	
	
	//parentId를 받아 중분류/소분류 조회
	@Override
	public List<Category> getMidOrSubCategories(int parentId) {
		 String sql = "SELECT * FROM CATEGORY WHERE ct_parent_id = ? ORDER BY ct_name";

	        return jdbcTemplate.query(sql, new Object[]{parentId}, new CategoryRowMapper());
	}
	
	@Override
	public List<Category> findCategoriesByIds(List<Integer> ctIds) {
		if(ctIds == null || ctIds.isEmpty()) {
			return new ArrayList<Category>();
		}
		
		StringBuilder inSql = new StringBuilder();
		for (int i = 0; i < ctIds.size(); i++) {
			inSql.append("?");
			if(i<ctIds.size() - 1) {
				inSql.append(",");
			}
		}
		String sql = "SELECT * FROM CATEGORY WHERE ct_id IN (" + inSql.toString() + ")";
		return jdbcTemplate.query(sql, ctIds.toArray(), new CategoryRowMapper());
	}
	
	@Override
	public List<Category> findCategoryWithParent(int subCategoryId) {
		List<Category> result = new ArrayList<Category>();
		String sql3 = "SELECT * FROM CATEGORY WHERE ct_id = ?";
		List<Category> subList = jdbcTemplate.query(sql3, new Object[] {subCategoryId}, new CategoryRowMapper());
		
		if(subList.size() == 0) {
			return result;
		}
		
		Category subCategory = subList.get(0);
		result.add(subCategory);
		
		if(subCategory.getCtParentId() != null) {
			String sql2 = "SELECT * FROM CATEGORY WHERE ct_id=?";
			List<Category> mid = jdbcTemplate.query(sql2, new Object[] {subCategory.getCtParentId()}, new CategoryRowMapper());
			
			if(mid.size() > 0) {
				Category midCategory = mid.get(0);
				result.add(midCategory);
				
				if(midCategory.getCtParentId() != null) {
					String sql1 = "SELECT * FROM CATEGORY WHERE ct_id=?";
					List<Category> top = jdbcTemplate.query(sql1, new Object[] {midCategory.getCtParentId()}, new CategoryRowMapper());
					
					if(top.size() > 0) {
						result.add(top.get(0));
					}
				}
			}
		}
		
		return result;
	}
	
	
	@Override
	public List<Category> getcategoriesByLevel(int ctLevel) {
		String sql = "SELECT * FROM CATEGORY WHERE ct_level=?";
		List<Category> list = jdbcTemplate.query(sql, new Object[] {ctLevel}, new CategoryRowMapper());
		return list;
	}
	
	@Override
	public void addCategory(String ctName, String ctCode, Integer parentId) {
		String sql = "INSERT INTO CATEGORY (ct_name, ct_code, ct_parent_id, ct_level) VALUES (?, ?, ?, ?)";
		int level;
		if(parentId == null) {
			level=1;
		} else {
			level = getLevel(parentId) + 1;
		}
		jdbcTemplate.update(sql, ctName, ctCode, parentId, level);
	}
	
	private int getLevel(int ctId) {
		String sql = "SELECT ct_level FROM CATEGORY WHERE ct_id=?";
		return jdbcTemplate.queryForObject(sql, Integer.class, ctId);
	}
	
	@Override
	public String findLastTopLevelCode() {
		String sql = "SELECT ct_code FROM CATEGORY WHERE ct_parent_id IS NULL ORDER BY ct_code DESC LIMIT 1";
		List<String> result = jdbcTemplate.queryForList(sql, String.class);
		if (result.isEmpty()) {
		    return null;
		} else {
		    return result.get(0);
		}
	}
	
	@Override
	public String findCodeById(int ctId) {
		String sql = "SELECT ct_code FROM CATEGORY WHERE ct_id=?";
		return jdbcTemplate.queryForObject(sql, String.class, ctId);
	}
	
	@Override
	public String findLastChildCode(String parentCode) {
		String sql = "SELECT ct_code FROM CATEGORY WHERE ct_code LIKE ? ORDER BY ct_code DESC LIMIT 1";
		List<String> result = jdbcTemplate.queryForList(sql, String.class, parentCode + "_%");
		
		if(result.isEmpty()){
			return null;
		} else {
			return result.get(0);
		}
	}
	
	@Override
	public List<Category> getChildCategories(Integer parentId) {
		String sql = "SELECT * FROM CATEGORY WHERE ct_parent_id=?";
		List<Category> list =jdbcTemplate.query(sql, new CategoryRowMapper(), parentId);
		return list;
	}
	
	@Override
	public void updateName(int ctId, String ctName) {
		String sql = "UPDATE CATEGORY SET ct_name=? WHERE ct_id=?";
		jdbcTemplate.update(sql, ctName, ctId);
	}
	
	@Override
	public void updateParent(int ctId, Integer newparentId) {
		String sql = "UPDATE CATEGORY SET ct_parent_id=? WHERE ct_id=?";
		jdbcTemplate.update(sql, newparentId, ctId);
	}
	
	@Override
	public void updateCode(int ctId, String newCtCode) {
		String sql = "UPDATE CATEGORY SET ct_code=? WHERE ct_id=?";
		jdbcTemplate.update(sql, newCtCode, ctId);
	}
	
	@Override
	public void deleteCategory(int ctId) {
		String sql = "DELETE FROM CATEGORY WHERE ct_id=?";
		jdbcTemplate.update(sql, ctId);
	}
	
	@Override
	public void deleteClubCategories(int ctId) {
		String sql = "DELETE FROM CLUBCATEGORY WHERE ct_id=?";
		jdbcTemplate.update(sql, ctId);
	}
	
	@Override
	public void deleteMemberCategories(int ctId) {
		String sql = "DELETE FROM MEMBERCATEGORY WHERE ct_id=?";
		jdbcTemplate.update(sql, ctId);
	}
	
	
	
	
	
	
	@Override
	public List<Category> getAllCategories() {
		String sql = "SELECT * FROM CATEGORY ORDER BY ct_level, ct_parent_id, ct_name";
        return jdbcTemplate.query(sql, new CategoryRowMapper());
	}
	
	@Override
	public Category getCategoryById(int ctId) {
		String sql = "SELECT * FROM CATEGORY WHERE ct_id = ?";
		return jdbcTemplate.queryForObject(sql, new CategoryRowMapper(), ctId);
	}
}
