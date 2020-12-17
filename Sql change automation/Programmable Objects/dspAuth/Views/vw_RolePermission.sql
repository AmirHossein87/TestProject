IF OBJECT_ID('[dspAuth].[vw_RolePermission]') IS NOT NULL
	DROP VIEW [dspAuth].[vw_RolePermission];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dspAuth].[vw_RolePermission]
AS
SELECT  P.PermissionId, P.PermissionName, R.RoleId, R.RoleName, PG.PermissionGroupId, PG.PermissionGroupName, SD.SecurityDescriptorId, SD.ObjectTypeId,
    SD.ObjectId, ROSD.SecurityDescriptorId AS RoleOwnerSecurityDescriptorId, ROSD.ObjectTypeId AS RoleOwnerObjectTypeId, ROSD.ObjectId AS RoleOwnerObjectId
  FROM  dspAuth.Role AS R
        LEFT JOIN dspAuth.SecurityDescriptor AS ROSD ON ROSD.SecurityDescriptorId = R.OwnerSecurityDescriptorId
        LEFT JOIN dspAuth.SecurityDescriptorRolePermission AS SDRP ON SDRP.RoleId = R.RoleId
        LEFT JOIN dspAuth.SecurityDescriptor AS SD ON SD.SecurityDescriptorId = SDRP.SecurityDescriptorId
        LEFT JOIN dspAuth.PermissionGroup AS PG ON PG.PermissionGroupId = SDRP.PermissionGroupId
        LEFT JOIN dspAuth.PermissionGroupPermission AS PGP ON PGP.PermissionGroupId = PG.PermissionGroupId
        LEFT JOIN dspAuth.Permission AS P ON P.PermissionId = PGP.PermissionId;





GO
