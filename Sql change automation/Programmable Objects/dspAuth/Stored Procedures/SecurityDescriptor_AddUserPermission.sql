IF OBJECT_ID('[dspAuth].[SecurityDescriptor_AddUserPermission]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_AddUserPermission];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_AddUserPermission]
    @SecurityDescriptorId BIGINT, @PermissionGroupId INT, @UserId INT, @AuditUserId INT
AS
BEGIN
    INSERT  dspAuth.SecurityDescriptorUserPermission (SecurityDescriptorId, UserId, PermissionGroupId, CreatedByUserId)
    VALUES (@SecurityDescriptorId, @UserId, @PermissionGroupId, @AuditUserId);
END;

GO
