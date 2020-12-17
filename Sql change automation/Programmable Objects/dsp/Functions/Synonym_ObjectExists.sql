IF OBJECT_ID('[dsp].[Synonym_ObjectExists]') IS NOT NULL
	DROP FUNCTION [dsp].[Synonym_ObjectExists];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Synonym_ObjectExists] (@SchemaName TSTRING,
	@SynonymName TSTRING)
RETURNS BIT
BEGIN
	RETURN IIF(
		EXISTS (SELECT		1 FROM sys.synonyms WHERE name = @SynonymName AND schema_id = SCHEMA_ID(@SchemaName) AND
														base_object_name NOT LIKE '%NullServer%'),
		1,
		0);
END;


GO
