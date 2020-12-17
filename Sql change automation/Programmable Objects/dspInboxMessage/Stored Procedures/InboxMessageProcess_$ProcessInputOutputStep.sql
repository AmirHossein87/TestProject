IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessInputOutputStep]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessInputOutputStep];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessInputOutputStep]
    @MessagePatternStepId INT, @MessagePatternStepTypeId INT, @DefaultValue TSTRING, @MessageBodyCurrentValue TSTRING, @ParameterName TSTRING,
    @Address TSTRING, @ProviderInfoId INT, @MessageLastData TJSON OUTPUT, @DoBreak BIT OUTPUT, @HasCustomValue BIT, @UsedMessageBodyCurrentValue BIT OUTPUT
AS
BEGIN
    -- Declare const variable
    DECLARE @StepType_InputParam INT = dspconst.MessagePatternStepType_InputParam();
    DECLARE @StepType_OutputParam INT = dspconst.MessagePatternStepType_OutputParam();
    DECLARE @StepType_InputOutputParam INT = dspconst.MessagePatternStepType_InputOutputParam();
    DECLARE @InboxMessageProcessKeyTag_ParameterSpecification TSTRING = dspInboxMessage.InboxMessageProcessKeyTag_ParameterSpecification();
    DECLARE @ParameterValue TSTRING;
    DECLARE @ParamType TSTRING;
    DECLARE @ParameterSpec TJSON;

    -- Initialize output parameter
    SET @DoBreak = 0;
    SET @UsedMessageBodyCurrentValue = 0;

    -- If StepType is not input so return
    IF @MessagePatternStepTypeId NOT IN ( @StepType_InputParam, @StepType_InputOutputParam, @StepType_OutputParam )
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'Invalid SteptypeId';

    -- These types need parameter value
    IF @MessagePatternStepTypeId IN ( @StepType_InputParam, @StepType_InputOutputParam )
    BEGIN
        SET @ParameterValue = NULL;

        IF @HasCustomValue = 1
        BEGIN
            EXEC dspInboxMessage.InboxMessageProcess_$GetCustomValue @ProviderInfoId = @ProviderInfoId, @Address = @Address,
                @MessageLastData = @MessageLastData, @MessagePatternStepId = @MessagePatternStepId, @ParameterName = @ParameterName,
                @ParameterValue = @ParameterValue OUTPUT;
            SET @ParameterValue = ISNULL(@ParameterValue, dspInboxMessage.InboxMessageProcessKeyTag_NullExpression());
        END;

        -- If Step has DefaultValue, fill itself by DefaultValue and do not wait for MessageBody
        IF (@DefaultValue IS NOT NULL)
            SET @ParameterValue = @DefaultValue;

        --If has value in MessageBody then add to LastData and go to next step
        IF (@ParameterValue IS NULL AND @MessageBodyCurrentValue IS NOT NULL)
        BEGIN
            SET @ParameterValue = @MessageBodyCurrentValue;
            SET @UsedMessageBodyCurrentValue = 1;
        END;

        --If dont have value in message body, insert request and wait for new message body
        IF (@ParameterValue IS NULL)
        BEGIN
            -- Insert into waitReply table with @MessageLastData
            EXEC dspInboxMessage.[InboxMessageProcess_$CreateWaitForReplyMessage] @Address = @Address, @MessagePatternStepId = @MessagePatternStepId,
                @MessageLastData = @MessageLastData, @ProviderInfoId = @ProviderInfoId;

            SET @DoBreak = 1;
            RETURN;
        END;
    END;

    -- Detect parameter type
    SET @ParamType = CASE @MessagePatternStepTypeId
                         WHEN @StepType_InputParam
                             THEN 'Input'
                         WHEN @StepType_InputOutputParam
                             THEN 'Output'
                         WHEN @StepType_OutputParam
                             THEN 'Output'
                     END;

    -- Put parameter specifications into MessageLastData and continue
    SET @ParameterSpec = (   SELECT @ParameterName AS ParamName, @ParamType AS ParamType, @ParameterValue AS ParamValue
                             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

    SET @MessageLastData =
        dspInboxMessage.[InboxMessageProcess_$AppendToMessageLastData](@MessageLastData, @InboxMessageProcessKeyTag_ParameterSpecification, @ParameterSpec);
END;

GO
