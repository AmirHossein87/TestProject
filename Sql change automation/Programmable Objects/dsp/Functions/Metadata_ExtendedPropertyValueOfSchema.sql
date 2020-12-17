IF OBJECT_ID('[dsp].[Metadata_ExtendedPropertyValueOfSchema]') IS NOT NULL
	DROP FUNCTION [dsp].[Metadata_ExtendedPropertyValueOfSchema];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Metadata_ExtendedPropertyValueOfSchema] (@SchemaName TSTRING,
	@ExtendedPropertyName TSTRING)
RETURNS SQL_VARIANT
AS
BEGIN
	DECLARE @Value SQL_VARIANT;

	SELECT	@Value = value
	FROM	sys.fn_listextendedproperty(NULL, 'SCHEMA', NULL, NULL, NULL, NULL, NULL)
	WHERE	objname = @SchemaName AND	name = @ExtendedPropertyName;

	RETURN @Value;
END;

GO
