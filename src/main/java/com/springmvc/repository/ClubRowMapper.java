package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Club;

public class ClubRowMapper implements RowMapper<Club> {
	@Override
	public Club mapRow(ResultSet rs, int rowNum) throws SQLException {
		Club club = new Club();
		
		club.setcId(rs.getInt("c_id"));
		club.setcName(rs.getString("c_name"));
		club.setcDescription(rs.getString("c_description"));
		club.setcCreateDate((LocalDateTime)rs.getObject("c_create_date"));
		club.setcFounderId(rs.getString("c_founder_id"));
		club.setcMaxMembers(rs.getInt("c_max_members"));
		club.setcMemberCount(rs.getInt("c_member_count"));
		club.setcLocation(rs.getString("c_location"));
		club.setcSiDo(rs.getString("c_si_do"));
		club.setcSiDoCode(rs.getString("c_si_do_code"));
		club.setcGuGun(rs.getString("c_gu_gun"));
		club.setcGuGunCode(rs.getString("c_gu_gun_code"));
		club.setcDong(rs.getString("c_dong"));
		club.setcDongCode(rs.getString("c_dong_code"));
		club.setcMainPlace(rs.getString("c_main_place"));
		club.setcMainImageName(rs.getString("c_main_image_name"));
		club.setcStatus(rs.getString("c_status"));
		
		return club;
	}
}
