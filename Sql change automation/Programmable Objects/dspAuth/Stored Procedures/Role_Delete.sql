IF OBJECT_ID('[dspAuth].[Role_Delete]') IS NOT NULL
	DROP PROCEDURE [dspAuth].[Role_Delete];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dspAuth].[Role_Delete]
	@AuditUserId INT, @RoleId INT
AS
BEGIN
	-- Checking if there is a role with RoleId: @RoleId
	EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Checking if there is a role with RoleId: {0}', @Param0 = @RoleId;
	DECLARE @ActualRoleId INT;
	SELECT	@ActualRoleId = R.RoleId
	FROM dspAuth.Role AS R
	WHERE	R.RoleId = @RoleId;

	IF (@ActualRoleId IS NULL) --
		EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = N'There is no Role with RoleId: {0}', @Param0 = @RoleId;

	DECLARE @TranCount INT = @@TRANCOUNT;
	IF (@TranCount = 0)
		BEGIN TRANSACTION;
	BEGIN TRY
		-- Updating Role before deleting it
		EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Updating Role before deleting it';
		UPDATE	dspAuth.Role
		SET ModifiedByUserId = @AuditUserId
		WHERE	RoleId = @RoleId;

		-- Deleting with RoleId: @RoleId
		EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Deleting with RoleId: {0}', @Param0 = @RoleId;
		DELETE dspAuth.Role
		WHERE	RoleId = @RoleId;

		IF (@TranCount = 0) COMMIT;
	END TRY
	BEGIN CATCH
		IF (@TranCount = 0)
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;


GO
