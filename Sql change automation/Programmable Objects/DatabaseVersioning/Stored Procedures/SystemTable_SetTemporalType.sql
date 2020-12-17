IF OBJECT_ID('[DatabaseVersioning].[SystemTable_SetTemporalType]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[SystemTable_SetTemporalType];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[SystemTable_SetTemporalType]
    @SchemaName TSTRING, @TableName TSTRING, @TemporalTypeId INT
AS
BEGIN
    MERGE dsp.SystemTable AS target
    USING (SELECT   @SchemaName SchemaName, @TableName TableName, @TemporalTypeId TemporalTypeId) AS source (SchemaName, TableName, TemporalTypeId)
       ON (target.SchemaName = source.SchemaName AND target.TableName = source.TableName)
     WHEN MATCHED
        THEN UPDATE SET target.TemporalTypeId = source.TemporalTypeId
     WHEN NOT MATCHED
        THEN INSERT (SystemTableId, SchemaName, TableName, TemporalTypeId)
             VALUES (OBJECT_ID(source.SchemaName + '.' + source.TableName), source.SchemaName, source.TableName, source.TemporalTypeId);
END;

GO
