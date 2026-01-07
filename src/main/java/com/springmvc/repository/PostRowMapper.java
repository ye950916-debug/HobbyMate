package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Post;

public class PostRowMapper implements RowMapper<Post> {
	@Override
	public Post mapRow(ResultSet rs, int rowNum) throws SQLException {
		Post p = new Post();
		
		p.setPostId(rs.getLong("p_id"));
		p.setPostCId(rs.getInt("c_id"));
		p.setPostMId(rs.getString("m_id"));
		p.setPostTitle(rs.getString("p_title"));
		p.setPostContent(rs.getString("p_content"));
		p.setPostCreatedDate((LocalDateTime)rs.getObject("p_created_date"));
		p.setPostUpdatedDate((LocalDateTime)rs.getObject("p_updated_date"));
		p.setPostDeletedDate((LocalDateTime)rs.getObject("p_deleted_date"));
		p.setPostViewCount(rs.getInt("p_view_count"));
		p.setPostStatus(rs.getString("p_status"));
		p.setPostType(rs.getString("p_type"));
		p.setPostEventNo((Integer) rs.getObject("p_event_no"));
		
		// ✅ 컬럼 존재할 때만 읽기
        if (hasColumn(rs, "start_time")) {
            p.setScheduleStartTime(
                rs.getObject("start_time", LocalDateTime.class)
            );
        }

        if (hasColumn(rs, "end_time")) {
            p.setScheduleEndTime(
                rs.getObject("end_time", LocalDateTime.class)
            );
        }

        if (hasColumn(rs, "event_title")) {
            p.setScheduleTitle(rs.getString("event_title"));
        }

        return p;
    }

    // 컬럼 존재 여부 체크 유틸
    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}
