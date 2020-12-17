IF OBJECT_ID('[dspAuth].[Role_AddUser]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_AddUser];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dspAuth].[Role_AddUser]
    @AuditUserId INT, @RoleId INT, @UserId INT
AS
BEGIN
    BEGIN TRY
        INSERT  dspAuth.RoleUser (RoleId, UserId, ModifiedByUserId)
        VALUES (@RoleId, @UserId, @AuditUserId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627) -- duplicate key error
            EXEC dsperr.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = N'UserId: {0}', @Param0 = @UserId;
        THROW;
    END CATCH;
END;
GO
