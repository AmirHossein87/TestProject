IF OBJECT_ID('[dspconst].[TemporalType_Transactional]') IS NOT NULL
	DROP FUNCTION [dspconst].[TemporalType_Transactional];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dspconst].[TemporalType_Transactional]() 
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;





GO
