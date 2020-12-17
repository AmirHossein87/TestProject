IF OBJECT_ID('[DatabaseVersioning].[SystemTable_SetLevelPriority]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[SystemTable_SetLevelPriority];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [DatabaseVersioning].[SystemTable_SetLevelPriority]
    @SchemaName TSTRING, @TableName TSTRING, @PriorityLevelValue INT = 1
AS
BEGIN
    MERGE dsp.SystemTable AS target
    USING (SELECT   @SchemaName SchemaName, @TableName TableName, @PriorityLevelValue LevelPriority) AS source (SchemaName, TableName, LevelPriority)
       ON (target.SchemaName = source.SchemaName AND target.TableName = source.TableName)
     WHEN MATCHED
        THEN UPDATE SET target.LevelPriority = source.LevelPriority
     WHEN NOT MATCHED
        THEN INSERT (SystemTableId, SchemaName, TableName, LevelPriority)
             VALUES (OBJECT_ID(source.SchemaName + '.' + source.TableName), source.SchemaName, source.TableName, source.LevelPriority);
END;
GO
