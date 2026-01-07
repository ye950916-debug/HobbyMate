package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.springmvc.domain.Schedule;

@Component
public class ScheduleRowMapper implements RowMapper<Schedule> {
	
	public Schedule mapRow(ResultSet rs, int rowNum) throws SQLException {
		Schedule s = new Schedule();
		s.setEventNo(rs.getInt("event_no"));
		s.setcId(rs.getString("c_id"));
		s.setRegisterId(rs.getString("register_id"));
		s.setEventTitle(rs.getString("event_title"));
		s.setEventContent(rs.getString("event_content"));
		s.setsStatus(rs.getString("s_status"));
		
		if(rs.getTimestamp("start_time") != null){
			s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
		}
		
		if(rs.getTimestamp("end_time") != null) {
			s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
		}
		
		if(rs.getTimestamp("create_event_date") != null) {
			s.setCreateEventDate(rs.getTimestamp("create_event_date").toLocalDateTime());
		}
		
		s.setPeopleLimit(rs.getInt("people_limit"));
        s.setEventAddress(rs.getString("event_address"));
        s.setEventDetailAddress(rs.getString("event_detail_address"));
        s.setLatitude(rs.getDouble("latitude"));
        s.setLongitude(rs.getDouble("longitude"));
        
        return s;
	}

}
