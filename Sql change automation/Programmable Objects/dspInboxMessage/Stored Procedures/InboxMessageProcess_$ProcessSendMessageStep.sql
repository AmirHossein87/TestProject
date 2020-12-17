IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessSendMessageStep]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessSendMessageStep];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessSendMessageStep]
    @MessagePatternStepTypeId INT, @SendMessageValue TSTRING, @ProviderInfoId INT, @Address TSTRING, @MessagePatternStepId INT
AS
BEGIN
    -- Declare const variable
    DECLARE @StepType_SendMessage INT = dspconst.MessagePatternStepType_SendMessage();

    -- If StepType is not send message so return
    IF (@MessagePatternStepTypeId <> @StepType_SendMessage) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Invalid SteptypeId in send message';

    -- Call Api.SendMessage
    EXEC dspInboxMessage.InboxMessageProcess_$SendReplyMessage @ProviderInfoId = @ProviderInfoId, @Address = @Address, @SendMessageValue = @SendMessageValue,
        @MessagePatternStepId = @MessagePatternStepId;
END;

GO
