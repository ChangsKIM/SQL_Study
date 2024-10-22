-- 회원 테이블 생성
CREATE TABLE member (
    userID      VARCHAR2(50)  NOT NULL,    -- 사용자 ID
    m_name      VARCHAR2(50)  NOT NULL,    -- 사용자 이름
    m_password  CHAR(128)     NOT NULL,    -- 비밀번호
    m_nickname  VARCHAR2(50)  NOT NULL,    -- 닉네임
    m_email     VARCHAR2(100) NOT NULL,    -- 이메일
    CONSTRAINT pk_member PRIMARY KEY (userID)
);

-- 게시판 테이블 생성
CREATE TABLE post (
    p_no           NUMBER        NOT NULL,   -- 글 번호 (게시글 고유 번호)
    userID         VARCHAR2(50)  NOT NULL,   -- 사용자 ID (작성자)
    p_title        VARCHAR2(100) NOT NULL,   -- 게시글 제목
    p_content      CLOB          NOT NULL,   -- 게시글 내용
    p_viewcount    NUMBER,                  -- 조회수 (NULL 허용이므로 NULL 명시 불필요)
    p_createddate  DATE          DEFAULT SYSDATE NOT NULL,  -- 작성일
    p_modifieddate DATE          DEFAULT SYSDATE NOT NULL,  -- 수정일
    CONSTRAINT pk_post PRIMARY KEY (p_no),
    CONSTRAINT fk_post_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);


-- 댓글 테이블 생성
CREATE TABLE user_comment (
    c_no           NUMBER        NOT NULL,   -- 댓글 번호 (고유 번호)
    userID         VARCHAR2(50)  NOT NULL,   -- 사용자 ID (작성자)
    p_no           NUMBER        NOT NULL,   -- 글 번호 (댓글이 달린 게시글 번호)
    c_content      VARCHAR2(500) NOT NULL,   -- 댓글 내용
    c_createddate  DATE          DEFAULT SYSDATE NOT NULL,  -- 작성일
    c_modifieddate DATE          DEFAULT SYSDATE NOT NULL,  -- 수정일
    CONSTRAINT pk_comment PRIMARY KEY (c_no),
    CONSTRAINT fk_comment_post FOREIGN KEY (p_no) REFERENCES post(p_no) ON DELETE CASCADE,
    CONSTRAINT fk_comment_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);


-- 게시글 좋아요 테이블 생성
CREATE TABLE post_like (
    p_no    NUMBER       NOT NULL,   -- 글 번호 (게시글)
    userID  VARCHAR2(50) NOT NULL,   -- 사용자 ID
    CONSTRAINT pk_post_like PRIMARY KEY (p_no, userID),
    CONSTRAINT fk_post_like_post FOREIGN KEY (p_no) REFERENCES post(p_no) ON DELETE CASCADE,
    CONSTRAINT fk_post_like_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);

-- 게시글 싫어요 테이블 생성
CREATE TABLE post_dislike (
    p_no    NUMBER       NOT NULL,   -- 글 번호 (게시글)
    userID  VARCHAR2(50) NOT NULL,   -- 사용자 ID
    CONSTRAINT pk_post_dislike PRIMARY KEY (p_no, userID),
    CONSTRAINT fk_post_dislike_post FOREIGN KEY (p_no) REFERENCES post(p_no) ON DELETE CASCADE,
    CONSTRAINT fk_post_dislike_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);

-- 댓글 좋아요 테이블 생성
CREATE TABLE user_comment_like (
    c_no   NUMBER       NOT NULL,   -- 댓글 번호 (댓글)
    userID VARCHAR2(50) NOT NULL,   -- 사용자 ID
    p_no   NUMBER       NOT NULL,   -- 글 번호 (댓글이 달린 게시글 번호)
    CONSTRAINT pk_comment_like PRIMARY KEY (c_no, userID),
    CONSTRAINT fk_comment_like_comment FOREIGN KEY (c_no) REFERENCES user_comment(c_no) ON DELETE CASCADE,
    CONSTRAINT fk_comment_like_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);

-- 댓글 싫어요 테이블 생성
CREATE TABLE user_comment_dislike (
    c_no   NUMBER       NOT NULL,   -- 댓글 번호 (댓글)
    userID VARCHAR2(50) NOT NULL,   -- 사용자 ID
    p_no   NUMBER       NOT NULL,   -- 글 번호 (댓글이 달린 게시글 번호)
    CONSTRAINT pk_comment_dislike PRIMARY KEY (c_no, userID),
    CONSTRAINT fk_comment_dislike_comment FOREIGN KEY (c_no) REFERENCES user_comment(c_no) ON DELETE CASCADE,
    CONSTRAINT fk_comment_dislike_member FOREIGN KEY (userID) REFERENCES member(userID) ON DELETE CASCADE
);

-- 첨부파일 테이블 생성
CREATE TABLE attachment (
    f_no     NUMBER         NOT NULL,   -- 파일 번호
    p_no     NUMBER         NOT NULL,   -- 게시글 번호
    f_name   VARCHAR2(50)   NOT NULL,   -- 파일 이름
    f_path   VARCHAR2(256)  NOT NULL,   -- 파일 경로
    f_upload DATE DEFAULT SYSDATE NOT NULL,  -- 업로드 날짜
    CONSTRAINT pk_attachment PRIMARY KEY (f_no),
    CONSTRAINT fk_attachment_post FOREIGN KEY (p_no) REFERENCES post(p_no) ON DELETE CASCADE
);

----------------------
-- 02. 시퀀스 설정
-- 게시글 번호 시퀀스
CREATE SEQUENCE seq_post
START WITH 1
INCREMENT BY 1;

-- 댓글 번호 시퀀스
CREATE SEQUENCE seq_comment
START WITH 1
INCREMENT BY 1;

-- 첨부파일 번호 시퀀스
CREATE SEQUENCE seq_attachment
START WITH 1
INCREMENT BY 1;


-- 데이터 삽입
-- 회원 샘플 데이터
INSERT INTO member VALUES ('user01', '홍길동', 'password1', 'hong', 'hong@gmail.com');
INSERT INTO member VALUES ('user02', '이순신', 'password2', 'lee', 'lee@gmail.com');
INSERT INTO member VALUES ('user03', '강감찬', 'password3', 'kang', 'kang@gmail.com');
INSERT INTO member VALUES ('user04', '유관순', 'password4', 'yoo', 'yoo@gmail.com');
INSERT INTO member VALUES ('user05', '안중근', 'password5', 'ahn', 'ahn@gmail.com');

-- 게시글 샘플 데이터
INSERT INTO post VALUES (seq_post.NEXTVAL, 'user01', '첫번째 글', '내용1', 100, SYSDATE, SYSDATE);
INSERT INTO post VALUES (seq_post.NEXTVAL, 'user02', '두번째 글', '내용2', 50, SYSDATE, SYSDATE);
INSERT INTO post VALUES (seq_post.NEXTVAL, 'user03', '세번째 글', '내용3', 70, SYSDATE, SYSDATE);
INSERT INTO post VALUES (seq_post.NEXTVAL, 'user04', '네번째 글', '내용4', 120, SYSDATE, SYSDATE);
INSERT INTO post VALUES (seq_post.NEXTVAL, 'user05', '다섯번째 글', '내용5', 150, SYSDATE, SYSDATE);

-- 댓글 샘플 데이터
INSERT INTO comment VALUES (seq_comment.NEXTVAL, 'user01', 1, '첫번째 댓글', SYSDATE, SYSDATE);
INSERT INTO comment VALUES (seq_comment.NEXTVAL, 'user02', 1, '두번째 댓글', SYSDATE, SYSDATE);
INSERT INTO comment VALUES (seq_comment.NEXTVAL, 'user03', 2, '세번째 댓글', SYSDATE, SYSDATE);
INSERT INTO comment VALUES (seq_comment.NEXTVAL, 'user04', 3, '네번째 댓글', SYSDATE, SYSDATE);
INSERT INTO comment VALUES (seq_comment.NEXTVAL, 'user05', 4, '다섯번째 댓글', SYSDATE, SYSDATE);

-- 첨부파일 샘플 데이터
INSERT INTO attachment VALUES (seq_attachment.NEXTVAL, 1, 'file1.txt', '/files/file1.txt', SYSDATE);
INSERT INTO attachment VALUES (seq_attachment.NEXTVAL, 2, 'file2.txt', '/files/file2.txt', SYSDATE);
INSERT INTO attachment VALUES (seq_attachment.NEXTVAL, 3, 'file3.txt', '/files/file3.txt', SYSDATE);
INSERT INTO attachment VALUES (seq_attachment.NEXTVAL, 4, 'file4.txt', '/files/file4.txt', SYSDATE);
INSERT INTO attachment VALUES (seq_attachment.NEXTVAL, 5, 'file5.txt', '/files/file5.txt', SYSDATE);

