/**********************************************************************************
-- 구    분 : 부서 정보_DPTINF
-- 작 성 일 : 2020-03-26
-- 작 성 자 : 윤태원
-- 설    명 :
-- EXEC Util_Query_Maker DPTINF
**********************************************************************************/

IF OBJECT_ID('dbo.DPTINF', 'U') IS NOT NULL
DROP TABLE dbo.DPTINF
GO

CREATE TABLE dbo.DPTINF
(
    DPTCD     VARCHAR(5) NOT NULL,                       -- 부서 코드
    CSTNM     VARCHAR(50) NULL,                          -- 부서명
    CSTNM_L  NVARCHAR(50) NULL,                          -- 부서명(LC)
    REGID      CHAR(10) NULL,                            -- 등록자
    REGDT     SMALLDATETIME NOT NULL DEFAULT GETDATE()   -- 등록일

    CONSTRAINT PK_DPTINF PRIMARY KEY NONCLUSTERED (DPTCD)
);
GO