IF OBJECT_ID('[dspInboxMessage].[Setting_GetProps]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[Setting_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ALTER TABLE dspInboxMessage.Setting ADD FaildConfirmActivationMessage NVARCHAR(400)

CREATE PROCEDURE [dspInboxMessage].[Setting_GetProps]
    @WaitExpirationTreshold INT = NULL OUT, @RefreshRecordCount INT = NULL OUT, @ProcessRecordCount INT = NULL OUT,
    @FailedConfirmStepMessage TSTRING = NULL OUTPUT, @AddressRegistrationIsActive BIT = NULL OUTPUT, @FaildConfirmActivationMessage TSTRING = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT --
        @WaitExpirationTreshold = ISNULL(WaitExpirationTreshold, 300), --
        @RefreshRecordCount = ISNULL(RefreshRecordCount, 1000), --
        @ProcessRecordCount = ISNULL(ProcessRecordCount, 1000), --
        @FailedConfirmStepMessage = FailedConfirmStepMessage, --
        @AddressRegistrationIsActive = ISNULL(AddressRegistrationIsActive, 0), --
        @FaildConfirmActivationMessage = FaildConfirmActivationMessage --
      FROM  dspInboxMessage.Setting;

END;
GO
