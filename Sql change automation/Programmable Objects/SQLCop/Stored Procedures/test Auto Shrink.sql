IF OBJECT_ID('[SQLCop].[test Auto Shrink]') IS NOT NULL
	DROP PROCEDURE [SQLCop].[test Auto Shrink];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [SQLCop].[test Auto Shrink]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://www.sqlskills.com/blogs/paul/post/Auto-shrink-e28093-turn-it-OFF!.aspx
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    Select @Output = @Output + 'Database set to Auto Shrink' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoShrink') = 1
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://www.sqlskills.com/blogs/paul/post/Auto-shrink-e28093-turn-it-OFF!.aspx'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;
GO
