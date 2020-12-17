IF OBJECT_ID('[dsp].[ThrowFail]') IS NOT NULL
	DROP PROCEDURE [dsp].[ThrowFail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[ThrowFail]
    @ProcId INT, @Message TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>', @Param2 TSTRING = '<notset>',
    @Param3 TSTRING = '<notset>'
AS
BEGIN
    DECLARE @ExceptionId INT = dspconst.Exception_DspFailErrorId();
    THROW @ExceptionId, @Message, 1;
END;
GO
