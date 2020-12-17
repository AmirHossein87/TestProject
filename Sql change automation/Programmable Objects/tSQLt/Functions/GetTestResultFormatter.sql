IF OBJECT_ID('[tSQLt].[GetTestResultFormatter]') IS NOT NULL
	DROP FUNCTION [tSQLt].[GetTestResultFormatter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [tSQLt].[GetTestResultFormatter]()
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @FormatterName NVARCHAR(MAX);
    
    SELECT @FormatterName = CAST(value AS NVARCHAR(MAX))
    FROM sys.extended_properties
    WHERE name = N'tSQLt.ResultsFormatter'
      AND major_id = OBJECT_ID('tSQLt.Private_OutputTestResults');
      
    SELECT @FormatterName = COALESCE(@FormatterName, 'tSQLt.DefaultResultFormatter');
    
    RETURN @FormatterName;
END;
GO