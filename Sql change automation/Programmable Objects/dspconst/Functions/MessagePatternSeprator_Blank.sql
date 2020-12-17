IF OBJECT_ID('[dspconst].[MessagePatternSeprator_Blank]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternSeprator_Blank];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[MessagePatternSeprator_Blank] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
