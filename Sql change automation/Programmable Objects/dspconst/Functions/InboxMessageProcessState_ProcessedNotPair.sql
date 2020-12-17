IF OBJECT_ID('[dspconst].[InboxMessageProcessState_ProcessedNotPair]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_ProcessedNotPair];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_ProcessedNotPair] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 3;
END;
GO
