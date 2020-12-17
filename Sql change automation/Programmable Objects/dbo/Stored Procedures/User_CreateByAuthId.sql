IF OBJECT_ID('[dbo].[User_CreateByAuthId]') IS NOT NULL
	DROP PROCEDURE [dbo].[User_CreateByAuthId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[User_CreateByAuthId]
    @AuditUserId INT, @AuthUserId INT, @UserId INT = NULL OUT
AS
BEGIN
    -- Only the user System can have AuditUserId with null value 
    IF (@AuditUserId IS NULL AND EXISTS (SELECT 1 FROM  dbo.Users)) --
        EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = 'AuditUserId can not be NULL if table has some records';

    DECLARE @ObjectTypeId INT = dspAuth.ObjectType_User();    

    BEGIN TRY
        INSERT  dbo.Users (AuthUserId, IsEnabled, ModifiedByUserId)
        VALUES (@AuthUserId, 1, @AuditUserId);
        SET @UserId = SCOPE_IDENTITY();        
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2601) -- SQL Duplicate Key
        BEGIN
            DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
            EXEC dsperr.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = @ErrorMessage;
        END;
        THROW;
    END CATCH;
END;
GO
