IF OBJECT_ID('[dspconst].[InboxMessageProcessState_ProcessedFailed]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_ProcessedFailed];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_ProcessedFailed] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;
GO
