IF OBJECT_ID('[dspconst].[MessagePatternSeprator_DollorSign]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternSeprator_DollorSign];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternSeprator_DollorSign] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 5;
END;
GO
