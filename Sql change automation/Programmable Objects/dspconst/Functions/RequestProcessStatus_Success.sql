IF OBJECT_ID('[dspconst].[RequestProcessStatus_Success]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessStatus_Success];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestProcessStatus_Success] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;

GO
