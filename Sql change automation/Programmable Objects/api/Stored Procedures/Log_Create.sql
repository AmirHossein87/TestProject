IF OBJECT_ID('[api].[Log_Create]') IS NOT NULL
	DROP PROCEDURE [api].[Log_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [api].[Log_Create]
    @Context TCONTEXT OUTPUT, @ApplicationId INT, @CategoryId INT = NULL, @SubCategoryId BIGINT = NULL, @CustomData TJSON = NULL, @LogId BIGINT = NULL OUTPUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dsp.Context_Verify @Context = @Context OUT, @ProcId = @@PROCID;
    DECLARE @ContextUserId INT = dsp.Context_UserId(@Context);

    -- call dbo
    EXEC dbo.Log_Create @AuditUserId = @ContextUserId, @ApplicationId = @ApplicationId, @CategoryId = @CategoryId, @SubCategoryId = @SubCategoryId,
        @CustomData = @CustomData, @LogId = @LogId OUTPUT;
END;
GO
