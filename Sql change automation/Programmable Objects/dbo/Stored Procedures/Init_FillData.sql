IF OBJECT_ID('[dbo].[Init_FillData]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_FillData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Init_FillData]
AS
BEGIN
    SET NOCOUNT ON;

    -- Initialize UserService
    EXEC IcUserService.dsp.Init;

    -- Initialize the app 
    EXEC dsp.Setting_SetProps @AppName = 'IcLoyalty', @AppVersion = '2.0.*';

    -- Init UsersAndRoles
    IF NOT EXISTS (SELECT   1 FROM  dbo.Users AS U)
        EXEC dbo.[Init_$CreateUsersAndRoles];
END;

GO
