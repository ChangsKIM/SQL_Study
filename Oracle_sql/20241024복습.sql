-- VIEW 생성 권한
GRANT CREATE VIEW TO C##CHANGS;

-- 학생정보 조회 ; 학번, 이름, 학과명, 평점, 성별
SELECT 
	S.STD_NO ,
	S.STD_NAME ,
	M.MAJOR_NAME ,
	S.STD_SCORE ,
	S.STD_GENDER 
FROM STUDENT s 
JOIN MAJOR m ON S.MAJOR_NO = M.MAJOR_NO; 

-- 뷰로 만들기
CREATE OR REPLACE VIEW STUDENT_VIEW02
AS
SELECT 
	S.STD_NO ,
	S.STD_NAME ,
	M.MAJOR_NAME ,
	S.STD_SCORE ,
	S.STD_GENDER 
FROM STUDENT s 
JOIN MAJOR m ON S.MAJOR_NO = M.MAJOR_NO; 

-- 뷰 조회
SELECT * FROM STUDENT_VIEW02;

-- 학과별 인원수
SELECT 
	M.MAJOR_NAME ,
	COUNT(*) AS 인원수
FROM STUDENT s JOIN MAJOR m ON S.MAJOR_NO = M.MAJOR_NO 
GROUP BY MAJOR_NAME ;


-- 장학금을 받은 학생들 조회
-- 장학금 번호, 금액, 학번, 학과명, 성별, 평점
SELECT
	SS.SCHOLARSHIP_NO AS 장학금번호,
	SS.MONEY AS 금액,
	S.STD_NO AS 학번,
	M.MAJOR_NAME AS 학과명,
	S.STD_GENDER AS 성별,
	S.STD_SCORE AS 학점
FROM STUDENT s 
JOIN SUDENT_SCHOLARSHRIP ss ON S.STD_NO = SS.STD_NO 
JOIN MAJOR m ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY SS.SCHOLARSHIP_NO ;

-- 뷰 만들기
CREATE OR REPLACE VIEW SUDENT_SCHOLARSHRIP_VIEW
AS
SELECT
	SS.SCHOLARSHIP_NO AS 장학금번호,
	SS.MONEY AS 금액,
	S.STD_NO AS 학번,
	M.MAJOR_NAME AS 학과명,
	S.STD_GENDER AS 성별,
	S.STD_SCORE AS 학점
FROM STUDENT s 
JOIN SUDENT_SCHOLARSHRIP ss ON S.STD_NO = SS.STD_NO 
JOIN MAJOR m ON S.MAJOR_NO = M.MAJOR_NO
ORDER BY SS.SCHOLARSHIP_NO ;

-- 조회
SELECT * FROM SUDENT_SCHOLARSHRIP_VIEW;


-------------------------------------------------------
-- 생성된 인덱스 객체 조회
SELECT * FROM USER_INDEXES;

SELECT * FROM PERSON;
CREATE TABLE PERSON(
	P_NAME VARCHAR2(50),
	P_AGE NUMBER,
	P_GENDER CHAR(1)
);

SELECT * FROM PERSON p ;

-- 인덱스 설정
CREATE INDEX IDX_PERSON_NAME ON PERSON(P_NAME);
-- 이름으로 조회
SELECT * FROM PERSON p WHERE P_NAME = '임은서';
-- INDEX 삭제
DROP INDEX IDX_PERSON_NAME;


-- 회사원 인덱스 설정 및 조회
CREATE INDEX IDX_EMPLOYEE ON EMPLOYEE(EMP_NAME, POS_NO, DEPT_NO);
-- 조회
SELECT * FROM EMPLOYEE e WHERE POS_NO = 03 AND DEPT_NO = D003;



-------------------------------------------------------------
CREATE SEQUENCE NO_SEQ;

SELECT NO_SEQ.NEXTVAL FROM DUAL;

CREATE SEQUENCE TEST_SEQ
INCREMENT BY 2
START WITH 4
MINVALUE 4
MAXVALUE 10
CYCLE 
NOCACHE;

SELECT TEST_SEQ.NEXTVAL FROM DUAL;



-- 시퀸스 문제 03
-- 이름 ; SEQ_ORDER_NO / 시작 값 ; 1000 / 최소 값 ; 500 / 감소 값 ; 10 / 순환 미사용
CREATE SEQUENCE SEQ_ORDER_NO
START WITH 600
MAXVALUE 600
MINVALUE 400
INCREMENT BY -20
NOCYCLE;

SELECT SEQ_ORDER_NO.NEXTVAL FROM DUAL;


----------------------------------------------------------------------
-- 함수
-- 홀수, 짝수
CREATE OR REPLACE FUNCTION GET_ODD_EVEN(N IN NUMBER)
RETURN VARCHAR2 IS 
	-- 함수에서 사용할 변수를 선언하는 영역
	MSG VARCHAR2(100);
BEGIN 
	-- 실행하는 영역
	IF N = 0	THEN
		MSG := '0 입니다.';
	ELSIF MOD(N, 2) = 0 THEN
		MSG := '짝수입니다.';
	ELSE
		MSG := '홀수입니다.';
	END IF;
	RETURN MSG;
END;

SELECT 
	GET_ODD_EVEN(5), 
	GET_ODD_EVEN(0),
	GET_ODD_EVEN(20),
	GET_ODD_EVEN(87) 
FROM DUAL;


-- 실습문제 시험점수(A ~ F)
CREATE OR REPLACE FUNCTION GET_SCORE_GRADE(SCORE IN NUMBER)
RETURN VARCHAR2
IS
	MSG VARCHAR2(100);
	USER_EXCEPTION EXCEPTION; -- 이셉션 객체 생성
BEGIN 
	IF SCORE < 0 THEN
		RAISE USER_EXCEPTION;	
	END IF;
	IF SCORE >= 95 AND 91 >= SCORE THEN
		MSG := 'A+';
	ELSIF SCORE >= 90 THEN
		MSG := 'A';
	ELSIF SCORE >= 85 THEN
		MSG := 'B+';
	ELSIF SCORE >= 80 THEN
		MSG := 'B';
	ELSIF SCORE >= 75 THEN
		MSG := 'C+';
	ELSIF SCORE >= 70 THEN
		MSG := 'C';
	ELSIF SCORE >= 65 THEN
		MSG := 'D+';
	ELSIF SCORE >= 60 THEN
		MSG := 'D'; 
	ELSE
		MSG := 'F';		
	END IF;
	RETURN MSG;
EXCEPTION 
	WHEN USER_EXCEPTION THEN
		RETURN '점수는 0이상 입력';
	WHEN OTHERS THEN
		RETURN '알 수 없는 에러';
END;


SELECT 
	GET_SCORE_GRADE(96) AS 학생01,
	GET_SCORE_GRADE(72) AS 학생02,
	GET_SCORE_GRADE(83) AS 학생03,
	GET_SCORE_GRADE(11) AS 학생04,
	GET_SCORE_GRADE(0) AS 학생05,
	GET_SCORE_GRADE(-1) AS 학생06,
	GET_SCORE_GRADE(61) AS 학생07
	FROM dual;



	-- 실습문제 02

-- 학과 번호를 받아서 학과명을 리턴하는 함수
-- 없는 번호를 입력했을 때의 대처

CREATE OR REPLACE FUNCTION GET_MAJOR_NAME(V_MAJOR_NO IN VARCHAR2)
RETURN VARCHAR2
IS
	MSG VARCHAR2(30);	
BEGIN 
		-- 문자열
	SELECT M.MAJOR_NAME INTO MSG
	FROM MAJOR M 
	WHERE M.MAJOR_NO = V_MAJOR_NO;
	RETURN MSG;
EXCEPTION 
	WHEN OTHERS THEN
		RETURN '데이터 없음';
END;

SELECT 
	GET_MAJOR_NAME('20')
FROM DUAL;

SELECT 	GET_MAJOR_NAME('03') 
FROM DUAL;
