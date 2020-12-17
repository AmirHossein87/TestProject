IF OBJECT_ID('[dsp].[Table_GetExtendedPropertyValueByKey]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_GetExtendedPropertyValueByKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_GetExtendedPropertyValueByKey] (@SchemaName TSTRING = 'dbo',
    @TableName AS TSTRING,
    @ExtendedPropertyKey
AS  TSTRING)
RETURNS TABLE
RETURN SELECT   EP.name AS ExtendedPropertyKey, CAST(EP.value AS NVARCHAR(MAX /*NCQ*/)) ExtendedPropertyValue
         FROM   sys.tables T
                INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
                INNER JOIN sys.extended_properties EP ON T.object_id = EP.major_id
        WHERE   EP.class = 1 --
           AND  EP.minor_id = 0 --
           AND  T.name = @TableName --
           AND  EP.name = @ExtendedPropertyKey --
           AND  S.name = @SchemaName;

GO
