IF OBJECT_ID('[DatabaseVersioning].[Table_Columns]') IS NOT NULL
	DROP FUNCTION [DatabaseVersioning].[Table_Columns];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [DatabaseVersioning].[Table_Columns] (@SchemaName NVARCHAR(255),
    @TableName NVARCHAR(255))
RETURNS NVARCHAR(MAX /*NQC*/)
AS
BEGIN
    RETURN (   SELECT   STRING_AGG(C.name, ',')
                 FROM   sys.columns AS C
                WHERE   C.object_id = OBJECT_ID(@SchemaName + '.' + @TableName));
END;
GO
