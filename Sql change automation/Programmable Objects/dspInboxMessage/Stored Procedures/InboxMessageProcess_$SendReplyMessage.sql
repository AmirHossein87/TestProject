IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$SendReplyMessage]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$SendReplyMessage];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$SendReplyMessage]
    @ProviderInfoId BIGINT, @Address TSTRING, @SendMessageValue TSTRING, @MessagePatternStepId INT
AS
BEGIN
    -- It must be overwrite by client
    BEGIN TRY
        EXEC InboxMessage.InboxMessageProcess_SendReplyMessage @ProviderInfoId = @ProviderInfoId, @Address = @Address, @SendMessageValue = @SendMessageValue,
            @MessagePatternStepId = @MessagePatternStepId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;
END;
GO
