IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessSendMessageTag_DefaultValue]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_DefaultValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_DefaultValue] ()
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    RETURN '@@DefaultValue';
END;
GO
