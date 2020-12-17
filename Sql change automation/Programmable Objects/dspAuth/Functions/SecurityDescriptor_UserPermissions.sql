IF OBJECT_ID('[dspAuth].[SecurityDescriptor_UserPermissions]') IS NOT NULL
	DROP FUNCTION [dspAuth].[SecurityDescriptor_UserPermissions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspAuth].[SecurityDescriptor_UserPermissions] (@ObjectId BIGINT,
    @ObjectTypeId INT,
    @UserId INT,
    @FilterPermissionId INT)
RETURNS TABLE
AS
RETURN (   SELECT   PGP.PermissionId
             FROM   dspAuth.SecurityDescriptor AS SD
                    CROSS APPLY dspAuth.SecurityDescriptor_Parents(SD.SecurityDescriptorId) AS SDP
                    INNER JOIN dspAuth.SecurityDescriptorRolePermission AS ACL ON ACL.SecurityDescriptorId = SDP.SecurityDescriptorId
                    INNER JOIN dspAuth.PermissionGroupPermission AS PGP ON PGP.PermissionGroupId = ACL.PermissionGroupId
                    CROSS APPLY dspAuth.Role_HasUser(ACL.RoleId, @UserId) AS RHM
            WHERE   SD.ObjectId = @ObjectId --
               AND  SD.ObjectTypeId = @ObjectTypeId --               
               AND  RHM.HasMember = 1 --
               AND  (@FilterPermissionId IS NULL OR PGP.PermissionId = @FilterPermissionId)
           UNION
           SELECT   PGP.PermissionId
             FROM   dspAuth.SecurityDescriptor AS SD
                    CROSS APPLY dspAuth.SecurityDescriptor_Parents(SD.SecurityDescriptorId) AS SDP
                    INNER JOIN dspAuth.SecurityDescriptorUserPermission AS ACL ON ACL.SecurityDescriptorId = SDP.SecurityDescriptorId
                    INNER JOIN dspAuth.PermissionGroupPermission AS PGP ON PGP.PermissionGroupId = ACL.PermissionGroupId
            WHERE   SD.ObjectId = @ObjectId --
               AND  SD.ObjectTypeId = @ObjectTypeId --
               AND  ACL.UserId = @UserId --
               AND  (@FilterPermissionId IS NULL OR PGP.PermissionId = @FilterPermissionId)
            GROUP BY PGP.PermissionId);



GO
