IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$SetState]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$SetState];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$SetState]
    @InboxMessageItems TJSON
AS
BEGIN
    -- Update ProcessStateId 
    UPDATE  IM
       SET  IM.MessagePatternId = Items.MessagePatternId, --
        IM.InboxMessageProcessStateId = Items.InboxMessageProcessStateId, --
        IM.ProcessEndTime = GETDATE(), --
        IM.Error = Items.Error
      FROM
        OPENJSON(@InboxMessageItems)
        WITH (InboxMessageId BIGINT, MessagePatternId INT, InboxMessageProcessStateId INT, Error TJSON) Items
        INNER JOIN dspInboxMessage.InboxMessage IM ON IM.InboxMessageId = Items.InboxMessageId;
END;

GO
