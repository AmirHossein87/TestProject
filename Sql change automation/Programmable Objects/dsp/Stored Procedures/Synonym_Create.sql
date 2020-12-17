IF OBJECT_ID('[dsp].[Synonym_Create]') IS NOT NULL
	DROP PROCEDURE [dsp].[Synonym_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Synonym_Create]
	@SchemaName TSTRING, @SynonymName TSTRING, @ObjectName TSTRING
AS
BEGIN
	DECLARE @sql TSTRING;

	-- drop if already exists
	SET @sql = 'DROP SYNONYM IF EXISTS ' + @SchemaName + '.' + @SynonymName;
	EXEC (@sql);

	-- create synonym
	SET @sql = 'CREATE SYNONYM ' + @SchemaName + '.' + @SynonymName + ' FOR ' + @ObjectName;
	EXEC (@sql);
END;







GO
