IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessConfirmStep]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessConfirmStep];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessConfirmStep]
    @MessagePatternStepTypeId INT, @ProviderInfoId INT, @Address TSTRING, @MessageBody TSTRING, @DefaultValue TSTRING, @ConfirmHasCustomValidation BIT,
    @WaitStepId INT, @MessagePatternStepId INT, @SendMessageValue TSTRING, @MessageLastData TJSON = NULL OUTPUT, @DoBreak BIT = NULL OUTPUT,
    @InboxMessageProcessStateId INT = NULL OUTPUT
AS
BEGIN
    DECLARE @ConfirmValue TSTRING;

    -- Declare const variable
    DECLARE @StepType_Confirm INT = dspconst.MessagePatternStepType_Confirm();
    DECLARE @InboxMessageProcessKeyTag_ConfirmValue TSTRING = dspInboxMessage.InboxMessageProcessKeyTag_ConfirmValue();
    SET @DoBreak = 1;

    -- If StepType is not confirm message, so return
    IF (@MessagePatternStepTypeId <> @StepType_Confirm) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Invalid StepType in confirm';

    -- If current message is reply message, validate message value
    IF (@WaitStepId IS NOT NULL AND @WaitStepId = @MessagePatternStepId)
    BEGIN
        DECLARE @CustomConfirmationIsValid BIT = 0;
        IF @ConfirmHasCustomValidation = 1
            EXEC dspInboxMessage.[InboxMessageProcess_$ValidateCustomConfirmValue] @ProviderInfoId = @ProviderInfoId, @Address = @Address,
                @MessageBody = @MessageBody, @IsValid = @CustomConfirmationIsValid;
        ELSE
            -- Get ConfirmValue
            SELECT  @ConfirmValue = MsgValue
              FROM  dspInboxMessage.MessageLastData_ReadJson(@MessageLastData)
             WHERE  MsgKey = @InboxMessageProcessKeyTag_ConfirmValue;

        -- Validate ConfirmValue
        IF (@CustomConfirmationIsValid = 1 OR   @ConfirmValue IS NULL OR (@ConfirmValue IS NOT NULL AND @MessageBody = @ConfirmValue))
            SET @DoBreak = 0;
        ELSE
        BEGIN
            SET @InboxMessageProcessStateId = dspconst.InboxMessageProcessState_CustomConfirmFailed();

            -- Get from setting
            EXEC dspInboxMessage.Setting_GetProps @FailedConfirmStepMessage = @SendMessageValue OUTPUT;

            -- Call send message
            IF @SendMessageValue IS NOT NULL
                EXEC dspInboxMessage.[InboxMessageProcess_$SendReplyMessage] @ProviderInfoId = @ProviderInfoId, @Address = @Address,
                    @SendMessageValue = @SendMessageValue, @MessagePatternStepId = @MessagePatternStepId;
        END;

        RETURN;
    END;

    -- Prepare message to send
    -- Prpare @@RandomString
    EXEC dspInboxMessage.[Message_$BuildByDynamicExpression] @Message = @SendMessageValue, @DefaultValue = @DefaultValue,
        @ConfirmHasCustomValidation = @ConfirmHasCustomValidation, @ResultMessage = @SendMessageValue OUTPUT, @ConfirmValue = @ConfirmValue OUTPUT;

    IF @ConfirmHasCustomValidation = 1
        SET @ConfirmValue = 'CustomConfirmValidation';

    -- Call send message
    EXEC dspInboxMessage.[InboxMessageProcess_$SendReplyMessage] @ProviderInfoId = @ProviderInfoId, @Address = @Address, @SendMessageValue = @SendMessageValue,
        @MessagePatternStepId = @MessagePatternStepId;

    -- Delete all key with confirm tag and insert new confirm tag into LastData
    SET @MessageLastData = (   SELECT   *
                                 FROM   dspInboxMessage.MessageLastData_ReadJson(@MessageLastData)
                                WHERE   MsgKey <> @InboxMessageProcessKeyTag_ConfirmValue
                               FOR JSON AUTO);

    -- insert new confirm tag into LastData
    SET @MessageLastData =
        dspInboxMessage.[InboxMessageProcess_$AppendToMessageLastData](@MessageLastData, @InboxMessageProcessKeyTag_ConfirmValue, @ConfirmValue);

    -- insert into waitReply table with new LastData
    EXEC dspInboxMessage.[InboxMessageProcess_$CreateWaitForReplyMessage] @Address = @Address, @MessagePatternStepId = @MessagePatternStepId,
        @MessageLastData = @MessageLastData, @ProviderInfoId = @ProviderInfoId;
END;
GO
