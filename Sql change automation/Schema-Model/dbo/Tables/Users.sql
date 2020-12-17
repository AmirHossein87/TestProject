﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[Users]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[AuthUserId] [int] NULL,
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_Users_IsEnabled] DEFAULT ((1)),
[ModifiedByUserId] [int] NULL,
[SysStartTime] [datetime2] NOT NULL CONSTRAINT [DF_UsersSysStartTime] DEFAULT (sysutcdatetime()),
[SysEndTime] [datetime2] NOT NULL CONSTRAINT [DF_UsersSysEndTime] DEFAULT ('9999.12.31 23:59:59.99'),
[MoneyTransactionCountModeId] [tinyint] NULL,
[ModifiedTime] [datetime] NULL
)
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AuthUserId] ON [dbo].[Users] ([AuthUserId])
GO
