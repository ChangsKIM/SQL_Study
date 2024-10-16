-- 테이블 생성
CREATE TABLE STUDENT(
    STD_NO CHAR(8) PRIMARY KEY,
    STD_NAME VARCHAR2(30) NOT NULL,
    STD_MAJOR VARCHAR2(30),
    STD_SCORE NUMBER(3,2) DEFAULT 0 NOT NULL,
    STD_GENDER CHAR(1)
);

SELECT * FROM STUDENT;

-- 각 학과별 평균(소수점 2자리까지)
SELECT STD_MAJOR AS 학과명, TRUNC(AVG(STD_SCORE), 2) AS 평점
FROM STUDENT
GROUP BY STD_MAJOR;

-- 학과별 평점의 최대 값, 최소값
SELECT 
STD_MAJOR AS 학과명, 
MAX(STD_SCORE), MIN(STD_SCORE)--, COUNT(STD_SCORE)
FROM STUDENT
GROUP BY STD_MAJOR;

-- 학과별 인원수 조회 / 단, 평점이 3.0이상인 사람만 출력
-- 학과별 인원수를 조회, 평점이 3.0 이상인 학생들만 조회
SELECT STD_MAJOR, COUNT(STD_SCORE)  --4
FROM STUDENT -- 1
WHERE STD_SCORE > 3.0  -- 2
GROUP BY STD_MAJOR; -- 3

-- 학과별 인원수를 조회, 평점이 2.8이하인 학생들만 출력
SELECT
	STD_MAJOR, COUNT(STD_SCORE)
	FROM STUDENT
	WHERE STUDENT.STD_SCORE < 2.8
	GROUP BY STD_MAJOR ;

-- 현재 학생 테이블에 있는 데이터를 기준으로 학과별 인원수를 조회
-- 단, 조회하는 인원수가 50명 이상인 학과만 출력
SELECT STD_MAJOR AS 학과명, COUNT(*)
FROM STUDENT
GROUP BY STD_MAJOR HAVING COUNT(*) >= 50;

--연습문제

-- NEW_STUDENT TABLE 생성
CREATE TABLE NEW_STUDENT(
    STD_NO CHAR(8) PRIMARY KEY,
    STD_NAME VARCHAR2(30) NOT NULL,
    STD_MAJOR VARCHAR2(30),
    STD_SCORE NUMBER(3,2) DEFAULT 0 NOT NULL,
    STD_GENDER CHAR(1)
);

SELECT * FROM NEW_STUDENT;


-- 1. 입학한 년도별, 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS 입학년도,
	STD_MAJOR AS 학과명,
	STD_GENDER AS 성별,
	COUNT(*) AS 인원수,
	TRUNC (AVG(STD_SCORE), 2) AS "평점 평균",
	SUM(STD_SCORE) AS 총점
FROM NEW_STUDENT
GROUP BY SUBSTR(STD_NO, 1, 4), STD_MAJOR, STD_GENDER; 

-- 2. 입학한 년도별, 학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT
	SUBSTR(STD_NO, 1, 4) AS 입학년도,
	STD_MAJOR AS 학과명,
	COUNT(*) AS 인원수,
	TRUNC (AVG(STD_SCORE), 2) AS "평점 평균",
	SUM(STD_SCORE) AS 총점
FROM NEW_STUDENT
GROUP BY SUBSTR(STD_NO, 1, 4), STD_MAJOR;

-- 3. 입학한 년도별, 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	SUBSTR(STD_NO, 1, 4) AS 입학년도,
	COUNT(*) AS 인원수,
	SUM(STD_SCORE) AS 총점,
	TRUNC(AVG(STD_SCORE), 2) AS 평균 
FROM NEW_STUDENT
GROUP BY SUBSTR (STD_NO, 1, 4);

-- 4. 학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
	STD_MAJOR AS 학과명,
	COUNT(*) AS 인원수,
	TRUNC(AVG(STD_SCORE), 2) AS 평균,
	SUM(STD_SCORE) AS 총점
FROM NEW_STUDENT
GROUP BY STD_MAJOR
ORDER BY 총점 DESC;

-- 5. 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT
	STD_MAJOR AS 학과,
	STD_GENDER AS 성별,
	COUNT(*) AS 인원수,
	TRUNC(AVG(STD_SCORE), 2) AS 평균점수,
	SUM(STD_SCORE) AS 총점
FROM NEW_STUDENT
GROUP BY STD_MAJOR , STD_GENDER
ORDER BY 평균점수 DESC;

-- 6. 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT
	STD_GENDER AS 성별,
	COUNT(*) AS 인원수,
	TRUNC(AVG(STD_SCORE), 2) AS 평균점수,
	SUM(STD_SCORE) AS 총점 
FROM NEW_STUDENT
GROUP BY STD_GENDER;

-- 7. 전체 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT
	COUNT(*) AS 인원수,
	TRUNC(AVG(STD_SCORE), 2) AS 평균점수,
	SUM(STD_SCORE) AS 총점 
FROM NEW_STUDENT

-- GROUPING SETS
SELECT 
    STD_MAJOR, 
    STD_GENDER, 
    COUNT(*) AS 학생수, 
    TRUNC(AVG(STD_SCORE), 2) AS 평균점수
FROM NEW_STUDENT
GROUP BY GROUPING SETS (
    (STD_MAJOR, STD_GENDER),  -- 학과별 + 성별
    (STD_MAJOR),              -- 학과별
    (STD_GENDER),             -- 성별별
    ()                        -- 전체
);
