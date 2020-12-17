IF OBJECT_ID('[dspAuth].[Init_Cleanup]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Init_Cleanup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspAuth].[Init_Cleanup]
AS
BEGIN
    SET NOCOUNT ON;
	
    -- Protect production environment
    EXEC dsp.Util_ProtectProductionEnvironment;

    DELETE  dspAuth.SecurityDescriptorUserPermission;
    DELETE  dspAuth.SecurityDescriptorRolePermission;
    DELETE  dspAuth.PermissionGroupPermission;
    DELETE  dspAuth.PermissionGroup;
    DELETE  dspAuth.Permission;
    DELETE  dspAuth.Role;
    DELETE  dspAuth.SecurityDescriptorParent;
    DELETE  dspAuth.SecurityDescriptor;
    DELETE  dspAuth.ObjectType;
    
	DBCC CHECKIDENT('dspAuth.SecurityDescriptor', RESEED, 10000000000);

END;

GO
