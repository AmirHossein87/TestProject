IF OBJECT_ID('[dspAuth].[SecurityDescriptor_RemoveRolePermission]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_RemoveRolePermission];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_RemoveRolePermission]
    @SecurityDescriptorId BIGINT, @PermissionGroupId INT, @RoleId INT
AS
BEGIN
	-- Check if role has not the permission on object
    IF NOT EXISTS (   SELECT    1
                        FROM    dspAuth.SecurityDescriptorRolePermission AS SDRP
                       WHERE SDRP.RoleId = @RoleId --
                          AND   SDRP.PermissionGroupId = @PermissionGroupId --
                          AND   SDRP.SecurityDescriptorId = @SecurityDescriptorId)
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID;

	-- Delete permission
    DELETE  dspAuth.SecurityDescriptorRolePermission
     WHERE  RoleId = @RoleId AND PermissionGroupId = @PermissionGroupId AND SecurityDescriptorId = @SecurityDescriptorId;
END;
GO
