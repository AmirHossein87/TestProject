﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dspInboxMessage].[MessagePatternState]
(
[MessagePatternStateId] [int] NOT NULL,
[MessagePatternStateName] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dspInboxMessage].[MessagePatternState] ADD CONSTRAINT [PK_MessagePatternState] PRIMARY KEY CLUSTERED  ([MessagePatternStateId])
GO
