package com.springmvc.repository;

import java.util.List;
import java.util.Map;

import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;

public interface ScheduleRepository {
	
	List<Schedule> getSchedulesByClubId(String cId);
	void addSchedule(Schedule schedule);
	Schedule getScheduleByNum(int eventNo);
	void updateSchedule(Schedule schedule);
	void deleteSchedule(int eventNo);
	List<Schedule> getSchedulesByClubIds(List<Integer> clubIds);
	int getCurrentParticipantCount(int eventNo);
	int getPeopleLimit(int eventNo);
	void memberSchedule(String mId, int eventNo);
	List<Schedule> memberScheduleList(String mId);
	int findLastEventNoByClubAndMember(String cId, String mId);
	boolean existsMemberSchedule(String mId, int eventNo);
	List<Integer> getMemberEventNos(String mId);
	void deleteMemberSchedule(int eventNo);
	void deleteOnlyMemberSchedule(String mId, int eventNo);
	List<Member> getParticipants(int eventNo);
	void deleteMemberScheduleByMember(String mId);
	void nullifyRegisterId(String mId);
	List<Schedule> getAllSchedules();
	void deleteMemberScheduleByEventNo(int eventNo);
	void updateScheduleStatus(int eventNo, String status);
	List<Schedule> getSchedulesByClubId(int clubId);
	List<Schedule> selectSchedulesByClubIdsAndSearch(Map<String, Object> paramMap);
	List<Schedule> selectAllSchedulesAndSearch(Map<String, Object> paramMap);
	void deleteSchedulesByClubId(int clubId);
	List<Integer> findEventNosByClubId(int clubId);
	Schedule getScheduleForHobbyLog(int eventNo);
}
