package com.springmvc.repository;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;


@Repository
public class ClubMemberRepositoryImpl implements ClubMemberRepository {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//clubmember 테이블에 데이터 추가(멤버가입)
	@Override
	public void insertClubMember(ClubMember clubMember) {
		String sql = "INSERT INTO CLUBMEMBER (cm_m_id, cm_c_id, cm_role, cm_join_date, cm_status) VALUES(?, ?, ?, ?, ?)";
		jdbcTemplate.update(sql, 
				clubMember.getCmMId(), 
				clubMember.getCmCId(), 
				clubMember.getCmRole(), 
				Timestamp.valueOf(clubMember.getCmJoinDate()), 
				clubMember.getCmStatus());
	}
	
	//회원 아이디를 이용해 해당 회원이 가입한 club 목록 가져오기
	@Override
	public List<Club> findClubInfobyMId(String loginId) {
		String sql = "SELECT c.* FROM CLUBMEMBER cm "
				+ "JOIN CLUB c ON cm.cm_c_id = c.c_id "
				+ "WHERE cm.cm_m_id=?";
		 return jdbcTemplate.query(sql, (rs, rowNum) -> {
		        Club club = new Club();
		        club.setcId(rs.getInt("c_id"));
		        club.setcName(rs.getString("c_name"));
		        club.setcDescription(rs.getString("c_description"));
		        club.setcLocation(rs.getString("c_location"));
		        club.setcMaxMembers(rs.getInt("c_max_members"));
		        club.setcCreateDate(rs.getTimestamp("c_create_date").toLocalDateTime());
		        club.setcFounderId(rs.getString("c_founder_id"));
		        return club;
		    }, loginId);
	}
	
	@Override
	public void insertLeaderAsMember(int clubId, String memberId) {
		String sql = "INSERT INTO CLUBMEMBER (cm_m_id, cm_c_id, cm_role, cm_status, cm_join_date) VALUES (?, ?, 'LEADER', 'A', NOW())";
		jdbcTemplate.update(sql, memberId, clubId);
	}
	
	//모임 가입 승인
	@Override
	public void applyJoin(int clubId, String memberId) {
		String sql = "INSERT INTO CLUBMEMBER (cm_m_id, cm_c_id, cm_role, cm_status, cm_join_date) VALUES (?, ?, 'MEMBER', 'W', NOW())";
		jdbcTemplate.update(sql, memberId, clubId);
	}
	
	//모임 회원 리스트 가져오기
	@Override
	public ClubMember getClubMember(String memberId, int clubId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_m_id=? AND cm_c_id=?";
		List<ClubMember> list = jdbcTemplate.query(sql, new Object[] {memberId, clubId}, new ClubMemberRowMapper());
		if (list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}
	
	
	//상태에 따른 모임 회원 목록 가져오기
	@Override
	public List<ClubMember> getMembersByStatus(int clubId, String status) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_status=?";
		List<ClubMember> list = jdbcTemplate.query(sql, new Object[] {clubId, status}, new ClubMemberRowMapper());
		return list;
	}
	
	
	@Override
	public List<Integer> getClubIdsByMembersStatus(String memberId, String status) {
		String sql = "SELECT cm_c_id FROM CLUBMEMBER WHERE cm_m_id = ? AND cm_status = ?";
		List<Integer> clubIds = jdbcTemplate.queryForList(sql, Integer.class, memberId, status); 
		return clubIds;
	}
	
	//모임 회원 상태 수정
	@Override
	public void updateStatus(String memberId, int clubId, String status) {
		String sql = "UPDATE CLUBMEMBER SET cm_status=? WHERE cm_m_id=? AND cm_c_id=?";
		jdbcTemplate.update(sql, status, memberId, clubId);
	}
	
	//모임 회원 삭제
	@Override
	public String deleteMember(String memberId, int clubId) {
		
		ClubMember cm = getClubMember(memberId, clubId);
		String statusBeforeDelete;
		if(cm != null) {
			statusBeforeDelete = cm.getCmStatus();
		}
		else {
			statusBeforeDelete = null;
		}
		
		String sql = "DELETE FROM CLUBMEMBER WHERE cm_m_id=? AND cm_c_id=?";
		jdbcTemplate.update(sql, memberId, clubId);
		
		return statusBeforeDelete;
	}
	
	//멤버가 가입한 모든 CLUB ID 조회
	@Override
	public List<Integer> findClubIdsByMemberId(String mId) {
		String sql = "SELECT cm_c_id FROM CLUBMEMBER WHERE cm_m_id = ?";
		return jdbcTemplate.queryForList(sql, Integer.class, mId);
	}
	
	//회원 아이디로 해당 회원이 leader인 모임id들 찾기
	@Override
	public List<Integer> findClubIdsByIdRole(String loginId, String role) {
		String sql = "SELECT cm_c_id FROM CLUBMEMBER WHERE cm_m_id = ? AND cm_role=?";
		return jdbcTemplate.queryForList(sql, Integer.class, loginId, role);
	}
	
	@Override
	public void deleteByMember(String mId) {
	    String sql = "DELETE FROM CLUBMEMBER WHERE cm_m_id = ?";
	    jdbcTemplate.update(sql, mId);
	}
	
	//로그인한 회원이 해당 클럽의 리더인지 여부 조회
	@Override
	public boolean loginMemberEqClubLeader(int clubId, String memberId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_m_id=? AND cm_role='LEADER'";
		List<ClubMember> list = jdbcTemplate.query(sql, new Object[] {clubId, memberId}, new ClubMemberRowMapper());
		if(list.size() == 0) {
			return false;
		}
		return true;
	}
	
	//리더를 제외한 모임의 멤버 목록(승인) 조회하기
	@Override
	public List<ClubMember> getApprovedMemberExceptLeader(int clubId, String leaderId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_status='A' AND cm_m_id != ? ";
		return jdbcTemplate.query(sql, new Object[] {clubId, leaderId}, new ClubMemberRowMapper());
	}
	
	//회원이 모임에서 승인상태인지 여부 확인
	@Override
	public boolean isApprovedMember(int clubId, String newLeaderId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_m_id=? AND cm_status='A'";
		List<ClubMember> list = jdbcTemplate.query(sql, new Object[] {clubId, newLeaderId}, new ClubMemberRowMapper());
		if(list.size() == 0) {
			return false;
		}
		return true;
	}
	
	//모임 멤버의 역할 바꾸기
	@Override
	public int updateRole(int clubId, String memberId, String role) {
		String sql = "UPDATE CLUBMEMBER SET cm_role=? WHERE cm_c_id=? AND cm_m_id=?";
		return jdbcTemplate.update(sql, role, clubId, memberId);
	}
	
	//관리자가 모임 멤버의 역할 바꾸기
	@Override
	public int updateRoleAdmin(int clubId, String memberId, String role) {
		String sql = "UPDATE CLUBMEMBER SET cm_role=? WHERE cm_m_id=? AND cm_c_id=?";
	    return jdbcTemplate.update(sql, role, memberId, clubId);
	}
	
	//해당 모임의 승인된 멤버 목록
	@Override
	public List<ClubMember> findApprovedMembers(int clubId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_status='A'";
	    return jdbcTemplate.query(sql, new Object[]{clubId}, new ClubMemberRowMapper());
	}
	
	//해당 모임의 리더 정보
	@Override
	public ClubMember findLeaderByClubId(int clubId) {
		String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id=? AND cm_role='LEADER'";

	    List<ClubMember> list =
	        jdbcTemplate.query(sql, new Object[]{clubId}, new ClubMemberRowMapper());

	    if (list == null || list.size() == 0) return null;

	    return list.get(0);
	}
	
	 @Override
	 public List<Club> findLeaderClubsByMemberId(String mId) {
		 	String sql = "SELECT C.* FROM CLUB C JOIN CLUBMEMBER CM ON C.c_id = CM.cm_c_id WHERE CM.cm_m_id = ? AND CM.cm_role = 'LEADER'";
		 return jdbcTemplate.query(sql, new ClubRowMapper(), mId);
	 }
	 
	 @Override
		public List<ClubMember> isLoginMemberJoinThisClub(int clubId, String loginId) {
			String sql = "SELECT * FROM CLUBMEMBER WHERE cm_c_id = ? AND cm_m_id = ?";
			return jdbcTemplate.query(sql, new ClubMemberRowMapper(), clubId, loginId);
		}
	 
	 @Override
     public void deleteMembersByClubId(int clubId) {
             String sql = "DELETE FROM CLUBMEMBER WHERE cm_c_id = ?";
             jdbcTemplate.update(sql, clubId);
     }
	 
     @Override
     public String getMemberStatus(int clubId, String memberId) {
             String sql = "SELECT cm_status FROM CLUBMEMBER WHERE cm_c_id = ? AND cm_m_id = ?";
             try {
             return jdbcTemplate.queryForObject(sql, String.class, clubId, memberId);
         } catch (Exception e) {
             return "NONE"; // 가입 기록 없음
         }
     }
	 
}
