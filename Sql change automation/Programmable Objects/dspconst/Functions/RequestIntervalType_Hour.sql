IF OBJECT_ID('[dspconst].[RequestIntervalType_Hour]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestIntervalType_Hour];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestIntervalType_Hour] ()
RETURNS TINYINT
AS
BEGIN
    RETURN 2;
END;
GO
