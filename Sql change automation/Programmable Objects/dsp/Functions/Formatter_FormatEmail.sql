IF OBJECT_ID('[dsp].[Formatter_FormatEmail]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatEmail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_FormatEmail] (@Email TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @Email = dsp.Formatter_FormatString(@Email);
	RETURN IIF(dsp.Validate_IsValidEmail(@Email) = 1, @Email, NULL);
END;

GO
