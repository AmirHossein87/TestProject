IF OBJECT_ID('[dspAuth].[SecurityDescriptor_AddRolePermission]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_AddRolePermission];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_AddRolePermission]
    @AuditUserId INT, @SecurityDescriptorId BIGINT, @PermissionGroupId INT, @RoleId INT
AS
BEGIN
    BEGIN TRY		
        INSERT  dspAuth.SecurityDescriptorRolePermission (SecurityDescriptorId, RoleId, PermissionGroupId, AuditUserId)
        VALUES (@SecurityDescriptorId, @RoleId, @PermissionGroupId, @AuditUserId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627) -- duplicate key error
            EXEC dsperr.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = N'SecurityDescriptor: {0}, RoleId {1}, PermissionGroupId: {2}',
                @Param0 = @SecurityDescriptorId, @Param1 = @RoleId, @Param2 = @PermissionGroupId;
        THROW;
    END CATCH;
END;
GO
