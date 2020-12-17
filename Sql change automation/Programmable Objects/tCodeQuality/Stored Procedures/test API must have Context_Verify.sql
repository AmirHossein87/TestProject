IF OBJECT_ID('[tCodeQuality].[test API must have Context_Verify]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test API must have Context_Verify];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test API must have Context_Verify]
AS
BEGIN
    DECLARE @msg TSTRING;
    DECLARE @ProcedureName TSTRING;
    DECLARE @SchemaName TSTRING = 'api';

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all procedures with api schema';
    DECLARE @t TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        Script TBIGSTRING);
    INSERT INTO @t
    SELECT  @SchemaName, VPD.StoredProcedureName, VPD.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List(@SchemaName) AS VPD;

    -- Looking for "Context_Verify" in api procedure
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N' Looking for "Context_Verify" in api procedure';
    SELECT  @ProcedureName = SchemaName + '.' + ProcedureName
      FROM  @t
     WHERE  (SchemaName IN ( 'api' )) AND   Script NOT LIKE N'%dsp.Context_Verify%';

    IF (@ProcedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should contain dsp.Context_Verify in procedure: ' + @ProcedureName;
        EXEC dsptest.Fail @ProcId = @@PROCID, @Message0 = @msg;
    END;
END;

GO
