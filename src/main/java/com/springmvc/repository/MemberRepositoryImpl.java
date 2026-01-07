package com.springmvc.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Member;

@Repository
public class MemberRepositoryImpl implements MemberRepository {
	
	@Autowired
	private JdbcTemplate template;

	//회원 전체 조회
	@Override
	public List<Member> getAllMembers() {
		String sql = "SELECT * FROM MEMBER";
		return template.query(sql, new MemberRowMapper());
	}

	//회원 조건 조회 (Read some)
	@Override
	public List<Member> searchMembers(String keyword) {
		String sql = "SELECT * FROM MEMBER " + "WHERE m_id LIKE ? " + "OR m_name LIKE ? " + "OR m_age LIKE ? " + "OR m_gender LIKE ? " + "OR m_phone LIKE ? " + "OR m_address LIKE ? " + "OR m_join_date LIKE ?";
		String param = "%" + keyword + "%";
		return template.query(sql, new MemberRowMapper(), param, param, param, param, param, param, param);
	}
	
	//회원 상세 조회 (Read one)
	@Override
	public Member getMemberById(String mId) {
		String sql = "SELECT * FROM MEMBER WHERE m_id = ?";
		
		try {
			return template.queryForObject(sql, new MemberRowMapper(), mId);
		} catch (Exception e) {
			return null;
		}
	}
	
	
	//회원 추가 
	@Override
	public void addMember(Member member) {
		
		System.out.println("Repository addMember() 실행됨");
		System.out.println("INSERT시도 : " + member);
		
		String sql = "INSERT INTO MEMBER (m_id, m_pw, m_name, m_age, m_gender, m_phone, m_address, m_si_do, m_gu_gun, m_dong, m_role, m_join_date, m_profile_image_name ) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		int result = template.update(sql,
				member.getmId(),
				member.getmPw(),
				member.getmName(),
				member.getmAge(),
				member.getmGender(),
				member.getmPhone(),
				member.getmAddress(),
				member.getmSiDo(),
				member.getmGuGun(),
				member.getmDong(),
				member.getmRole(),
				member.getmJoinDate(),
				member.getmProfileImageName()
			);
		
		if (result > 0) {
			System.out.println("INSERT 성공 : " + result );
		}
		else {
			System.out.println("INSERT 실패");
		}
	}
	

	//회원 수정
	@Override
	public void updateMember(Member member) {
		
	String sql = "UPDATE MEMBER SET m_pw = ?, m_name = ?, m_age = ?, m_gender = ?, m_phone = ?, m_address = ?, m_si_do = ?, m_gu_gun = ?, m_dong = ?, m_profile_image_name = ? WHERE m_id = ?";
	
	int result = template.update(sql,
			member.getmPw(),
			member.getmName(),
			member.getmAge(),
			member.getmGender(),
			member.getmPhone(),
			member.getmAddress(),
			member.getmSiDo(),
			member.getmGuGun(),
			member.getmDong(),
			member.getmProfileImageName(),
			member.getmId());
	
	System.out.println("UPDATE 결과: " + result);
	
	}

	//회원 탈퇴
	@Override
	public void deleteMember(String mId) {
		String sql = "DELETE FROM member WHERE m_id = ?";
		template.update(sql, mId);
		
	}

	@Override
	public void updateStatus(String mId, String status) {
		String sql = "UPDATE MEMBER SET m_status = ? WHERE m_id = ?";
		template.update(sql, status, mId);
	}

	@Override
	public Member findByPhone(String mPhone) {
		String sql = "SELECT * FROM MEMBER WHERE m_phone = ?";
		List<Member> list = template.query(sql, new MemberRowMapper(), mPhone);
		return list.isEmpty() ? null : list.get(0);
	}
	
	@Override
	public void increaseLogCount(String memberId) {
		String sql = "UPDATE MEMBER SET m_log_count = m_log_count + 1 WHERE m_id = ?";
	    template.update(sql, memberId);
	}
	
	@Override
	public int getLogCount(String memberId) {
		String sql = "SELECT m_log_count FROM MEMBER WHERE m_id = ?";
	    return template.queryForObject(sql, Integer.class, memberId);
	}

	
}
