IF OBJECT_ID('[dbo].[Init_$CreateUsersAndRoles]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_$CreateUsersAndRoles];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Init_$CreateUsersAndRoles]
AS
BEGIN
    SET NOCOUNT ON;

    -- Creating Loyalty_System User; We need to assign system role later after creationg the system club 
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Creating the System User';
    DECLARE @UserId_Admin INT;
	EXEC dbo.User_CreateByAuthUserName @UserName = 'Log_Admin', @AuditUserId = NULL, @UserId = @UserId_Admin OUT;	
    EXEC dsp.Setting_SetProps @SystemUserId = @UserId_Admin;

    -- Creating the App User
    --EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Creating the App User';
    --DECLARE @UserName_AppUser TSTRING = const.UserName_App();
    --DECLARE @UserId_AppUser INT;
	
    --EXEC dbo.User_CreateByAuthUserName @UserName = @UserName_System, @AuditUserId = NULL, @UserId = @UserId_System OUT;
	
    --SET @UserId_AppUser = SCOPE_IDENTITY();
    --EXEC dsp.Setting_SetProps @AppUserId = @UserId_AppUser;

END;


GO
