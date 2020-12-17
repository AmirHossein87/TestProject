IF OBJECT_ID('[dspInboxMessage].[MessagePattern_SetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_SetProps]
    @MessagePatternId INT, @PatternName TSTRING = '<notset>', @StartTime DATETIME = '1753-01-01', @ExpirationTime DATETIME = '1753-01-01',
    @MessagePatternSepratorId INT = -1, @ResponseProcedureSchemaName TSTRING = '<notset>', @ResponseProcedureName TSTRING = '<notset>',
    @PatternKey TSTRING = '<notset>', @MessagePatternStateId INT = -1, @Description TSTRING = '<notset>', @StepItems TJSON = '<notset>'
AS
BEGIN
    DECLARE @OldPatternName TSTRING;
    DECLARE @OldStartTime DATETIME;
    DECLARE @OldExpirationTime DATETIME;
    DECLARE @OldMessagePatternSepratorId INT;
    DECLARE @OldResponseProcedureSchemaName TSTRING;
    DECLARE @OldResponseProcedureName TSTRING;
    DECLARE @OldPatternKey TSTRING;
    DECLARE @OldMessagePatternStateId INT;
    DECLARE @OldDescription TSTRING;
    DECLARE @OldSuccessfulProcessMessage TSTRING;

    -- Validate data
    EXEC [dspInboxMessage].[MessagePattern_$Validate] @MessagePatternId = @MessagePatternId, @PatternName = @PatternName, @StartTime = @StartTime,
        @ExpirationTime = @ExpirationTime, @MessagePatternSepratorId = @MessagePatternSepratorId, @ResponseProcedureSchemaName = @ResponseProcedureSchemaName,
        @ResponseProcedureName = @ResponseProcedureName, @PatternKey = @PatternKey, @MessagePatternStateId = @MessagePatternStateId,
        @Description = @Description;

    -- Get old props and validate Existance
    EXEC [dspInboxMessage].MessagePattern_GetProps @MessagePatternId = @MessagePatternId, @PatternName = @OldPatternName OUTPUT,
        @StartTime = @OldStartTime OUTPUT, @ExpirationTime = @OldExpirationTime OUTPUT, @MessagePatternSepratorId = @OldMessagePatternSepratorId OUTPUT,
        @ResponseProcedureSchemaName = @OldResponseProcedureSchemaName OUTPUT, @ResponseProcedureName = @OldResponseProcedureName OUTPUT,
        @PatternKey = @OldPatternKey OUTPUT, @MessagePatternStateId = @OldMessagePatternStateId OUTPUT, @Description = @Description OUTPUT;

    -- Detect if there are any changes
    DECLARE @IsRecordUpdated BIT = 0;

    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'PatternName', @IsUpdated = @IsRecordUpdated OUT, @OldValue = @OldPatternName OUT,
        @NewValue = @PatternName;

    EXEC dsp.SetIfChanged_Time @ProcId = @@PROCID, @PropName = 'StartTime', @IsUpdated = @IsRecordUpdated OUT, @OldValue = @OldStartTime OUT,
        @NewValue = @StartTime;

    EXEC dsp.SetIfChanged_Time @ProcId = @@PROCID, @PropName = 'ExpireTime', @IsUpdated = @IsRecordUpdated OUT, @OldValue = @OldExpirationTime OUT,
        @NewValue = @ExpirationTime;

    EXEC dsp.SetIfChanged_Int @ProcId = @@PROCID, @PropName = 'MessagePatternSepratorId', @IsUpdated = @IsRecordUpdated OUT,
        @OldValue = @OldMessagePatternSepratorId OUT, @NewValue = @MessagePatternSepratorId;

    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'ResponseProcedureSchemaName', @IsUpdated = @IsRecordUpdated OUT,
        @OldValue = @OldResponseProcedureSchemaName OUT, @NewValue = @ResponseProcedureSchemaName;

    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'ResponseProcedureName', @IsUpdated = @IsRecordUpdated OUT,
        @OldValue = @OldResponseProcedureName OUT, @NewValue = @ResponseProcedureName;

    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'PatternKey', @IsUpdated = @IsRecordUpdated OUT, @OldValue = @OldPatternKey OUT,
        @NewValue = @PatternKey;

    EXEC dsp.SetIfChanged_Int @ProcId = @@PROCID, @PropName = 'MessagePatternStateId', @IsUpdated = @IsRecordUpdated OUT,
        @OldValue = @OldMessagePatternStateId OUT, @NewValue = @MessagePatternStateId;

    EXEC dsp.SetIfChanged_String @ProcId = @@PROCID, @PropName = 'Description', @IsUpdated = @IsRecordUpdated OUT, @OldValue = @OldDescription OUT,
        @NewValue = @Description;

    BEGIN
        DECLARE @TranCount INT = @@TRANCOUNT;
        IF (@TranCount = 0)
            BEGIN TRANSACTION;
        BEGIN TRY

            -- Update table if neccassary
            IF (@IsRecordUpdated = 1)
            BEGIN
                UPDATE  [dspInboxMessage].MessagePattern
                   SET  PatternName = @OldPatternName, StartTime = @OldStartTime, ExpirationTime = @OldExpirationTime,
                    MessagePatternSepratorId = @OldMessagePatternSepratorId, ResponseProcedureSchemaName = @OldResponseProcedureSchemaName,
                    ResponseProcedureName = @OldResponseProcedureName, PatternKey = @OldPatternKey, MessagePatternStateId = @OldMessagePatternStateId,
                    [Description] = @OldDescription
                 WHERE  MessagePatternId = @MessagePatternId;
            END;

            IF (dsp.Param_IsSetForMaxSize(@StepItems) = 1)
            BEGIN
                -- Call delete for old steps
                EXEC [dspInboxMessage].MessagePattern_DeleteMessagePatternSteps @MessagePatternId = @MessagePatternId;

                -- Call create step
                EXEC [dspInboxMessage].[MessagePatternStep_CreateBulk] @MessagePatternId = @MessagePatternId, @StepItems = @StepItems;
            END;
            IF (@TranCount = 0) COMMIT;
        END TRY
        BEGIN CATCH
            IF (@TranCount = 0)
                ROLLBACK TRANSACTION;
            THROW;
        END CATCH;
    END;
END;


GO
