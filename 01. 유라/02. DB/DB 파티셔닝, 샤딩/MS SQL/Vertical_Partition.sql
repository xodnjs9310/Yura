ALTER DATABASE TP_Test ADD FILEGROUP FileGroupVertical

ALTER DATABASE TP_Test
ADD FILE
(NAME = FileGroupVertical,
 FILENAME = 'D:\Partition\FileGroupVertical.ndf',
 SIZE = 1MB,  --파일 처음 크기
 MAXSIZE = 100MB,  -- 파일 최대 크기
 FILEGROWTH = 1MB)  -- 파일 증가 크기
 TO FILEGROUP FileGroupVertical

CREATE TABLE dbo.Customer
(
 Security_Number VARCHAR(20) NOT NULL,
 Name VARCHAR(100) NOT NULL,
 Age INT NOT NULL,
 Gender VARCHAR(5) NOT NULL,
 Car VARCHAR(30) NOT NULL,
 Phone VARCHAR(20) NOT NULL,

 CONSTRAINT [pk_dbo.Personnel1] PRIMARY KEY CLUSTERED (Security_Number)
)
    ON FileGroupVertical;


CREATE TABLE dbo.CustDetail
(
 Security_Number VARCHAR(20) NOT NULL,
 Name VARCHAR(100) NOT NULL,
 Age INT NOT NULL,
 Gender VARCHAR(5) NOT NULL,

 CONSTRAINT [pk_dbo.Personnel2] PRIMARY KEY CLUSTERED (Security_Number) 
)
    ON FileGroupVertical;
GO


CREATE TABLE dbo.CustMainForm
(
 Security_Number VARCHAR(20) NOT NULL,
 Car VARCHAR(30) NOT NULL,
 Phone VARCHAR(20) NOT NULL,
 CONSTRAINT [pk_dbo.PersonnelImage_dbo.PersonnelDetail_PersonnelID1] FOREIGN KEY (Security_Number) REFERENCES dbo.CustDetail (Security_Number)
)
    ON FileGroupVertical;
GO

/*
CREATE VIEW dbo.Customer_view
AS
SELECT  CD.Security_Number,
        CD.Name,
        CD.Age,
        CD.Gender,
        CF.Car,
        CF.Phone
FROM    dbo.CustDetail CD
        JOIN dbo.CustMainForm CF 
ON CD.Security_Number = CF.Security_Number;
*/

CREATE TRIGGER dbo.Personnel_i ON dbo.Customer
    INSTEAD OF INSERT
AS
	DECLARE @Security_Number VARCHAR(20);
	DECLARE @Name VARCHAR(100);
	DECLARE @Age INT;
	DECLARE @Gender VARCHAR(5);
	DECLARE @Car VARCHAR(30);
	DECLARE @Phone VARCHAR(20);
BEGIN
    SET NOCOUNT ON;
	SET @Security_Number = '';
	SET @Name = '';
	SET @Age = 0;
	SET @Gender = '';
	SET @Car = '';
	SET @Phone = '';
	
	SELECT @Security_Number=Security_Number, @Name=Name, @Age=Age, @Gender=Gender, @Car=Car, @Phone=Phone FROM inserted;
	
	INSERT INTO dbo.Customer VALUES(@Security_Number, @Name, @Age, @Gender, @Car, @Phone);
	INSERT INTO dbo.CustDetail(Security_Number, Name, Age, Gender) VALUES(@Security_Number, @Name, @Age, @Gender);
	INSERT INTO dbo.CustMainForm(Security_Number, Car, Phone) VALUES(@Security_Number, @Car, @Phone);
END
GO

CREATE TRIGGER dbo.Personnel_u ON dbo.Customer
    INSTEAD OF UPDATE
AS
	DECLARE @Security_Number VARCHAR(20);
	DECLARE @Name VARCHAR(100);
	DECLARE @Age INT;
	DECLARE @Gender VARCHAR(5);
	DECLARE @Car VARCHAR(30);
	DECLARE @Phone VARCHAR(20);
BEGIN
    SET NOCOUNT ON;
	SET @Security_Number = '';
	SET @Name = '';
	SET @Age = 0;
	SET @Gender = '';
	SET @Car = '';
	SET @Phone = '';
	
	SELECT @Security_Number=Security_Number, @Name=Name, @Age=Age, @Gender=Gender, @Car=Car, @Phone=Phone FROM inserted;
	
	UPDATE dbo.Customer SET Name=@Name, Age=@Age, Gender=@Gender, Car=@Car, Phone=@Phone WHERE Security_Number=@Security_Number;
	UPDATE dbo.CustDetail SET Name=@Name, Age=@Age, Gender=@Gender WHERE Security_Number=@Security_Number;
	UPDATE dbo.CustMainForm SET Car=@Car, Phone=@Phone WHERE Security_Number=@Security_Number;
END
GO


CREATE TRIGGER dbo.Personnel_d ON dbo.Customer
    INSTEAD OF DELETE
AS
	DECLARE @Security_Number VARCHAR(20);
BEGIN
    SET NOCOUNT ON;
	SET @Security_Number = '';
	
	SELECT @Security_Number=Security_Number FROM inserted;
	
	DELETE FROM dbo.Customer  WHERE Security_Number = @Security_Number;
	DELETE FROM dbo.CustDetail  WHERE Security_Number = @Security_Number;
	DELETE FROM dbo.CustMainForm  WHERE Security_Number = @Security_Number;

END
GO


INSERT INTO Customer VALUES('920211-114311', 'TAEWON', 26, '남', '아반떼', '010-1111-2222');

UPDATE Customer SET Name = 'JACK' WHERE Security_Number = '920211-114311';


