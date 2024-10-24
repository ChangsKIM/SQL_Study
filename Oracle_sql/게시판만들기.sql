-- 01 테이블 생성 및 기본키, 외래키 설정
-- 회원 테이블
CREATE TABLE board_member (
    id VARCHAR2(50) ,          -- 회원 아이디
    password CHAR(128) ,       -- 암호
    username VARCHAR2(50) ,    -- 이름
    nickname VARCHAR2(50) ,    -- 닉네임
    PRIMARY KEY (id)                   -- 기본키 설정
);

-- 게시판 테이블
CREATE TABLE board (
    bno NUMBER ,               -- 글 번호
    id VARCHAR2(50) ,          -- 회원 아이디 (외래키)
    title VARCHAR2(150) ,      -- 목
    content CLOB ,             -- 내용
    write_date DATE DEFAULT SYSDATE,   -- 작성일
    write_update_date DATE DEFAULT SYSDATE, -- 수정일
    bcount NUMBER DEFAULT 0,           -- 조회수
    PRIMARY KEY (bno),                 -- 기본키 설정
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조 (외래키)
);

-- 게시글 좋아요 테이블
CREATE TABLE board_content_like (
    bno NUMBER ,               -- 글 번호 (외래키)
    id VARCHAR2(50) ,          -- 회원 아이디 (외래키)
    PRIMARY KEY (bno, id),             -- 복합키 설정 (글 번호, 회원 아이디)
    FOREIGN KEY (bno) REFERENCES board(bno),  -- 게시판 테이블 참조
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조
);

-- 게시글 싫어요 테이블
CREATE TABLE board_content_hate (
    bno NUMBER ,               -- 글 번호 (외래키)
    id VARCHAR2(50) ,          -- 회원 아이디 (외래키)
    PRIMARY KEY (bno, id),             -- 복합키 설정 (글 번호, 회원 아이디)
    FOREIGN KEY (bno) REFERENCES board(bno),  -- 게시판 테이블 참조
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조
);

-- 댓글 테이블
CREATE TABLE board_comment (
    cno NUMBER,               -- 댓글 번호
    bno NUMBER ,               -- 글 번호 (외래키)
    id VARCHAR2(50) ,          -- 회원 아이디 (외래키)
    content VARCHAR2(1000) ,   -- 댓글 내용
    cdate DATE DEFAULT SYSDATE,        -- 댓글 작성일
    PRIMARY KEY (cno),                 -- 기본키 설정
    FOREIGN KEY (bno) REFERENCES board(bno),  -- 게시판 테이블 참조
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조
);

-- 댓글 좋아요 테이블
CREATE TABLE board_comment_like (
    cno NUMBER ,               -- 댓글 번호 (외래키)
    id VARCHAR2(50),          -- 회원 아이디 (외래키)
    PRIMARY KEY (cno, id),             -- 복합키 설정 (댓글 번호, 회원 아이디)
    FOREIGN KEY (cno) REFERENCES board_comment(cno),  -- 댓글 테이블 참조
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조
);

-- 댓글 싫어요 테이블
CREATE TABLE board_comment_hate (
    cno NUMBER ,               -- 댓글 번호 (외래키)
    id VARCHAR2(50) ,          -- 회원 아이디 (외래키)
    PRIMARY KEY (cno, id),             -- 복합키 설정 (댓글 번호, 회원 아이디)
    FOREIGN KEY (cno) REFERENCES board_comment(cno),  -- 댓글 테이블 참조
    FOREIGN KEY (id) REFERENCES board_member(id) -- 회원 테이블 참조
);

-- 첨부파일 테이블
CREATE TABLE board_file (
    fno CHAR(10) ,             -- 파일 번호
    bno NUMBER ,               -- 글 번호 (외래키)
    fpath VARCHAR2(256) ,          -- 파일 경로
    PRIMARY KEY (fno),                 -- 기본키 설정
    FOREIGN KEY (bno) REFERENCES board(bno) -- 게시판 테이블 참조
);


-- 02. 시퀸스 생성
-- 게시글 번호 시퀸스 생성
CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1;

-- 댓글 번호 시퀸스 생성
CREATE SEQUENCE comment_seq
START WITH 1
INCREMENT BY 1;

-- 파일 번호 시퀸스 생성
CREATE SEQUENCE file_seq
START WITH 1
MINVALUE 1
MAXVALUE 9999999
INCREMENT BY 1
NOCYCLE;

-- 글 번호, 제목, 작성자, 닉네임, 조회수, 작성일, 글내용, 좋아요, 싫어요
-- 글 번호 좋아요 개수 조회
SELECT 
	BCL.CNO ,
	COUNT(*) 
FROM BOARD_COMMENT_LIKE bcl 
GROUP BY BCL.CNO ;

SELECT
	BCL.BNO ,
	COUNT(*) 
FROM BOARD_CONTENT_LIKE bcl 
GROUP BY BCL.BNO ;


-- 글 번호, 제목, 작성자, 닉네임, 조회수, 작성일, 글내용, 좋아요, 싫어요
-- 글 번호 기준으로 내림차순 정렬

SELECT B.*, BM.NICKNAME, NVL(BLIKE,0) AS BLIKE , NVL(BHATE,0) AS BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BLIKE 
FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL
ON BL.BNO = B.BNO
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BHATE 
FROM BOARD_CONTENT_HATE GROUP BY BNO) BH
ON BH.BNO = B.BNO ORDER BY B.BNO DESC;


-- 뷰 생성
CREATE OR REPLACE VIEW BOARD_VIEW
AS
SELECT B.*, BM.NICKNAME, NVL(BLIKE,0) AS BLIKE , NVL(BHATE,0) AS BHATE
FROM BOARD B JOIN BOARD_MEMBER BM ON B.ID = BM.ID
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BLIKE 
FROM BOARD_CONTENT_LIKE GROUP BY BNO) BL
ON BL.BNO = B.BNO
LEFT OUTER JOIN (SELECT BNO, COUNT(*) AS BHATE 
FROM BOARD_CONTENT_HATE GROUP BY BNO) BH
ON BH.BNO = B.BNO ORDER BY B.BNO DESC;

-- 조회
SELECT * FROM BOARD_VIEW;
