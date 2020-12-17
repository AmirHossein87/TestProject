IF OBJECT_ID('[dsp].[StringTable_Value]') IS NOT NULL
	DROP FUNCTION [dsp].[StringTable_Value];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	FUNCTION [dsp].[StringTable_Value] (@StringId TSTRING)
RETURNS TSTRING
AS
BEGIN
	DECLARE @Value TSTRING;

	SELECT	@Value = ST.StringValue
	FROM	dsp.StringTable AS ST
	WHERE	ST.StringId = @StringId;

	RETURN dsp.String_ReplaceEnter(@Value);
END;


GO
