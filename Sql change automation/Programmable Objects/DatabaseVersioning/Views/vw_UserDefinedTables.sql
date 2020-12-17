IF OBJECT_ID('[DatabaseVersioning].[vw_UserDefinedTables]') IS NOT NULL
	DROP VIEW [DatabaseVersioning].[vw_UserDefinedTables];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DatabaseVersioning].[vw_UserDefinedTables]
AS
SELECT  T.object_id AS ObjectId, S.name AS SchemaName, T.name AS TableName
  FROM  sys.tables T
        INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
 WHERE  LOWER(S.name) NOT LIKE N'tsqlt%' AND LOWER(T.name) NOT LIKE '%history';
GO
