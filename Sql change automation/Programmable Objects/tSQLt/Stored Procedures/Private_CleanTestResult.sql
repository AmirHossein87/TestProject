IF OBJECT_ID('[tSQLt].[Private_CleanTestResult]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_CleanTestResult];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_CleanTestResult]
AS
BEGIN
   DELETE FROM tSQLt.TestResult;
END;
GO