package com.springmvc.service;

import java.util.List;
import java.util.Map;

public interface RegionService {
	List<Map<String, Object>> getSidoList();
	List<Map<String, Object>> getCachedRegionData();
}
