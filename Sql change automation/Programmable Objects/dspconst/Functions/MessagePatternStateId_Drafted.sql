IF OBJECT_ID('[dspconst].[MessagePatternStateId_Drafted]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStateId_Drafted];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternStateId_Drafted] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
