IF OBJECT_ID('[dspAuth].[Role_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Role_GetProps]
    @RoleId INT, @OwnerSecurityDescriptorId BIGINT = NULL OUT, @RoleName TSTRING = NULL OUT, @RoleTypeId INT = NULL OUT
AS
BEGIN
    SELECT  @RoleName = R.RoleName, @OwnerSecurityDescriptorId = R.OwnerSecurityDescriptorId, @RoleTypeId = R.RoleTypeId
      FROM  dspAuth.Role AS R
     WHERE  R.RoleId = @RoleId;

    IF (@OwnerSecurityDescriptorId IS NULL) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = 'RoleId: {0}', @Param0 = @RoleId;
END;
GO
