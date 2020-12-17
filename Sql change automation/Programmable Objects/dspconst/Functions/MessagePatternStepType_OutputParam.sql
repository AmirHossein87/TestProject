IF OBJECT_ID('[dspconst].[MessagePatternStepType_OutputParam]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_OutputParam];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_OutputParam] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
