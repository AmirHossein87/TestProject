IF OBJECT_ID('[tCodeQuality].[test dbo should not have WITH EXECUTE AS OWNER]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test dbo should not have WITH EXECUTE AS OWNER];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test dbo should not have WITH EXECUTE AS OWNER]
AS
BEGIN
    -- Declaring pattern
    DECLARE @Pattern_WithExecuteASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @Pattern_WithExecASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;
    DECLARE @ProcedureName TSTRING;

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all procedures with pagination';
    DECLARE @t TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        Script TBIGSTRING);
    INSERT INTO @t
    SELECT  PD.StoredProcedureSchemaName, PD.StoredProcedureName, PD.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List(NULL) AS PD
     WHERE  PD.StoredProcedureSchemaName IN ( 'dsp', 'dbo', 'perm' );

    -- Looking for "With Execute AS Owner" phrase
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Looking for "With Execute AS Owner" phrase';
    SELECT  @ProcedureName = SchemaName + '.' + ProcedureName
      FROM  @t
     WHERE  CHARINDEX(@Pattern_WithExecuteASOwner, Script) > 0 OR   CHARINDEX(@Pattern_WithExecASOwner, Script) > 0;

    IF (@ProcedureName IS NOT NULL)
    BEGIN
        SET @msg = '"With Execute AS Owner" phrase was found in procedure: ' + @ProcedureName;
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;
    END;
END;
GO
