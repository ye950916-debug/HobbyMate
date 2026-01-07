package com.springmvc.repository;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.ClubCategory;

@Repository
public class ClubCategoryRepositoryImpl implements ClubCategoryRepository {
	
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public void insertClubCategory(ClubCategory cc) {
		String sql = "INSERT INTO CLUBCATEGORY (c_id, ct_id) VALUES (?, ?)";
		jdbcTemplate.update(sql, cc.getcId(), cc.getCtId());
	}
	
	@Override
	public List<Integer> findCategoryiesByIds(int clubId) {
		String sql = "SELECT ct_id FROM CLUBCATEGORY WHERE c_id=?";
		return jdbcTemplate.query(sql, new Object[] {clubId}, new ClubCategoryRowMapper());
	}
	
	@Override
	public void deleteByClubId(int clubId) {
		String sql = "DELETE FROM CLUBCATEGORY WHERE c_id=?";
		jdbcTemplate.update(sql, new Object[] {clubId});
	}
	
	@Override
	public void insertClubCategory(int clubId, int ctId) {
		String sql = "INSERT INTO CLUBCATEGORY (c_id, ct_id) VALUES (?, ?)";
		jdbcTemplate.update(sql, clubId, ctId);
	}
	
	@Override
	public void deleteClubCategory(int clubId) {
		String sql = "DELETE FROM CLUBCATEGORY WHERE c_id=?";
		jdbcTemplate.update(sql, clubId);
	}
	
	// categoryid로 해당 카테고리에 부합하는 club의 clubid 조회
	@Override
	public List<Integer> getClubIdsByCategoryIds(List<Integer> ctIds) {
		if (ctIds == null || ctIds.isEmpty()) {
			return Collections.emptyList(); 
        }
		
		// IN 절에 들어갈 '?, ?, ?' 형태의 문자열 생성
		StringBuilder inClauseBuilder = new StringBuilder();
        for (int i = 0; i < ctIds.size(); i++) {
            inClauseBuilder.append("?");
            if (i < ctIds.size() - 1) { 
                inClauseBuilder.append(", ");
            }
        }
        String inClause = inClauseBuilder.toString();
        
        // CLUBCATEGORY 테이블에서 c_id만 조회
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT DISTINCT c_id FROM CLUBCATEGORY ");
        // 생성한 IN 절을 연결
        sqlBuilder.append("WHERE ct_id IN (").append(inClause).append(") ");
        sqlBuilder.append("ORDER BY c_id DESC");
		
        String sql = sqlBuilder.toString();
        
		
        return jdbcTemplate.queryForList(sql, Integer.class, ctIds.toArray());
	}
}