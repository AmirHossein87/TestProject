IF OBJECT_ID('[dspAuth].[Role_RemoveUser]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_RemoveUser];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Role_RemoveUser]
    @RoleId INT, @UserId INT
AS
BEGIN
    -- Throw Exception if there is no record corresponding to User and Role
    IF NOT EXISTS (   SELECT    1
                        FROM    dspAuth.RoleUser AS RM
                       WHERE RM.UserId = @UserId AND RM.RoleId = @RoleId)
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = N'there is no user:{0} in Role: {1}', @Param0 = @UserId, @Param1 = @RoleId;

    -- Get RoleType
    DECLARE @RoleTypeId INT;
    EXEC dspAuth.Role_GetProps @RoleId = @RoleId, @RoleTypeId = @RoleTypeId OUTPUT;
	
    -- delete record
    DELETE  dspAuth.RoleUser
     WHERE  UserId = @UserId AND RoleId = @RoleId;
END;
GO
