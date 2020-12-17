IF OBJECT_ID('[tSQLt].[Private_OutputTestResults]') IS NOT NULL
	DROP PROCEDURE [tSQLt].[Private_OutputTestResults];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tSQLt].[Private_OutputTestResults]
  @TestResultFormatter NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Formatter NVARCHAR(MAX);
    SELECT @Formatter = COALESCE(@TestResultFormatter, tSQLt.GetTestResultFormatter());
    EXEC (@Formatter);
END
GO
