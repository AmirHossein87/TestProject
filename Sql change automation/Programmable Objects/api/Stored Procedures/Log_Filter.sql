IF OBJECT_ID('[api].[Log_Filter]') IS NOT NULL
	DROP PROCEDURE [api].[Log_Filter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [api].[Log_Filter]
    @Context TCONTEXT OUTPUT, @ApplicationId INT, @CategoryId INT = NULL, @SubCategoryId BIGINT = NULL, @CustomData TJSON = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dsp.Context_Verify @Context = @Context OUT, @ProcId = @@PROCID;
    DECLARE @ContextUserId INT = dsp.Context_UserId(@Context);

    DECLARE @RecordCount INT;
    DECLARE @RecordIndex INT;
    EXEC dsp.Context_GetProps @Context = @Context OUTPUT, @RecordCount = @RecordCount OUTPUT, @RecordIndex = @RecordIndex OUTPUT;

    -- call dbo
    SELECT  LF.LogId, LF.CategoryId, LF.SubCategoryId, LF.CustomData, LF.CreatedTime
      FROM  dbo.Log_Filter(@ApplicationId, @CategoryId, @SubCategoryId, @CustomData, @RecordCount, @RecordIndex) AS LF;
END;
GO
