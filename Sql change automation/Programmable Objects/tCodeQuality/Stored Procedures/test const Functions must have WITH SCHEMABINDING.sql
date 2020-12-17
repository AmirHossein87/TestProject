IF OBJECT_ID('[tCodeQuality].[test const Functions must have WITH SCHEMABINDING]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test const Functions must have WITH SCHEMABINDING];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test const Functions must have WITH SCHEMABINDING]
AS
BEGIN

    -- Declaring pattern
    DECLARE @Pattern_Context TCONTEXT = dsp.String_RemoveWhitespaces('WITH SCHEMABINDING');

    DECLARE @msg TSTRING;
    DECLARE @FunctionName TSTRING;
    DECLARE @SchemaName TSTRING = 'const';

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all functions with const schema';
    DECLARE @t TABLE (SchemaName TSTRING,
        FunctionName TSTRING,
        Script TBIGSTRING);
    INSERT INTO @t
    SELECT  @SchemaName, PD.StoredProcedureName, dsp.String_RemoveWhitespaces(PD.StoredProcedureDefinitionCode)
      FROM  dsp.StoredProcedure_List(@SchemaName) AS PD;

    -- Looking for "@Context TCONTEXT OUT" phrase
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Looking for "WITH SCHEMABINDING" phrase';
    SELECT  @FunctionName = SchemaName + '.' + FunctionName
      FROM  @t
     WHERE  CHARINDEX(@Pattern_Context, Script) < 1 AND CHARINDEX('TSTRING', Script) = 0;

    IF (@FunctionName IS NOT NULL)
    BEGIN
        SET @msg = '"WITH SCHEMABINDING" phrase was not found in Function: ' + @FunctionName;
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;
    END;
END;
GO
