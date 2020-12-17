IF OBJECT_ID('[dspconst].[InboxMessageProcessState_CustomConfirmFailed]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_CustomConfirmFailed];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_CustomConfirmFailed]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 9;
END;
GO
