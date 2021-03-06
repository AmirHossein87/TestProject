IF OBJECT_ID('[dsp].[Lock_Release]') IS NOT NULL
	DROP PROCEDURE [dsp].[Lock_Release];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Lock_Release]
	@LockId TSTRING
AS
BEGIN
	-- Ignore if no lock obtained
	IF (@LockId IS NULL)
		RETURN;

	DECLARE @LockName TSTRING = JSON_VALUE(@LockId, '$.LockName');
	DECLARE @LockOwner TSTRING = JSON_VALUE(@LockId, '$.LockOwner');

	-- Don't release lock for transaction to prevent release on uncommitted lock
	IF (@LockOwner = 'Transaction')
	BEGIN
		SET @LockId = NULL;
		RETURN;
	END;

	-- Release the lock
	DECLARE @Result INT;
	EXEC @Result = sys.sp_releaseapplock @Resource = @LockName, @LockOwner = @LockOwner;

	-- throw error for error result
	IF (@Result < 0) --
		EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = N'Release AppLock Error! ErrorNumber: {0}', @Param0 = @Result;

	SET @LockId = NULL;
END;















GO
