IF OBJECT_ID('[dsp].[Exception_BuildMessage]') IS NOT NULL
	DROP FUNCTION [dsp].[Exception_BuildMessage];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Exception_BuildMessage] (@ProcId INT,
	@ExceptionId INT,
	@Message TSTRING = NULL)
RETURNS TJSON
AS
BEGIN
	RETURN	dsp.Exception_BuildMessageParam4(@ProcId, @ExceptionId, @Message, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
END;
GO
