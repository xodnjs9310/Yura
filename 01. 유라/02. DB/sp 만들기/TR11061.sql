IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'TR11061'
)
DROP PROCEDURE dbo.TR11061
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
CREATE PROCEDURE [dbo].[TR11061]
    @DPTCD      VARCHAR(5),         -- 부서 코드
    @LANG       VARCHAR(1)          -- 언어:0(KO), 1(현지어)
AS
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    SELECT A.DPTCD, A.CSTNM, A.CSTNM_L,
        CASE WHEN @LANG = 0 THEN A.CSTNM ELSE ISNULL(A.CSTNM_L, A.CSTNM) END
    FROM DPTINF A
    WHERE A.DPTCD LIKE RTRIM(@DPTCD) + '%'

    IF @@ROWCOUNT = 0 BEGIN
        THROW 52001, '52001데이타가 존재하지 않습니다.', 1;
        RETURN
    END

    SET NOCOUNT OFF;
GO
