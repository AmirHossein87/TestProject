IF OBJECT_ID('[dspconst].[InboxMessageProcessState_Processed]') IS NOT NULL
	DROP FUNCTION [dspconst].[InboxMessageProcessState_Processed];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[InboxMessageProcessState_Processed] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 2;
END;
GO
