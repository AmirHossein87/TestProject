IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomNumber]') IS NOT NULL
	DROP FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspInboxMessage].[InboxMessageProcessSendMessageTag_RandomNumber] ()
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    RETURN '@@RandomNumber';
END;
GO
