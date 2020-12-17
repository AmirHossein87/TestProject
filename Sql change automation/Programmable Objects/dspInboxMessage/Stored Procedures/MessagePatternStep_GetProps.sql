IF OBJECT_ID('[dspInboxMessage].[MessagePatternStep_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePatternStep_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePatternStep_GetProps]
    @MessagePatternStepId INT, @MessagePatternId INT = NULL OUTPUT, @MessagePatternStepTypeId INT = NULL OUTPUT, @ParameterName TSTRING = NULL OUTPUT,
    @SendMessageValue TSTRING = NULL OUTPUT, @Order INT = NULL OUTPUT, @DefaultValue TSTRING = NULL OUTPUT, @Description TSTRING = NULL OUTPUT,
    @ConfirmHasCustomValidation BIT = NULL OUTPUT, @HasCustomValue BIT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ActualStepId INT;

    --Get ApiId from local data
    SELECT  @ActualStepId = MessagePatternStepId, @MessagePatternId = MessagePatternId, @MessagePatternStepTypeId = MessagePatternStepTypeId,
        @ParameterName = ParameterName, @SendMessageValue = SendMessageValue, @Order = [Order], @DefaultValue = DefaultValue, @Description = [Description],
        @ConfirmHasCustomValidation = ConfirmHasCustomValidation, @HasCustomValue = HasCustomValue
      FROM  dspInboxMessage.MessagePatternStep
     WHERE  MessagePatternStepId = @MessagePatternStepId;

    IF (@ActualStepId IS NULL) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID;
END;

GO
