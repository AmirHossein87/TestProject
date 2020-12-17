IF OBJECT_ID('[DatabaseVersioning].[Table_GetData]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_GetData];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_GetData]
    @SnapshotTime DATETIME, @SchemaName TSTRING, @TableName TSTRING, @TemporalTypeIdValue INT, @MainItemJson TJSON OUTPUT, @HistoryItemJson TJSON = NULL OUTPUT
AS
BEGIN
    SET @MainItemJson = NULL;
    SET @HistoryItemJson = NULL;
    DECLARE @MaxCreatedTime DATETIME;
    DECLARE @MaxModifiedTime DATETIME;

    -- Get max data
    EXEC DatabaseVersioning.Table_GetMaxTimeValue @SchemaName = @SchemaName, @TableName = @TableName, @TemporalTypeIdValue = @TemporalTypeIdValue,
        @MaxCreatedTime = @MaxCreatedTime OUTPUT, @MaxModifiedTime = @MaxModifiedTime OUTPUT;

    -- Get Ordinary Data
    IF (@TemporalTypeIdValue = /*dspconst.TemporalType_Ordinary()*/ 1)
        EXEC DatabaseVersioning.Table_GetOrdinaryData @SchemaName = @SchemaName, @TableName = @TableName, @EndTime = @SnapshotTime,
            @CreatedStartTime = @MaxCreatedTime, @ModifiedStartTime = @MaxModifiedTime, @ResultItems = @MainItemJson OUTPUT;

    -- Get Transactional Data
    IF (@TemporalTypeIdValue = /*dspconst.TemporalType_Transactional()*/ 3)
        EXEC DatabaseVersioning.Table_GetTransactionalData @SchemaName = @SchemaName, @TableName = @TableName, @EndTime = @SnapshotTime,
            @CreatedStartTime = @MaxCreatedTime, @ResultItems = @MainItemJson OUTPUT;

    --Get Temporal Data
    IF (@TemporalTypeIdValue = /*dspconst.TemporalType_Temporal()*/ 2)
        DECLARE @MainJsonResult TJSON, @HistoryJsonResult TJSON;
    EXEC DatabaseVersioning.Table_GetTemporalData @SchemaName = @SchemaName, @TableName = @TableName, @CreatedStartTime = @MaxCreatedTime,
        @EndTime = @SnapshotTime, @MainJsonResult = @MainItemJson OUTPUT, @HistoryJsonResult = @HistoryItemJson OUTPUT;

    --Get Lookup Data
	IF(@TemporalTypeIdValue = /*[dspconst].[TemporalType_Lookup]*/4)
	DECLARE @ResultItems TSTRING;
	EXEC DatabaseVersioning.Table_GetLookupData @SchemaName = @SchemaName, @TableName = @TableName, @ResultItems = @ResultItems OUTPUT

END;
GO
