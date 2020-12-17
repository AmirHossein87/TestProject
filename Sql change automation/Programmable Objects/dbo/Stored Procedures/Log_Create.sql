IF OBJECT_ID('[dbo].[Log_Create]') IS NOT NULL
	DROP PROCEDURE [dbo].[Log_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Log_Create]
    @AuditUserId INT, @ApplicationId INT, @CategoryId INT = NULL, @SubCategoryId BIGINT = NULL, @CustomData TJSON = NULL, @LogId BIGINT = NULL OUTPUT
AS
BEGIN
    IF (@ApplicationId IS NULL) --
        EXEC err.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ApplicationId is null';

    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    dbo.Application AS A
                       WHERE A.ApplicationId = @ApplicationId) --
        EXEC err.ThrowInvalidArgument @ProcId = @@PROCID, @Message = 'ApplicationId is an invalid value';

    INSERT INTO dbo.Logs (ApplicationId, CategoryId, SubCategoryId, CustomData, CreatedByUserId, CreatedTime)
    VALUES (@ApplicationId, @CategoryId, @SubCategoryId, @CustomData, @AuditUserId, GETDATE());

    SET @LogId = SCOPE_IDENTITY();

END;
GO
