IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$ValidateCustomConfirmValue]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ValidateCustomConfirmValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$ValidateCustomConfirmValue]
    @ProviderInfoId INT, @Address TSTRING, @MessageBody TSTRING, @IsValid BIT OUTPUT
AS
BEGIN
    -- It must be overwrite by client
    BEGIN TRY
        EXEC InboxMessage.[InboxMessageProcess_ValidateCustomConfirmValue] @ProviderInfoId = @ProviderInfoId, @Address = @Address, @MessageBody = @MessageBody,
            @IsValid = @IsValid OUTPUT;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;
END;

GO
