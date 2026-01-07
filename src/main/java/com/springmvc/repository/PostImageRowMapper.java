package com.springmvc.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.PostImage;

public class PostImageRowMapper implements RowMapper<PostImage> {

    @Override
    public PostImage mapRow(ResultSet rs, int rowNum) throws SQLException {

        PostImage img = new PostImage();
        img.setPiId(rs.getLong("pi_id"));
        img.setPostId(rs.getLong("p_id"));
        img.setPiName(rs.getString("pi_name"));
        img.setPiOrder(rs.getInt("pi_order"));
        img.setPiCreatedDate(
            rs.getTimestamp("pi_created_date").toLocalDateTime()
        );

        return img;
    }
}
