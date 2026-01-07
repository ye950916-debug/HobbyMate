package com.springmvc.service;

import java.util.List;

public interface MemberCategoryService {
	
	void add(String mId, int ctId);
	List<Integer> getCategoriesByMember(String mId);
	void deleteAll(String mId);

}
