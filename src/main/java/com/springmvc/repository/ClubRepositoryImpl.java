package com.springmvc.repository;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubDetail;
import com.springmvc.service.ClubService;

@Repository
public class ClubRepositoryImpl implements ClubRepository {
	
	@Autowired
	private JdbcTemplate template;
	
	@Override
	public void insertClub(Club club) {
		String sql = "INSERT INTO club (c_name, c_description, c_create_date, c_founder_id, c_max_members, c_member_count, c_location, c_si_do, c_si_do_code, c_gu_gun, c_gu_gun_code, c_dong, c_dong_code, c_main_place, c_main_image_name)" 
	+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		template.update(sql,
		    club.getcName(),
		    club.getcDescription(),
		    Timestamp.valueOf(club.getcCreateDate()),
		    club.getcFounderId(),
		    club.getcMaxMembers(),
		    club.getcMemberCount(),
		    club.getcLocation(),
		    club.getcSiDo(),
		    club.getcSiDoCode(),
		    club.getcGuGun(),
		    club.getcGuGunCode(),
		    club.getcDong(),
		    club.getcDongCode(),
		    club.getcMainPlace(),
		    club.getcMainImageName()
		);
	}
	
	
	@Override
	public boolean existsClubName(String clubName) {
		String sql = "SELECT COUNT(*) FROM CLUB WHERE c_name = ? AND c_status = 'ACTIVE'";
		Integer count = template.queryForObject(sql, Integer.class, clubName);
		return count != null && count>0;
	}
	
	@Override
	public List<Club> findClubsByIds(List<Integer> clubIds) {
		if(clubIds == null || clubIds.isEmpty()) {
			return new ArrayList<>();
		}
		String placeholders = "";
		for(int i=0; i<clubIds.size(); i++) {
			if(i>0)  {
				placeholders += ",";
			}
			placeholders += "?";
		}
		
		String sql = "SELECT * FROM CLUB WHERE c_id IN(" + placeholders + ") AND c_status = 'ACTIVE'";

		return template.query(sql, clubIds.toArray(), new ClubRowMapper());
	}
	
	@Override
	public Club findClubByClubId(int clubId) {
		String sql = "SELECT * FROM CLUB WHERE c_id = ? AND c_status = 'ACTIVE'";
		return template.queryForObject(sql, new Object[] {clubId}, new ClubRowMapper());
	}
	
	@Override
	public void updateClub(Club club) {
		String sql = "UPDATE CLUB SET c_name=?, c_description=?, c_max_members=?, c_member_count=?, c_location=?, c_si_do = ?, c_si_do_code =?, c_gu_gun = ?, c_gu_gun_code = ?, c_dong = ?, c_dong_code = ?,  c_main_place = ?, c_main_image_name = ?  WHERE c_id=?";
		
		template.update(sql,
				club.getcName(),
				club.getcDescription(),
				club.getcMaxMembers(),
				club.getcMemberCount(),
				club.getcLocation(),
				club.getcSiDo(),
				club.getcSiDoCode(),
				club.getcGuGun(),
				club.getcGuGunCode(),
				club.getcDong(),
				club.getcDongCode(),
				club.getcMainPlace(),
				club.getcMainImageName(),
				club.getcId()
		);
	}
	
	// 클럽 삭제(클럽리더)
	@Override
	public void deleteClub(int clubId) {
	    String sql = "UPDATE CLUB SET c_status = 'DELETED' WHERE c_id = ?";
	    template.update(sql, clubId);
	}
	
	//대-중-소 카테고리 정보 담긴 club리스트
	@Override
	public List<ClubDetail> getAllClubDetails() {
		String SQL = 
				"SELECT C.*, "
				+ "S.ct_id AS sub_id, S.ct_name AS sub_name, "
				+ "M.ct_id AS mid_id, M.ct_name AS mid_name, "
				+ "L.ct_id AS lrg_id, L.ct_name AS lrg_name, "
				+ "(SELECT cm_m_id FROM CLUBMEMBER WHERE cm_c_id = C.c_id AND cm_role='LEADER' LIMIT 1) AS leader_id "
				+ "FROM CLUB C "
				+ "LEFT JOIN CLUBCATEGORY CC ON C.c_id = CC.c_id "
				+ "LEFT JOIN CATEGORY S ON CC.ct_id = S.ct_id "
				+ "LEFT JOIN CATEGORY M ON S.ct_parent_id = M.ct_id "
				+ "LEFT JOIN CATEGORY L ON M.ct_parent_id = L.ct_id "
				+ "WHERE C.c_status = 'ACTIVE'";
		List<ClubDetail> clubs = template.query(SQL, new ClubDetailRowMapper());
		return clubs;
	}
	
	@Override
	public Club findClubByLeaderId(String clubLeaderId) {
	    String sql =
	            "SELECT C.* " +
	            "FROM CLUB C " +
	            "JOIN CLUBMEMBER CM ON C.c_id = CM.cm_c_id " +
	            "WHERE CM.cm_m_id = ? " +
	            "AND CM.cm_role = 'LEADER' " +
	            "AND C.c_status = 'ACTIVE'";
	    return template.queryForObject(sql, new Object[]{clubLeaderId}, new ClubRowMapper());
	}
	
	@Override
	public int getLastInsertId() {
		String sql = "SELECT LAST_INSERT_ID()";
	    return template.queryForObject(sql, Integer.class);
	}
	
	@Override
	public List<Integer> findLeaderClubIdsByMemberId(String mId) {
	    String sql =
	            "SELECT c.c_id " +
	            "FROM CLUB c " +
	            "JOIN CLUBMEMBER cm ON c.c_id = cm.cm_c_id " +
	            "WHERE cm.cm_m_id = ? " +
	            "AND cm.cm_role = 'LEADER' " +
	            "AND c.c_status = 'ACTIVE'";

	        return template.queryForList(sql, Integer.class, mId);
	}


	@Override
	public String findClubNameById(String cId) {
		String sql = "SELECT C_name FROM CLUB WHERE c_id = ? ";
		return template.queryForObject(sql, String.class, cId);
	}
	
	@Override
	public void updateClubMemberCount(int clubId, int count) {
		String sql = "UPDATE CLUB SET c_member_count = c_member_count + ? WHERE c_id = ?";
		template.update(sql, count, clubId);
	}
	
	@Override
	public List<ClubDetail> getClubsByCategoriesAndLocation(List<Integer> categoryIds, String sido, String gugun) {
		// 유효성 검사
        if (categoryIds == null || categoryIds.isEmpty() || sido == null || gugun == null) {
            return Collections.emptyList();
        }
		
		// IN 절에 들어갈 '?, ?, ?' 형태의 문자열 생성
        StringBuilder inSqlBuilder = new StringBuilder();
        for (int i = 0; i < categoryIds.size(); i++) {
            inSqlBuilder.append("?");
            if (i < categoryIds.size() - 1) { 
                inSqlBuilder.append(", ");
            }
        }
        String inSql = inSqlBuilder.toString();
        
        String sql = String.format(
        	    "SELECT C.*, "
        	    + "MIN(S.ct_id) AS sub_id, MIN(S.ct_name) AS sub_name, "
        	    + "MIN(M.ct_id) AS mid_id, MIN(M.ct_name) AS mid_name, "
        	    + "MIN(L.ct_id) AS lrg_id, MIN(L.ct_name) AS lrg_name, "
        	    + "(SELECT cm_m_id FROM CLUBMEMBER WHERE cm_c_id = C.c_id AND cm_role='LEADER' LIMIT 1) AS leader_id "
        	    + "FROM CLUB C "
        	    + "LEFT JOIN CLUBCATEGORY CC ON C.c_id = CC.c_id "
        	    + "LEFT JOIN CATEGORY S ON CC.ct_id = S.ct_id "
        	    + "LEFT JOIN CATEGORY M ON S.ct_parent_id = M.ct_id "
        	    + "LEFT JOIN CATEGORY L ON M.ct_parent_id = L.ct_id "
        	    + "WHERE C.c_status = 'ACTIVE' "
        	    + "AND C.c_si_do = ? AND C.c_gu_gun = ? "
        	    + "AND CC.ct_id IN (%s) "
        	    + "GROUP BY C.c_id",
        	    inSql
        	);

    		// 파라미터 리스트 구성: [sido, gugun, categoryId1, categoryId2, ...]
	        List<Object> paramsList = new ArrayList<>();
	        paramsList.add(sido);
	        paramsList.add(gugun);
	        paramsList.addAll(categoryIds); // List<Integer>를 List<Object>에 추가
	        
	        Object[] params = paramsList.toArray();

	        // 🚨 5단계: 쿼리 실행
	        // JdbcTemplate이 SQL, Object 배열 파라미터, RowMapper를 사용해 쿼리를 실행합니다.
	        return template.query(sql, params, new ClubDetailRowMapper());
	}
	
	@Override
	public List<ClubDetail> getClubsByLocation(String memberSido, String memberGugun) {
		String sql =
			    "SELECT C.*, "
			  + "MIN(S.ct_id) AS sub_id, MIN(S.ct_name) AS sub_name, "
			  + "MIN(M.ct_id) AS mid_id, MIN(M.ct_name) AS mid_name, "
			  + "MIN(L.ct_id) AS lrg_id, MIN(L.ct_name) AS lrg_name, "
			  + "(SELECT cm_m_id FROM CLUBMEMBER WHERE cm_c_id = C.c_id AND cm_role='LEADER' LIMIT 1) AS leader_id "
			  + "FROM CLUB C "
			  + "LEFT JOIN CLUBCATEGORY CC ON C.c_id = CC.c_id "
			  + "LEFT JOIN CATEGORY S ON CC.ct_id = S.ct_id "
			  + "LEFT JOIN CATEGORY M ON S.ct_parent_id = M.ct_id "
			  + "LEFT JOIN CATEGORY L ON M.ct_parent_id = L.ct_id "
			  + "WHERE C.c_status = 'ACTIVE' "
			  + "AND C.c_si_do = ? AND C.c_gu_gun = ? "
			  + "GROUP BY C.c_id";

		
		List<ClubDetail> cd = template.query(sql, new Object[] {memberSido, memberGugun}, new ClubDetailRowMapper());
		
		return cd;
	}
	
	@Override
	public List<Club> findClubsByClubIds(List<Integer> clubIds) {
		String sql = "SELECT * FROM CLUB WHERE c_id = ? AND c_status = 'ACTIVE'";
		List<Club> clubs = new ArrayList<>(); ;
		for(int i=0; i<clubIds.size(); i++) {
			int clubId = clubIds.get(i);
			clubs.add(template.queryForObject(sql, new Object[] {clubId}, new ClubRowMapper()));
		}
		return clubs;
	}
	
	@Override
	public List<ClubDetail> getClubsBySearch(String searchType, String searchKeyword) {
		// 1. 기본 쿼리 (WHERE 조건은 제외)
		String baseSql = "SELECT " +
		                 // 1. CLUB 기본 정보 (컬럼 이름은 DB와 일치해야 하며, 여기서는 RowMapper에 맞춤)
		                 "c.c_id, c.c_name, c.c_description, c.c_max_members, " +
		                 "c.c_create_date, " + 
		                 "c.c_si_do, c.c_si_do_code, c.c_gu_gun, c.c_gu_gun_code, c.c_main_place, c.c_main_image_name, c.c_founder_id, c.c_location, c.c_dong, c.c_dong_code, " +

		                 // 2. 카테고리 정보 (RowMapper의 Alias와 일치)
		                 "ct_sub.ct_id AS sub_id, ct_sub.ct_name AS sub_name, " +
		                 "ct_mid.ct_id AS mid_id, ct_mid.ct_name AS mid_name, " +
		                 "ct_lrg.ct_id AS lrg_id, ct_lrg.ct_name AS lrg_name, " +

		                 "(SELECT m.m_id FROM CLUBMEMBER cm JOIN member m ON cm.cm_m_id = m.m_id WHERE cm.cm_c_id = c.c_id AND cm.cm_role = 'LEADER') AS leader_id, " + 
		                 "(SELECT COUNT(*) FROM CLUBMEMBER cm WHERE cm.cm_c_id = c.c_id AND cm.cm_status = 'A') AS c_member_count " +
		                 
		                 // FROM 절 및 JOIN 로직
		                 "FROM CLUB c " +
		                 "LEFT JOIN CLUBCATEGORY cc ON c.c_id = cc.c_id " +
		                 "LEFT JOIN CATEGORY ct_sub ON cc.ct_id = ct_sub.ct_id " +
		                 "LEFT JOIN CATEGORY ct_mid ON ct_sub.ct_parent_id = ct_mid.ct_id " +
		                 "LEFT JOIN CATEGORY ct_lrg ON ct_mid.ct_parent_id = ct_lrg.ct_id " +
		                 "WHERE c.c_status = 'ACTIVE' ";

	    StringBuilder sqlBuilder = new StringBuilder(baseSql);
	    List<Object> params = new ArrayList<>();
	    
	    // 2. 동적 WHERE 조건 추가
	    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	        String keyword = "%" + searchKeyword.trim() + "%";
	        
	        sqlBuilder.append(" AND (");
	        
	        // 검색 타입에 따라 조건 삽입
	        if ("name".equals(searchType)) {
	            sqlBuilder.append("c.c_name LIKE ?");
	            params.add(keyword);
	            
	        } else if ("content".equals(searchType)) {
	            sqlBuilder.append("c.c_description LIKE ?");
	            params.add(keyword);
	            
	        } else {
	        	sqlBuilder.append("c.c_name LIKE ?");
	        	params.add(keyword);
	        }
	        
	        sqlBuilder.append(")"); // AND ( ... ) 닫기
	    }

	    // 3. 정렬 조건 추가
	    sqlBuilder.append(" ORDER BY c.c_create_date DESC");

	    // 4. JdbcTemplate 실행
	    return template.query(sqlBuilder.toString(), params.toArray(), new ClubDetailRowMapper());
	}
	
	@Override
	public List<ClubDetail> selectFilteredClubs(Map<String, Object> filters) {

	    String baseSql =
	        "SELECT " +
	        "c.c_id, c.c_name, c.c_description, c.c_max_members, " +
	        "c.c_create_date, " +
	        "c.c_si_do, c.c_si_do_code, c.c_gu_gun, c.c_gu_gun_code, " +
	        "c.c_main_place, c.c_main_image_name, c.c_founder_id, " +
	        "c.c_location, c.c_dong, c.c_dong_code, " +

	        "ct_sub.ct_id AS sub_id, ct_sub.ct_name AS sub_name, " +
	        "ct_mid.ct_id AS mid_id, ct_mid.ct_name AS mid_name, " +
	        "ct_lrg.ct_id AS lrg_id, ct_lrg.ct_name AS lrg_name, " +

	        "(SELECT m.m_id FROM CLUBMEMBER cm JOIN MEMBER m " +
	        " WHERE cm.cm_m_id = m.m_id AND cm.cm_c_id = c.c_id AND cm.cm_role = 'LEADER') AS leader_id, " +
	        "(SELECT COUNT(*) FROM CLUBMEMBER cm " +
	        " WHERE cm.cm_c_id = c.c_id AND cm.cm_status = 'A') AS c_member_count " +

	        "FROM CLUB c " +
	        "LEFT JOIN CLUBCATEGORY cc ON c.c_id = cc.c_id " +
	        "LEFT JOIN CATEGORY ct_sub ON cc.ct_id = ct_sub.ct_id " +
	        "LEFT JOIN CATEGORY ct_mid ON ct_sub.ct_parent_id = ct_mid.ct_id " +
	        "LEFT JOIN CATEGORY ct_lrg ON ct_mid.ct_parent_id = ct_lrg.ct_id " +
	        "WHERE c.c_status = 'ACTIVE' ";

	    StringBuilder sqlBuilder = new StringBuilder(baseSql);
	    List<Object> params = new ArrayList<>();

	    // 지역
	    if (filters.get("sidoCode") != null) {
	        sqlBuilder.append(" AND c.c_si_do_code = ?");
	        params.add(filters.get("sidoCode"));
	    }

	    if (filters.get("gugunCode") != null) {
	        sqlBuilder.append(" AND c.c_gu_gun_code = ?");
	        params.add(filters.get("gugunCode"));
	    }

	    // 카테고리
	    if (filters.get("largeCode") != null) {
	        sqlBuilder.append(" AND ct_lrg.ct_code = ?");
	        params.add(filters.get("largeCode"));
	    }

	    if (filters.get("midCode") != null) {
	        sqlBuilder.append(" AND ct_mid.ct_code = ?");
	        params.add(filters.get("midCode"));
	    }

	    if (filters.get("subCode") != null) {
	        sqlBuilder.append(" AND ct_sub.ct_code = ?");
	        params.add(filters.get("subCode"));
	    }

	    // 키워드 검색
	    String keyword = (String) filters.get("searchKeyword");
	    String searchType = (String) filters.get("searchType");

	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sqlBuilder.append(" AND ");
	        if ("content".equals(searchType)) {
	            sqlBuilder.append("c.c_description LIKE ?");
	        } else {
	            sqlBuilder.append("c.c_name LIKE ?");
	        }
	        params.add("%" + keyword.trim() + "%");
	    }

	    sqlBuilder.append(" ORDER BY c.c_create_date DESC");

	    return template.query(sqlBuilder.toString(), params.toArray(), new ClubDetailRowMapper());
	}

	
}
