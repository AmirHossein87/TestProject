IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_Refresh]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_Refresh];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_Refresh]
AS
BEGIN
    -- Process MAX value of InboxMessageId
    DECLARE @MaxInboxMessageId BIGINT = ISNULL((SELECT  MAX(InboxMessageId) FROM    dspInboxMessage.InboxMessage), 0);

    -- Process not registered address
    EXEC dspInboxMessage.[InboxMessageProcess_$ProcessNotRegisteredAddress] @MaxInboxMessageId = @MaxInboxMessageId;

    -- Get nex InboxMessagerocess for process
    DECLARE @GetNextBulkResult TJSON;
    EXEC dspInboxMessage.[InboxMessageProcess_$GetNextBulk] @MaxInboxMessageId = @MaxInboxMessageId, @InboxMessageItems = @GetNextBulkResult OUTPUT;

    -- Process items
    -- This function guarantees that handle exception
    DECLARE @InboxMessageResultItems TJSON;
    EXEC dspInboxMessage.[InboxMessageProcess_$ProcessItems] @InboxMessageItems = @GetNextBulkResult, @InboxMessageResultItems = @InboxMessageResultItems OUTPUT;

    -- Set state
    EXEC dspInboxMessage.InboxMessageProcess_$SetState @InboxMessageItems = @InboxMessageResultItems;
END;

GO
