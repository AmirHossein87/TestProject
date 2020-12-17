IF OBJECT_ID('[dspconst].[RequestProcessStatus_InProgress]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessStatus_InProgress];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestProcessStatus_InProgress] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
