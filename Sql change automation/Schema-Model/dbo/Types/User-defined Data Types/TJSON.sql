﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

IF TYPE_ID('[dbo].[TJSON]') IS NOT NULL
	DROP TYPE [dbo].[TJSON];

GO
CREATE TYPE [dbo].[TJSON] FROM nvarchar (max) NULL
GO
