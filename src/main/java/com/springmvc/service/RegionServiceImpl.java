package com.springmvc.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class RegionServiceImpl implements RegionService {
	
	@Value("${odcloud.api.key}")
	private String apiKey;

    private static final String BASE_URL = "https://api.odcloud.kr/api/15063424/v1/uddi:5176efd5-da6e-42a0-b2cf-8512f74503ea";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper mapper = new ObjectMapper();

    // 캐싱된 전체 데이터
    private static List<Map<String, Object>> CACHED_REGION_DATA = null;

    @PostConstruct
    public void init() {
  	
        try {
            System.out.println("🏁 RegionService 초기 데이터 로딩중...");
            //CACHED_REGION_DATA = loadAllRegionData();
            System.out.println("✅ 로딩 완료: " + CACHED_REGION_DATA.size() + "건");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /** 공공데이터 전체 로딩 */
    private List<Map<String, Object>> loadAllRegionData() throws Exception {

        if (CACHED_REGION_DATA != null) {
            return CACHED_REGION_DATA;
        }

        List<Map<String, Object>> totalList = new ArrayList<>();

        int page = 1;
        int perPage = 10000;

        while (true) {
            String url = BASE_URL
                    + "?serviceKey=" + apiKey
                    + "&page=" + page
                    + "&perPage=" + perPage
                    + "&returnType=json";

            String response = restTemplate.getForObject(url, String.class);

            Map<String, Object> json = mapper.readValue(response, Map.class);
            List<Map<String, Object>> data = (List<Map<String, Object>>) json.get("data");

            if (data == null || data.isEmpty())
                break;

            totalList.addAll(data);

            if (data.size() < perPage)
                break;

            page++;
        }

        CACHED_REGION_DATA = totalList;
        return totalList;
    }


    /** 시도 리스트 반환 */
    @Override
    public List<Map<String, Object>> getSidoList() {

        List<Map<String, Object>> allData = CACHED_REGION_DATA;
        List<Map<String, Object>> sidoList = new ArrayList<>();
        Set<String> added = new HashSet<>();

        for (Map<String, Object> item : allData) {

            String sido = (String) item.get("시도명");
            String sigungu = (String) item.get("시군구명");
            String dong = (String) item.get("읍면동명");

            Object delObj = item.get("삭제일자");
            String deleteDate = (delObj == null || "null".equals(delObj)) ? null : String.valueOf(delObj);

            if (sido == null) continue;

            // 세종 특례
            if (sido.equals("세종특별자치시")) {
                if (!added.contains(sido)) {
                    added.add(sido);
                    sidoList.add(item);
                }
                continue;
            }

            // 현재 시도 조건
            if (sigungu == null && dong == null && deleteDate == null) {
                if (!added.contains(sido)) {
                    added.add(sido);
                    sidoList.add(item);
                }
            }
        }

        return sidoList;
    }


    @Override
    public List<Map<String, Object>> getCachedRegionData() {
        return CACHED_REGION_DATA;
    }
}

