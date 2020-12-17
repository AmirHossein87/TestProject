IF OBJECT_ID('[DatabaseVersioning].[Table_HasColumnName]') IS NOT NULL
	DROP FUNCTION [DatabaseVersioning].[Table_HasColumnName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [DatabaseVersioning].[Table_HasColumnName] (@ObjectId INT,
    @ColumName TSTRING)
RETURNS TABLE
AS
RETURN SELECT TOP 1 1 AS HasColumn
         FROM   sys.columns AS C
        WHERE   C.object_id = @ObjectId --
           AND  C.name = @ColumName;
GO
