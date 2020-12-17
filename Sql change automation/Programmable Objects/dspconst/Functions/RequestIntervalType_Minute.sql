IF OBJECT_ID('[dspconst].[RequestIntervalType_Minute]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestIntervalType_Minute];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestIntervalType_Minute] ()
RETURNS TINYINT
AS
BEGIN
    RETURN 1;
END;
GO
