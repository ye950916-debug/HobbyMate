CREATE DATABASE hobbymate;

USE hobbymate;

CREATE TABLE MEMBER(
	m_id VARCHAR(20) NOT NULL PRIMARY KEY,
    m_pw VARCHAR(20) NOT NULL,
    m_name VARCHAR(10) NOT NULL,
    m_age INT,
    m_gender CHAR(2),
    m_phone CHAR(11),
    m_address VARCHAR(100),
    m_si_do VARCHAR(20),
    m_gu_gun VARCHAR(20),
    m_dong VARCHAR(40),
    m_role VARCHAR(5),
    m_join_date DATETIME,
    m_profile_image_name VARCHAR(200),
    m_status VARCHAR(10) DEFAULT 'ACTIVE'
);
UPDATE member SET m_role = 'ADMIN' WHERE m_id = 'admin';
ALTER TABLE MEMBER
ADD m_log_count INT NOT NULL DEFAULT 0;


CREATE TABLE CLUB(
	c_id INT PRIMARY KEY AUTO_INCREMENT,
    c_name VARCHAR(50),
    c_description TEXT,
    c_create_date DATETIME,
    c_founder_id VARCHAR(20),
    c_max_members INT,
    c_member_count INT,
    c_location VARCHAR(100),
    c_si_do VARCHAR(20),
    c_si_do_code VARCHAR(20),
    c_gu_gun VARCHAR(20),
    c_gu_gun_code VARCHAR(20),
    c_dong VARCHAR(40),
    c_dong_code VARCHAR(20),
    c_main_place VARCHAR(10)
);
ALTER TABLE CLUB ADD COLUMN c_si_do_code VARCHAR(20) after c_si_do;
ALTER TABLE CLUB ADD COLUMN c_gu_gun_code VARCHAR(20) after c_gu_gun;
ALTER TABLE CLUB ADD COLUMN c_dong_code VARCHAR(20) after c_dong;
ALTER TABLE CLUB ADD COLUMN c_main_image_name VARCHAR(200);
ALTER TABLE CLUB
ADD c_status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE'; -- active: 활성화, deleted: 비활성화

CREATE TABLE CLUBMEMBER(
	cm_m_id VARCHAR(20) NOT NULL,
    cm_c_id INT NOT NULL,
    cm_role VARCHAR(10),
    cm_join_date DATETIME,
    cm_status VARCHAR(10), -- 회원상태
    PRIMARY KEY (cm_m_id, cm_c_id),
    FOREIGN KEY(cm_m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY(cm_c_id) REFERENCES CLUB(c_id)
);

CREATE TABLE SCHEDULE(
	event_no INT PRIMARY KEY AUTO_INCREMENT,
    c_id INT NOT NULL,
    register_id VARCHAR(20) NULL,
    event_title VARCHAR(30),
    event_content TEXT,
    start_time DATETIME,
    end_time DATETIME,
    create_event_date DATETIME,
    people_limit INT,
    event_address VARCHAR(50),
    event_detail_address VARCHAR(200),
    latitude double,
    longitude double,
    s_status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, STOPPED, REMOVED(사용자에게 안보임), ARCHIVED(클럽 삭제돼도 하비로그위해 남겨둠)
    FOREIGN KEY(c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY(register_id) REFERENCES MEMBER(m_id)
);


CREATE TABLE CATEGORY (
    ct_id INT AUTO_INCREMENT PRIMARY KEY,
    ct_code VARCHAR(40) UNIQUE NOT NULL,
    ct_name VARCHAR(50) NOT NULL,
    ct_level INT NOT NULL,
    ct_parent_id INT,
    FOREIGN KEY (ct_parent_id) REFERENCES CATEGORY(ct_id)
);

CREATE TABLE MEMBERCATEGORY(
    mct_id INT AUTO_INCREMENT PRIMARY KEY,
    m_id VARCHAR(20) NOT NULL,
    ct_id INT NOT NULL,
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (ct_id) REFERENCES CATEGORY(ct_id)
);

CREATE TABLE CLUBCATEGORY(
    cct_id INT AUTO_INCREMENT PRIMARY KEY,
    c_id INT NOT NULL,
    ct_id INT NOT NULL,
    FOREIGN KEY (c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY (ct_id) REFERENCES CATEGORY(ct_id)
);

CREATE TABLE MEMBERSCHEDULE(
    ms_id INT AUTO_INCREMENT PRIMARY KEY, -- 멤버스케줄 고유아이디
    m_id VARCHAR(20) NOT NULL, -- 멤버 아이디
    event_no INT NOT NULL, -- schedule 테이블에서 자동 생성되는 event 고유 번호
    attend_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 유저가 스케줄을 자신의 일정에 추가한 날짜와 시간
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),
    FOREIGN KEY (event_no) REFERENCES SCHEDULE(event_no),
    UNIQUE(m_id, event_no)
);

CREATE TABLE POST (
    p_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    c_id INT NOT NULL,
    m_id VARCHAR(20) NOT NULL,
    p_title VARCHAR(255) NOT NULL,
    p_content TEXT,
    p_created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    p_updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    p_deleted_date TIMESTAMP NULL,
    p_view_count INT DEFAULT 0,
    p_status VARCHAR(10) DEFAULT 'ACTIVE', -- 게시글 상태 (ACTIVE: 활성, DELETED: 삭제)
    FOREIGN KEY (c_id) REFERENCES CLUB(c_id),
    FOREIGN KEY (m_id) REFERENCES MEMBER(m_id)
);

ALTER TABLE POST
ADD COLUMN p_type VARCHAR(20) NOT NULL DEFAULT 'NORMAL'
COMMENT '게시글 유형 (NORMAL, NOTICE, HOBBYLOG)';
ALTER TABLE POST
ADD COLUMN p_event_no INT NULL COMMENT '하비로그 대상 일정 번호';
ALTER TABLE POST
ADD CONSTRAINT fk_post_event
FOREIGN KEY (p_event_no)
REFERENCES SCHEDULE(event_no)
ON DELETE SET NULL;

CREATE TABLE POSTIMAGE (
    pi_id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    p_id            BIGINT NOT NULL,
    pi_name         VARCHAR(255) NOT NULL,
    pi_order        INT DEFAULT 0,
    pi_created_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_postimage_post
        FOREIGN KEY (p_id)
        REFERENCES POST(p_id)
        ON DELETE CASCADE
);

CREATE TABLE BADGE (
    badge_id INT AUTO_INCREMENT PRIMARY KEY,
    badge_name VARCHAR(30) NOT NULL,
    badge_desc VARCHAR(100),
    required_log_count INT NOT NULL
);

CREATE TABLE MEMBERBADGE (
    memberbadge_id INT AUTO_INCREMENT PRIMARY KEY,
    m_id VARCHAR(20) NOT NULL,
    badge_id INT NOT NULL,
    is_representative BOOLEAN DEFAULT FALSE,
    acquired_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_memberbadge_member
        FOREIGN KEY (m_id) REFERENCES MEMBER(m_id),

    CONSTRAINT fk_memberbadge_badge
        FOREIGN KEY (badge_id) REFERENCES BADGE(badge_id),

    UNIQUE (m_id, badge_id)
);

SELECT * FROM MEMBER;
SELECT * FROM CLUB;
SELECT * FROM CLUBMEMBER;
SELECT * FROM SCHEDULE;
SELECT * FROM CATEGORY;
SELECT * FROM CLUBCATEGORY;
SELECT * FROM MEMBERCATEGORY;
SELECT * FROM MEMBERSCHEDULE;
SELECT * FROM POST;
SELECT * FROM POSTIMAGE;
SELECT * FROM BADGE;
SELECT * FROM MEMBERBADGE;