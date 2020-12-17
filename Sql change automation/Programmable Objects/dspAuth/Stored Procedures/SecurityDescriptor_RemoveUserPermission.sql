IF OBJECT_ID('[dspAuth].[SecurityDescriptor_RemoveUserPermission]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_RemoveUserPermission];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_RemoveUserPermission]
    @SecurityDescriptorId BIGINT, @PermissionGroupId INT, @UserId INT
AS
BEGIN
	-- Check if role has not the permission on object
    IF NOT EXISTS (   SELECT    1
                        FROM    dspAuth.SecurityDescriptorUserPermission AS SDRP
                       WHERE SDRP.UserId = @UserId --
                          AND   SDRP.PermissionGroupId = @PermissionGroupId --
                          AND   SDRP.SecurityDescriptorId = @SecurityDescriptorId)
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID;

	-- Delete permission
    DELETE  dspAuth.SecurityDescriptorUserPermission
     WHERE  UserId = @UserId AND PermissionGroupId = @PermissionGroupId AND SecurityDescriptorId = @SecurityDescriptorId;
END;
GO
