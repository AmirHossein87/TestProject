IF OBJECT_ID('[dspconst].[WaitForReplyMessageState_Expired]') IS NOT NULL
	DROP FUNCTION [dspconst].[WaitForReplyMessageState_Expired];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[WaitForReplyMessageState_Expired] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
