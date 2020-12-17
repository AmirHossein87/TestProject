IF OBJECT_ID('[dspconst].[Table_IsTemporalHistory]') IS NOT NULL
	DROP FUNCTION [dspconst].[Table_IsTemporalHistory];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [dspconst].[Table_IsTemporalHistory] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;                                                       
END;


GO
