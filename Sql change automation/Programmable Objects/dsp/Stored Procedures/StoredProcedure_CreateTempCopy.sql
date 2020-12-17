IF OBJECT_ID('[dsp].[StoredProcedure_CreateTempCopy]') IS NOT NULL
	DROP PROCEDURE [dsp].[StoredProcedure_CreateTempCopy];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[StoredProcedure_CreateTempCopy]
    @SchemaName TSTRING, @StoredProcedureName TSTRING
AS
BEGIN

    -- Get stored procedure API key and definiton code
    DECLARE @StoredProcedureDefinitionCode TBIGSTRING;
    DECLARE @ApiKey TJSON;
    SELECT --
        @ApiKey = SPM.StoredProcedureKey, --
        @StoredProcedureDefinitionCode = SPM.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
     WHERE  SPM.StoredProcedureName = @StoredProcedureName;

    -- Should not be exists another temp with the current API key
    IF EXISTS (   SELECT    *
                    FROM    dsp.StoredProcedure_NameByApiKey('temp', @ApiKey)
                   WHERE StoredProcedureName IS NOT NULL) --
        EXEC dsp.ThrowFatalError @ProcId = @@PROCID, @Message = 'Another API already exists with new procedure''s APIkey, ApiKey ={0}', @Param0 = @ApiKey;

    IF (@StoredProcedureDefinitionCode IS NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Could not find stored procedure';

    -- Create stored procedure temp copy
    DECLARE @TempName TSTRING = 'temp.' + @StoredProcedureName;
    DECLARE @CreatedStoredProcedureName TSTRING = @SchemaName + '.' + @StoredProcedureName;
    DECLARE @CreatedStoredProcedureNameWithBracker TSTRING = CONCAT(QUOTENAME(@SchemaName), '.', QUOTENAME(@StoredProcedureName));
    SET @StoredProcedureDefinitionCode = REPLACE(@StoredProcedureDefinitionCode, @CreatedStoredProcedureName, @TempName);
    SET @StoredProcedureDefinitionCode = REPLACE(@StoredProcedureDefinitionCode, @CreatedStoredProcedureNameWithBracker, @TempName);
    EXEC sys.sp_executesql @StoredProcedureDefinitionCode;
END;



















GO
