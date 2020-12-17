﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspInboxMessage].[Provider]
(
[ProviderId] [int] NOT NULL,
[ProviderName] [nvarchar] (500) NOT NULL,
[ProviderTypeId] [tinyint] NOT NULL,
[IsEnable] [bit] NOT NULL,
[Description] [nvarchar] (max) NULL
)
GO
ALTER TABLE [dspInboxMessage].[Provider] ADD CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED  ([ProviderId])
GO
ALTER TABLE [dspInboxMessage].[Provider] ADD CONSTRAINT [FK_Provider_ProviderType] FOREIGN KEY ([ProviderTypeId]) REFERENCES [dspInboxMessage].[ProviderType] ([ProviderTypeId])
GO
