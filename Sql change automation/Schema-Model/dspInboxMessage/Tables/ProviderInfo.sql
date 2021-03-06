﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspInboxMessage].[ProviderInfo]
(
[ProviderInfoId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[ContactInfo] [nvarchar] (200) NOT NULL,
[IsEnable] [bit] NOT NULL,
[Description] [nvarchar] (max) NULL
)
GO
ALTER TABLE [dspInboxMessage].[ProviderInfo] ADD CONSTRAINT [PK_ProviderInfo] PRIMARY KEY CLUSTERED  ([ProviderInfoId])
GO
ALTER TABLE [dspInboxMessage].[ProviderInfo] ADD CONSTRAINT [FK_ProviderInfo_Provider] FOREIGN KEY ([ProviderId]) REFERENCES [dspInboxMessage].[Provider] ([ProviderId])
GO
