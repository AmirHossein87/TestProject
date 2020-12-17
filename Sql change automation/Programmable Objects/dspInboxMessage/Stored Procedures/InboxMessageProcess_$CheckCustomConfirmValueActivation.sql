IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$CheckCustomConfirmValueActivation]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$CheckCustomConfirmValueActivation];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$CheckCustomConfirmValueActivation]
    @ProviderInfoId INT, @Address TSTRING, @IsActive BIT OUTPUT
AS
BEGIN
    -- It must be overwrite by client
    BEGIN TRY
        EXEC InboxMessage.InboxMessageProcess_CheckCustomConfirmValueActivation @ProviderInfoId = @ProviderInfoId, @Address = @Address,
            @IsActive = @IsActive OUTPUT;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;
END;
GO
