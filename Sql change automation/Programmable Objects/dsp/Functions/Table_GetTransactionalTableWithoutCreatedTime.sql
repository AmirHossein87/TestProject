IF OBJECT_ID('[dsp].[Table_GetTransactionalTableWithoutCreatedTime]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_GetTransactionalTableWithoutCreatedTime];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_GetTransactionalTableWithoutCreatedTime] (@SchemaName TSTRING = NULL,
    @TableName TSTRING = NULL)
RETURNS TABLE
AS
RETURN (   SELECT DISTINCT  S.name AS SchemaName, T.name AS TableName, GEPV.ExtendedPropertyValue
             FROM   sys.tables T
                    INNER JOIN sys.columns C ON C.object_id = T.object_id
                    INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
                    CROSS APPLY dsp.Table_GetExtendedPropertyValueByKey(S.name, T.name, 'TemporalTypeId') GEPV
            WHERE   GEPV.ExtendedPropertyValue = 3 AND  C.name <> 'CreatedTime' AND (S.name = @SchemaName OR S.name IS NULL) AND (T.name = @TableName OR T.name IS NULL) );




GO
