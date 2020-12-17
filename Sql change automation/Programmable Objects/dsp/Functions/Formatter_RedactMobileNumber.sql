IF OBJECT_ID('[dsp].[Formatter_RedactMobileNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_RedactMobileNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Formatter_RedactMobileNumber] (@MobileNumber TSTRING)
RETURNS TSTRING
BEGIN
	SET @MobileNumber = dsp.Formatter_FormatMobileNumber(@MobileNumber);
	IF (@MobileNumber IS NOT NULL)
		RETURN '*********' + SUBSTRING(@MobileNumber, LEN(@MobileNumber) - 1, 2);

	RETURN NULL;
END;



GO
