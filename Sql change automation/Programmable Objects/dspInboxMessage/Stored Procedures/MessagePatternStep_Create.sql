IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_Create]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePatternStep_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePatternStep_Create]
    @MessagePatternId INT, @MessagePatternStepTypeId INT = NULL, @ParameterName TSTRING = NULL, @SendMessageValue TSTRING = NULL, @DefaultValue TSTRING = NULL,
    @Description TSTRING = NULL, @Order INT = NULL, @ConfirmHasCustomValidation BIT = NULL, @HasCustomValue BIT = NULL, @MessagePatternStepId INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    --validate data
    EXEC dspInboxMessage.[MessagePatternStep_$Validate] @MessagePatternId = @MessagePatternId, @MessagePatternStepId = @MessagePatternStepId,
        @MessagePatternStepTypeId = @MessagePatternStepTypeId, @ParameterName = @ParameterName, @SendMessageValue = @SendMessageValue,
        @DefaultValue = @DefaultValue, @ConfirmHasCustomValidation = @ConfirmHasCustomValidation, @HasCustomValue = @HasCustomValue, @Order = @Order;

    --insert data
    INSERT INTO dspInboxMessage.MessagePatternStep (MessagePatternId, MessagePatternStepTypeId, ParameterName, SendMessageValue, [Order], DefaultValue,
        Description, ConfirmHasCustomValidation, HasCustomValue)
    VALUES (@MessagePatternId, @MessagePatternStepTypeId, @ParameterName, @SendMessageValue, @Order, @DefaultValue, @Description, @ConfirmHasCustomValidation,
        @HasCustomValue);

    SET @MessagePatternStepId = SCOPE_IDENTITY();
END;
GO
