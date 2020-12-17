IF OBJECT_ID('[dspconst].[MessagePatternStepType_DoCheckConfirmActivation]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStepType_DoCheckConfirmActivation];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStepType_DoCheckConfirmActivation]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 7;
END;
GO
