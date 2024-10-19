CREATE TABLE ANIMAL (
    AnimalID INT PRIMARY KEY,      -- 동물 ID
    Name VARCHAR(50),              -- 동물 이름
    Species VARCHAR(50),           -- 종
    Age INT,                       -- 나이
    DateOfArrival DATE             -- 동물 보호소 도착일
);

-- 데이터 삽입 예시
INSERT INTO ANIMAL (AnimalID, Name, Species, Age, DateOfArrival)
VALUES (1, '루돌프', '사슴', 5, '2023-01-01');

INSERT INTO ANIMAL (AnimalID, Name, Species, Age, DateOfArrival)
VALUES (2, '바둑이', '개', 3, '2023-02-10');

INSERT INTO ANIMAL (AnimalID, Name, Species, Age, DateOfArrival)
VALUES (3, '야옹이', '고양이', 2, '2023-03-15');

SELECT * FROM ANIMAL ;

-- 데이터 수정
-- 사슴 나이 6으로 수정
UPDATE ANIMAL SET AGE = 6
WHERE ANIMALID = 1;

UPDATE ANIMAL SET NAME = '냥이'
WHERE ANIMALID = 3;

-- 데이터 삭제
-- ainmailid가 2인 동물 삭제
DELETE FROM ANIMAL WHERE ANIMALID = 2;

SELECT * FROM ANIMAL ;

-- 조회 나이 오름 차순
SELECT * FROM ANIMAL
ORDER BY AGE ;
-- 조회 나이 내림차순
SELECT * FROM ANIMAL ORDER BY AGE DESC ;

SELECT NAME, AGE FROM ANIMAL WHERE AGE = 6; 

SELECT * FROM ANIMAL WHERE AGE BETWEEN 1 AND 4;