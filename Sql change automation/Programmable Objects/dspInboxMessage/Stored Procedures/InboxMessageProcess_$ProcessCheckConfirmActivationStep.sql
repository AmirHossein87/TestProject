IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessCheckConfirmActivationStep]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessCheckConfirmActivationStep];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessCheckConfirmActivationStep]
    @MessagePatternStepId INT, @ProviderInfoId INT, @Address TSTRING, @DoBreak BIT = NULL OUTPUT, @InboxMessageProcessStateId INT = NULL OUTPUT
AS
BEGIN
    DECLARE @IsActive BIT;
	DECLARE @FaildConfirmActivationMessage TSTRING;
    DECLARE @MessagePatternId INT = (   SELECT  MessagePatternId
                                          FROM  dspInboxMessage.MessagePatternStep
                                         WHERE  MessagePatternStepId = @MessagePatternStepId);

    SET @DoBreak = 0;

    -- Check custom confirm validation existance
    IF dspInboxMessage.[MessagePatternStep_HasCustomConfirmValidation](@MessagePatternId) = 1
    BEGIN
        -- Call client api for check custom validation activation
        EXEC dspInboxMessage.InboxMessageProcess_$CheckCustomConfirmValueActivation @ProviderInfoId = @ProviderInfoId, @Address = @Address,
            @IsActive = @IsActive OUTPUT;

        -- if is not active then exit process and send error message to user address
        IF @IsActive = 0
        BEGIN
            SET @DoBreak = 1;
            SET @InboxMessageProcessStateId = dspconst.InboxMessageProcessState_CustomConfirmNotActive();
            EXEC dspInboxMessage.Setting_GetProps @FaildConfirmActivationMessage = @FaildConfirmActivationMessage OUTPUT;
            SET @MessagePatternStepId = (   SELECT TOP 1    MessagePatternStepId
                                              FROM  dspInboxMessage.MessagePatternStep
                                             WHERE  MessagePatternId = @MessagePatternId
                                             ORDER BY [Order]);
            IF @FaildConfirmActivationMessage IS NOT NULL
                EXEC dspInboxMessage.[InboxMessageProcess_$SendReplyMessage] @ProviderInfoId = @ProviderInfoId, @Address = @Address,
                    @SendMessageValue = @FaildConfirmActivationMessage, @MessagePatternStepId = @MessagePatternStepId;
        END;
    END;
END;
GO
