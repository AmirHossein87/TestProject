IF OBJECT_ID('[dsp].[Table_HasTemporalAttributes]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_HasTemporalAttributes];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  FUNCTION [dsp].[Table_HasTemporalAttributes] (@SchemaName TSTRING = 'dbo',
    @TableName TSTRING)
RETURNS TABLE
RETURN SELECT   IIF((   SELECT  COUNT(1)
                          FROM  sys.columns C
                                INNER JOIN sys.tables T ON T.object_id = C.object_id
                                INNER JOIN sys.schemas SCh ON SCh.schema_id = T.schema_id
                         WHERE  T.name = @TableName --
                            AND SCh.name = @SchemaName --
                            AND (C.name = 'VersioningStartTime' OR C.name = 'VersioningEndTime')) = 2,
                    1,
                    0) HasVersioningFields;

GO
