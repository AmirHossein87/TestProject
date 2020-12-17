IF OBJECT_ID('[dsp].[Database_CheckPrimaryOnTables]') IS NOT NULL
	DROP FUNCTION [dsp].[Database_CheckPrimaryOnTables];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dsp].[Database_CheckPrimaryOnTables] (@ExceptedSchemaName TSTRING = 'tSQLt')
RETURNS TABLE
RETURN SELECT   SCh.name AS SchemaName, tab.name AS TableName 
         FROM   sys.tables tab
                INNER JOIN sys.schemas SCh ON SCh.schema_id = tab.schema_id
                LEFT OUTER JOIN sys.indexes pk ON tab.object_id = pk.object_id AND  pk.is_primary_key = 1
                OUTER APPLY dsp.Table_HasTemporalAttributes(DEFAULT, tab.name) THSAE
        WHERE   pk.name IS NULL --
           AND  (@ExceptedSchemaName IS NULL OR SCh.name <> 'tSQLt') --
           AND  tab.temporal_type <> dspconst.Table_IsTemporalHistory() --
           AND  THSAE.HasVersioningFields = 0;
GO
