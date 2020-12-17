IF OBJECT_ID('[dsp].[Util_VerifyServerName]') IS NOT NULL
	DROP PROCEDURE [dsp].[Util_VerifyServerName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Util_VerifyServerName]
	@ConfirmServerName TSTRING
AS
BEGIN
	DECLARE @ServerName TSTRING = @@SERVERNAME;
	IF (@ConfirmServerName IS NULL OR	LOWER(@ConfirmServerName) != LOWER(@@SERVERNAME))
		EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = N'ConfirmServerName must be set to ''{0}''!',
			@Param0 = @ServerName;
END;
GO
