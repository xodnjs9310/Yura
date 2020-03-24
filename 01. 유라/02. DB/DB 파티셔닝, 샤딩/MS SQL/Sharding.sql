ALTER DATABASE Shard_1 ADD FILEGROUP Shard_1_FileGroup;

ALTER DATABASE Shard_1
ADD FILE
(NAME = Shard_1_Name,
 FILENAME = 'D:\Database\FileGroup\Shard_1.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP Shard_1_FileGroup;

CREATE TABLE Shard_1
(
 Name VARCHAR(100) NOT NULL,
 Age INT NOT NULL,
 Gender VARCHAR(5) NOT NULL
)
    ON Shard_1_FileGroup;


	
CREATE TRIGGER Shard_1_Trigger ON Shard_1
    INSTEAD OF INSERT
AS
	DECLARE @Name VARCHAR(100);
	DECLARE @Age INT;
	DECLARE @Gender VARCHAR(5);
BEGIN
    SET NOCOUNT ON;
	SET @Name = '';
	SET @Age = 0;
	SET @Gender = '';
	
	SELECT  @Name=Name, @Age=Age, @Gender=Gender FROM inserted;

	IF (@Age < 30) 
		INSERT INTO dbo.Shard_1 VALUES( @Name, @Age, @Gender);
	ELSE IF (@Age >= 30 AND @Age < 40)
		INSERT INTO Shard_2.dbo.Shard_2 VALUES( @Name, @Age, @Gender);
	ELSE IF (@Age >= 40 AND @Age < 50)
		INSERT INTO Shard_3.dbo.Shard_3 VALUES( @Name, @Age, @Gender);
	ELSE
		INSERT INTO Shard_4.dbo.Shard_4 VALUES( @Name, @Age, @Gender);
	 
END
GO


INSERT INTO Shard_1 VALUES('김XX', 51, '남');

SELECT * FROM Shard_1;
SELECT * FROM Shard_2.dbo.Shard_2;
SELECT * FROM Shard_3.dbo.Shard_3;
SELECT * FROM Shard_4.dbo.Shard_4;
