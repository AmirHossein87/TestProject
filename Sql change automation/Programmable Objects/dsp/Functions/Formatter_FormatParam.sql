IF OBJECT_ID('[dsp].[Formatter_FormatParam]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatParam];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_FormatParam] (@Param TSTRING)
RETURNS TSTRING
AS
BEGIN
	-- return nothing has been set
	IF (dsp.Param_IsSetString(@Param) = 0)
		RETURN '<notset>';

	-- set <null> string for NULL to indicate the value is null
	RETURN ISNULL(@Param, '<null>');
END;




GO
