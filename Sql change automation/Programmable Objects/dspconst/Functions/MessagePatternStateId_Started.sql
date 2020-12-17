IF OBJECT_ID('[dspconst].[MessagePatternStateId_Started]') IS NOT NULL
	DROP FUNCTION [dspconst].[MessagePatternStateId_Started];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[MessagePatternStateId_Started] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
