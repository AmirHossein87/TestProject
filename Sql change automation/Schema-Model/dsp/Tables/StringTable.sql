﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dsp].[StringTable]
(
[StringId] [nvarchar] (100) NOT NULL,
[StringValue] [nvarchar] (max) NOT NULL,
[LocaleName] [nvarchar] (10) NULL,
[Description] [nvarchar] (max) NULL
)
GO
ALTER TABLE [dsp].[StringTable] ADD CONSTRAINT [PK_StringTable_Name] PRIMARY KEY CLUSTERED  ([StringId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'137', 'SCHEMA', N'dsp', 'TABLE', N'StringTable', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'dsp', 'TABLE', N'StringTable', NULL, NULL
GO