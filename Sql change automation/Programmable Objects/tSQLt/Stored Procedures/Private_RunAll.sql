IF OBJECT_ID('[tSQLt].[Private_RunAll]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_RunAll];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_RunAll]
  @TestResultFormatter NVARCHAR(MAX)
AS
BEGIN
  EXEC tSQLt.Private_RunCursor @TestResultFormatter = @TestResultFormatter, @GetCursorCallback = 'tSQLt.Private_GetCursorForRunAll';
END;
GO
