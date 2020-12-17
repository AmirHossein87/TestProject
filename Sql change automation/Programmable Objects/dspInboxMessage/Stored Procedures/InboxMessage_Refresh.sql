IF OBJECT_ID('[dspInboxMessage].[InboxMessage_Refresh]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessage_Refresh];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessage_Refresh]
    @ApplicationId INT, @ResultItems TJSON = NULL OUTPUT
AS
BEGIN
    DECLARE @Context TCONTEXT = '$$';
    DECLARE @FilterInboxMessageIdFrom BIGINT;
    DECLARE @ErrorMessage TSTRING;

    -- Get @RefreshRecordCount from setting
    DECLARE @RefreshRecordCount INT;
    EXEC dspInboxMessage.Setting_GetProps @RefreshRecordCount = @RefreshRecordCount OUTPUT;

    CREATE TABLE #InboxMessage ([InboxMessageId] BIGINT NOT NULL,
        [MessageRefrenceNumber] NVARCHAR(MAX /*NCQ*/),
        [Address] NVARCHAR(MAX /*NCQ*/),
        [MessageBody] NVARCHAR(MAX /*NCQ*/),
        [MessageTime] DATETIME NOT NULL,
        [ProviderInfoId] [INT] NOT NULL,
        [InboxMessageDataSource1Id] BIGINT NULL,
        [CreatedTime] DATETIME NOT NULL,
        [ContactInfo] NVARCHAR(MAX /*NCQ*/),
        Error NVARCHAR(MAX /*NCQ*/));

    WHILE (1 = 1)
    BEGIN
        -- Get data from InboxMessage_LastRefershTime
        SET @FilterInboxMessageIdFrom = (   SELECT LastRefershInboxMessageNumber
                                           FROM dspInboxMessage.InboxMessage_LastRefershInboxMessageNumber);

        SET @FilterInboxMessageIdFrom = ISNULL(@FilterInboxMessageIdFrom, 0);

        -- Call syn to get data
        BEGIN TRY
            TRUNCATE TABLE #InboxMessage;

            INSERT INTO #InboxMessage (InboxMessageId, MessageRefrenceNumber, Address, MessageBody, MessageTime, ProviderInfoId, InboxMessageDataSource1Id,
                CreatedTime, ContactInfo)
            EXEC syn.MessageServer_InboxMessageList @Context = @Context OUTPUT, @ApplicationId = @ApplicationId,
                @FilterInboxMessageIdFrom = @FilterInboxMessageIdFrom, @RequestRecordCount = @RefreshRecordCount;

            -- If no new data available then exit
            IF NOT EXISTS (SELECT   * FROM  #InboxMessage)
                BREAK;
        END TRY
        BEGIN CATCH
            -- Update InboxMessage_LastRefershInboxMessageNumber table with max MessageServerInboxMessageId
            UPDATE  dspInboxMessage.InboxMessage_LastRefershInboxMessageNumber
               SET  LastRefershInboxMessageNumber = (SELECT MAX(InboxMessageId) FROM    #InboxMessage);

            SET @ErrorMessage = ERROR_MESSAGE();
            EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = @ErrorMessage;
        END CATCH;

        -- Call create bulk
        DECLARE @TranCount INT = @@TRANCOUNT;
        IF (@TranCount = 0)
            BEGIN TRANSACTION;
        BEGIN TRY
            EXEC dspInboxMessage.InboxMessage_CreateBulk @ResultItems = @ResultItems OUTPUT;

            -- Update InboxMessage_LastRefershInboxMessageNumber
            UPDATE  dspInboxMessage.InboxMessage_LastRefershInboxMessageNumber
               SET  LastRefershInboxMessageNumber = (SELECT MAX(InboxMessageId) FROM    #InboxMessage);

            IF (@TranCount = 0) COMMIT;
        END TRY
        BEGIN CATCH
            IF (@TranCount = 0)
                ROLLBACK TRANSACTION;

            SET @ErrorMessage = ERROR_MESSAGE();
            EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
        END CATCH;
    END;
END;
GO
