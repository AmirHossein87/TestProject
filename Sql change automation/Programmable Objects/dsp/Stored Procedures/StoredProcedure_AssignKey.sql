IF OBJECT_ID('[dsp].[StoredProcedure_AssignKey]') IS NOT NULL
	DROP PROCEDURE [dsp].[StoredProcedure_AssignKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[StoredProcedure_AssignKey]
    @SchemaName TSTRING, @StoredProcedureName TSTRING
AS
BEGIN
    -- Get the max API key
    DECLARE @MaxKey TSTRING = dsp.StoredProcedure_MaxKey(@SchemaName);

    -- Get the stored procedure data attributes
    DECLARE @StoredProcedureMetadata TJSON;
    SELECT  @StoredProcedureMetadata = SPM.StoredProcedureMetadata
      FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
     WHERE  SPM.StoredProcedureName = @StoredProcedureName;

    -- Append HasNewVersion attribute
    DECLARE @NewMetadata TJSON = JSON_MODIFY(@StoredProcedureMetadata, '$.ApiKey', @MaxKey);
    SET @NewMetadata =
        REPLACE(
            @NewMetadata, CHAR(/*No Codequality Error*/ 13) + CHAR(/*No Codequality Error*/ 10) + ',"ApiKey":"' + @MaxKey + '"',
            dsp.String_ReplaceEnter(',\n	"ApiKey":"' + @MaxKey + '"\n'));

    -- Alter the stored procedure
    DECLARE @StoreProcedureDefinitionCode TBIGSTRING;
    SELECT  @StoreProcedureDefinitionCode = StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List(@SchemaName)
     WHERE  StoredProcedureName = @StoredProcedureName;

    SET @StoreProcedureDefinitionCode = REPLACE(@StoreProcedureDefinitionCode, @StoredProcedureMetadata, @NewMetadata);
    SET @StoreProcedureDefinitionCode = REPLACE(@StoreProcedureDefinitionCode, 'CREATE PROCEDURE', 'ALTER PROCEDURE');

    EXEC sys.sp_executesql @StoreProcedureDefinitionCode;
END;















GO
