IF OBJECT_ID('[dsperr].[ThrowFatalError]') IS NOT NULL
	DROP PROCEDURE [dsperr].[ThrowFatalError];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsperr].[ThrowFatalError] @ProcId INT, @Message TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>', @Param2 TSTRING = '<notset>', @Param3 TSTRING = '<notset>'
AS
BEGIN
    DECLARE @ExceptionId INT = dsperr.FatalErrorId();
    EXEC dsp.ThrowAppException @ProcId = @ProcId, @ExceptionId = @ExceptionId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1,
        @Param2 = @Param2, @Param3 = @Param3;
END
GO
