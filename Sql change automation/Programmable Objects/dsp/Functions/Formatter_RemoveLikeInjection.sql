IF OBJECT_ID('[dsp].[Formatter_RemoveLikeInjection]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_RemoveLikeInjection];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_RemoveLikeInjection] (@Value TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @Value = dsp.Formatter_FormatString(@Value);
	SET @Value = REPLACE(@Value, '%', '');
	SET @Value = REPLACE(@Value, '[', '');
	SET @Value = REPLACE(@Value, '_', '[_]');

	RETURN @Value;
END;



GO
