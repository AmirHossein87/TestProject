IF OBJECT_ID('[dspconst].[InboxMessageProcessState_NotProcessed]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_NotProcessed];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_NotProcessed] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
