IF OBJECT_ID('[tSQLt].[RunWithNullResults]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[RunWithNullResults];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[RunWithNullResults]
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
  EXEC tSQLt.Run @TestName = @TestName, @TestResultFormatter = 'tSQLt.NullTestResultFormatter';
END;
GO
