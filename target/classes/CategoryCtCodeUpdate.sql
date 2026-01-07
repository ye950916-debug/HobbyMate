-- ===========================
-- 1) 대분류 업데이트
-- ===========================
UPDATE CATEGORY SET ct_code = 'C001' WHERE ct_id = 1; -- 스포츠
UPDATE CATEGORY SET ct_code = 'C002' WHERE ct_id = 2; -- 음악


-- ===========================
-- 2) 중분류 업데이트
-- ===========================
UPDATE CATEGORY SET ct_code = 'C001_001' WHERE ct_id = 3; -- 야외 스포츠
UPDATE CATEGORY SET ct_code = 'C001_002' WHERE ct_id = 4; -- 실내 스포츠

UPDATE CATEGORY SET ct_code = 'C002_001' WHERE ct_id = 5; -- 악기 연주
UPDATE CATEGORY SET ct_code = 'C002_002' WHERE ct_id = 6; -- 음악 감상


-- ===========================
-- 3) 소분류 - 야외 스포츠 (parent=3)
-- ===========================
UPDATE CATEGORY SET ct_code = 'C001_001_001' WHERE ct_id = 7; -- 러닝
UPDATE CATEGORY SET ct_code = 'C001_001_002' WHERE ct_id = 8; -- 등산


-- ===========================
-- 4) 소분류 - 실내 스포츠 (parent=4)
-- ===========================
UPDATE CATEGORY SET ct_code = 'C001_002_001' WHERE ct_id = 9;  -- 헬스
UPDATE CATEGORY SET ct_code = 'C001_002_002' WHERE ct_id = 10; -- 수영


-- ===========================
-- 5) 소분류 - 악기 연주 (parent=5)
-- ===========================
UPDATE CATEGORY SET ct_code = 'C002_001_001' WHERE ct_id = 11; -- 피아노
UPDATE CATEGORY SET ct_code = 'C002_001_002' WHERE ct_id = 12; -- 기타


-- ===========================
-- 6) 소분류 - 음악 감상 (parent=6)
-- ===========================
UPDATE CATEGORY SET ct_code = 'C002_002_001' WHERE ct_id = 13; -- 발라드 감상
UPDATE CATEGORY SET ct_code = 'C002_002_002' WHERE ct_id = 14; -- 팝 감상
