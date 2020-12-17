IF OBJECT_ID('[dspInboxMessage].[InboxMessage_CreateBulk]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessage_CreateBulk];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessage_CreateBulk]
    @ResultItems TJSON = NULL OUTPUT
AS
BEGIN
    -- It is for prompt
    IF (1 = 0)
    BEGIN
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
    END;

    -- Consts
    DECLARE @InboxMessageProcessStateId TINYINT = dspconst.InboxMessageProcessState_NotProcessed();

    -- Declare variable to get inserted id 
    DECLARE @InsertedId TABLE (InboxMessageId BIGINT,
        MessageServerInboxNumber BIGINT);

    -- Check data duplicatation
    -- Use index 'IX_MessageServerInboxNumber'
    UPDATE  StageInbox
       SET  StageInbox.Error = dsp.Exception_BuildMessageParam4(
                                   @@PROCID, dsperr.DuplicateRequestExceptionId(), 'InboxMessage already exist', DEFAULT, DEFAULT, DEFAULT, DEFAULT)
      FROM  #InboxMessage StageInbox
            INNER JOIN dspInboxMessage.InboxMessage MainInbox ON MainInbox.MessageServerInboxNumber = StageInbox.InboxMessageId
     WHERE  StageInbox.Error IS NULL;

    -- Insert into my InboxMessage table
    BEGIN TRY
        INSERT INTO dspInboxMessage.InboxMessage (MessageRefrenceNumber, Address, MessageBody, MessageTime, ProviderInfoId, MessageServerCreatedTime,
            MessageServerInboxNumber, InboxMessageProcessStateId)
        OUTPUT Inserted.InboxMessageId, Inserted.MessageServerInboxNumber
        INTO @InsertedId (InboxMessageId, MessageServerInboxNumber)
        SELECT  MessageRefrenceNumber, Address, MessageBody, MessageTime, ProviderInfoId, CreatedTime, InboxMessageId, @InboxMessageProcessStateId
          FROM  #InboxMessage
         WHERE  Error IS NULL;
    END TRY
    BEGIN CATCH
        -- Update result json
        UPDATE  TIM
           SET  TIM.Error = dsp.Exception_BuildMessageParam4(@@PROCID, dsperr.InvalidOperationId(), ERROR_MESSAGE(), DEFAULT, DEFAULT, DEFAULT, DEFAULT)
          FROM  #InboxMessage TIM
         WHERE  TIM.Error IS NULL;
    END CATCH;

    -- Set all inpute data with status
    SET @ResultItems =
    (   SELECT      *
          FROM      (   SELECT  MessageServerInboxNumber = StageInbox.InboxMessageId, InboxMessageId = InsertedIds.InboxMessageId, StageInbox.Error
                          FROM  #InboxMessage StageInbox
                                LEFT OUTER JOIN @InsertedId InsertedIds ON InsertedIds.MessageServerInboxNumber = StageInbox.InboxMessageId) T
        FOR JSON AUTO);
END;
GO
