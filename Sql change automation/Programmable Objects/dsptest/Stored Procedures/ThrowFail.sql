IF OBJECT_ID('[dsptest].[ThrowFail]') IS NOT NULL
	DROP PROCEDURE [dsptest].[ThrowFail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsptest].[ThrowFail]
    @ProcId INT, @Message TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>', @Param2 TSTRING = '<notset>',
    @Param3 TSTRING = '<notset>'
AS
BEGIN
    DECLARE @ExceptionId INT = dspconst.Exception_DspFailErrorId();
	IF (dsp.Param_IsSetString(@Param0) = 1) --
		SET @Message = REPLACE(@Message, '{0}', @Param0);

    THROW @ExceptionId, @Message, 1;

END;
GO
