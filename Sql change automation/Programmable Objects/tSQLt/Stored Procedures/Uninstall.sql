IF OBJECT_ID('[tSQLt].[Uninstall]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Uninstall];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Uninstall]
AS
BEGIN
  DROP TYPE tSQLt.Private;

  EXEC tSQLt.DropClass 'tSQLt';  
  
  DROP ASSEMBLY tSQLtCLR;
END;
GO
