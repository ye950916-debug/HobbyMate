package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.ClubMember;

public class ClubMemberRowMapper implements RowMapper<ClubMember> {
	
	@Override
	public ClubMember mapRow(ResultSet rs, int rowNum) throws SQLException {
		ClubMember cm = new ClubMember();
		cm.setCmMId(rs.getString("cm_m_id"));
		cm.setCmCId(rs.getInt("cm_c_id"));
		cm.setCmRole(rs.getString("cm_role"));
		cm.setCmJoinDate(rs.getTimestamp("cm_join_date").toLocalDateTime());
		cm.setCmStatus(rs.getString("cm_status"));
		return cm;
	}
}
