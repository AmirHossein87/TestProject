IF OBJECT_ID('[dsp].[Table_ListBaseOnExtendedProperty]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_ListBaseOnExtendedProperty];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_ListBaseOnExtendedProperty] (@ExtendedProperty TSTRING = NULL)
RETURNS TABLE
AS
RETURN SELECT   t.object_id AS ObjectId, s.name SchemaName, t.name AS TableName, ep.name AS ExtendedPropertyName, ep.value AS ExtendedPropertyValue
         FROM   sys.extended_properties ep
                INNER JOIN sys.tables t ON t.object_id = ep.major_id
                INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE   ep.class = 1 --
           AND  ep.minor_id = 0 --
           AND  (@ExtendedProperty IS NULL OR   ep.name = @ExtendedProperty) --
           AND  s.name <> 'tSQLt';

GO
