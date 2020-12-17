IF OBJECT_ID('[dspconst].[TemporalType_Ordinary]') IS NOT NULL
	DROP FUNCTION [dspconst].[TemporalType_Ordinary];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[TemporalType_Ordinary] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;




GO
