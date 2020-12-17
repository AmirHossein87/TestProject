IF OBJECT_ID('[dspconst].[MessagePatternStateId_Canceled]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStateId_Canceled];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternStateId_Canceled] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;
GO
