IF OBJECT_ID('[dspconst].[InboxMessageProcessState_InProcess]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_InProcess];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_InProcess]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 5;
END;
GO
