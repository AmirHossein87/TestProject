IF OBJECT_ID('[dspconst].[InboxMessageProcessState_CustomConfirmNotActive]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_CustomConfirmNotActive];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_CustomConfirmNotActive]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 8;
END;
GO
