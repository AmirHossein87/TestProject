IF OBJECT_ID('[dspInboxMessage].[MessagePattern_$MessagePatternStepItems]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_$MessagePatternStepItems];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_$MessagePatternStepItems]
    @MessagePatternId INT, @StepItems TJSON = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @StepItems =
    (   SELECT  MessagePatternStepId, MessagePatternId, MessagePatternStepTypeId, ParameterName, SendMessageValue, [Order], DefaultValue, Description,
            ConfirmHasCustomValidation, HasCustomValue
          FROM  dspInboxMessage.MessagePatternStep
         WHERE MessagePatternId = @MessagePatternId AND [Order] > 0
         ORDER BY [Order]
        FOR JSON AUTO, INCLUDE_NULL_VALUES);
END;
GO
