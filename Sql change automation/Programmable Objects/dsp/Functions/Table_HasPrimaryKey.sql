IF OBJECT_ID('[dsp].[Table_HasPrimaryKey]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_HasPrimaryKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_HasPrimaryKey] (@SchemaName TSTRING,
    @TableName TSTRING)
RETURNS TABLE
RETURN SELECT   ISNULL((   SELECT   1
                             FROM   sys.tables T
                                    INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
                                    LEFT OUTER JOIN sys.indexes I ON T.object_id = I.object_id
                            WHERE   I.is_primary_key = 1 --
                               AND  (@SchemaName IS NULL OR S.name = @SchemaName) --
                               AND  (@TableName IS NULL OR  T.name = @TableName)), 0) HasPrimaryKey;

GO
