IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$CreateWaitForReplyMessage]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$CreateWaitForReplyMessage];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$CreateWaitForReplyMessage]
    @Address TSTRING, @MessagePatternStepId INT, @MessageLastData TJSON, @ProviderInfoId INT, @WaitForReplyMessageId BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dspInboxMessage.WaitForReplyMessage (Address, MessagePatternStepId, MessageLastData, WaitForReplyMessageStateId, ProviderInfoId)
    VALUES (@Address, @MessagePatternStepId, @MessageLastData, dspconst.WaitForReplyMessageState_NotProcess(), @ProviderInfoId);

    SET @WaitForReplyMessageId = SCOPE_IDENTITY();
END;
GO
