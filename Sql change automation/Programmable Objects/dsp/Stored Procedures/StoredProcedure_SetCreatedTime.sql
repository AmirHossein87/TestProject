IF OBJECT_ID('[dsp].[StoredProcedure_SetCreatedTime]') IS NOT NULL
	DROP PROCEDURE [dsp].[StoredProcedure_SetCreatedTime];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[StoredProcedure_SetCreatedTime]
    @SchemaName TSTRING, @StoredProcedureName TSTRING
AS
BEGIN
    -- Get the stored procedure metadata
    DECLARE @StoredProcedureMetadata TJSON;
    SELECT  @StoredProcedureMetadata = SPM.StoredProcedureMetadata
      FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
     WHERE  SPM.StoredProcedureName = @StoredProcedureName;

    -- Check if storedProcedure has created time 
    IF (JSON_VALUE(@StoredProcedureMetadata, '$.CreatedTime') IS NOT NULL) --
        RETURN;

    DECLARE @CreatedTime TSTRING = CONVERT(NVARCHAR, GETDATE(), 120);
    -- Append HasNewVersion attribute
    DECLARE @NewMetadata TJSON = JSON_MODIFY(@StoredProcedureMetadata, '$.CreatedTime', @CreatedTime);
    SET @NewMetadata =
        REPLACE(
            @NewMetadata, CHAR(/*No Codequality Error*/ 13) + CHAR(/*No Codequality Error*/ 10) + ',"CreatedTime":"' + @CreatedTime + '"',
            dsp.String_ReplaceEnter(',\n	"CreatedTime":"' + @CreatedTime + '"\n'));

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
