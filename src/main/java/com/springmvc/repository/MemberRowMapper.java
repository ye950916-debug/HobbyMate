package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Member;

public class MemberRowMapper implements RowMapper<Member> {
	
	@Override
	public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
		Member m = new Member();
		
		m.setmId(rs.getString("m_id"));
		m.setmPw(rs.getString("m_pw"));
		m.setmName(rs.getString("m_name"));
		m.setmAge(rs.getInt("m_age"));
		m.setmGender(rs.getString("m_gender"));
		m.setmPhone(rs.getString("m_phone"));
		m.setmAddress(rs.getString("m_address"));
		m.setmSiDo(rs.getString("m_si_do"));
		m.setmGuGun(rs.getString("m_gu_gun"));
		m.setmDong(rs.getString("m_dong"));
		m.setmRole(rs.getString("m_role"));
		m.setmStatus(rs.getString("m_status"));
		m.setmLogCount(rs.getInt("m_log_count"));
	
		if (rs.getTimestamp("m_join_date") != null) {
			m.setmJoinDate(rs.getTimestamp("m_join_date").toLocalDateTime());
		}
		
		m.setmProfileImageName(rs.getString("m_profile_image_name"));
		
		return m;

	}
}
