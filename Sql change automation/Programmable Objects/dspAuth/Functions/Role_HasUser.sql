IF OBJECT_ID('[dspAuth].[Role_HasUser]') IS NOT NULL
	DROP FUNCTION [dspAuth].[Role_HasUser];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspAuth].[Role_HasUser] (@RoleId INT,
    @UserId INT)
RETURNS TABLE
RETURN (SELECT  ISNULL((   SELECT   1
                             FROM   dspAuth.RoleUser AS RMU
                            WHERE   RMU.RoleId = @RoleId AND RMU.UserId = @UserId), 0) AS HasMember);
GO
