IF OBJECT_ID('[dsp].[Table_GetMaxPrimaryKeyValue]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_GetMaxPrimaryKeyValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_GetMaxPrimaryKeyValue] (
    @SchemaName TSTRING, @TableName TSTRING, @MaxPrimaryColumnValue BIGINT = NULL OUTPUT)
AS
BEGIN
    -- Validate PrimaryColumn
    DECLARE @PrimaryKeyColumnName TSTRING = dsp.Table_GetPrimaryKey(@SchemaName, @TableName);
    IF (@PrimaryKeyColumnName IS NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Table does not have primary column';

    DECLARE @ResultMaxValue TSTRING;
    DECLARE @Query TSTRING;
    DECLARE @Params TSTRING;
    SET @Query =
        CONCAT(
            'SET @MaxPrimaryKey = (SELECT MAX(', @PrimaryKeyColumnName, ') as ', @PrimaryKeyColumnName, ' FROM ', @SchemaName, '.' + @TableName,
            ' FOR JSON AUTO)');
    SET @Params = '@MaxPrimaryKey NVARCHAR(MAX) OUTPUT';
    EXEC sys.sp_executesql @Query, @Params, @MaxPrimaryKey = @ResultMaxValue OUTPUT;

    DECLARE @Path TJSON = REPLACE('$[0].@Id', '@Id', @PrimaryKeyColumnName);
    SET @MaxPrimaryColumnValue = JSON_VALUE(@ResultMaxValue, @Path);
END;




GO
