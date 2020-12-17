IF OBJECT_ID('[dspInboxMessage].[Setting_SetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[Setting_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dspInboxMessage].[Setting_SetProps]
    @WaitExpirationTreshold INT = -1, @RefreshRecordCount INT = -1, @ProcessRecordCount INT = -1, @FailedConfirmStepMessage TSTRING = '<notset>',
    @AddressRegistrationIsActive INT = -1, @FaildConfirmActivationMessage TSTRING = '<notset>'
AS
BEGIN
    IF (dsp.Param_IsSetOrNotNull(@WaitExpirationTreshold) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  WaitExpirationTreshold = @WaitExpirationTreshold;

    IF (dsp.Param_IsSetOrNotNull(@RefreshRecordCount) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  RefreshRecordCount = @RefreshRecordCount;

    IF (dsp.Param_IsSetOrNotNull(@ProcessRecordCount) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  ProcessRecordCount = @ProcessRecordCount;

    IF (dsp.Param_IsSetOrNotNull(@FailedConfirmStepMessage) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  FailedConfirmStepMessage = @FailedConfirmStepMessage;

    IF (dsp.Param_IsSetOrNotNull(@AddressRegistrationIsActive) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  AddressRegistrationIsActive = @AddressRegistrationIsActive;

    IF (dsp.Param_IsSetOrNotNull(@FaildConfirmActivationMessage) = 1)
        UPDATE  dspInboxMessage.Setting
           SET  FaildConfirmActivationMessage = @FaildConfirmActivationMessage;
END;

GO
