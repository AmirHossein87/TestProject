IF OBJECT_ID('[dsp].[Context_Verify]') IS NOT NULL
	DROP PROCEDURE [dsp].[Context_Verify];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Context_Verify]
	@Context TCONTEXT OUT, @ProcId INT
AS
BEGIN
	-- Settings
	DECLARE @AppName TSTRING;
	DECLARE @AppVersion TSTRING;
	DECLARE @AppUserId TSTRING;
	DECLARE @SystemUserId TSTRING;
	DECLARE @MaintenanceMode INT;
	EXEC dsp.Setting_GetProps @AppVersion = @AppVersion OUT, @AppName = @AppName OUT, @AppUserId = @AppUserId OUT, @SystemUserId = @SystemUserId OUT,
		@MaintenanceMode = @MaintenanceMode OUT;

	-- Set SystemContext
	IF (@Context = N'$') EXEC dsp.Context_CreateSystem @SystemContext = @Context OUTPUT;
	IF (@Context = N'$$') EXEC dsp.Context_Create @UserId = '$$', @Context = @Context OUT, @IsCaptcha = 1;

	-- Context 
	DECLARE @ContextAuthUserId TSTRING;
	DECLARE @ContextAppName TSTRING;
	DECLARE @ContextUserId TSTRING;
	DECLARE @ContextInvokerAppVersion TSTRING;
	DECLARE @IsReadonlyIntent BIT;
	DECLARE @IsInvokedByMidware BIT;
	EXEC dsp.Context_GetProps @Context = @Context OUTPUT, @AuthUserId = @ContextAuthUserId OUTPUT, @UserId = @ContextUserId OUTPUT,
		@AppName = @ContextAppName OUTPUT, @InvokerAppVersion = @ContextInvokerAppVersion OUT, @IsReadonlyIntent = @IsReadonlyIntent OUT,
		@IsInvokedByMidware = @IsInvokedByMidware OUT;
	DECLARE @ContextUserIdOrg TSTRING = @ContextUserId;

	-- Check MaintenanceMode
	IF (@IsInvokedByMidware = 1)
	BEGIN
		IF (@MaintenanceMode = 2) --
			EXEC dsperr.ThrowMaintenance @ProcId = @@PROCID, @Message = 'Maintenance';

		IF (@IsReadonlyIntent = 0 AND	(@MaintenanceMode = 1 OR dsp.Database_IsReadOnly(DB_NAME()) = 1))
			EXEC dsperr.ThrowMaintenanceReadOnly @ProcId = @@PROCID, @Message = 'MaintenanceReadOnly';
	END;

	-- Validate AppName
	IF (@ContextAppName IS NULL OR @ContextAppName <> @AppName) --
		EXEC dsp.ThrowGeneralException @ProcId = @ProcId, @Message = N'the app property of context is not valid! AppName: {0}; ContextAppName: {1}',
			@Param0 = @AppName, @Param1 = @ContextAppName;

	-- Check InvokerAppVersion if set
	IF (@ContextInvokerAppVersion IS NOT NULL AND	@ContextInvokerAppVersion <> @AppVersion)
		EXEC dsperr.ThrowInvokerAppVersion @ProcId = @ProcId;

	-------------
	-- Fin UserId for System Accounts
	-------------
	IF (@ContextUserId = N'$$')
		SET @ContextUserId = ISNULL(@AppUserId, N'$');

	IF (@ContextUserId = N'$')
	BEGIN
		SET @ContextUserId = @SystemUserId;
		IF (@ContextUserId IS NULL) --
			EXEC dsp.ThrowGeneralException @ProcId = @ProcId, @Message = 'SystemUserId has not been initailized';
	END;

	-- Find UserId by AuthUserId
	IF (@ContextUserId IS NULL) --
	BEGIN
		IF (@ContextAuthUserId = '$$')
			SET @ContextUserId = ISNULL(@AppUserId, @SystemUserId);
		ELSE
			EXEC dbo.User_UserIdByAuthUserId @AuthUserId = @ContextAuthUserId, @UserId = @ContextUserId OUT;
	END;

	-------------
	-- Update Context if user context
	-------------
	IF (@ContextUserIdOrg IS NULL OR @ContextUserIdOrg <> @ContextUserId) --
		EXEC dsp.Context_SetProps @Context = @Context OUTPUT, @UserId = @ContextUserId, @AppVersion = @AppVersion;

END;

GO
