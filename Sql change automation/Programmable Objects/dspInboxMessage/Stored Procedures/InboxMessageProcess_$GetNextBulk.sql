IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$GetNextBulk]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetNextBulk];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetNextBulk]
    @MaxInboxMessageId BIGINT, @InboxMessageItems TJSON = NULL OUTPUT
AS
BEGIN
    -- Consts
    DECLARE @ProcessRecordCount BIGINT;

    -- Get @ProcessRecordCount from setting
    EXEC dspInboxMessage.Setting_GetProps @ProcessRecordCount = @ProcessRecordCount OUTPUT;

    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY
        EXEC dsp.Lock_Create @ObjectTypeName = 'InboxMessageProcess_$GetNextBulk';

        -- TODO : need index
        SET @InboxMessageItems =
        (   SELECT TOP (@ProcessRecordCount)    IM.InboxMessageId, IM.Address, IM.MessageBody, IM.MessageTime, IM.ProviderInfoId
              FROM  dspInboxMessage.InboxMessage IM
			  LEFT JOIN  dspInboxMessage.InboxMessage IMInProcess ON IMInProcess.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_InProcess()*/ 5 --
				AND IMInProcess.Address = IM.Address
             WHERE IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_NotProcessed()*/ 1 --
                AND IMInProcess.InboxMessageId IS NULL
                AND IM.InboxMessageId <= @MaxInboxMessageId
             ORDER BY IM.MessageTime
            FOR JSON AUTO);
		
		-- TODO: Need perfomance tunning
        --SET @InboxMessageItems =
        --(   SELECT TOP (@ProcessRecordCount)    IM.InboxMessageId, IM.Address, IM.MessageBody, IM.MessageTime, IM.ProviderInfoId
        --      FROM  InboxMessage.InboxMessage IM
        --     WHERE IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_NotProcessed()*/ 1 --
        --        AND
        --           NOT EXISTS (   SELECT    1
        --                            FROM    InboxMessage.InboxMessage IMInProcess
        --                           WHERE  IMInProcess.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_InProcess()*/ 5 AND
        --                                  IMInProcess.Address = IM.Address) --
        --        AND InboxMessageId <= @MaxInboxMessageId
        --     ORDER BY IM.MessageTime
        --    FOR JSON AUTO);

        -- Update state
        UPDATE  IM
           SET  IM.InboxMessageProcessStateId = /*dspconst.InboxMessageProcessState_InProcess()*/ 5, IM.ProcessStartTime = GETDATE()
          FROM  (   SELECT  *
                      FROM
                        OPENJSON(@InboxMessageItems)
                        WITH (InboxMessageId BIGINT)) Result
                INNER JOIN dspInboxMessage.InboxMessage IM ON IM.InboxMessageId = Result.InboxMessageId;

        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;
END;
GO
