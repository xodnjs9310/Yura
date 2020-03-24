USE TP_Test
GO
ALTER DATABASE TP_Test ADD FILEGROUP fg1
ALTER DATABASE TP_Test ADD FILEGROUP fg2
ALTER DATABASE TP_Test ADD FILEGROUP fg3
ALTER DATABASE TP_Test ADD FILEGROUP fg4

ALTER DATABASE TP_Test
ADD FILE
(NAME = data1,
 FILENAME = 'D:\Partition\Test1.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP fg1

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data2,
 FILENAME = 'D:\Partition\Test2.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP fg2

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data3,
 FILENAME = 'D:\Partition\Test3.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP fg3

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data4,
 FILENAME = 'D:\Partition\Test4.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP fg4


 ALTER DATABASE TP_Test  
REMOVE FILE data1 ;

 ALTER DATABASE TP_Test  
REMOVE FILEGROUP fg4 ;

--------------------------------------------------

-- PARTITION FUNCTION 생성
CREATE PARTITION FUNCTION pf_AgeCheckPF(integer)
AS RANGE LEFT
FOR VALUES (29, 39, 49)
--해당 파티션 함수를 사용하는 테이블이 있으면 테이블 먼저 삭제
DROP PARTITION FUNCTION pf_AgeCheck;

---------------------------------------------
--Partition Scheme 생성
CREATE PARTITION SCHEME AgePS
AS PARTITION pf_AgeCheckPF
TO (fg1, fg2, fg3, fg4)

--해당 파티션 스키마를 사용하는 테이블이 있으면 테이블 먼저 삭제
DROP PARTITION SCHEME AgePS;

-------------------------------------------
--파티션 테이블 생성
CREATE TABLE TestAge(
	NAME VARCHAR(30),
	AGE INTEGER,
	GENDER VARCHAR(10)
)
ON AgePS(AGE);

INSERT INTO TestAge VALUES('김XX', 24, '여');
INSERT INTO TestAge VALUES('박XX', 30, '남');
INSERT INTO TestAge VALUES('윤XX', 51, '남');
INSERT INTO TestAge VALUES('양XX', 16, '여');
INSERT INTO TestAge VALUES('구XX', 59, '여');
INSERT INTO TestAge VALUES('이XX', 43, '여');
INSERT INTO TestAge VALUES('김XX', 34, '남');
INSERT INTO TestAge VALUES('지XX', 66, '남');

SELECT * FROM TestAge;

UPDATE TestAge SET AGE = 49 WHERE NAME = '지XX';

select NAME, AGE, GENDER, $partition.pf_AgeCheckPF(AGE) FileGroup
from TestAge;

select * from TestAge where $partition.pf_AgeCheckPF(AGE) = 1;
