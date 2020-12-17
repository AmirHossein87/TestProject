IF OBJECT_ID('[dsp].[Table_Params]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_Params];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Table_Params] (@TableId INT)
RETURNS TABLE
AS
RETURN (   SELECT   OBJECT_SCHEMA_NAME(T.object_id) AS SchemaName, T.name AS TableName, C.name AS ColumnName,C.column_id AS ColumnId ,C.is_identity IsIdentity, Y.name AS DataType,
               C.is_nullable IsNullable, C.max_length MaxLength, C.collation_name CollationName, Y.is_user_defined IsUserDefined
             FROM   sys.tables T
                    INNER JOIN sys.columns C ON T.object_id = C.object_id
                    INNER JOIN sys.types Y ON C.system_type_id = Y.system_type_id AND   C.user_type_id = Y.user_type_id
            WHERE   T.object_id = @TableId);


GO
