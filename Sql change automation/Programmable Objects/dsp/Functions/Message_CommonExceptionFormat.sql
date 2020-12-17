IF OBJECT_ID('[dsp].[Message_CommonExceptionFormat]') IS NOT NULL
	DROP FUNCTION [dsp].[Message_CommonExceptionFormat];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Message_CommonExceptionFormat] (@ProcId INT,
    @Message TSTRING)
RETURNS TJSON
AS
BEGIN
    DECLARE @Exception TJSON;
    DECLARE @ExceptionId INT = IIF(ISJSON(@Message) = 1, JSON_VALUE(@Message, '$.errorId'), NULL);

    IF (@ExceptionId IS NOT NULL)
        SET @Exception = @Message;
    ELSE
        SET @Exception = dsp.Exception_BuildMessageParam4(@ProcId, dsperr.UnHandledExceptionId(), @Message, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

    RETURN @Exception;
END;
GO
