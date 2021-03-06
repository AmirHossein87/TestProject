﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

IF TYPE_ID('[dbo].[ud_LogFilter]') IS NOT NULL
	DROP TYPE [dbo].[ud_LogFilter];

GO
CREATE TYPE [dbo].[ud_LogFilter] AS TABLE
(
[LogId] [bigint] NULL,
[CategoryId] [int] NULL,
[SubCategoryId] [int] NULL,
[CustomData] [dbo].[TJSON] NULL,
[CreatedTime] [datetime] NULL
)
GO
