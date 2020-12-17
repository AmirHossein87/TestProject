IF OBJECT_ID('[tCodeQuality].[test API must have WITH EXECUTE AS OWNER]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test API must have WITH EXECUTE AS OWNER];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test API must have WITH EXECUTE AS OWNER]
AS
BEGIN
    -- Declaring pattern
    DECLARE @Pattern_WithExecuteASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @Pattern_WithExecASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;
    DECLARE @SchemaName TSTRING = 'api';

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all procedures with pagination';
    DECLARE @t TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        Script TBIGSTRING);

    INSERT INTO @t
    SELECT  @SchemaName, PD.StoredProcedureName, dsp.String_RemoveWhitespacesBig(PD.StoredProcedureDefinitionCode)
      FROM  dsp.StoredProcedure_List(@SchemaName) AS PD;

    -- Looking for "With Execute AS Owner" phrase
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Looking for "With Execute AS Owner" phrase';
    SET @msg = (   SELECT   SchemaName + '.' + ProcedureName AS ProcedureName
                     FROM   @t
                    WHERE   CHARINDEX(@Pattern_WithExecuteASOwner, Script) = 0 AND  CHARINDEX(@Pattern_WithExecASOwner, Script) = 0
                   FOR JSON AUTO);

    IF (@msg IS NOT NULL) --
        EXEC dsptest.Fail @ProcId = @@PROCID, @Message0 = @msg;
END;

GO
