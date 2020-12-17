IF OBJECT_ID('[DatabaseVersioning].[Table_GetMaxTimeValue]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Table_GetMaxTimeValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Table_GetMaxTimeValue]
    @SchemaName TSTRING, @TableName TSTRING, @TemporalTypeIdValue INT, @MaxCreatedTime DATETIME = NULL OUTPUT, @MaxModifiedTime DATETIME = NULL OUTPUT
AS
BEGIN
    DECLARE @Query TSTRING;
    DECLARE @Params TSTRING;

    SET @MaxCreatedTime = NULL;
    SET @MaxModifiedTime = NULL;

    -- Get max value of CreateTime and ModifiedTime for ordinary table
    IF @TemporalTypeIdValue = /*dspconst.TemporalType_Ordinary()*/ 1
    BEGIN
        SET @Query = CONCAT('
				SELECT @MaxCreatedTime = MAX(CreatedTime), @MaxModifiedTime = MAX(ModifiedTime)
				FROM ', @SchemaName, '.' + @TableName);
        SET @Params = '@MaxCreatedTime DATETIME OUTPUT, @MaxModifiedTime DATETIME OUTPUT';
        EXEC sys.sp_executesql @stmt = @Query, @params = @Params, @MaxCreatedTime = @MaxCreatedTime OUTPUT, @MaxModifiedTime = @MaxModifiedTime OUTPUT;
    END;

    -- Get max value of VersioningStartTime and ModifiedTime for temporal table
    IF @TemporalTypeIdValue = /*dspconst.TemporalType_Temporal()*/ 2
    BEGIN
        SET @Query = CONCAT('
				SELECT @MaxCreatedTime = MAX(VersioningStartTime)
				FROM ', @SchemaName, '.' + @TableName);
        SET @Params = '@MaxCreatedTime DATETIME OUTPUT';
        EXEC sys.sp_executesql @stmt = @Query, @params = @Params, @MaxCreatedTime = @MaxCreatedTime OUTPUT;
    END;

    -- Get max value of CreatedTime and ModifiedTime for transactional table
    IF @TemporalTypeIdValue = /*dspconst.TemporalType_Transactional()*/ 3
    BEGIN
        SET @Query = CONCAT('
				SELECT @MaxCreatedTime = MAX(CreatedTime)
				FROM ', @SchemaName, '.' + @TableName);
        SET @Params = '@MaxCreatedTime DATETIME OUTPUT';
        EXEC sys.sp_executesql @stmt = @Query, @params = @Params, @MaxCreatedTime = @MaxCreatedTime OUTPUT;
    END;
END;

GO
