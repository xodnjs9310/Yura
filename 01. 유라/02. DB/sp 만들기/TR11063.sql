IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'TR11063'
)
DROP PROCEDURE dbo.TR11063
GO
/**********************************************************************************
-- 구    분 : [11060] 부서 정보
-- 작 성 일 : 2020-03-26
-- 작 성 자 : 윤태원
-- 설    명 :
-----------------------------------------------------------------------------------
-- 수 정 일     작성자      수정내용
-----------------------------------------------------------------------------------
--
**********************************************************************************/
CREATE PROCEDURE [dbo].[TR11063]
    @DPTCD VARCHAR(5),      -- 부서코드
    @CSTNM VARCHAR(50),     -- 부서명
    @CSTNM_L NVARCHAR(50),  -- 부서명(LC)
    @REGID CHAR(10)         -- 등록자
AS
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    UPDATE DPTINF SET CSTNM = @CSTNM, CSTNM_L = @CSTNM_L, REGID = @REGID, REGDT = GETDATE()
    FROM DPTINF
    WHERE DPTCD = @DPTCD

    IF @@ROWCOUNT = 0 BEGIN
        THROW 52003, '52003수정할 내용이 없거나 수정작업 중 오류가 발생했습니다.', 1;
        RETURN
    END

    SET NOCOUNT OFF;
GO
