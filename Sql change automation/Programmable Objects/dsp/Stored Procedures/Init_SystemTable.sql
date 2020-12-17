IF OBJECT_ID('[dsp].[Init_SystemTable]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_SystemTable];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Init_SystemTable]
    @DoNotDisableTemporalForActiveTemporal BIT
AS
BEGIN
    DECLARE @Message TSTRING;

    DECLARE @MirroringIsEnabled INT;
    EXEC DatabaseVersioning.Setting_GetProps @MirroringIsEnabled = @MirroringIsEnabled OUTPUT;


    IF @MirroringIsEnabled = 1
    BEGIN
        -- Check LevelPriority existance for all tables
        SET @Message = NULL;
        SELECT  @Message = STRING_AGG(SchemaName + '.' + TableName, ', ')
          FROM  dsp.SystemTable
         WHERE  LevelPriority IS NULL;

        IF @Message IS NOT NULL
            EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Identify LevelPriority in SystemTables for these tables: {0}', @Param0 = @Message;

        -- Check TemporalType existance for all tables
        SET @Message = NULL;
        SELECT  @Message = STRING_AGG(SchemaName + '.' + TableName, ', ')
          FROM  dsp.SystemTable
         WHERE  TemporalTypeId IS NULL;

        IF @Message IS NOT NULL
            EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Identify TemporalType in SystemTables for these tables: {0}', @Param0 = @Message;

        -- Check ClusterColumnName existance for all tables
        SET @Message = NULL;
        SELECT  @Message = STRING_AGG(SchemaName + '.' + TableName, ', ')
          FROM  dsp.SystemTable
         WHERE  ClusterColumnsName IS NULL;

        IF @Message IS NOT NULL
            EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Identify cluster coilumn(s) for these tables: {0}', @Param0 = @Message;
    END;

    DECLARE _Cursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  SystemTableId, SchemaName, TableName, IsTemporal
      FROM  dsp.SystemTable;

    OPEN _Cursor;

    DECLARE @SchemaName TSTRING;
    DECLARE @TableName TSTRING;
    DECLARE @IsTemporal BIT;
    DECLARE @object_id INT;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _Cursor
         INTO @object_id, @SchemaName, @TableName, @IsTemporal;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- Enable temporal for all tables that Istemporal is set
        IF @IsTemporal = 1
            EXEC dsp.Table_EnableTemporalAttribute @SchemaName = @SchemaName, @TableName = @TableName;

        -- Disable temporal for all tables that Istemporal is not set
        IF @IsTemporal = 0
        BEGIN
            IF @DoNotDisableTemporalForActiveTemporal = 1
                IF EXISTS (   SELECT    *
                                FROM    sys.tables
                               WHERE object_id = @object_id AND temporal_type <> 0)
                    EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID,
                        @Message = 'Temporal is active for table {0}.{1}, it is depend on Init argument, you can not disable it', @Param0 = @SchemaName,
                        @Param1 = @TableName;
            EXEC dsp.Table_DisableTemporalAttribute @SchemaName = @SchemaName, @TableName = @TableName;
        END;
    END;
    CLOSE _Cursor;
    DEALLOCATE _Cursor;
END;
GO
