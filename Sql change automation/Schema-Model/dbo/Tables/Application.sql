﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[Application]
(
[ApplicationId] [int] NOT NULL,
[ApplicationName] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[Application] ADD CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED  ([ApplicationId])
GO
