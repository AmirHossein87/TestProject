﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

IF TYPE_ID('[dbo].[TSTRING]') IS NOT NULL
	DROP TYPE [dbo].[TSTRING];

GO
CREATE TYPE [dbo].[TSTRING] FROM nvarchar (4000) NULL
GO