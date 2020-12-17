IF OBJECT_ID('[dspInboxMessage].[MessagePattern_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_GetProps]
    @MessagePatternId INT = NULL, @PatternName TSTRING = NULL OUTPUT, @StartTime DATETIME = NULL OUTPUT, @ExpirationTime DATETIME = NULL OUTPUT,
    @MessagePatternSepratorId INT = NULL OUTPUT, @ResponseProcedureSchemaName TSTRING = NULL OUTPUT, @ResponseProcedureName TSTRING = NULL OUTPUT,
    @PatternKey TSTRING = NULL OUTPUT, @MessagePatternStateId INT = NULL OUTPUT, @Description TSTRING = NULL OUTPUT, @StepItems TJSON = NULL OUTPUT,
    @MessagePatternSeprator TSTRING = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ActualPatternId INT;

    -- Get Data
    SELECT  @ActualPatternId = MP.MessagePatternId, @PatternName = MP.PatternName, @StartTime = MP.StartTime, @ExpirationTime = MP.ExpirationTime,
        @MessagePatternSepratorId = MP.MessagePatternSepratorId, @ResponseProcedureSchemaName = MP.ResponseProcedureSchemaName,
        @ResponseProcedureName = MP.ResponseProcedureName, @PatternKey = MP.PatternKey, @MessagePatternStateId = MP.MessagePatternStateId,
        @Description = [MP].[Description], @MessagePatternSeprator = MPS.MessagePatternSeprator
      FROM  dspInboxMessage.vw_MessagePattern MP
            INNER JOIN dspInboxMessage.MessagePatternSeprator MPS ON MPS.MessagePatternSepratorId = MP.MessagePatternSepratorId
     WHERE  MP.MessagePatternId = @MessagePatternId;

    IF (@ActualPatternId IS NULL) --
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = 'ActualPatternId IS NULL';

    -- Get steps data
    EXEC dspInboxMessage.[MessagePattern_$MessagePatternStepItems] @MessagePatternId = @MessagePatternId, @StepItems = @StepItems OUTPUT;
END;

GO
