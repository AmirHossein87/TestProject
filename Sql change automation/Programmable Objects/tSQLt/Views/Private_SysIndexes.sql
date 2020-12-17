IF OBJECT_ID('[tSQLt].[Private_SysIndexes]') IS NOT NULL
	DROP VIEW [tSQLt].[Private_SysIndexes];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [tSQLt].[Private_SysIndexes] AS SELECT * FROM sys.indexes;
GO
