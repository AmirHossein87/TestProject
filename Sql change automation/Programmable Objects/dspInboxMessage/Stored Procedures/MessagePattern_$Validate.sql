IF OBJECT_ID('[dspInboxMessage].[MessagePattern_$Validate]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_$Validate];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_$Validate]
    @MessagePatternId INT = NULL, @PatternName TSTRING = '<notset>', @StartTime DATETIME = '1753-01-01', @ExpirationTime DATETIME = '1753-01-01',
    @MessagePatternSepratorId INT = -1, @PatternKey TSTRING = '<notset>', @MessagePatternStateId INT = -1, @Description TSTRING = '<notset>',
    @ResponseProcedureSchemaName TSTRING = '<notset>', @ResponseProcedureName TSTRING = '<notset>'
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate Call Mode
    -- Is Better to Create dspconst Function
    DECLARE @State_Create INT = 1;
    DECLARE @State_SetProp INT = 2;
    DECLARE @ValidateState INT = CASE
                                     WHEN @MessagePatternId IS NOT NULL
                                         THEN @State_SetProp ELSE @State_Create
                                 END;
    -- Call GetProp and read required old feilds value for validation
    IF (@ValidateState = @State_SetProp)
    BEGIN
        DECLARE @OldStartTime DATETIME;
        DECLARE @OldExpirationTime DATETIME;
        EXEC dspInboxMessage.MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @StartTime = @OldStartTime OUTPUT,
            @ExpirationTime = @OldExpirationTime OUTPUT;

        EXEC dsp.SetIfChanged_Time @ProcId = @@PROCID, @PropName = 'StartTime', @OldValue = @OldStartTime OUT, @NewValue = @StartTime;
        EXEC dsp.SetIfChanged_Time @ProcId = @@PROCID, @PropName = 'ExpirationTime', @OldValue = @OldExpirationTime OUT, @NewValue = @ExpirationTime;
    END;
    ELSE
    BEGIN
        SELECT  @OldStartTime = @StartTime, @OldExpirationTime = @ExpirationTime;
    END;

    -- Validate parameters
    IF dsp.Param_IsSet(@PatternName) = 1 --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'PatternName', @ArgumentValue = @PatternName;

    IF (dsp.Param_IsSet(@StartTime) = 1) --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'StartTime', @ArgumentValue = @StartTime;

    IF (dsp.Param_IsSet(@ExpirationTime) = 1) --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'ExpirationTime', @ArgumentValue = @ExpirationTime;

    IF (dsp.Param_IsSet(@PatternKey) = 1)
    BEGIN
        -- Validate PatternKey
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'PatternKey', @ArgumentValue = @PatternKey;

        IF EXISTS (   SELECT    *
                        FROM    dspInboxMessage.MessagePatternSeprator
                       WHERE CHARINDEX(MessagePatternSeprator, SUBSTRING(@PatternKey, 2, LEN(@PatternKey))) > 0)
            EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'PatternKey', @ArgumentValue = @PatternKey,
                @Message = 'PatternKey Can not include seprator charecter';
    END;

    -- Validate MessagePatternSepratorId
    IF (dsp.Param_IsSet(@MessagePatternSepratorId) = 1) --
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'MessagePatternSepratorId', @ArgumentValue = @MessagePatternSepratorId;

    IF (dsp.Param_IsSet(@StartTime) = 1) OR (dsp.Param_IsSet(@ExpirationTime) = 1)
        IF @OldStartTime > @OldExpirationTime
            EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'StartTime', @ArgumentValue = @StartTime,
                @Message = 'StartTime Can not be Bigger Than ExpirationTime';

    -- Validate MessagePatternStateId is not null
    IF (dsp.Param_IsSet(@MessagePatternStateId) = 1) --
    BEGIN
        EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = '@MessagePatternStateId', @ArgumentValue = @MessagePatternStateId;

        -- Validate MessagePatternStateId
        IF (@MessagePatternStateId = dspconst.MessagePatternStateId_Started())
        BEGIN
            IF (NOT EXISTS (   SELECT   1
                                 FROM   dspInboxMessage.MessagePatternStep
                                WHERE   MessagePatternId = @MessagePatternId))
                EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'MessagePatternStateId', @ArgumentValue = @StartTime,
                    @Message = 'MessagePattern must have steps';

            IF (NOT EXISTS (   SELECT   1
                                 FROM   dspInboxMessage.MessagePatternStep
                                WHERE   MessagePatternId = @MessagePatternId --
                                   AND  MessagePatternStepTypeId = dspconst.MessagePatternStepType_DoCheckConfirmActivation() --
                                   AND  [Order] = 0))
                EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'MessagePatternStateId', @ArgumentValue = @StartTime,
                    @Message = 'MessagePattern must have DoCheckConfirmActivation step as first order';


            IF (NOT EXISTS (   SELECT   1
                                 FROM   dspInboxMessage.MessagePatternStep
                                WHERE   MessagePatternId = @MessagePatternId --
                                   AND  MessagePatternStepTypeId = dspconst.MessagePatternStepType_DoRun() --
                                   AND  [Order] = (   SELECT    MAX([Order])
                                                        FROM    dspInboxMessage.MessagePatternStep
                                                       WHERE MessagePatternId = @MessagePatternId)))
                EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'MessagePatternStateId', @ArgumentValue = @StartTime,
                    @Message = 'MessagePattern must have DoRun step as last order';
        END;
    END;

    -- Validate PatternKey repetitive
    IF (dsp.Param_IsSet(@PatternKey) = 1)
    BEGIN
        IF EXISTS (   SELECT    *
                        FROM    dspInboxMessage.vw_MessagePattern
                       WHERE MessagePatternId <> ISNULL(@MessagePatternId, 0) AND   PatternKey = @PatternKey)
            EXEC dsperr.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = 'PatternKey can not be duplicate';
    END;

    -- Validate PatternName
    IF (dsp.Param_IsSet(@PatternName) = 1)
    BEGIN
        IF EXISTS (   SELECT    *
                        FROM    dspInboxMessage.vw_MessagePattern
                       WHERE MessagePatternId <> ISNULL(@MessagePatternId, 0) AND   PatternName = @PatternName)
            EXEC dsperr.ThrowObjectAlreadyExists @ProcId = @@PROCID, @Message = 'PatternName can not be duplicate';
    END;

    -- Validate ResponseProcedureSchemaName
    IF (dsp.Param_IsSet(@ResponseProcedureSchemaName) = 1) EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'ResponseProcedureSchemaName',
                                                           @ArgumentValue = @ResponseProcedureSchemaName;


    -- Validate ResponseProcedureName
    IF (dsp.Param_IsSet(@ResponseProcedureName) = 1) EXEC dsp.Validate_CheckNotNull @ProcId = @@PROCID, @ArgumentName = 'ResponseProcedureName',
                                                     @ArgumentValue = @ResponseProcedureName;

    -- Validate response procedure existance
    IF (dsp.Param_IsSet(@ResponseProcedureSchemaName) = 1) OR   (dsp.Param_IsSet(@ResponseProcedureName) = 1)
    BEGIN
        DECLARE @ResponseProcedureFullName TSTRING = @ResponseProcedureSchemaName + '.' + @ResponseProcedureName;
        IF NOT EXISTS (   SELECT    *
                            FROM    sys.objects O
                           WHERE O.object_id = OBJECT_ID(@ResponseProcedureFullName) AND O.type = 'P')
            EXEC dsp.ThrowInvalidArgument @ProcId = @@PROCID, @ArgumentName = 'ResponseProcedureName', @ArgumentValue = @ResponseProcedureName,
                @Message = 'ResponseProcedureName is invalid';
    END;

    IF @ValidateState = @State_SetProp
        IF EXISTS (   SELECT    *
                        FROM    dspInboxMessage.InboxMessage
                       WHERE MessagePatternId = @MessagePatternId)
        BEGIN
            DECLARE @ExceptionId INT = dsperr.ObjectIsInUseId();
            EXEC dsp.ThrowAppException @ProcId = @@PROCID, @ExceptionId = @ExceptionId, @Message = 'Object is in use, can not SetProp';
        END;


END;
GO
