IF OBJECT_ID('[tCodeQuality].[test Find functions with dsptest schema which not in test Functioncs]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Find functions with dsptest schema which not in test Functioncs];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [tCodeQuality].[test Find functions with dsptest schema which not in test Functioncs]
AS
BEGIN
    --------------------------------
    -- Checking: InvalidOperation exception is expected when we have a function with one of "dspTest" schema object and code quality method does not return function name
    --------------------------------
    EXEC dsp.Log_Trace @ProcId = @@PROCID,
        @Message = 'Checking 1: InvalidOperation exception is expected when we have a function with one of "dspTest" schema object and code quality method does not return function name';

    SAVE TRANSACTION Test;

    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure
	AS
	BEGIN
	EXEC dsptest.AssertEquals @Expected = 1, @Actual = NULL	
	END');

    DECLARE @FunctionNames TSTRING = dsptest.Database_FindFunctionsWithDspTestSchemaWhichNotInTestFunctioncs();

    IF (@FunctionNames IS NULL OR  CHARINDEX('ALTER PROCEDURE [dbo].[TestProcedure]', @FunctionNames) = 0)
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'method does not return true function names';

    ROLLBACK TRANSACTION Test;
END;
GO
