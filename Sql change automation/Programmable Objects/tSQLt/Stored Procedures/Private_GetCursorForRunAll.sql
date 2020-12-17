IF OBJECT_ID('[tSQLt].[Private_GetCursorForRunAll]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_GetCursorForRunAll];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_GetCursorForRunAll]
  @TestClassCursor CURSOR VARYING OUTPUT
AS
BEGIN
  SET @TestClassCursor = CURSOR LOCAL FAST_FORWARD FOR
   SELECT Name
     FROM tSQLt.TestClasses;

  OPEN @TestClassCursor;
END;
GO
