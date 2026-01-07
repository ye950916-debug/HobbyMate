

USE ksg002424;

SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- MEMBER
-- =========================
CREATE TABLE MEMBER (
    m_id VARCHAR(20) PRIMARY KEY,
    m_pw VARCHAR(255) NOT NULL,
    m_name VARCHAR(10) NOT NULL,
    m_age INT,
    m_gender CHAR(2),
    m_phone CHAR(11) UNIQUE,
    m_address VARCHAR(100),
    m_si_do VARCHAR(20),
    m_gu_gun VARCHAR(20),
    m_dong VARCHAR(40),
    m_role VARCHAR(10) DEFAULT 'USER',
    m_status VARCHAR(10) DEFAULT 'ACTIVE',
    m_profile_image_name VARCHAR(200),
    m_log_count INT NOT NULL DEFAULT 0,
    m_join_date DATETIME
);

-- =========================
-- CLUB
-- =========================
CREATE TABLE CLUB (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    c_name VARCHAR(50) NOT NULL,
    c_description TEXT,
    c_founder_id VARCHAR(20),
    c_max_members INT,
    c_member_count INT DEFAULT 0,
    c_location VARCHAR(100),
    c_si_do VARCHAR(20),
    c_si_do_code VARCHAR(20),
    c_gu_gun VARCHAR(20),
    c_gu_gun_code VARCHAR(20),
    c_dong VARCHAR(40),
    c_dong_code VARCHAR(20),
    c_main_place VARCHAR(10),
    c_main_image_name VARCHAR(200),
    c_create_date DATETIME,
    FOREIGN KEY (c_founder_id) REFERENCES MEMBER(m_id)
);
ALTER TABLE CLUB
ADD c_status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE'; -- active: 활성화, deleted: 비활성화

-- =========================
-- CLUBMEMBER
-- =========================
CREATE TABLE CLUBMEMBER (
    cm_m_id VARCHAR(20),
    cm_c_id INT,
    cm_role VARCHAR(10),
    cm_status VARCHAR(10) DEFAULT 'ACTIVE',
    cm_join_date DATETIME,
    PRIMARY KEY (cm_m_id, cm_c_id),
    FOREIGN KEY (cm_m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (cm_c_id) REFERENCES CLUB(c_id)
);

-- =========================
-- SCHEDULE
-- =========================
CREATE TABLE SCHEDULE (
    event_no INT AUTO_INCREMENT PRIMARY KEY,
    c_id INT NOT NULL,
    register_id VARCHAR(20),
    event_title VARCHAR(50),
    event_content TEXT,
    start_time DATETIME,
    end_time DATETIME,
    people_limit INT,
    event_address VARCHAR(50),
    event_detail_address VARCHAR(200),
    latitude DOUBLE,
    longitude DOUBLE,
    s_status VARCHAR(20) DEFAULT 'ACTIVE',
    create_event_date DATETIME,
    FOREIGN KEY (c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY (register_id) REFERENCES MEMBER(m_id)
);

-- =========================
-- CATEGORY
-- =========================
CREATE TABLE CATEGORY (
    ct_id INT AUTO_INCREMENT PRIMARY KEY,
    ct_code VARCHAR(30) UNIQUE NOT NULL,
    ct_name VARCHAR(50) NOT NULL,
    ct_level INT NOT NULL,
    ct_parent_id INT,
    FOREIGN KEY (ct_parent_id) REFERENCES CATEGORY(ct_id)
);

-- =========================
-- MEMBERCATEGORY
-- =========================
CREATE TABLE MEMBERCATEGORY (
    mct_id INT AUTO_INCREMENT PRIMARY KEY,
    m_id VARCHAR(20) NOT NULL,
    ct_id INT NOT NULL,
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (ct_id) REFERENCES CATEGORY(ct_id)
);

-- =========================
-- CLUBCATEGORY
-- =========================
CREATE TABLE CLUBCATEGORY (
    cct_id INT AUTO_INCREMENT PRIMARY KEY,
    c_id INT NOT NULL,
    ct_id INT NOT NULL,
    FOREIGN KEY (c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY (ct_id) REFERENCES CATEGORY(ct_id)
);

-- =========================
-- MEMBERSCHEDULE
-- =========================
CREATE TABLE MEMBERSCHEDULE (
    ms_id INT AUTO_INCREMENT PRIMARY KEY,
    m_id VARCHAR(20) NOT NULL,
    event_no INT NOT NULL,
    attend_date DATETIME,
    UNIQUE (m_id, event_no),
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (event_no) REFERENCES SCHEDULE(event_no)
);

-- =========================
-- POST
-- =========================
CREATE TABLE POST (
    p_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    c_id INT NOT NULL,
    m_id VARCHAR(20) NOT NULL,
    p_title VARCHAR(255) NOT NULL,
    p_content TEXT,
    p_type VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    p_event_no INT,
    p_view_count INT DEFAULT 0,
    p_status VARCHAR(10) DEFAULT 'ACTIVE',
    p_created_date DATETIME,
    p_updated_date DATETIME,
    p_deleted_date DATETIME,
    FOREIGN KEY (c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (p_event_no) REFERENCES SCHEDULE(event_no)
        ON DELETE SET NULL
);

-- =========================
-- POSTIMAGE
-- =========================
CREATE TABLE POSTIMAGE (
    pi_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    p_id BIGINT NOT NULL,
    pi_name VARCHAR(255) NOT NULL,
    pi_order INT DEFAULT 0,
    pi_created_date DATETIME,
    FOREIGN KEY (p_id) REFERENCES POST(p_id)
        ON DELETE CASCADE
);

-- =========================
-- BADGE
-- =========================
CREATE TABLE BADGE (
    badge_id INT AUTO_INCREMENT PRIMARY KEY,
    badge_name VARCHAR(30) NOT NULL,
    badge_desc VARCHAR(100),
    required_log_count INT NOT NULL
);

-- =========================
-- MEMBERBADGE
-- =========================
CREATE TABLE MEMBERBADGE (
    memberbadge_id INT AUTO_INCREMENT PRIMARY KEY,
    m_id VARCHAR(20) NOT NULL,
    badge_id INT NOT NULL,
    is_representative BOOLEAN DEFAULT FALSE,
    acquired_at DATETIME,
    UNIQUE (m_id, badge_id),
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (badge_id) REFERENCES BADGE(badge_id)
);

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO CATEGORY (ct_id, ct_code, ct_name, ct_level, ct_parent_id) VALUES
-- 1단계 (대분류)
(1, 'C001', '스포츠', 1, NULL),
(2, 'C002', '음악',   1, NULL),

-- 2단계 (중분류)
(3, 'C001_001', '야외 스포츠', 2, 1),
(4, 'C001_002', '실내 스포츠', 2, 1),
(5, 'C002_001', '악기 연주',   2, 2),
(6, 'C002_002', '음악 감상',   2, 2),

-- 3단계 (소분류)
(7,  'C001_001_001', '러닝',        3, 3),
(8,  'C001_001_002', '등산',        3, 3),
(9,  'C001_002_001', '헬스',        3, 4),
(10, 'C001_002_002', '수영',        3, 4),
(11, 'C002_001_001', '피아노',      3, 5),
(12, 'C002_001_002', '기타',        3, 5),
(13, 'C002_002_001', '발라드 감상', 3, 6),
(14, 'C002_002_002', '팝 감상',     3, 6);
