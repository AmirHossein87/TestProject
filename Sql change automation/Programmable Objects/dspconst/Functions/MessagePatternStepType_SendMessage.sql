IF OBJECT_ID('[dspconst].[MessagePatternStepType_SendMessage]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_SendMessage];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_SendMessage] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;
GO
