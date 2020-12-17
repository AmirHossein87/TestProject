IF OBJECT_ID('[dsp].[Formatter_FormatNationalNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_FormatNationalNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_FormatNationalNumber] (@NationalNumber TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @NationalNumber = REPLACE(dsp.Formatter_FormatString(@NationalNumber), '-', '');
	RETURN IIF(ISNUMERIC(@NationalNumber) = 1 AND LEN(@NationalNumber) = 10, @NationalNumber, NULL);
END;

GO
