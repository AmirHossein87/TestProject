IF OBJECT_ID('[dspInboxMessage].[InboxMessageProcess_$GetCustomValue]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetCustomValue];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[InboxMessageProcess_$GetCustomValue]
    @ProviderInfoId INT, @Address TSTRING, @MessageLastData TJSON, @MessagePatternStepId INT, @ParameterName TSTRING, @ParameterValue TSTRING OUTPUT
AS
BEGIN
    -- It must be overwrite by client
    BEGIN TRY
        EXEC InboxMessage.InboxMessageProcess_GetCustomValue @ProviderInfoId = @ProviderInfoId, @Address = @Address,
            @MessageLastData = @MessageLastData, @MessagePatternStepId = @MessagePatternStepId, @ParameterName = @ParameterName,
            @ParameterValue = @ParameterValue OUTPUT;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage TSTRING = ERROR_MESSAGE();
        EXEC dsp.Exception_ThrowWithCommonFormat @ProcId = @@PROCID, @ErrorMessage = @ErrorMessage;
    END CATCH;

END;

GO
