package com.springmvc.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Post;

@Repository
public class PostRepositoryImpl implements PostRepository {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	// ACTIVE 상태인 게시글 로드 (최신순 정렬)
	@Override
	public List<Post> getPostsByClubId(int clubId) {
		String sql = "SELECT * FROM POST WHERE c_id = ? AND p_status = 'ACTIVE' AND p_type = 'NORMAL' ORDER BY p_created_date DESC";
		return jdbcTemplate.query(sql, new Object[]{clubId}, new PostRowMapper());
	}
	
	// 게시글 저장
	@Override
	public void savePost(Post post) {

	    String sql =
	        "INSERT INTO POST (c_id, m_id, p_title, p_content, p_type, p_event_no) " +
	        "VALUES (?, ?, ?, ?, ?, ?)";

	    KeyHolder keyHolder = new GeneratedKeyHolder();

	    jdbcTemplate.update(con -> {
	        PreparedStatement ps =
	            con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

	        ps.setInt(1, post.getPostCId());
	        ps.setString(2, post.getPostMId());
	        ps.setString(3, post.getPostTitle());
	        ps.setString(4, post.getPostContent());
	        ps.setString(5, post.getPostType());
	        
	        if ("HOBBYLOG".equals(post.getPostType())) {
	            ps.setInt(6, post.getPostEventNo());
	        } else {
	            ps.setNull(6, Types.INTEGER);
	        }

	        return ps;
	    }, keyHolder);

	    // ⭐⭐⭐ 핵심 한 줄
	    post.setPostId(keyHolder.getKey().longValue());
	}
	
	// postId로 게시글 정보 불러오기
	@Override
	public Post getPostById(long postId) {
		String sql = "SELECT * FROM POST WHERE p_id = ? AND p_status = 'ACTIVE'";
		try {
            return jdbcTemplate.queryForObject(sql, new PostRowMapper(), postId);
        } catch (EmptyResultDataAccessException e) {
            // 해당 ID의 게시글이 없거나 삭제되었을 경우 null 반환
            return null; 
        }
	}
	
	// 글 조회수 1 상승
	@Override
	public void incrementViewCount(long postId) {
		String sql = "UPDATE POST SET p_view_count = p_view_count + 1 WHERE p_id = ?";
        jdbcTemplate.update(sql, postId);
	}
	
	// PostUpdateForm을 통해 받은 데이터 db 저장
	@Override
	public void updatePost(Post post) {
		String sql = "UPDATE POST SET p_title = ?, p_content = ?, p_updated_date = CURRENT_TIMESTAMP WHERE p_id = ? AND m_id = ?";
        
        jdbcTemplate.update(sql, 
            post.getPostTitle(),
            post.getPostContent(),
            post.getPostId(),
            post.getPostMId() // 작성자 ID를 조건에 넣어 보안 강화
        );
	}
	
	
	// postId로 게시글 찾아서 삭제
	@Override
	public void deletePost(long postId, String memberId) {
		String sql = "UPDATE POST SET p_status = 'DELETED', p_deleted_date = CURRENT_TIMESTAMP WHERE p_id = ? AND m_id = ?";
		jdbcTemplate.update(sql, postId, memberId);
	}


	@Override
	public boolean existsHobbyLog(int eventNo, String memberId) {
		String sql = "SELECT COUNT(*) FROM POST WHERE p_type = 'HOBBYLOG' AND m_id = ? AND p_status = 'ACTIVE' AND p_event_no = ? ";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, memberId, eventNo);
		return count != null && count > 0;
	}

	@Override
    public List<Post> getHobbyLogsByMemberAndDateRange(String memberId, LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT p.*, s.start_time, s.end_time, s.event_title FROM POST p LEFT JOIN SCHEDULE s ON p.p_event_no = s.event_no WHERE p.p_type = 'HOBBYLOG' AND p.m_id = ? AND p.p_status = 'ACTIVE' AND ( s.event_no IS NULL OR (s.start_time < ? AND s.end_time >= ?)) ORDER BY s.start_time ASC";
        return jdbcTemplate.query(sql, new PostRowMapper(), memberId, end, start);
    }
	
    @Override
    public List<Post> getMonthlyHobbyLogs(String memberId, LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT p.*, s.start_time, s.end_time, s.event_title FROM POST p LEFT JOIN SCHEDULE s ON p.p_event_no = s.event_no WHERE p.p_type = 'HOBBYLOG' AND p.m_id = ? AND p.p_status = 'ACTIVE' AND ( s.event_no IS NULL OR (s.start_time < ? AND s.end_time >= ?)) ORDER BY s.start_time ASC";
        return jdbcTemplate.query(sql, new PostRowMapper(), memberId, end, start);
    }

    @Override
    public Post getHobbyLogById(long postId) {
        String sql = "SELECT p.*, s.start_time, s.end_time FROM POST p LEFT JOIN SCHEDULE s ON p.p_event_no = s.event_no WHERE p.p_id = ? AND p.p_status = 'ACTIVE' AND p.p_type = 'HOBBYLOG'";
        try {
            return jdbcTemplate.queryForObject(
                sql,
                new PostRowMapper(),
                postId
            );
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

	@Override
	public Long findHobbyLogId(int eventNo, String mId) {
		String sql = "SELECT p_id FROM post WHERE p_event_no = ? AND m_id = ? AND p_type = 'HOBBYLOG' LIMIT 1";
		try {
            return jdbcTemplate.queryForObject(
                sql,
                Long.class,
                eventNo,
                mId
            );
        } catch (Exception e) {
            return null;
        }
	}

	@Override
	public List<Long> findHobbyLogIdsByMember(String memberId) {
		String sql = "SELECT p_id FROM POST WHERE m_id = ? AND p_type = 'HOBBYLOG'";
		return jdbcTemplate.queryForList(sql, Long.class, memberId);
	}

	@Override
	public void deleteHobbyLogsByMember(String memberId) {
		String sql = "DELETE FROM POST WHERE m_id = ? AND p_type = 'HOBBYLOG'";
		jdbcTemplate.update(sql, memberId);
	}
	
	// 클럽 삭제시 post deleted 처리
	@Override
	public void deletePostByClubId(int clubId) {
		String SQL = "UPDATE POST SET p_status = 'DELETED' WHERE c_id = ? AND p_type != 'HOBBYLOG'";
	    jdbcTemplate.update(SQL, clubId);
	}
	
}
