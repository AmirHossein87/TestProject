IF OBJECT_ID('[dspInboxMessage].[MessagePattern_Create]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[MessagePattern_Create];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[MessagePattern_Create]
    @MessagePatternId INT = NULL OUTPUT, @PatternName TSTRING = NULL, @StartTime DATETIME = NULL, @ExpirationTime DATETIME = NULL,
    @MessagePatternSepratorId INT = NULL, @ResponseProcedureSchemaName TSTRING = NULL, @ResponseProcedureName TSTRING = NULL, @PatternKey TSTRING = NULL,
    @Description TSTRING = NULL, @StepItems TJSON = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @MessagePatternId = NULL;

    DECLARE @MessagePatternStateId INT;
    SET @MessagePatternStateId = dspconst.MessagePatternStateId_Drafted();

    -- Validate Data
    EXEC dspInboxMessage.MessagePattern_$Validate @MessagePatternId = @MessagePatternId, @PatternName = @PatternName, @StartTime = @StartTime,
        @ExpirationTime = @ExpirationTime, @MessagePatternSepratorId = @MessagePatternSepratorId, @PatternKey = @PatternKey,
        @MessagePatternStateId = @MessagePatternStateId, @ResponseProcedureSchemaName = @ResponseProcedureSchemaName,
        @ResponseProcedureName = @ResponseProcedureName;

    -- Insert Into MessagePattern Table
    DECLARE @TranCount INT = @@TRANCOUNT;
    BEGIN TRY
        IF (@TranCount = 0)
            BEGIN TRANSACTION;

        -- Insert header data
        INSERT INTO dspInboxMessage.MessagePattern (PatternName, StartTime, ExpirationTime, MessagePatternSepratorId, PatternKey, MessagePatternStateId,
            [Description], ResponseProcedureSchemaName, ResponseProcedureName)
        VALUES (@PatternName, @StartTime, @ExpirationTime, @MessagePatternSepratorId, @PatternKey, @MessagePatternStateId, @Description,
            @ResponseProcedureSchemaName, @ResponseProcedureName);

        SET @MessagePatternId = SCOPE_IDENTITY();

        -- Create steps
        EXEC dspInboxMessage.MessagePatternStep_CreateCheckConfirmActivationStep @MessagePatternId = @MessagePatternId;
        EXEC dspInboxMessage.MessagePatternStep_CreateBulk @MessagePatternId = @MessagePatternId, @StepItems = @StepItems;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION; --
        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;
END;

GO
