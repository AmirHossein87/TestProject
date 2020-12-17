IF OBJECT_ID('[dspconst].[MessagePatternStepType_InputParam]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_InputParam];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_InputParam] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
