package com.springmvc.repository;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.PostImage;

@Repository
public class PostImageRepositoryImpl implements PostImageRepository {
	
	private final JdbcTemplate jdbcTemplate;
	
	public PostImageRepositoryImpl(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	@Override
	public void insert(PostImage img) {
		String sql = "INSERT INTO POSTIMAGE (p_id, pi_name, pi_order) VALUES (?, ?, ?)";
		jdbcTemplate.update(sql, img.getPostId(), img.getPiName(), img.getPiOrder());
	}

	@Override
	public List<PostImage> findByPostId(long postId) {
		String sql = "SELECT pi_id, p_id, pi_name, pi_order, pi_created_date FROM POSTIMAGE WHERE p_id = ? ORDER BY pi_order ASC, pi_id ASC";
		return jdbcTemplate.query(sql, new PostImageRowMapper(), postId);
	}

	@Override
	public void deleteByPostId(long postId) {
		String sql = "DELETE FROM POSTIMAGE WHERE p_id = ?";
		jdbcTemplate.update(sql, postId);
	}

	@Override
	public void deleteByImageId(long piId) {
		String sql = "DELETE FROM POSTIMAGE WHERE pi_id = ?";
		jdbcTemplate.update(sql, piId);
	}
	
	@Override
	public PostImage findById(long imageId) {
		String sql = "SELECT pi_id, p_id, pi_name, pi_order, pi_created_date FROM POSTIMAGE WHERE pi_id = ?";
		return jdbcTemplate.queryForObject(sql, new PostImageRowMapper(), imageId);
	}
	
}
