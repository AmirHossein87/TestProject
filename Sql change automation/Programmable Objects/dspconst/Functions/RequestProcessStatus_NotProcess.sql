IF OBJECT_ID('[dspconst].[RequestProcessStatus_NotProcess]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessStatus_NotProcess];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestProcessStatus_NotProcess] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;

GO
