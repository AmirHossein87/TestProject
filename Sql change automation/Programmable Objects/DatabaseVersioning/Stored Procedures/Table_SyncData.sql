IF OBJECT_ID('[DatabaseVersioning].[Table_SyncData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_SyncData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_SyncData]
    @SchemaName TSTRING, @TableName TSTRING, @TemporalTypeIdValue INT, @MainItemJson TJSON, @HistoryItemJson TJSON = NULL
AS
BEGIN
    -- Prepare parameters
    DECLARE @Query TBIGSTRING;

    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;

    BEGIN TRY
        -- Get merge script to sync datas
        SET @Query = DatabaseVersioning.Table_SyncDataScript(@SchemaName, @TableName, @TemporalTypeIdValue, @MainItemJson);

        -- Call merge command to sync datas        
        EXEC (@Query);

        -- For temporal tables, sync history table datas
        IF (@TemporalTypeIdValue = dspconst.TemporalType_Temporal())
        BEGIN
            SET @Query = DatabaseVersioning.Table_SyncDataScript(@SchemaName, @TableName + 'History', @TemporalTypeIdValue, @HistoryItemJson);
			--SELECT @SchemaName , @TableName , @TemporalTypeIdValue , @HistoryItemJson
			--PRINT @Query
            EXEC (@Query);
			
        END;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

END;



GO
