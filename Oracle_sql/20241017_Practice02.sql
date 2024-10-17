-- 2024/10/17 복습

-- 학생 테이블 문제
-- 01. 학생정보 조회시 학번, 이름, 학과명 평점 조회
SELECT
s.STD_NO AS 학번,
s.STD_NAME AS 이름,
m.MAJOR_NAME AS 학과명,
s.STD_SCORE AS 평점
FROM STUDENT s 
LEFT OUTER JOIN MAJOR m ON s.MAJOR_NO = m.MAJOR_NO; 

-- 02. 장학금을 받는 학생 조회시 학번, 이름, 학과명, 평점, 성별, 금액 출력
SELECT 
	ss.SCHOLARSHIP_NO,
	s.STD_NO ,
	s.STD_NAME ,
	m.MAJOR_NAME ,
	s.STD_SCORE ,
	s.STD_GENDER ,
	ss.MONEY 
FROM STUDENT s 
LEFT OUTER JOIN MAJOR m ON s.STD_NO = m.MAJOR_NO 
JOIN SUDENT_SCHOLARSHRIP ss ON s.STD_NO = ss.STD_NO;

-- 03. 학생정보 출력할 때 학생 테이블, 학과 테이블에 있는 모든 데이터 조회
-- 이때, 모든 컬럼 조회 / 연결되지 않은 학과도 전부 조회
SELECT s.*, m.*
FROM STUDENT s 
LEFT OUTER JOIN MAJOR m ON s.STD_NO = m.MAJOR_NO ;

-- 학과 테이블에 데이터 2건 추가
INSERT INTO MAJOR VALUES ('A9', '국어국문학과');
INSERT INTO MAJOR VALUES ('B2', '생활체육학과');

-- 04. 학생이 한명도 없는 학과 조회
-- 일치하지 않는 데이터를 조회 > 불일치 쿼리
SELECT
    M.*, S.STD_NO 
FROM STUDENT S 
RIGHT OUTER JOIN MAJOR M 
ON S.MAJOR_NO = M.MAJOR_NO
WHERE S.STD_NAME IS NULL;

-- 05. 장학금을 받지 못한 학생들 조회
SELECT 
	s.STD_NAME , 
	ss.SCHOLARSHIP_NO ,
	s.STD_NO ,
	ss.MONEY 
FROM STUDENT s 
LEFT OUTER JOIN SUDENT_SCHOLARSHRIP ss ON s.STD_NO = ss.STD_NO 
WHERE ss.SCHOLARSHIP_NO IS null;

-- 06. 학과별로 장학금을 받은 학생들 조회시 학과별, 성별을 기준으로 인원수, 최고평점, 최저평점 출력
SELECT 
	m.MAJOR_NAME AS 학과명,
	s.STD_GENDER AS 성별,
	COUNT(*) AS 인원수,
	max(s.STD_SCORE) AS 최고점수,
	MIN(s.STD_SCORE) AS 최저점수 
FROM STUDENT s 
LEFT OUTER JOIN SUDENT_SCHOLARSHRIP ss ON s.STD_NO = ss.STD_NO
JOIN MAJOR m ON s.MAJOR_NO = m.MAJOR_NO 
GROUP BY m.MAJOR_NAME , s.STD_GENDER ;

-- 07.
