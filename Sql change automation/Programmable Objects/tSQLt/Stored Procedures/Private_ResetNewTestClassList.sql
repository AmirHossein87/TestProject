IF OBJECT_ID('[tSQLt].[Private_ResetNewTestClassList]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_ResetNewTestClassList];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_ResetNewTestClassList]
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM tSQLt.Private_NewTestClassList;
END;
GO
