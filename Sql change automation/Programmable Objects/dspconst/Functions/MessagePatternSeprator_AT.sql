IF OBJECT_ID('[dspconst].[MessagePatternSeprator_AT]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternSeprator_AT];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternSeprator_AT] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;
GO
