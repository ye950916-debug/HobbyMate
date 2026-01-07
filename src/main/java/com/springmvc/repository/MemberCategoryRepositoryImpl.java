package com.springmvc.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class MemberCategoryRepositoryImpl implements MemberCategoryRepository {
	
	@Autowired
	private JdbcTemplate template;
	
	public void insertMemberCategory(String mId, int ctId) {
		String sql = "INSERT INTO MEMBERCATEGORY (m_id, ct_id) VALUES (?, ?)";
		template.update(sql, mId, ctId);
	}

	@Override
	public List<Integer> getCategoryIdsByMemberId(String mId) {
		String sql = "SELECT ct_id FROM MEMBERCATEGORY WHERE m_id = ? ORDER BY mct_id ASC";
		return template.queryForList(sql, Integer.class, mId);
	}

	@Override
	public void deleteAll(String mId) {
		String sql = "DELETE FROM MEMBERCATEGORY WHERE m_id = ?";
		template.update(sql, mId);
		
	}
	
	@Override
	public List<Integer> getMemberCategoryIds(String memberId) {
		String sql = "SELECT ct_id FROM MEMBERCATEGORY where m_id = ?";
		return template.queryForList(sql, Integer.class, memberId);
	}

}
