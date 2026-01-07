INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES 
('SPT', '스포츠', 1, NULL),
('MUS', '음악', 1, NULL);

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('SPT_OUT', '야외 스포츠', 2, 1),
('SPT_IN', '실내 스포츠', 2, 1);

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('MUS_PLAY', '악기 연주', 2, 2),
('MUS_LIST', '음악 감상', 2, 2);


SELECT ct_id INTO @pid 
FROM CATEGORY 
WHERE ct_code = 'SPT_OUT';

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('SPT_OUT_RUN', '러닝', 3, @pid),
('SPT_OUT_HIK', '등산', 3, @pid);

SELECT ct_id INTO @pid 
FROM CATEGORY 
WHERE ct_code = 'SPT_IN';

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('SPT_IN_GYM', '헬스', 3, @pid),
('SPT_IN_SWIM', '수영', 3, @pid);

SELECT ct_id INTO @pid 
FROM CATEGORY 
WHERE ct_code = 'MUS_PLAY';

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('MUS_PLAY_PIANO', '피아노', 3, @pid),
('MUS_PLAY_GUIT', '기타', 3, @pid);

SELECT ct_id INTO @pid 
FROM CATEGORY 
WHERE ct_code = 'MUS_LIST';

INSERT INTO CATEGORY (ct_code, ct_name, ct_level, ct_parent_id)
VALUES
('MUS_LIST_BALLAD', '발라드 감상', 3, @pid),
('MUS_LIST_POP', '팝 감상', 3, @pid);

