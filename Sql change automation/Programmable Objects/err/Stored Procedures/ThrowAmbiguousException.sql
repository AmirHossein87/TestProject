IF OBJECT_ID('[err].[ThrowAmbiguousException]') IS NOT NULL
	DROP PROCEDURE [err].[ThrowAmbiguousException];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [err].[ThrowAmbiguousException] @ProcId INT, @Message TSTRING = NULL, @Param0 TSTRING = '<notset>', @Param1 TSTRING = '<notset>', @Param2 TSTRING = '<notset>', @Param3 TSTRING = '<notset>'
AS
BEGIN
    DECLARE @ExceptionId INT = err.AmbiguousExceptionId();
    EXEC dsp.ThrowAppException @ProcId = @ProcId, @ExceptionId = @ExceptionId, @Message = @Message, @Param0 = @Param0, @Param1 = @Param1,
        @Param2 = @Param2, @Param3 = @Param3;
END
GO
