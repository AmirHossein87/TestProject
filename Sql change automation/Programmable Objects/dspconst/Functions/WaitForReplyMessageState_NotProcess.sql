IF OBJECT_ID('[dspconst].[WaitForReplyMessageState_NotProcess]') IS NOT NULL
	DROP FUNCTION [dspconst].[WaitForReplyMessageState_NotProcess];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[WaitForReplyMessageState_NotProcess] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;
GO
