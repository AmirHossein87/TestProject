IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomString]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomString] ()
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    RETURN '@@RandomString';
END;
GO
