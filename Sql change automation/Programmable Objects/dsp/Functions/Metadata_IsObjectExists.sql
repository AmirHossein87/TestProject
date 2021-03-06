IF OBJECT_ID('[dsp].[Metadata_IsObjectExists]') IS NOT NULL
	DROP FUNCTION [dsp].[Metadata_IsObjectExists];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Metadata_IsObjectExists] (@SchemaName TSTRING,
	@ObjectName TSTRING,
	@TypeName TSTRING)
RETURNS BIT
BEGIN

	DECLARE @IsExist BIT = 0;
	SELECT	@IsExist = 1
	FROM	sys.objects AS O
			INNER JOIN sys.schemas
AS		S ON O.schema_id = S.schema_id
	WHERE	S.name = @SchemaName --
		AND O.name = @ObjectName --
		AND O.type = @TypeName;
	RETURN @IsExist;

END;
GO
