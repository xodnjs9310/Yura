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
 SIZE = 1MB,  --���� ó�� ũ��
 MAXSIZE = 100MB,  -- ���� �ִ� ũ��
 FILEGROWTH = 1MB)  -- ���� ���� ũ��
 TO FILEGROUP fg1

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data2,
 FILENAME = 'D:\Partition\Test2.ndf',
 SIZE = 1MB,  --���� ó�� ũ��
 MAXSIZE = 100MB,  -- ���� �ִ� ũ��
 FILEGROWTH = 1MB)  -- ���� ���� ũ��
 TO FILEGROUP fg2

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data3,
 FILENAME = 'D:\Partition\Test3.ndf',
 SIZE = 1MB,  --���� ó�� ũ��
 MAXSIZE = 100MB,  -- ���� �ִ� ũ��
 FILEGROWTH = 1MB)  -- ���� ���� ũ��
 TO FILEGROUP fg3

 
ALTER DATABASE TP_Test
ADD FILE
(NAME = data4,
 FILENAME = 'D:\Partition\Test4.ndf',
 SIZE = 1MB,  --���� ó�� ũ��
 MAXSIZE = 100MB,  -- ���� �ִ� ũ��
 FILEGROWTH = 1MB)  -- ���� ���� ũ��
 TO FILEGROUP fg4


 ALTER DATABASE TP_Test  
REMOVE FILE data1 ;

 ALTER DATABASE TP_Test  
REMOVE FILEGROUP fg4 ;

--------------------------------------------------

-- PARTITION FUNCTION ����
CREATE PARTITION FUNCTION pf_AgeCheckPF(integer)
AS RANGE LEFT
FOR VALUES (29, 39, 49)
--�ش� ��Ƽ�� �Լ��� ����ϴ� ���̺��� ������ ���̺� ���� ����
DROP PARTITION FUNCTION pf_AgeCheck;

---------------------------------------------
--Partition Scheme ����
CREATE PARTITION SCHEME AgePS
AS PARTITION pf_AgeCheckPF
TO (fg1, fg2, fg3, fg4)

--�ش� ��Ƽ�� ��Ű���� ����ϴ� ���̺��� ������ ���̺� ���� ����
DROP PARTITION SCHEME AgePS;

-------------------------------------------
--��Ƽ�� ���̺� ����
CREATE TABLE TestAge(
	NAME VARCHAR(30),
	AGE INTEGER,
	GENDER VARCHAR(10)
)
ON AgePS(AGE);

INSERT INTO TestAge VALUES('��XX', 24, '��');
INSERT INTO TestAge VALUES('��XX', 30, '��');
INSERT INTO TestAge VALUES('��XX', 51, '��');
INSERT INTO TestAge VALUES('��XX', 16, '��');
INSERT INTO TestAge VALUES('��XX', 59, '��');
INSERT INTO TestAge VALUES('��XX', 43, '��');
INSERT INTO TestAge VALUES('��XX', 34, '��');
INSERT INTO TestAge VALUES('��XX', 66, '��');

SELECT * FROM TestAge;

UPDATE TestAge SET AGE = 49 WHERE NAME = '��XX';

select NAME, AGE, GENDER, $partition.pf_AgeCheckPF(AGE) FileGroup
from TestAge;

select * from TestAge where $partition.pf_AgeCheckPF(AGE) = 1;
