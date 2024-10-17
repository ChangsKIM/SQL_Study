-- 01. 학생 테이블 생성
CREATE TABLE STUDENT(
    STD_NO CHAR(8) PRIMARY KEY,
    STD_NAME VARCHAR2(30) NOT NULL,
    STD_MAJOR VARCHAR2(30),
    STD_SCORE NUMBER(3,2) DEFAULT 0 NOT NULL,
    STD_GENDER CHAR(1)
);

--------------------------------------------------------------

-- 02. 학과 테이블 생성
CREATE TABLE MAJOR
AS
SELECT 
	TO_CHAR(ROWNUM,'FM00') AS MAJOR_NO, 
	STD_MAJOR AS MAJOR_NAME 
FROM (SELECT DISTINCT STD_MAJOR FROM STUDENT);

--학생 테이블에 학과 번호 컬럼을 추가
ALTER TABLE STUDENT ADD MAJOR_NO VARCHAR2(3);

--학생 테이블에 학과 번호 업데이트
UPDATE STUDENT
SET MAJOR_NO = 
	(SELECT MAJOR_NO FROM MAJOR WHERE MAJOR_NAME = STD_MAJOR);

--학생 테이블에서 학과명 컬럼 삭제
ALTER TABLE STUDENT DROP COLUMN STD_MAJOR;

--------------------------------------------------------------

-- 03. 학생 장학금 테이블 생성
CREATE TABLE SUDENT_SCHOLARSHRIP(
	SCHOLARSHIP_NO NUMBER,
	STD_NO CHAR(8),
	MONEY NUMBER
);

--------------------------------------------------------------


