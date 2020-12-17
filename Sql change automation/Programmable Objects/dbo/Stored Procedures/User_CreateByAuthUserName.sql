IF OBJECT_ID('[dbo].[User_CreateByAuthUserName]') IS NOT NULL
	DROP PROCEDURE [dbo].[User_CreateByAuthUserName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[User_CreateByAuthUserName]
	@AuditUserId INT, @UserName TSTRING, @UserId INT = NULL OUTPUT
AS
BEGIN
	--ToDo Transaction
	DECLARE @Log_AppUserContext TCONTEXT = '$$';

	-- Get User from IcUserService by Username
	DECLARE @AuthUserId INT;
	EXEC IcUserService.api.User_GetIdByUserName @Context = @Log_AppUserContext OUT, @UserName = @UserName, @UserId = @AuthUserId OUTPUT;
	
	-- Add created User to IcLoyalty
	EXEC dbo.User_CreateByAuthId @AuthUserId = @AuthUserId, @AuditUserId = @AuditUserId, @UserId = @UserId OUT;	
END;

GO
