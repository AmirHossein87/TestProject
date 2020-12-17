IF OBJECT_ID('[dsp].[Formatter_RedactCardNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[Formatter_RedactCardNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Formatter_RedactCardNumber] (@CardNumber NVARCHAR(/*NoCodeQuality*/4000))
RETURNS NVARCHAR(/*NoCodeQuality*/4000)
WITH SCHEMABINDING
AS
BEGIN
    SET @CardNumber = dsp.Formatter_FormatString(@CardNumber);
    RETURN LEFT(@CardNumber, 6) + REPLICATE('x', LEN(@CardNumber) - 6 - 4) + RIGHT(@CardNumber, 4);
END;





GO
