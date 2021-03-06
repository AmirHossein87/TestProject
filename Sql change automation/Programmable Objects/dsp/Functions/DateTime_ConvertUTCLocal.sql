IF OBJECT_ID('[dsp].[DateTime_ConvertUTCLocal]') IS NOT NULL
	DROP FUNCTION [dsp].[DateTime_ConvertUTCLocal];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dsp].[DateTime_ConvertUTCLocal] (@UTCDate DATETIME2)
RETURNS DATETIME
WITH SCHEMABINDING
AS
BEGIN

    RETURN DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), GETDATE()), @UTCDate);

END;

GO
