﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspInboxMessage].[Setting]
(
[SettingId] [int] NOT NULL,
[WaitExpirationTreshold] [int] NULL,
[ProcessRecordCount] [int] NULL,
[RefreshRecordCount] [int] NULL,
[FailedConfirmStepMessage] [nvarchar] (200) NULL,
[AddressRegistrationIsActive] [bit] NULL CONSTRAINT [DF__Setting__Address__21F7932D] DEFAULT ((0)),
[FaildConfirmActivationMessage] [nvarchar] (400) NULL
)
GO
