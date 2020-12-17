IF OBJECT_ID('[dspAuth].[SecurityDescriptor_UserPermissionObject]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[SecurityDescriptor_UserPermissionObject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[SecurityDescriptor_UserPermissionObject]
    @ObjectId BIGINT, @ObjectTypeId INT, @UserId INT, @ThrowIfNotExists BIT = 1, @Permissions TSTRING = NULL OUT
AS
BEGIN
    SET @ThrowIfNotExists = ISNULL(@ThrowIfNotExists, 1);

    SET @Permissions = CONCAT('[', (   SELECT   STRING_AGG(dsp.Convert_ToString(SDUPF.PermissionId), ',')
                                         FROM   dspAuth.SecurityDescriptor_UserPermissions(@ObjectId, @ObjectTypeId, @UserId, NULL) AS SDUPF ), ']');

    IF (@Permissions IS NULL AND @ThrowIfNotExists = 1) --	
        EXEC dsp.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @ObjectTypeName = 'Permissions', @ObjectId = @Permissions;

END;

GO
