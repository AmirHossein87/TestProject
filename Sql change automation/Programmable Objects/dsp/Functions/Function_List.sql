IF OBJECT_ID('[dsp].[Function_List]') IS NOT NULL
	DROP FUNCTION [dsp].[Function_List];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Function_List] (@SchemaName TSTRING)
RETURNS TABLE
AS
RETURN SELECT   O.object_id FunctionId, --
           S.name AS FunctionSchemaName, --
           O.name AS FunctionName, --
           OBJECT_DEFINITION(O.object_id) AS FunctionDefinitionCode, --
           DFTN.TypeName FunctionTypeName --
         FROM   sys.objects AS O
                INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
                CROSS APPLY dsp.[Database_$FunctionTypeName](O.type) AS DFTN
        WHERE   O.type IN ( 'FN', 'IF', 'TF' ) --
           AND  (S.name = @SchemaName OR @SchemaName IS NULL);




GO
