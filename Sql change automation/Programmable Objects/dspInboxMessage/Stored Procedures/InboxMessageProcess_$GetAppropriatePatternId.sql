IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$GetAppropriatePatternId]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetAppropriatePatternId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetAppropriatePatternId]
    @MessageBody TSTRING, @MessageTime DATETIME, @Address TSTRING, @ProviderInfoId INT, --
    @MessagePatternId INT OUTPUT, @MessageLastData TJSON OUTPUT, @WaitStepId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Find in wait for reply
    EXEC dspInboxMessage.[InboxMessageProcess_$GetMessagePatternIdByWaitForReply] @MessageTime = @MessageTime, @Address = @Address,
        @ProviderInfoId = @ProviderInfoId, @MessagePatternId = @MessagePatternId OUTPUT, @MessageLastData = @MessageLastData OUTPUT,
        @WaitStepId = @WaitStepId OUTPUT;
    -- Process PatternId if not found in wait table
    IF @MessagePatternId IS NULL
        SET @MessagePatternId = dspInboxMessage.InboxMessageProcess_$GetMessagePatternIdByCoding(@MessageBody, @MessageTime);
END;
GO
