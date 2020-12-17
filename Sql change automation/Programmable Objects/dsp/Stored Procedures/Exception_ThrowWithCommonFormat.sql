IF OBJECT_ID('[dsp].[Exception_ThrowWithCommonFormat]') IS NOT NULL
	DROP PROCEDURE [dsp].[Exception_ThrowWithCommonFormat];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Exception_ThrowWithCommonFormat]
    @ProcId INT, @ErrorMessage TJSON
AS
BEGIN
    -- Get exception from json
    DECLARE @Exception TJSON;
    DECLARE @ExceptionId INT = IIF(ISJSON(@ErrorMessage) = 1, JSON_VALUE(@ErrorMessage, '$.errorId'), NULL);

    IF (@ExceptionId IS NOT NULL)
        SET @Exception = @ErrorMessage;
    ELSE
        SET @Exception = dsp.Exception_BuildMessageParam4(@ProcId, dsperr.UnHandledExceptionId(), @ErrorMessage, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

    EXEC dsp.ThrowException @Exception = @Exception;
END;

GO
