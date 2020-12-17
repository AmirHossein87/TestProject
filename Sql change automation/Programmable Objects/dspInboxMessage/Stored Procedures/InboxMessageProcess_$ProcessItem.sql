IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessItem]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessItem];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessItem]
    @Address TSTRING, @MessageBody TSTRING, @MessageTime DATETIME, @ProviderInfoId INT, @MessagePatternId INT = NULL OUTPUT,
    @InboxMessageProcessStateId INT = NULL OUTPUT, @ErrorMessage TJSON = NULL OUTPUT
AS
BEGIN
    DECLARE @MessageLastData TJSON;
    DECLARE @WaitStepId INT;

    -- Consts
    DECLARE @ProcessState_Proceed INT = dspconst.InboxMessageProcessState_Processed();
    DECLARE @ProcessState_ProceedNotPair INT = dspconst.InboxMessageProcessState_ProcessedNotPair();

    SET @ErrorMessage = NULL;
    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY
        -- Get appropriate PatternId
        EXEC dspInboxMessage.InboxMessageProcess_$GetAppropriatePatternId @MessageBody = @MessageBody, @MessageTime = @MessageTime, @Address = @Address,
            @ProviderInfoId = @ProviderInfoId, @MessagePatternId = @MessagePatternId OUTPUT, @MessageLastData = @MessageLastData OUTPUT,
            @WaitStepId = @WaitStepId OUTPUT;

        -- Process pattern when it founded sucess
        IF @MessagePatternId IS NOT NULL
        BEGIN
            SET @InboxMessageProcessStateId = @ProcessState_Proceed;

            -- Start process pattern steps
            EXEC dspInboxMessage.InboxMessageProcess_$ProcessSteps @MessagePatternId = @MessagePatternId, @WaitStepId = @WaitStepId,
                @ProviderInfoId = @ProviderInfoId, @Address = @Address, @MessageBody = @MessageBody, @MessageLastData = @MessageLastData OUTPUT,
                @InboxMessageProcessStateId = @InboxMessageProcessStateId OUTPUT, @ErrorMessage = @ErrorMessage OUTPUT;
        END;
        ELSE
            SET @InboxMessageProcessStateId = @ProcessState_ProceedNotPair;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;

END;
GO
