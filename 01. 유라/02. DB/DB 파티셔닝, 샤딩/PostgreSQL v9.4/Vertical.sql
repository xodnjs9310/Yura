CREATE TABLE Vertical
(
  Security_Number VARCHAR(20) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Age INT NOT NULL,
  Gender VARCHAR(5) NOT NULL,
  Car VARCHAR(30) NOT NULL,
  Phone VARCHAR(20) NOT NULL,

  CONSTRAINT Vertical_pk PRIMARY KEY (Security_Number)
);

CREATE TABLE Vertical_SubData
(
 Security_Number VARCHAR(20) NOT NULL,
 Name VARCHAR(100) NOT NULL,
 Age INT NOT NULL,
 Gender VARCHAR(5) NOT NULL,

 CONSTRAINT Vertical_SubData_pk PRIMARY KEY (Security_Number) 
);

CREATE TABLE Vertical_MainData
(
 Security_Number VARCHAR(20) NOT NULL,
 Car VARCHAR(30) NOT NULL,
 Phone VARCHAR(20) NOT NULL,
 CONSTRAINT Vertical_MainData_pk FOREIGN KEY (Security_Number) REFERENCES Vertical_SubData (Security_Number)
);

-- 함수 및 트리거를 생성
CREATE OR REPLACE FUNCTION func_Vertical_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
 
    INSERT INTO Vertical_SubData(Security_Number, Name, Age, Gender) 
    VALUES(New.Security_Number, New.Name, New.Age, New.Gender);
    
    INSERT INTO Vertical_MainData(Security_Number, Car, Phone) 
    VALUES(New.Security_Number, New.Car, New.Phone);

    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION func_Vertical_insert_trigger() CASCADE;

CREATE TRIGGER trigger_Vertical_insert
   BEFORE INSERT on Vertical
   FOR EACH ROW EXECUTE PROCEDURE func_Vertical_insert_trigger();

-----------------------------------------------------------------------------------   
SELECT A.Security_Number, A.Name, A.Age, A.Gender, B.Car, B.Phone	
FROM Vertical_SubData A LEFT JOIN Vertical_MainData B
ON A.Security_Number = B.Security_Number;

SELECT * FROM Vertical_SubData;
SELECT * FROM Vertical_MainData;

delete from Vertical_SubData;
delete from Vertical_MainData;

INSERT INTO Vertical VALUES('111111-1111111', '김XX', 52, '남', '쏘나타', '010-1111-1111');
INSERT INTO Vertical VALUES('111112-1111111', '현XX', 12, '여', '니로', '010-1112-1111');
INSERT INTO Vertical VALUES('111113-1111111', '강XX', 26, '남', 'K5', '010-1113-1111');
INSERT INTO Vertical VALUES('111114-1111111', '지XX', 24, '여', '에쿠스', '010-1114-1111');
INSERT INTO Vertical VALUES('111115-1111111', '훈XX', 31, '남', '제네시스', '010-1115-1111');
INSERT INTO Vertical VALUES('111116-1111111', '현XX', 54, '여', '쏘나타', '010-1116-1111');
INSERT INTO Vertical VALUES('111117-1111111', '지XX', 33, '남', '스포티지', '010-1117-1111');
INSERT INTO Vertical VALUES('111118-1111111', '강XX', 44, '여', '쏘나타', '010-1118-1111');
INSERT INTO Vertical VALUES('111119-1111111', '한XX', 49, '남', 'K5', '010-1119-1111');
INSERT INTO Vertical VALUES('111110-1111111', '김XX', 47, '여', '쏘나타', '010-1110-1111');
INSERT INTO Vertical VALUES('111121-1111111', '한XX', 29, '남', '투싼', '010-1111-1112');
INSERT INTO Vertical VALUES('111122-1111111', '장XX', 11, '여', '스포티지', '010-1111-1113');
INSERT INTO Vertical VALUES('111123-1111111', '김XX', 20, '남', '쏘나타', '010-1111-1114');
INSERT INTO Vertical VALUES('111124-1111111', '장XX', 39, '여', '에쿠스', '010-1111-1115');
INSERT INTO Vertical VALUES('111125-1111111', '김XX', 42, '남', '쏘나타', '010-1111-1116');
INSERT INTO Vertical VALUES('111126-1111111', '구XX', 34, '여', '쏘나타', '010-1111-1117');
INSERT INTO Vertical VALUES('111127-1111111', '이XX', 31, '남', 'K5', '010-1111-1118');
INSERT INTO Vertical VALUES('111128-1111111', '최XX', 60, '여', '투싼', '010-1111-1119');
INSERT INTO Vertical VALUES('111129-1111111', '이XX', 70, '남', '쏘나타', '010-1111-1110');
INSERT INTO Vertical VALUES('111120-1111111', '김XX', 25, '여', '에쿠스', '010-2111-1111');
INSERT INTO Vertical VALUES('111131-1111111', '최XX', 35, '남', '스포티지', '010-3111-1111');
INSERT INTO Vertical VALUES('111132-1111111', '김XX', 45, '여', 'K5', '010-4111-1111');
INSERT INTO Vertical VALUES('111133-1111111', '장XX', 55, '남', '쏘나타', '010-5111-1111');
INSERT INTO Vertical VALUES('111134-1111111', '김XX', 65, '여', '마티즈', '010-6111-1111');
INSERT INTO Vertical VALUES('111135-1111111', '양XX', 29, '남', 'K5', '010-7111-1111');
INSERT INTO Vertical VALUES('111136-1111111', '박XX', 39, '여', '마티즈', '010-8111-1111');
INSERT INTO Vertical VALUES('111137-1111111', '양XX', 49, '남', 'K5', '010-9111-1111');
INSERT INTO Vertical VALUES('111138-1111111', '박XX', 59, '여', '투싼', '010-0111-1111');
INSERT INTO Vertical VALUES('111139-1111111', '김XX', 69, '남', '스포티지', '010-1211-1111');
INSERT INTO Vertical VALUES('111130-1111111', '박XX', 26, '여', 'K5', '010-1311-1111');
