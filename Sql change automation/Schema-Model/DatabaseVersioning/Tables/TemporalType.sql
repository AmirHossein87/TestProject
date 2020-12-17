﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [DatabaseVersioning].[TemporalType]
(
[TemporalTypeId] [tinyint] NOT NULL,
[TemporalTypeName] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [DatabaseVersioning].[TemporalType] ADD CONSTRAINT [PK_TemporalType] PRIMARY KEY CLUSTERED  ([TemporalTypeId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'148', 'SCHEMA', N'DatabaseVersioning', 'TABLE', N'TemporalType', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'DatabaseVersioning', 'TABLE', N'TemporalType', NULL, NULL
GO
