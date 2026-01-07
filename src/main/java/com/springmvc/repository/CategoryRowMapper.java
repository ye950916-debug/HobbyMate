package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Category;

public class CategoryRowMapper implements RowMapper<Category> {
	
	@Override
	public Category mapRow(ResultSet rs, int rowNum) throws SQLException {
		Category c = new Category();
		c.setCtId(rs.getInt("ct_id"));
		c.setCtName(rs.getString("ct_name"));
		c.setCtCode(rs.getString("ct_code"));
		c.setCtLevel(rs.getInt("ct_level"));
		
		int parentId = rs.getInt("ct_parent_id");
		if(rs.wasNull()) {
			c.setCtParentId(null);
		} else {
			c.setCtParentId(parentId);
		}
		return c;
	}
}
