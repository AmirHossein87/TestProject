IF OBJECT_ID('[tSQLt].[Private_SysTypes]') IS NOT NULL
	DROP VIEW [tSQLt].[Private_SysTypes];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [tSQLt].[Private_SysTypes] AS SELECT * FROM sys.types AS T;
GO