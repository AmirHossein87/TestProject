IF OBJECT_ID('[DatabaseVersioning].[Table_SyncAllData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_SyncAllData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_SyncAllData]
    @SnapshotTime DATETIME
AS
BEGIN
    DECLARE @MaxRecords INT;
    DECLARE @Counter INT;
    SET @SnapshotTime = ISNULL(@SnapshotTime, GETDATE());

    -- Get maxrecord
    EXEC DatabaseVersioning.Setting_GetProps @GetDataRowCount = @MaxRecords OUTPUT;

    -- Provisiong table in order to call engine
    DECLARE _Cursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  SchemaName, TableName, LevelPriority, TemporalTypeId
      FROM  dsp.SystemTable
     ORDER BY LevelPriority;

    OPEN _Cursor;

    DECLARE @SchemaName TSTRING;
    DECLARE @TableName TSTRING;
    DECLARE @LevelPriority TSTRING;
    DECLARE @TemporalTypeId INT;
    DECLARE @MainItemJson TJSON;
    DECLARE @HistoryItemJson TJSON;
    DECLARE @MainTableRecordCount INT;
    DECLARE @HistoryTableRecordCount INT;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _Cursor
         INTO @SchemaName, @TableName, @LevelPriority, @TemporalTypeId;

        IF (@@FETCH_STATUS <> 0)
            BREAK;

        SET @Counter = @MaxRecords;
        WHILE (@Counter = @MaxRecords)
        BEGIN
            -- Get data from source
            EXEC DatabaseVersioning.Table_GetData @SnapshotTime = @SnapshotTime, @SchemaName = @SchemaName, @TableName = @TableName,
                @TemporalTypeIdValue = @TemporalTypeId, @MainItemJson = @MainItemJson OUTPUT, @HistoryItemJson = @HistoryItemJson OUTPUT;

            -- Set counter
            SET @MainTableRecordCount = (SELECT COUNT(*) FROM   OPENJSON(@MainItemJson));
            SET @HistoryTableRecordCount = (SELECT  COUNT(*) FROM   OPENJSON(@HistoryItemJson));
            SET @Counter = IIF(@MainTableRecordCount > @HistoryTableRecordCount, @MainTableRecordCount, @HistoryTableRecordCount);

            -- Insert Data
            EXEC DatabaseVersioning.Table_SyncData @SchemaName = @SchemaName, @TableName = @TableName, @TemporalTypeIdValue = @TemporalTypeId,
                @MainItemJson = @MainItemJson, @HistoryItemJson = @HistoryItemJson;
        END;
    END;
    CLOSE _Cursor;
    DEALLOCATE _Cursor;

END;

GO
