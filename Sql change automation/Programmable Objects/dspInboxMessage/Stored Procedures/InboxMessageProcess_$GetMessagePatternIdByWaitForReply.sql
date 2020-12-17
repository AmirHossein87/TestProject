IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByWaitForReply]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByWaitForReply];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetMessagePatternIdByWaitForReply]
    @MessageTime DATETIME, @Address TSTRING, @ProviderInfoId INT, --
    @MessagePatternId INT OUTPUT, @MessageLastData TJSON OUTPUT, @WaitStepId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Declare variables
    DECLARE @WaitForReplyMessageId BIGINT;
    DECLARE @WaitCreateTime DATETIME;
    DECLARE @ExpirationTreshold INT;
    DECLARE @WaitForReplyMessageStateId TINYINT;

    -- Get ExpirationTreshold from setting
    EXEC dspInboxMessage.Setting_GetProps @WaitExpirationTreshold = @ExpirationTreshold OUTPUT;

    -- Initialize output parameter
    SET @WaitForReplyMessageId = NULL;
    SET @MessagePatternId = NULL;
    SET @MessageLastData = NULL;
    SET @WaitStepId = NULL;

    -- Find first not processed item in wait for reply messages
    -- Index IX_AddressProviderInfoId
    SELECT TOP (1)  @WaitForReplyMessageId = W.WaitForReplyMessageId, @MessagePatternId = Step.MessagePatternId, @MessageLastData = W.MessageLastData,
        @WaitStepId = W.MessagePatternStepId, @WaitCreateTime = W.CreatedTime,
        @WaitForReplyMessageStateId = /*dspconst.WaitForReplyMessageState_Processed()*/ 1
      FROM  dspInboxMessage.WaitForReplyMessage W
            INNER JOIN dspInboxMessage.MessagePatternStep Step ON W.MessagePatternStepId = Step.MessagePatternStepId
     WHERE  W.WaitForReplyMessageStateId = /*dspconst.WaitForReplyMessageState_NotProcess()*/ 3 --
        AND W.[Address] = @Address --
        AND W.ProviderInfoId = @ProviderInfoId
     ORDER BY W.CreatedTime;

    -- Validate wait expiration time
    IF (DATEDIFF(SECOND, @WaitCreateTime, @MessageTime) > @ExpirationTreshold)
    BEGIN
        SET @MessagePatternId = NULL;
        SET @MessageLastData = NULL;
        SET @WaitStepId = NULL;
        SET @WaitForReplyMessageStateId = dspconst.WaitForReplyMessageState_Expired();
    END;

    -- Update wait process status
    IF (@WaitForReplyMessageId IS NOT NULL)
    BEGIN
        UPDATE  WFRM
           SET  WaitForReplyMessageStateId = @WaitForReplyMessageStateId
          FROM  dspInboxMessage.WaitForReplyMessage WFRM
         WHERE  WaitForReplyMessageId = @WaitForReplyMessageId;
    END;
END;
GO
