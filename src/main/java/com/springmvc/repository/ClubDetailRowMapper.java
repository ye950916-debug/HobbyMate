package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.ClubDetail;

public class ClubDetailRowMapper implements RowMapper<ClubDetail> {

	@Override
	public ClubDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
		ClubDetail cd = new ClubDetail();
		
		cd.setcId(rs.getInt("c_id"));
		cd.setcName(rs.getString("c_name"));
		cd.setcDescription(rs.getString("c_description"));
		cd.setcCreateDate((LocalDateTime)rs.getObject("c_create_date"));
		cd.setcFounderId(rs.getString("c_founder_id"));
		cd.setcMaxMembers(rs.getInt("c_max_members"));
		cd.setcMemberCount(rs.getInt("c_member_count"));
		cd.setcLocation(rs.getString("c_location"));
		cd.setcSiDo(rs.getString("c_si_do"));
		cd.setcSiDoCode(rs.getString("c_si_do_code"));
		cd.setcGuGun(rs.getString("c_gu_gun"));
		cd.setcGuGunCode(rs.getString("c_gu_gun_code"));
		cd.setcDong(rs.getString("c_dong"));
		cd.setcDongCode(rs.getString("c_dong_code"));
		cd.setcMainPlace(rs.getString("c_main_place"));
		cd.setcMainImageName(rs.getString("c_main_image_name"));
		cd.setSubId(rs.getInt("sub_id"));
		cd.setSubName(rs.getString("sub_name"));
		cd.setMidId(rs.getInt("mid_id"));
		cd.setMidName(rs.getString("mid_name"));
		cd.setLargeId(rs.getInt("lrg_id"));
		cd.setLargeName(rs.getString("lrg_name"));
		cd.setLeaderId(rs.getString("leader_id"));
		
		return cd;
	}
}
