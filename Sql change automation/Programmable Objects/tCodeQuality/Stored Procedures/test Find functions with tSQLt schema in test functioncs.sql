IF OBJECT_ID('[tCodeQuality].[test Find functions with tSQLt schema in test functioncs]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Find functions with tSQLt schema in test functioncs];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [tCodeQuality].[test Find functions with tSQLt schema in test functioncs]
AS
BEGIN
    --------------------------------
    -- Checking: InvalidOperation exception is expected when we have a function with one of "tSQLt" schema objects and code quality method does not return function name
    --------------------------------
    EXEC dsp.Log_Trace @ProcId = @@PROCID,
        @Message = 'Checking 1: InvalidOperation exception is expected when we have a function with one of "tSQLt" schema objects and code quality method does not return function name';

    SAVE TRANSACTION Test;

    EXEC ('CREATE OR ALTER PROCEDURE tRequest.TestProcedure
	AS
	BEGIN
	EXEC tSQLt.AssertEquals @Expected = 1, @Actual = NULL	
	END');

    DECLARE @FunctionNames TSTRING = dsptest.Database_FindFunctionsWithTSQLTSchemaInTestFunctioncs();

    IF (@FunctionNames IS NULL OR   CHARINDEX('[tRequest].[TestProcedure]', @FunctionNames) = 0)
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Method does not return true function names';

    ROLLBACK TRANSACTION Test;
END;
GO
