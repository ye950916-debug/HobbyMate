package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;

public interface ClubMemberService {
	//모임 회원 추가
	public void insertClubMember(ClubMember clubMember);
	//회원이 가입한 모임 찾기
	List<Club> findClubInfobyMId(String loginId);
	
	//모임가입하기
	void applyJoin(int clubId, String memberId);
	//모임 생성회원을 clubmember 테이블에 추가
	void insertLeaderAsMember(int clubId, String MemberId);
	// 모임의 멤버들 조회
	ClubMember getClubMember(String memberId, int clubId);
	// clubId와 가입상태로 멤버를 조회
	List<ClubMember> getMembersByStatus(int clubId, String status);
	// 해당 멤버의 가입상태로 모임 아이디를 조회
	List<Integer> getClubIdsByMembersStatus(String memberId, String status);
	void updateStatus(String memberId, int clubId, String status);
	String deleteMember(String memberId, int clubId);
	boolean loginMemberEqClubLeader(int clubId, String memberId);
	List<ClubMember> getApprovedMemberExceptLeader(int clubId, String leaderId);
	List<Integer> findClubIdsByMemberId(String mId);
	List<Integer> findClubIdsByLeaderIdRole(String loginId);		
	List<Integer> findClubIdsByMemberIdRole(String loginId);	
	void deleteByMember(String mId);
	List<ClubMember> findApprovedMembers(int clubId);
	boolean changeLeaderRole(int clubId, String currentLeaderId, String newLeaderId);
	boolean adminChangeLeader(int clubId, String newLeaderId);
	String findLeaderIdByClubId(int clubId);
	List<Club> findLeaderClubsByMemberId(String mId);
	String getMemberStatus(int clubId, String memberId);
}
