IF OBJECT_ID('[dspconst].[RequestIntervalType_DayOfWeek]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestIntervalType_DayOfWeek];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestIntervalType_DayOfWeek] ()
RETURNS TINYINT
AS
BEGIN
    RETURN 4;
END;
GO
