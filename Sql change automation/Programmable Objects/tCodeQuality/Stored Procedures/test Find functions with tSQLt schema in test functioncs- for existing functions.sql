IF OBJECT_ID('[tCodeQuality].[test Find functions with tSQLt schema in test functioncs- for existing functions]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Find functions with tSQLt schema in test functioncs- for existing functions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [tCodeQuality].[test Find functions with tSQLt schema in test functioncs- for existing functions]
AS
BEGIN
    --------------------------------
    -- Checking: InvalidOperation exception is expected when tSQLt objects wrong use in tests
    --------------------------------
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking 1: InvalidOperation exception is expected when tSQLt objects wrong use in tests';

    DECLARE @FunctionNames TSTRING = dsptest.Database_FindFunctionsWithTSQLTSchemaInTestFunctioncs();

    SET @FunctionNames = REPLACE(@FunctionNames, 'ALTER PROCEDURE [tCodeQuality].[test Find functions with tSQLt schema in test functioncs]', '');

    IF (LEN(@FunctionNames) > 0)
    BEGIN
        SET @FunctionNames = CHAR(10) + CHAR(13) + @FunctionNames;
        EXEC dsptest.Fail @ProcId = @@PROCID, @Message0 = 'These procedures use tSQLt objects: {0}', @Param0 = @FunctionNames;
    END;
END;

GO
