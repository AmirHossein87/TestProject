IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessKeyTag_ConfirmValue]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_ConfirmValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspInboxMessage].[InboxMessageProcessKeyTag_ConfirmValue] ()
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    RETURN 'ConfirmValue';
END;
GO
