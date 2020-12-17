IF OBJECT_ID('[dspconst].[MessagePatternSeprator_Sharp]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternSeprator_Sharp];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternSeprator_Sharp] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
