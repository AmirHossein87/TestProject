IF OBJECT_ID('[dsp].[Init_$Start]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$Start];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$Start]
    @IsProductionEnvironment BIT = NULL, @IsWithCleanup BIT = NULL, @Reserved BIT = NULL, @DoNotDisableTemporalForActiveTemporal BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET @Reserved = ISNULL(@Reserved, 1);

    -- SetUp DirectSp procedures and tables
    EXEC dsp.[Init_$SetUp];

    ----------------
    -- Check Production Environment and Run Cleanup
    ----------------	
    -- Cleanup is using setting so do init setting before cleanup but because cleanup cleaned the setting table we should do init setting again
    EXEC dsp.[Init_$Cleanup] @IsProductionEnvironment = @IsProductionEnvironment OUT, @IsWithCleanup = @IsWithCleanup OUT;

    -- Be carefull: in production environment, setting tables must not be owerwrite
    IF (@IsWithCleanup = 1)
    BEGIN
        -- Filling Setting
        EXEC dsp.[Init_$InitSettings];

        EXEC dspInboxMessage.[Init_$InitSettings];

        EXEC DatabaseVersioning.[Init_$InitSettings];

        -- You should implement this function to your specifics Setting
        IF (dsp.Metadata_IsObjectExists('dbo', 'Init_$InitSettings', 'P') = 1) --
            EXEC dbo.[Init_$InitSettings];
    END;

    ----------------
    -- Recreate Strings
    ----------------
    IF (@Reserved = 1) --
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Recreating strings';
    DELETE  dsp.StringTable;

    -- You should implement this function to your specifics String
    IF (dsp.Metadata_IsObjectExists('dbo', 'Init_FillStrings', 'P') = 1) --
        EXEC dbo.Init_FillStrings;

    -- Recreate string functions
    EXEC dsp.[Init_$RecreateStringFunctions];

    -- Check is internal databse
    DECLARE @IsInternalDatabase BIT = 0;
    SELECT  @IsInternalDatabase = 1
      FROM  dsp.StringTable AS ST
     WHERE  ST.StringId = 'IsDirectSpInternal';

    ----------------
    -- Recreate Exceptions 
    ----------------
    IF (@Reserved = 1) --
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Recreating exception';
    DELETE  dsp.Exception;

    -- You should implement this function to your specifics Exception
    -- Your ExceptionId mst be grather than 56000
    IF (dsp.Metadata_IsObjectExists('dbo', 'Init_FillExceptions', 'p') = 1) --
        EXEC dbo.Init_FillExceptions;

    -- make sure there is no invalid Exception Id for general application
    IF (@IsInternalDatabase = 0 AND EXISTS (   SELECT   1
                                                 FROM   dsp.Exception AS E
                                                WHERE   E.ExceptionId < 56000))
        EXEC dsp.ThrowAppException @ProcId = @@PROCID, @ExceptionId = 55001, @Message = 'Application ExceptionId cannot be less than 56000!';

    -- make sure there is no invalid Exception Id for DirectSpInternal
    IF (@IsInternalDatabase = 1 AND EXISTS (   SELECT   1
                                                 FROM   dsp.Exception AS E
                                                WHERE   E.ExceptionId < 55700 OR E.ExceptionId >= 56000))
        EXEC dsp.ThrowAppException @ProcId = @@PROCID, @ExceptionId = 55001, @Message = 'DirectSpInternal ExceptionId must asigned between 55700 and 56000!';

    -- Recreate exception function
    EXEC dsp.[Init_$CreateCommonExceptions];
    EXEC dsp.[Init_$RecreateExceptionFunctions];

    ----------------
    -- Lookups and Data
    ----------------
    IF (@Reserved = 1) --
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Filling lookups';
    EXEC dsp.Init_FillLookups;

    -- You should implement this function to your specifics Lookup
    IF (dsp.Metadata_IsObjectExists('dbo', 'Init_FillLookups', 'P') = 1) --
        EXEC dbo.Init_FillLookups;

    IF (@Reserved = 1) --
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Filling data';
    EXEC dsp.Init_FillData;

    -- Initialized startup data if you have not initialized yet your data
    IF (dsp.Metadata_IsObjectExists('dbo', 'Init_FillData', 'P') = 1) --
        EXEC dbo.Init_FillData;

    -- Initialize SystemTable to Temporal and DatabseVaersioning feature
    IF (dsp.Metadata_IsObjectExists('dbo', 'Init_SystemTable', 'P') = 1) --
        EXEC dbo.Init_SystemTable;

    -- Turn on feature by SystemTabkle
    EXEC dsp.Init_SystemTable @DoNotDisableTemporalForActiveTemporal = @DoNotDisableTemporalForActiveTemporal;

    -- Call Init again to make sure it can be called without cleanup
    IF (@IsProductionEnvironment = 0 AND @IsWithCleanup = 1 AND @Reserved = 1)
    BEGIN
        EXEC dsp.[Init_$Start] @IsProductionEnvironment = 0, @IsWithCleanup = 0, @Reserved = 0;
        RETURN;
    END;

    ----------------
    -- Init new application version
    ----------------
    DECLARE @IsEnabledInitNewAppVersion BIT;
    EXEC dsp.Setting_GetProps @IsEnabledInitNewAppVersion = @IsEnabledInitNewAppVersion OUTPUT;
    IF (@IsEnabledInitNewAppVersion = 1) --
        EXEC dsp.Init_NewAppVersion;

    -- Configure large fields
    -- EXEC dsp.Table_UpdateToUseBlobForFields;

    -- Report it is done
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Init has been completed.';

END;
GO
