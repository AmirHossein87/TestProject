IF OBJECT_ID('[dspconst].[RequestIntervalType_Day]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestIntervalType_Day];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestIntervalType_Day] ()
RETURNS TINYINT
AS
BEGIN
    RETURN 3;
END;
GO
