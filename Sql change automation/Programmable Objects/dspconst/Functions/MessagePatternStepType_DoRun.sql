IF OBJECT_ID('[dspconst].[MessagePatternStepType_DoRun]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_DoRun];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_DoRun]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 6;
END;
GO
