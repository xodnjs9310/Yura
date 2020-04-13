IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'TR11064'
)
DROP PROCEDURE dbo.TR11064
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
CREATE PROCEDURE [dbo].[TR11064]
    @DPTCD VARCHAR(5)      -- 부서코드
AS
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    DELETE FROM DPTINF
    WHERE DPTCD = @DPTCD

    IF @@ROWCOUNT = 0 BEGIN
        THROW 52004, '52004삭제할 내용이 없거나 삭제작업 중 오류가 발생했습니다.', 1;
        RETURN
    END

    SET NOCOUNT OFF;
GO
