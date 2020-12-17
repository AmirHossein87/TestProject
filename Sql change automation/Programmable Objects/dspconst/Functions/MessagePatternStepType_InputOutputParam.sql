IF OBJECT_ID('[dspconst].[MessagePatternStepType_InputOutputParam]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_InputOutputParam];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_InputOutputParam] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;
GO
