IF OBJECT_ID('[dsp].[Formatter_FormatNumeric]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatNumeric];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dsp].[Formatter_FormatNumeric] (@NumberStr TSTRING)
RETURNS TSTRING
AS
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@NumberStr, '*', ''), '-', ''), '_', ''), '/', ''), ' ', ''), '#', '');
END;


GO
