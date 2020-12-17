IF OBJECT_ID('[dspconst].[TemporalType_Lookup]') IS NOT NULL
	DROP FUNCTION [dspconst].[TemporalType_Lookup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    FUNCTION [dspconst].[TemporalType_Lookup] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;




GO
