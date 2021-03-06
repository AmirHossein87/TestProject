﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dsp].[AppVersionDetail]
(
[AppVersionDetailId] [int] NOT NULL IDENTITY(1, 1),
[AppVersionId] [int] NOT NULL,
[StoredProcedureId] [int] NOT NULL,
[StoredProcedureName] [nvarchar] (256) NOT NULL,
[StoredProcedurePhysicalName] [nvarchar] (256) NOT NULL,
[SchemaName] [nvarchar] (50) NOT NULL,
[StoredProcedureVersionNumber] [int] NULL,
[ExpirationTime] [datetime] NULL,
[CreatedTime] [datetime] NOT NULL CONSTRAINT [DF_AppVersionDetail_CreatedTime] DEFAULT (getdate())
)
GO
ALTER TABLE [dsp].[AppVersionDetail] ADD CONSTRAINT [PK_AppVersionDetail] PRIMARY KEY CLUSTERED  ([AppVersionDetailId])
GO
ALTER TABLE [dsp].[AppVersionDetail] ADD CONSTRAINT [FK_AppVersionDetail_AppVersion_AppVersionId] FOREIGN KEY ([AppVersionId]) REFERENCES [dsp].[AppVersion] ([AppVersionId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'118', 'SCHEMA', N'dsp', 'TABLE', N'AppVersionDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'dsp', 'TABLE', N'AppVersionDetail', NULL, NULL
GO
