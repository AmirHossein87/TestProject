IF OBJECT_ID('[SQLCop].[test Auto close]') IS NOT NULL
	DROP PROCEDURE [SQLCop].[test Auto close];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [SQLCop].[test Auto close]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBAdmin/sql-server-auto-close
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    Select @Output = @Output + 'Database set to Auto Close' + Char(13) + Char(10)
    Where   DatabaseProperty(db_name(), 'IsAutoClose') = 1

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBAdmin/sql-server-auto-close'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;
GO
