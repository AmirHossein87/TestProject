IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ProcessItems]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessItems];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ProcessItems]
    @InboxMessageItems TJSON, @InboxMessageResultItems TJSON = NULL OUTPUT
AS
BEGIN
    -- Provisioning parameters
    DECLARE @InboxMessageId BIGINT;
    DECLARE @Address TSTRING;
    DECLARE @MessageBody TSTRING;
    DECLARE @MessageTime DATETIME;
    DECLARE @ProviderInfoId INT;
    DECLARE @MessagePatternId INT;
    DECLARE @InboxMessageProcessStateId INT;
    DECLARE @ErrorMessage TJSON;

    -- Create temp for result
    DECLARE @Temp TABLE (InboxMessageId BIGINT PRIMARY KEY,
        MessagePatternId INT NULL,
        InboxMessageProcessStateId INT NOT NULL,
        Error TJSON NULL);

    DECLARE MessagesCursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  InboxMessageId, Address, MessageBody, MessageTime, ProviderInfoId
      FROM
        OPENJSON(@InboxMessageItems)
        WITH (InboxMessageId BIGINT, Address TSTRING, MessageBody TSTRING, MessageTime DATETIME, ProviderInfoId BIGINT);

    OPEN MessagesCursor;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM MessagesCursor
         INTO @InboxMessageId, @Address, @MessageBody, @MessageTime, @ProviderInfoId;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        DECLARE @TranCount INT = @@TRANCOUNT;
        IF (@TranCount = 0)
            BEGIN TRANSACTION;
        BEGIN TRY

            -- Call ProcessItem
            EXEC dspInboxMessage.[InboxMessageProcess_$ProcessItem] @Address = @Address, @MessageBody = @MessageBody, @MessageTime = @MessageTime,
                @ProviderInfoId = @ProviderInfoId, @MessagePatternId = @MessagePatternId OUTPUT,
                @InboxMessageProcessStateId = @InboxMessageProcessStateId OUTPUT, @ErrorMessage = @ErrorMessage OUTPUT;

            -- Fill successfull result
            INSERT INTO @Temp (InboxMessageId, MessagePatternId, InboxMessageProcessStateId, Error) --@InboxMessageProcessStateId
            VALUES (@InboxMessageId, @MessagePatternId, @InboxMessageProcessStateId, @ErrorMessage);

            IF (@TranCount = 0) COMMIT;
        END TRY
        BEGIN CATCH
            IF (@TranCount = 0)
                ROLLBACK TRANSACTION;

            -- Validate error
            SET @ErrorMessage = dsp.Message_CommonExceptionFormat(@@PROCID, ERROR_MESSAGE());

            -- Fill successfull result
            INSERT INTO @Temp (InboxMessageId, InboxMessageProcessStateId, Error)
            VALUES (@InboxMessageId, dspconst.InboxMessageProcessState_ProcessedFailed(), @ErrorMessage);

            SET @InboxMessageResultItems = (   SELECT   InboxMessageId, MessagePatternId, InboxMessageProcessStateId, Error
                                                 FROM   @Temp
                                               FOR JSON AUTO);
        END CATCH;
    END;
    CLOSE MessagesCursor;
    DEALLOCATE MessagesCursor;

    SET @InboxMessageResultItems = (   SELECT   InboxMessageId, MessagePatternId, InboxMessageProcessStateId, Error
                                         FROM   @Temp
                                       FOR JSON AUTO);
END;
GO
