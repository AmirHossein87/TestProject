IF OBJECT_ID('[dspconst].[RequestProcessStatus_Fail]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessStatus_Fail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestProcessStatus_Fail] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 5;
END;
GO
