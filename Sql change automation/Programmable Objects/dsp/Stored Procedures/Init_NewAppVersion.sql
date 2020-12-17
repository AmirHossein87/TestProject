IF OBJECT_ID('[dsp].[Init_NewAppVersion]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_NewAppVersion];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_NewAppVersion]
    @AppVersionId INT = NULL OUT
AS
BEGIN
    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY

        -- Increase the application version
        EXEC dsp.[Init_$IncreaseAppVersion] @AppVersionId = @AppVersionId OUT;

        -- Get the schema name
        DECLARE @SchemaName TSTRING = dsp.Setting_VersioningSchemaName();

        -- Insert all the procedures with the API schema name to the AppVersionDetail table 
        INSERT INTO dsp.AppVersionDetail (AppVersionId, StoredProcedureId, StoredProcedureName, StoredProcedurePhysicalName, SchemaName,
            StoredProcedureVersionNumber, ExpirationTime, CreatedTime)
        SELECT  @AppVersionId, --
            SPM.StoredProcedureId, --
            ISNULL(JSON_VALUE(SPM.StoredProcedureMetadata, '$.StoredProcedureName'), SPM.StoredProcedureName), --
            SPM.StoredProcedureName, --
            SPM.StoredProcedureSchemaName, --
            SPVN.VersionNumber, NULL, --
            GETDATE()
          FROM  dsp.StoredProcedure_List(@SchemaName) AS SPM
                OUTER APPLY dsp.StoredProcedure_VersionNumber(StoredProcedureName) AS SPVN
         ORDER BY SPVN.VersionNumber;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

END;


GO
