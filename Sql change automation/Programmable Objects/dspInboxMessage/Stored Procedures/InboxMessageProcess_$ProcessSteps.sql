IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessSteps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessSteps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessSteps]
    @MessagePatternId INT, @WaitStepId BIGINT, @ProviderInfoId INT, @Address TSTRING, @MessageBody TSTRING, @MessageLastData TJSON OUTPUT,
    @InboxMessageProcessStateId INT = NULL OUTPUT, @ErrorMessage TJSON = NULL OUTPUT
AS
BEGIN
    -- Consts
    DECLARE @StepType_InputParam INT = dspconst.MessagePatternStepType_InputParam();
    DECLARE @StepType_OutputParam INT = dspconst.MessagePatternStepType_OutputParam();
    DECLARE @StepType_InputOutputParam INT = dspconst.MessagePatternStepType_InputOutputParam();
    DECLARE @StepType_SendMessage INT = dspconst.MessagePatternStepType_SendMessage();
    DECLARE @StepType_Confirm INT = dspconst.MessagePatternStepType_Confirm();
    DECLARE @StepType_DoRun INT = dspconst.MessagePatternStepType_DoRun();
    DECLARE @StepType_DoCheckConfirmActivation INT = dspconst.MessagePatternStepType_DoCheckConfirmActivation();

    -- Declare variables
    DECLARE @MessagePatternSeprator TSTRING;
    DECLARE @MessagePatternStepId INT;
    DECLARE @MessagePatternStepTypeId INT;
    DECLARE @ParameterName TSTRING;
    DECLARE @SendMessageValue TSTRING;
    DECLARE @DefaultValue TSTRING;
    DECLARE @ConfirmHasCustomValidation BIT;
    DECLARE @HasCustomValue BIT;

    DECLARE @UsedMessageBodyCurrentValue BIT;
    DECLARE @MessageBodyCurrentValue TSTRING;

    DECLARE @DoBreak BIT;

    -- Call GetProps of MessagePattern
    EXEC dspInboxMessage.MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @MessagePatternSeprator = @MessagePatternSeprator OUTPUT;

    -- Get latest done step order
    DECLARE @LastOrder INT = ISNULL((   SELECT  [Step].[Order]
                                          FROM  dspInboxMessage.MessagePatternStep Step
                                         WHERE  Step.MessagePatternStepId = ISNULL(@WaitStepId, 0)), 0);

    -- Cursor for pattern all steps
    DECLARE StepsCursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  MessagePatternStepId, MPS.MessagePatternStepTypeId, MPS.ParameterName, MPS.SendMessageValue, MPS.DefaultValue, MPS.ConfirmHasCustomValidation,
        MPS.HasCustomValue
      FROM  dspInboxMessage.MessagePatternStep MPS
     WHERE  MessagePatternId = @MessagePatternId --
        AND [Order] >= @LastOrder
     ORDER BY [Order];

    OPEN StepsCursor;

    -- Calculate current index of parameters in process scenario
    DECLARE @UseableIndexOfMessageBody INT = IIF(@WaitStepId IS NULL, 2, 1);

    -- Variable for detect all steps proceed and related procedure must run
    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM StepsCursor
         INTO @MessagePatternStepId, @MessagePatternStepTypeId, @ParameterName, @SendMessageValue, @DefaultValue, @ConfirmHasCustomValidation, @HasCustomValue;

        IF (@@FETCH_STATUS <> 0)
        BEGIN
            BREAK;
        END;

        -- Get current value by MessageBody pointer
        SET @MessageBodyCurrentValue = dsp.SplitStringByIndex(@MessageBody, @MessagePatternSeprator, @UseableIndexOfMessageBody);

        IF (@MessagePatternStepTypeId = @StepType_DoCheckConfirmActivation)
        BEGIN
            EXEC dspInboxMessage.InboxMessageProcess_$ProcessCheckConfirmActivationStep @MessagePatternStepId = @MessagePatternStepId,
                @ProviderInfoId = @ProviderInfoId, @Address = @Address, @DoBreak = @DoBreak OUTPUT,
                @InboxMessageProcessStateId = @InboxMessageProcessStateId OUTPUT;

            IF (@DoBreak = 1)
                BREAK;
        END;
        -- When step is one of api parameter
        ELSE IF (@MessagePatternStepTypeId IN ( @StepType_InputParam, @StepType_InputOutputParam, @StepType_OutputParam ))
        BEGIN
            EXEC dspInboxMessage.InboxMessageProcess_$ProcessInputOutputStep @MessagePatternStepId = @MessagePatternStepId,
                @MessagePatternStepTypeId = @MessagePatternStepTypeId, @DefaultValue = @DefaultValue, @MessageBodyCurrentValue = @MessageBodyCurrentValue,
                @ParameterName = @ParameterName, @Address = @Address, @ProviderInfoId = @ProviderInfoId, @HasCustomValue = @HasCustomValue,
                @MessageLastData = @MessageLastData OUTPUT, @DoBreak = @DoBreak OUTPUT, @UsedMessageBodyCurrentValue = @UsedMessageBodyCurrentValue OUTPUT;

            IF (@UsedMessageBodyCurrentValue = 1)
            BEGIN
                SET @UseableIndexOfMessageBody = @UseableIndexOfMessageBody + 1;
                SET @MessageBodyCurrentValue = dsp.SplitStringByIndex(@MessageBody, @MessagePatternSeprator, @UseableIndexOfMessageBody);
            END;

            IF (@DoBreak = 1)
                BREAK;
        END;
        -- send message
        ELSE IF (@MessagePatternStepTypeId = @StepType_SendMessage)
            EXEC dspInboxMessage.InboxMessageProcess_$ProcessSendMessageStep @MessagePatternStepTypeId = @MessagePatternStepTypeId,
                @ProviderInfoId = @ProviderInfoId, @Address = @Address, @SendMessageValue = @SendMessageValue, @MessagePatternStepId = @MessagePatternStepId;
        -- confirm message
        ELSE IF (@MessagePatternStepTypeId = @StepType_Confirm)
        BEGIN
            EXEC dspInboxMessage.InboxMessageProcess_$ProcessConfirmStep @MessagePatternStepTypeId = @MessagePatternStepTypeId,
                @ProviderInfoId = @ProviderInfoId, @Address = @Address, @MessageBody = @MessageBody, @DefaultValue = @DefaultValue,
                @ConfirmHasCustomValidation = @ConfirmHasCustomValidation, @WaitStepId = @WaitStepId, @MessagePatternStepId = @MessagePatternStepId,
                @SendMessageValue = @SendMessageValue, @MessageLastData = @MessageLastData OUTPUT, @DoBreak = @DoBreak OUTPUT,
                @InboxMessageProcessStateId = @InboxMessageProcessStateId OUTPUT;

            IF (@DoBreak = 1)
                BREAK;
        END;
        ELSE IF (@MessagePatternStepTypeId = @StepType_DoRun)
        BEGIN
            EXEC dspInboxMessage.InboxMessageProcess_$DoRunResponseProcedure @MessageLastData = @MessageLastData, @ProviderInfoId = @ProviderInfoId,
                @Address = @Address, @SendMessageValue = @SendMessageValue, @MessagePatternStepId = @MessagePatternStepId,
                @InboxMessageProcessStateId = @InboxMessageProcessStateId OUTPUT, @ErrorMessage = @ErrorMessage OUTPUT;
        END;
    END;
    CLOSE StepsCursor;
    DEALLOCATE StepsCursor;
END;

GO
