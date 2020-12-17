IF OBJECT_ID('[dspAuth].[Validate_CheckAccess]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Validate_CheckAccess];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspAuth].[Validate_CheckAccess]
	@ProcId INT, @Permissions TSTRING, @PermissionId INT, @ThrowIfNotAccess BIT = 1, @HasPermission BIT = NULL OUT
AS
BEGIN
	-- Prepare input
	SET @HasPermission = 0;
	SET @ThrowIfNotAccess = ISNULL(@ThrowIfNotAccess, 1);
	SET @Permissions = STUFF(@Permissions, 1, 1, ',');
	SET @Permissions = STUFF(@Permissions, LEN(@Permissions), 1, ',');
	DECLARE @PermissionTemplate TSTRING = ',' + dsp.Convert_ToString(@PermissionId) + ',';

	-- Check access
	SET @HasPermission = IIF(CHARINDEX(@PermissionTemplate, @Permissions) > 0, 1, 0);

	-- Throw exception
	IF (@HasPermission = 0 AND @ThrowIfNotAccess = 1) --
		EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @ProcId;
END;
GO
