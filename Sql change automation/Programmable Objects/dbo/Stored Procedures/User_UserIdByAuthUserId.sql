IF OBJECT_ID('[dbo].[User_UserIdByAuthUserId]') IS NOT NULL
	DROP PROCEDURE [dbo].[User_UserIdByAuthUserId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[User_UserIdByAuthUserId]
    @AuthUserId INT, @UserId TSTRING OUT
AS
BEGIN
    SET @UserId = NULL;

    -- find the UserId from your own user table
    -- SELECT  @UserId = U.UserId FROM  dbo.Users AS U WHERE  U.AuthUserId = @AuthUserId;

    IF (@UserId IS NULL) --
        EXEC err.ThrowAuthUserNotFound @ProcId = @@PROCID, @Message = 'AuthUserId: {0}', @Param0 = @AuthUserId;
END;
GO
