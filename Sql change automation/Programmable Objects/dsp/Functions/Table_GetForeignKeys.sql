IF OBJECT_ID('[dsp].[Table_GetForeignKeys]') IS NOT NULL
	DROP FUNCTION [dsp].[Table_GetForeignKeys];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[Table_GetForeignKeys] (@schemaName TSTRING = 'dbo',
    @tablename TSTRING)
RETURNS TABLE
AS
RETURN (   SELECT   fk.object_id AS ConstraintId, fk.name, ct.object_id, ct.name AS tablename
             FROM   sys.foreign_keys AS fk
                    INNER JOIN sys.tables AS ct ON fk.parent_object_id = ct.object_id
                    INNER JOIN sys.schemas AS cs ON ct.schema_id = cs.schema_id
            WHERE   ct.name = @tablename AND cs.name = @schemaName);


GO
