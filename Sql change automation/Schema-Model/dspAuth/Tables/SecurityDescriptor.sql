﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspAuth].[SecurityDescriptor]
(
[SecurityDescriptorId] [bigint] NOT NULL IDENTITY(1, 1),
[ObjectTypeId] [smallint] NOT NULL,
[ObjectId] [int] NOT NULL
)
GO
ALTER TABLE [dspAuth].[SecurityDescriptor] ADD CONSTRAINT [PK_SecurityDescriptor] PRIMARY KEY CLUSTERED  ([SecurityDescriptorId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ObjectId_ObjectTypeId] ON [dspAuth].[SecurityDescriptor] ([ObjectTypeId], [ObjectId])
GO
ALTER TABLE [dspAuth].[SecurityDescriptor] ADD CONSTRAINT [FK_SecurityDescriptor_ObjectType_ObjectTypeId] FOREIGN KEY ([ObjectTypeId]) REFERENCES [dspAuth].[ObjectType] ([ObjectTypeId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'136', 'SCHEMA', N'dspAuth', 'TABLE', N'SecurityDescriptor', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'dspAuth', 'TABLE', N'SecurityDescriptor', NULL, NULL
GO