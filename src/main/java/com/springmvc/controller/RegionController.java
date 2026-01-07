package com.springmvc.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/region")
public class RegionController {
	
	@Value("${odcloud.api.key}")
	private String apiKey;
	
	
	// API 기본 호출 URL
	private static final String BASE_URL = "https://api.odcloud.kr/api/15063424/v1/uddi:5176efd5-da6e-42a0-b2cf-8512f74503ea";
	
	private final RestTemplate restTemplate = new RestTemplate(); 
	private final ObjectMapper mapper = new ObjectMapper();
	
	// 캐시 변수 추가 (api요청 개별로 반복하지 않기 위해서)
	private static List<Map<String, Object>> CACHED_REGION_DATA = null;
	
	@PostConstruct
    public void init() {
        try {
            System.out.println("🏁 지역 데이터 초기 로딩 시작");
            //CACHED_REGION_DATA = fetchAllRegionFromAPI();
            System.out.println("✅ 지역 데이터 로딩 완료. 총 " + CACHED_REGION_DATA.size() + "건");
        } catch (Exception e) {
            System.out.println("❌ 지역 데이터 초기 로딩 실패 → 사용자 요청 시 재시도함 ");
        }
    }

	/** 전체 데이터 페이징으로 수집 */
    private List<Map<String, Object>> loadAllRegionData() throws Exception {

    	if (CACHED_REGION_DATA != null) {
            return CACHED_REGION_DATA;
        }
        return CACHED_REGION_DATA = fetchAllRegionFromAPI();
    }
    
    private List<Map<String, Object>> fetchAllRegionFromAPI() throws Exception {
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

            if (data == null || data.isEmpty()) break;

            totalList.addAll(data);
            if (data.size() < perPage) break;

            page++;
        }

        return totalList;
    }



    @GetMapping("/sido")
    public ResponseEntity<Object> getSidoList() {

        try {
            List<Map<String, Object>> allData = loadAllRegionData();

            List<Map<String, Object>> sidoList = new ArrayList<>();
            Set<String> addedSido = new HashSet<>();

            for (Map<String, Object> item : allData) {

                String sido = (String) item.get("시도명");
                String sigungu = (String) item.get("시군구명");
                String dong = (String) item.get("읍면동명");

                // 삭제일자 (null이면 현재 행정구역)
                Object delObj = item.get("삭제일자");
                String deleteDate = (delObj == null || "null".equals(String.valueOf(delObj)))
                                        ? null
                                        : String.valueOf(delObj);

                if (sido == null) continue;

                // 세종특별자치시 예외 처리
                if (sido.equals("세종특별자치시")) {
                    if (!addedSido.contains(sido)) {
                        addedSido.add(sido);
                        sidoList.add(item);
                    }
                    continue;
                }

                // 조건:
                // 시도명 있음, 시군구/읍면동 없음, 삭제일자 null → 현재 시도
                if (sigungu == null && dong == null && deleteDate == null) {

                    if (!addedSido.contains(sido)) {
                        addedSido.add(sido);
                        sidoList.add(item);
                    }
                }
            }

            return ResponseEntity.ok(sidoList);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("데이터 로딩 실패");
        }
    }

    @GetMapping("/gugun")
    public ResponseEntity<Object> getGugunList(@RequestParam String sidocode) {

        try {
            List<Map<String, Object>> allData = loadAllRegionData();

            List<Map<String, Object>> gugunList = new ArrayList<>();
            Set<String> addedNames = new HashSet<>();

            // 시도 prefix = 앞 2자리
            String prefix2 = sidocode.substring(0, 2);

            for (Map<String, Object> item : allData) {

                String sido = (String) item.get("시도명");
                String sigungu = (String) item.get("시군구명");
                String dong = (String) item.get("읍면동명");

                Object delObj = item.get("삭제일자");
                String deleteDate = (delObj == null || "null".equals(String.valueOf(delObj)))
                                        ? null
                                        : String.valueOf(delObj);

                String code = String.valueOf(item.get("법정동코드"));

                // 조건:
                // 시군구명 있음 (구/군 단계)
                // 읍면동명 없음
                // 삭제일자 null (현재 행정구역)
                // 상위 시도의 prefix와 일치
                // 뒤 5자리가 00000 (구군 코드)
                if (sigungu != null &&
                    dong == null &&
                    deleteDate == null &&
                    code.startsWith(prefix2) &&
                    code.endsWith("00000")) {

                    if (!addedNames.contains(sigungu)) {
                        addedNames.add(sigungu);
                        gugunList.add(item);
                    }
                }
            }

            return ResponseEntity.ok(gugunList);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("데이터 로딩 실패");
        }
    }

    @GetMapping("/dong")
    public ResponseEntity<Object> getDong(@RequestParam String guguncode) {

        try {
            List<Map<String, Object>> all = loadAllRegionData();

            List<Map<String, Object>> result = new ArrayList<>();
            Set<String> added = new HashSet<>();

            // 구군 10자리 코드에서 앞 5자리
            String prefix5 = guguncode.substring(0, 5);

            for (Map<String, Object> item : all) {

                String dong = (String) item.get("읍면동명");
                String code = String.valueOf(item.get("법정동코드"));

                Object delObj = item.get("삭제일자");
                String deleteDate = (delObj == null || "null".equals(String.valueOf(delObj)))
                        ? null
                        : String.valueOf(delObj);

                // --- ★ 핵심 조건 3개 ★ ---
                if (dong != null &&
                    deleteDate == null &&
                    code.startsWith(prefix5) &&
                    !code.endsWith("00000"))  // 구군 코드가 아니어야 동임
                {
                    if (!added.contains(dong)) {
                        added.add(dong);
                        result.add(item);
                    }
                }
            }

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("동 조회 실패");
        }
    }

    
}
