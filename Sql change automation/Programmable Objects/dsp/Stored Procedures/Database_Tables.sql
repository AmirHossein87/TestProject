IF OBJECT_ID('[dsp].[Database_Tables]') IS NOT NULL
	DROP PROCEDURE [dsp].[Database_Tables];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Database_Tables]
    @SchemaName TSTRING = NULL, @TableName TSTRING = NULL, @TablesJsonResult TJSON = NULL OUTPUT
AS
BEGIN
    -- Set json fro result
    SET @TablesJsonResult =
    (   SELECT  ST.object_id AS TableId,ST.TableName, ST.SchemaName, --
            JSON_QUERY(dsp.Table_GetParamsJson(ST.object_id)) AS Params,--
			ST.TemporalTypeId, ST.LevelPriority
			--JSON_QUERY(dsp.Table_ExtendedProperty(ST.object_id)) AS ExtendedProperties
          FROM  dsp.vw_SystemTable AS ST
         WHERE  ST.SchemaName <> 'tSQLt' --
            AND (@SchemaName IS NULL OR ST.SchemaName = @SchemaName) --
            AND (@TableName IS NULL OR  ST.TableName = @TableName)
        FOR JSON AUTO);
END;
GO
