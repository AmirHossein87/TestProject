IF OBJECT_ID('[dspconst].[MessagePatternStateId_Paused]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStateId_Paused];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternStateId_Paused] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;
GO
