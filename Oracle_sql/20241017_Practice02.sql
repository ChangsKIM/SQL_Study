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

-- 07.학과별로 장학금을 받지 못한 학생들 조회. 단, 학과별 인원수만 출력
SELECT
	m.MAJOR_NAME ,
	COUNT(*) 
FROM STUDENT s 
LEFT OUTER JOIN SUDENT_SCHOLARSHRIP ss ON s.STD_NO = ss.STD_NO 
JOIN MAJOR m ON s.MAJOR_NO = m.MAJOR_NO
WHERE ss.SCHOLARSHIP_NO IS NULL 
GROUP BY m.MAJOR_NAME;


-- 자동차 테이블 문제
-- 01. 자동차 정보 조회시 자동차 번호, 자동차 모델명, 제조사명, 제조년도, 금액 출력
SELECT 
	c.CAR_ID AS 번호,
	cm.CAR_MAKER_CODE AS 모델명,
	cm.CAR_MAKER_NAME AS 제조사,
	c.CAR_MAKE_YEAR AS 제조년도,
	c.CAR_PRICE AS 금액
FROM CAR c 
LEFT OUTER JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE 

-- 02. 자동차 제조사별 차량 대수, 금액 평균가, 최고가, 최소가 조회
SELECT 
  cm.CAR_MAKER_NAME AS 제조사,
  COUNT(*) AS "차량 대수",
  TRUNC(AVG(c.CAR_PRICE), 2) AS 평균가, 
  MAX(c.CAR_PRICE) AS 최고가,
  MIN(c.CAR_PRICE) AS 최저가 
FROM CAR c
LEFT OUTER JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE
GROUP BY cm.CAR_MAKER_NAME ;

-- 03. 자동차 제조사별, 제조년도별, 출시된 차량 대수를 조회. 단, 금액이 10,000이상인 것들만 출력
SELECT 
	cm.CAR_MAKER_NAME AS 제조사,
	c.CAR_MAKE_YEAR AS 제조년도,
	COUNT(*) AS "차량 대수"
FROM CAR c 
JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE 
WHERE c.CAR_PRICE <= 10000
GROUP BY cm.CAR_MAKER_NAME , c.CAR_MAKE_YEAR; 

-- 04. 자동차 판매 정보 조회. 판매번호, 판매된 모델명, 판매 날짜, 판매 대수, 판매 금액 출력
SELECT 
	cs.CAR_SELL_NO AS 판매번호,
	c.CAR_NAME AS 모델명,
	cs.CAR_SELL_DATE AS 날짜,
	cs.CAR_SELL_EA AS 판매대수,
	cs.CAR_SELL_PRICE AS 판매금액
FROM CAR c 
JOIN CAR_SELL cs ON c.CAR_ID = cs.CAR_ID 
JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE ;

-- 05. 한번도 판매되지 않은 차량 조회. 자동차 번호, 모델명, 제조사, 제조년도, 금액 출력
SELECT 
	c.CAR_ID,
	c.CAR_NAME,
	cm.CAR_MAKER_NAME,
	c.CAR_MAKE_YEAR,
	c.CAR_PRICE 
FROM CAR c 
JOIN CAR_SELL cs ON c.CAR_ID = cs.CAR_ID 
JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE 
WHERE cs.CAR_ID IS NULL;

-- 06. 판매 연도별, 제조사별, 판매 대수 총합, 판매금액 총합, 판매금액 평균 조회
SELECT 
	TO_CHAR(cs.CAR_SELL_DATE, 'YYYY') AS 연도별,
	cm.CAR_MAKER_NAME AS 제조사,
	SUM(cs.CAR_SELL_EA) AS 판매대수,
	SUM(cs.CAR_SELL_PRICE) AS 판매금액,
	TRUNC(AVG(cs.CAR_SELL_PRICE), 2) AS 평균금액 
FROM CAR c 
JOIN CAR_SELL cs ON c.CAR_ID = cs.CAR_ID 
JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE 
GROUP BY TO_CHAR(cs.CAR_SELL_DATE, 'YYYY'),
		 cm.CAR_MAKER_NAME;

-- 07. 판매 연도/월별, 제조사별 조회. 판매 대수 총합, 판매금액 총합, 판매평균 출력
SELECT 
	TO_CHAR(cs.CAR_SELL_DATE, 'YYYY/MM') AS 월별,
	cm.CAR_MAKER_NAME AS 제조사,
	SUM(cs.CAR_SELL_EA) AS 판매대수,
	SUM(cs.CAR_SELL_PRICE) AS 판매금액,
	TRUNC(AVG(cs.CAR_SELL_PRICE), 2) AS 평균금액 
FROM CAR c 
JOIN CAR_SELL cs ON c.CAR_ID = cs.CAR_ID 
JOIN CAR_MAKER cm ON c.CAR_MAKER_CODE = cm.CAR_MAKER_CODE 
GROUP BY TO_CHAR(cs.CAR_SELL_DATE, 'YYYY/MM'),
		 cm.CAR_MAKER_NAME;
		 
		
-- 사원 테이블 문제
--문제
--각 사원의 이름, 부서명, 직급명을 조회하는 SQL 문을 작성하세요.

--각 부서별로 평균 연봉을 계산하여 부서명과 평균 연봉을 조회하는 SQL 문을 작성하세요. 평균 연봉은 내림차순으로 정렬하세요.

--사원들의 연봉 순위(RANK)를 구하고, 사원 이름, 연봉, 연봉 순위를 조회하는 SQL 문을 작성하세요. 동일한 연봉일 경우 동일한 순위를 부여하며, 연봉은 내림차순으로 정렬하세요.

--새로운 부서 '홍보부'를 부서 번호 'D009'로 EMP_DEPARTMENT 테이블에 추가하는 SQL 문을 작성하세요.

--사번이 'A20201111'인 사원의 연봉을 10% 인상하는 SQL 문을 작성하세요.

--직급 번호가 '08'인 사원들을 EMPLOYEE 테이블에서 삭제하는 SQL 문을 작성하세요.

--각 직급별로 사원 수를 계산하여 직급명과 사원 수를 조회하는 SQL 문을 작성하세요. 사원 수는 내림차순으로 정렬하세요.

--각 부서별로 사원 수를 계산하여 부서명과 사원 수와 순위를 조회하는 SQL 문을 작성하세요. 사원 수는 내림차순으로 정렬하세요.

--각 부서별로 연봉을 합산하여 부서별 연봉 순위와 부서명, 연봉 총합을 조회하는 SQL문을 작성하세요.