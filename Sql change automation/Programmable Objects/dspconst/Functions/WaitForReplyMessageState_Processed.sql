IF OBJECT_ID('[dspconst].[WaitForReplyMessageState_Processed]') IS NOT NULL
	DROP FUNCTION [dspconst].[WaitForReplyMessageState_Processed];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[WaitForReplyMessageState_Processed] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
