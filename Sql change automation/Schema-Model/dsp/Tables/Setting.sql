﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dsp].[Setting]
(
[SettingId] [int] NOT NULL,
[AppName] [nvarchar] (50) NOT NULL CONSTRAINT [DF_Setting_AppName] DEFAULT (N'NewApplicationName'),
[AppVersion] [varchar] (50) NOT NULL CONSTRAINT [DF_Setting_AppVersion] DEFAULT ('1.0.0'),
[IsUnitTestMode] [bit] NOT NULL CONSTRAINT [DF_Setting_IsUnitTestMode] DEFAULT ((0)),
[IsProductionEnvironment] [bit] NOT NULL CONSTRAINT [DF_Setting_IsProductionEnvironment] DEFAULT ((0)),
[PaginationDefaultRecordCount] [int] NOT NULL CONSTRAINT [DF_Setting_PaginationDefaultRecordCount] DEFAULT ((50)),
[PaginationMaxRecordCount] [int] NOT NULL CONSTRAINT [DF_Setting_PaginationMaxRecordCount] DEFAULT ((200)*(1000000)),
[AppUserId] [nvarchar] (50) NULL,
[SystemUserId] [nvarchar] (50) NULL,
[MaintenanceMode] [tinyint] NOT NULL CONSTRAINT [DF_Setting_MaintenanceMode] DEFAULT ((0)),
[IsVersioningEnable] [bit] NULL CONSTRAINT [DF_Setting_IsVersioningEnable] DEFAULT ((0)),
[IsEnabledInitNewAppVersion] [bit] NULL CONSTRAINT [DF_Setting_IsInitNewAppVersion] DEFAULT ((0)),
[StoredProcedureVersionNumberPrefix] [nvarchar] (50) NULL,
[IsEnabledRequestWroker] [bit] NULL CONSTRAINT [DF__Setting__IsEnabl__00B50445] DEFAULT ((1)),
[StartTime] [datetime2] NOT NULL CONSTRAINT [DF__Setting__StartTi__5DF76E9B] DEFAULT (getutcdate()),
[EndTime] [datetime2] NOT NULL CONSTRAINT [DF__Setting__EndTime__5EEB92D4] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999',(0)))
)
GO
ALTER TABLE [dsp].[Setting] ADD CONSTRAINT [CK_Setting_MaintenaceMode] CHECK (([MaintenanceMode]=(2) OR [MaintenanceMode]=(1) OR [MaintenanceMode]=(0)))
GO
ALTER TABLE [dsp].[Setting] ADD CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED  ([SettingId])
GO
EXEC sp_addextendedproperty N'DatabaseVersioningPriorityLevel', N'143', 'SCHEMA', N'dsp', 'TABLE', N'Setting', NULL, NULL
GO
EXEC sp_addextendedproperty N'TemporalTypeId', N'1', 'SCHEMA', N'dsp', 'TABLE', N'Setting', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Midware uses this UserId if it is set otherwise the midware use SystemUserId', 'SCHEMA', N'dsp', 'TABLE', N'Setting', 'COLUMN', N'AppUserId'
GO
