package com.springmvc.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;

@Repository
public class ScheduleRepositoryImpl implements ScheduleRepository {

	@Autowired
	private JdbcTemplate template;
	
	@Autowired
	private RowMapper<Schedule> scheduleRowMapper;
	
	//내가 속한 모든 클럽의 일정 조회
	@Override
    public List<Schedule> getSchedulesByClubIds(List<Integer> clubIds) {
        if (clubIds == null || clubIds.isEmpty()) {
            return new ArrayList<>();
        }

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT * FROM SCHEDULE ");
        sqlBuilder.append("WHERE s_status IN ('ACTIVE', 'STOPPED') ");
        sqlBuilder.append("AND c_id IN (");

        for (int i = 0; i < clubIds.size(); i++) {
            sqlBuilder.append("?");
            if (i < clubIds.size() -1) {
                sqlBuilder.append(", ");
            }
        }
        sqlBuilder.append(")");

        String sql = sqlBuilder.toString();

        Object[] params = clubIds.toArray();

        return template.query(sql, params, new ScheduleRowMapper());
    }


	//특정 클럽 일정 조회
    @Override
    public List<Schedule> getSchedulesByClubId(String cId) {
        String sql = "SELECT * FROM SCHEDULE WHERE c_id = ? AND s_status IN ('ACTIVE', 'STOPPED') ORDER BY start_time ASC";
        return template.query(sql, new BeanPropertyRowMapper<>(Schedule.class), cId);
    }

	//모임 일정 추가
	@Override
	public void addSchedule(Schedule schedule) {
		String sql = "INSERT INTO SCHEDULE "
					+ "(c_id, register_id, event_title, event_content, start_time, end_time, create_event_date, people_limit, event_address, event_detail_address, latitude, longitude) "
					+ "VALUES (?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)";
		template.update(sql,
						schedule.getcId(),
						schedule.getRegisterId(),
						schedule.getEventTitle(),
						schedule.getEventContent(),
						schedule.getStartTime(),
						schedule.getEndTime(),
						schedule.getPeopleLimit(),
						schedule.getEventAddress(),
						schedule.getEventDetailAddress(),
			            schedule.getLatitude(),
			            schedule.getLongitude()
						);
	}
	
	//모임 일정 고유 번호 조회
	@Override
	public Schedule getScheduleByNum(int eventNo) {
		String sql = "SELECT * FROM SCHEDULE WHERE event_no = ? AND s_status IN ('ACTIVE', 'STOPPED')";
        return template.queryForObject(sql, new ScheduleRowMapper(), eventNo);
	}
	
	//모임 일정 업데이트(리더)
	@Override
	public void updateSchedule(Schedule schedule) {
		String sql = "UPDATE SCHEDULE SET "
		        + "event_title = ?, "
		        + "event_content = ?, "
		        + "start_time = ?, "
		        + "end_time = ?, "
		        + "people_limit = ?, "
		        + "event_address = ?, "
		        + "event_detail_address = ?, "
		        + "latitude = ?, "
		        + "longitude = ? "
		        + "WHERE event_no = ? AND s_status = 'ACTIVE'";
		
		template.update(sql,
						schedule.getEventTitle(),
						schedule.getEventContent(),
						schedule.getStartTime(),
						schedule.getEndTime(),
						schedule.getPeopleLimit(),
						schedule.getEventAddress(),
						schedule.getEventDetailAddress(),
				        schedule.getLatitude(),
				        schedule.getLongitude(),
						schedule.getEventNo() 
						);
		
	}
	
	//모임 일정 삭제(리더)
	@Transactional
	@Override
	public void deleteSchedule(int eventNo) {
		
		String sql;

		sql = "DELETE FROM MEMBERSCHEDULE WHERE event_no = ?";
		template.update(sql, eventNo);

		sql = "UPDATE SCHEDULE SET s_status = 'REMOVED' WHERE event_no = ?";
		template.update(sql, eventNo);
		
	}

	//현재 모임 참여 인원 구하는 SQL
	@Override
	public int getCurrentParticipantCount(int eventNo) {
		String sql = "SELECT COUNT(*) FROM MEMBERSCHEDULE WHERE event_no = ?";
		Integer count = template.queryForObject(sql, Integer.class, eventNo);
		return count == null ? 0 : count;
	}
	
	//모임 정원(people_limit) 가져오기
	public int getPeopleLimit(int eventNo) {
		String sql = "SELECT people_limit FROM SCHEDULE WHERE event_no = ?";
		return template.queryForObject(sql, Integer.class, eventNo);
	}


	@Override
	public void memberSchedule(String mId, int eventNo) {
		String sql = "INSERT INTO MEMBERSCHEDULE "
				+ "(m_id, event_no) "
				+ "VALUES (?, ?)";
		
		template.update(sql, mId, eventNo);
	}
	
	@Override
	public List<Schedule> memberScheduleList(String mId) {
		
		String sql = "SELECT s.* FROM SCHEDULE s JOIN MEMBERSCHEDULE ms ON s.event_no = ms.event_no JOIN CLUBMEMBER cm ON s.c_id = cm.cm_c_id AND cm.cm_m_id = ms.m_id JOIN CLUB c ON s.c_id = c.c_id WHERE ms.m_id = ? AND s.s_status IN ('ACTIVE', 'STOPPED') AND cm.cm_status = 'A' AND c.c_status = 'ACTIVE' ORDER BY s.start_time ASC"; 
		
		return template.query(sql, new ScheduleRowMapper(), mId);
	}


	@Override
	public int findLastEventNoByClubAndMember(String cId, String mId) {
		String sql = "SELECT event_no FROM SCHEDULE WHERE c_id = ? AND register_id = ? ORDER BY create_event_date DESC LIMIT 1";
		return template.queryForObject(sql, Integer.class, cId, mId);
	}


	@Override
	public boolean existsMemberSchedule(String mId, int eventNo) {
		 String sql = "SELECT COUNT(*) FROM MEMBERSCHEDULE WHERE m_id = ? AND event_no = ?";
		 Integer count = template.queryForObject(sql, Integer.class, mId, eventNo);
		 return count != null && count > 0;
	}
	
	@Override
	public List<Integer> getMemberEventNos(String mId) {
	    String sql = "SELECT s.event_no FROM SCHEDULE s JOIN MEMBERSCHEDULE ms ON s.event_no = ms.event_no JOIN CLUBMEMBER cm ON s.c_id = cm.cm_c_id AND cm.cm_m_id = ms.m_id JOIN CLUB c ON s.c_id = c.c_id WHERE ms.m_id = ? AND s.s_status IN ('ACTIVE', 'STOPPED') AND cm.cm_status = 'A' AND c.c_status = 'ACTIVE'";
	    return template.queryForList(sql, Integer.class, mId);
	}
	
	@Override
	public void deleteMemberSchedule(int eventNo) {
	    String sql = "DELETE FROM MEMBERSCHEDULE WHERE event_no = ?";
	    template.update(sql, eventNo);
	}
	
	@Override
	public void deleteOnlyMemberSchedule(String mId, int eventNo) {

	    String sql = "DELETE FROM MEMBERSCHEDULE "
	               + "WHERE m_id = ? AND event_no = ?";

	    template.update(sql, mId, eventNo);
	}


	@Override
	public List<Member> getParticipants(int eventNo) {
		  String sql = "SELECT m.* FROM MEMBER m JOIN MEMBERSCHEDULE ms ON m.m_id = ms.m_id WHERE ms.event_no = ?";
    return template.query(sql, new MemberRowMapper(), eventNo);
	}


	@Override
	public void deleteMemberScheduleByMember(String mId) {
		String sql = "DELETE FROM MEMBERSCHEDULE WHERE m_id = ?";
	    template.update(sql, mId);
		
	}


	@Override
	public void nullifyRegisterId(String mId) {
		String sql = "UPDATE SCHEDULE SET register_id = NULL WHERE register_id = ?";
		template.update(sql, mId);
	}


	@Override
	public List<Schedule> getAllSchedules() {
		String sql = "SELECT * FROM SCHEDULE WHERE s_status IN ('ACTIVE', 'STOPPED') ORDER BY start_time ASC";
		return template.query(sql, new ScheduleRowMapper());
	}


	@Override
	public void deleteMemberScheduleByEventNo(int eventNo) {
		String sql = "DELETE FROM MEMBERSCHEDULE WHERE event_no = ?";
		template.update(sql, eventNo);
	}
	
	@Override
	public void updateScheduleStatus(int eventNo, String status) {
	    String sql = "UPDATE SCHEDULE SET s_status = ? WHERE event_no = ?";
	    template.update(sql, status, eventNo);
	}
	
	@Override
	public List<Schedule> getSchedulesByClubId(int clubId) {
		String sql = "SELECT * FROM schedule WHERE s_status IN ('ACTIVE', 'STOPPED') AND c_id = ? ORDER BY start_time ASC";
	    return template.query(sql, new ScheduleRowMapper(), clubId);
	}


	@Override
	public List<Schedule> selectSchedulesByClubIdsAndSearch(Map<String, Object> paramMap) {
		List<Integer> clubIds = (List<Integer>) paramMap.get("clubIds");
	    String searchKeyword = (String) paramMap.get("searchKeyword");
	    
	    // 1. 기본 SQL 쿼리 구성 (IN 절은 항상 포함)
	    String inSql = String.join(",", java.util.Collections.nCopies(clubIds.size(), "?"));
	    String sql = "SELECT s.* FROM SCHEDULE s JOIN CLUB c ON s.c_id = c.c_id WHERE s.s_status IN ('ACTIVE', 'STOPPED') AND s.c_id IN (" + inSql + ")"; 
	    
	    // 2. 파라미터 리스트 초기화 (clubIds는 항상 포함)
	    List<Object> params = new ArrayList<>(clubIds);
	    
	    // 3. 검색 키워드가 있을 경우 SQL에 AND 조건 추가 및 파라미터 추가
	    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	        // ✨ CONCAT으로 수정: s.event_title LIKE CONCAT('%', ?, '%') ✨
	        sql = sql + " AND (s.event_title LIKE CONCAT('%', ?, '%') OR c.c_name LIKE CONCAT('%', ?, '%'))"; 
	        params.add(searchKeyword);
	        params.add(searchKeyword);
	    }
	    
	    // 4. ORDER BY 추가
	    sql = sql + " ORDER BY s.start_time ASC"; 
	    
	    // 5. 쿼리 실행
	    return template.query(sql, scheduleRowMapper, params.toArray());
	}


	@Override
	public List<Schedule> selectAllSchedulesAndSearch(Map<String, Object> paramMap) {
		String searchKeyword = (String) paramMap.get("searchKeyword");
	    
	    // 1. 기본 SQL 쿼리 (WHERE 절 없음)
	    String sql = "SELECT s.* FROM SCHEDULE s JOIN CLUB c ON s.c_id = c.c_id WHERE s.s_status IN ('ACTIVE', 'STOPPED')";
	    List<Object> params = new ArrayList<>();
	    
	    // 2. 검색 키워드가 있을 경우 WHERE 조건 추가 및 파라미터 추가
	    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	        // ✨ CONCAT으로 수정: s.event_title LIKE CONCAT('%', ?, '%') ✨
	        // 참고: 기존 코드의 'sql +=' 부분도 요청대로 'sql = sql + ...'로 대체 가능
	        sql = sql + " AND (s.event_title LIKE CONCAT('%', ?, '%') OR c.c_name LIKE CONCAT('%', ?, '%'))";
	        params.add(searchKeyword);
	        params.add(searchKeyword);
	    }
	    
	    // 3. ORDER BY 추가
	    sql = sql + " ORDER BY s.start_time ASC";
	    
	    // 4. 쿼리 실행 (파라미터 리스트의 내용에 따라 실행)
	    return template.query(sql, scheduleRowMapper, params.toArray());
	}
	
    @Override
    public void deleteSchedulesByClubId(int clubId) {
            String sql = "UPDATE SCHEDULE SET s_status = 'ARCHIVED' WHERE c_id = ?";
            template.update(sql, clubId);
    }
    
    @Override
    public List<Integer> findEventNosByClubId(int clubId) {
            String sql = "SELECT event_no FROM SCHEDULE WHERE c_id = ? AND s_status != 'REMOVED'";
        return template.queryForList(sql, Integer.class, clubId);
    }
	
    @Override
    public Schedule getScheduleForHobbyLog(int eventNo) {
        String sql =
                "SELECT * FROM SCHEDULE " +
                "WHERE event_no = ? " +
                "AND s_status IN ('ACTIVE', 'STOPPED', 'ARCHIVED')";
            try {
                return template.queryForObject(sql, new ScheduleRowMapper(), eventNo);
            } catch (Exception e) {
                return null; // 일정 정보가 완전히 없는 경우
            }
    }
}
