IF OBJECT_ID('[dspconst].[TemporalType_Temporal]') IS NOT NULL
	DROP FUNCTION [dspconst].[TemporalType_Temporal];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [dspconst].[TemporalType_Temporal]() 
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;

GO
