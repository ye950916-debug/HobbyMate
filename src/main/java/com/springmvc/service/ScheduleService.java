package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;

public interface ScheduleService {

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
	List<Integer> getMemberEventNos(String mId);
	void deleteOnlyMemberSchedule(String mId, int eventNo);
	List<Member> getParticipants(int eventNo);
	void deleteMemberScheduleByMember(String mId);
	void nullifyRegisterId(String mId);
	List<Schedule> getAllSchedules();
	void deleteMemberScheduleByEventNo(int eventNo);
	void updateScheduleStatus(int eventNo, String status);
	//특정 클럽의 일정 가져오기
	List<Schedule> getSchedulesByClubId(int clubId);
	List<Schedule> getSchedulesByClubIdsAndSearch(List<Integer> clubIds, String searchKeyword);
	List<Schedule> getAllSchedulesAndSearch(String searchKeyword);
	Schedule getScheduleForHobbyLog(int eventNo);
}
