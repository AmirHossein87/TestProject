IF OBJECT_ID('[dsp].[Table_EnableTemporalAttribute]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_EnableTemporalAttribute];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_EnableTemporalAttribute]
    @SchemaName TSTRING, @TableName TSTRING
AS
BEGIN
    SET NOCOUNT ON;

    SET @SchemaName = ISNULL(@SchemaName, 'dbo');

    -- Vaidate for existance
    EXEC dsp.Table_ValidateExistance @SchemaName = @SchemaName, @TableName = @TableName;

    -- Check if Temporal Table Exisits
    IF EXISTS (   SELECT    *
                    FROM    sys.tables
                   WHERE name = @TableName AND  temporal_type = 2)
        RETURN;

    -- Check PERIOD FOR SYSTEM_TIME 
    DECLARE @Query TSTRING;
    -- 
    IF EXISTS (   SELECT    1
                    FROM    sys.columns
                   WHERE (name = N'VersioningStartTime' OR  name = N'VersioningEndTime') AND object_id = OBJECT_ID(@SchemaName + '.' + @TableName))
    BEGIN
        SET @Query = 'ALTER TABLE ' + @SchemaName + '.' + @TableName + ' ADD PERIOD FOR SYSTEM_TIME(VersioningStartTime, VersioningEndTime)';
        EXEC (@Query);
    END;

    -- check for exists version columns
    SET @Query = NULL;
    IF NOT EXISTS (   SELECT    *
                        FROM    sys.columns
                       WHERE (name = N'VersioningStartTime' OR  name = N'VersioningEndTime') AND object_id = OBJECT_ID(@SchemaName + '.' + @TableName))
    BEGIN
        SET @Query =
            'ALTER TABLE ' + @SchemaName + '.' + @TableName
            + ' Add  
							   VersioningStartTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN DEFAULT GETUTCDATE(),
							   VersioningEndTime  DATETIME2 GENERATED ALWAYS AS ROW END   HIDDEN DEFAULT  CONVERT(DATETIME2, ''9999-12-31 23:59:59.9999999''),
							   PERIOD FOR SYSTEM_TIME (VersioningStartTime, VersioningEndTime) ';
        EXEC (@Query);

    END;

    -- Add HistoricalTable
    SET @Query = NULL;
    SET @Query =
        'ALTER TABLE ' + @SchemaName + '.' + @TableName + ' set  (SYSTEM_VERSIONING = ON (HISTORY_TABLE=' + @SchemaName + '.' + @TableName + 'History' + ')) ';
    EXEC (@Query);

END;
GO
