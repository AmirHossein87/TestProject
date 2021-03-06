﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspAuth].[PermissionGroup]
(
[PermissionGroupId] [smallint] NOT NULL,
[PermissionGroupName] [varchar] (100) NOT NULL,
[Description] [nvarchar] (max) NULL
)
GO
ALTER TABLE [dspAuth].[PermissionGroup] ADD CONSTRAINT [PK_PermissionGroupId] PRIMARY KEY CLUSTERED  ([PermissionGroupId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'128', 'SCHEMA', N'dspAuth', 'TABLE', N'PermissionGroup', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'dspAuth', 'TABLE', N'PermissionGroup', NULL, NULL
GO
