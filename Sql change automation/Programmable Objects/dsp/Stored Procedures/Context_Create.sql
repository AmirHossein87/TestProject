IF OBJECT_ID('[dsp].[Context_Create]') IS NOT NULL
	DROP PROCEDURE [dsp].[Context_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [dsp].[Context_Create]
	@UserId TSTRING, @IsCaptcha INT = 0, @Context TCONTEXT = NULL OUT
AS
BEGIN
	DECLARE @AppName TSTRING;
	DECLARE @AppVersion TSTRING;
	EXEC dsp.Setting_GetProps @AppName = @AppName OUTPUT, @AppVersion = @AppVersion OUTPUT;

	SET @Context = NULL;
	EXEC dsp.Context_SetProps @Context = @Context OUTPUT, @UserId = @UserId, @AppName = @AppName, @AppVersion = @AppVersion, @IsCaptcha = @IsCaptcha;
END;




GO
