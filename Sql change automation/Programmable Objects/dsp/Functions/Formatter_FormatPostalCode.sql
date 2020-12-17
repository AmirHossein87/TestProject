IF OBJECT_ID('[dsp].[Formatter_FormatPostalCode]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatPostalCode];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_FormatPostalCode] (@PostalCode TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @PostalCode = dsp.Formatter_FormatString(@PostalCode);
	RETURN IIF(ISNUMERIC(@PostalCode) = 1 AND LEN(@PostalCode) = 10, @PostalCode, NULL);
END;

GO
