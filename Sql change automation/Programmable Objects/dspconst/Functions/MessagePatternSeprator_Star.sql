IF OBJECT_ID('[dspconst].[MessagePatternSeprator_Star]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternSeprator_Star];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   FUNCTION [dspconst].[MessagePatternSeprator_Star] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;
GO
