IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'TR11062'
)
DROP PROCEDURE dbo.TR11062
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
CREATE PROCEDURE [dbo].[TR11062]
    @DPTCD VARCHAR(5),      -- 부서코드
    @CSTNM VARCHAR(50),     -- 부서명
    @CSTNM_L NVARCHAR(50),  -- 부서명(LC)
    @REGID CHAR(10)         -- 등록자
AS
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    -- 중복 체크
    IF EXISTS(
        SELECT 1
        FROM DPTINF
        WHERE DPTCD = @DPTCD
    ) BEGIN
        THROW 52009, '52009이미 등록되어 있습니다.', 1;
        RETURN
    END
    
    INSERT DPTINF (DPTCD, CSTNM, CSTNM_L, REGID) 
    VALUES (@DPTCD, @CSTNM, @CSTNM_L, @REGID)

    IF @@ERROR <> 0 BEGIN
        THROW 52002, '52002입력 중 에러가 발생했습니다.', 1;
        RETURN
    END

    SET NOCOUNT OFF;
GO