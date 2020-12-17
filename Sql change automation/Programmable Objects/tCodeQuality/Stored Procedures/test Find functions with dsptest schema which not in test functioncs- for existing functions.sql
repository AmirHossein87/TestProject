IF OBJECT_ID('[tCodeQuality].[test Find functions with dsptest schema which not in test functioncs- for existing functions]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Find functions with dsptest schema which not in test functioncs- for existing functions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [tCodeQuality].[test Find functions with dsptest schema which not in test functioncs- for existing functions]
AS
BEGIN
    --------------------------------
    -- Checking: InvalidOperation exception is expected when dspTest objects not only use in tests
    --------------------------------
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Checking 1: InvalidOperation exception is expected when dspTest objects not only use in tests';

    DECLARE @FunctionNames TSTRING = dsptest.Database_FindFunctionsWithDspTestSchemaWhichNotInTestFunctioncs();

    IF (@FunctionNames IS NOT NULL)
    BEGIN
        SET @FunctionNames = CHAR(10) + CHAR(13) + @FunctionNames;
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = N'These procedures use dspTest objects: {0}', @Param0 = @FunctionNames;
    END;

END;
GO
