IF OBJECT_ID('[dsp].[Formatter_FormatCardNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatCardNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_FormatCardNumber] (@CardNumber TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @CardNumber = dsp.Formatter_FormatString(@CardNumber);
	SET @CardNumber = REPLACE(@CardNumber, ' ', '');
	SET @CardNumber = REPLACE(@CardNumber, '-', '');
	SET @CardNumber = REPLACE(@CardNumber, '$', '');
	RETURN IIF(ISNUMERIC(@CardNumber) = 1 AND (LEN(@CardNumber) = 16 OR		LEN(@CardNumber) = 20), @CardNumber, NULL);
END;

GO
