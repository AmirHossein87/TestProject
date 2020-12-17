IF OBJECT_ID('[dsp].[Setting_GetProps]') IS NOT NULL
	DROP PROCEDURE [dsp].[Setting_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Setting_GetProps]
    @AppName TSTRING = NULL OUT, @AppVersion TSTRING = NULL OUT, @SystemUserId TSTRING = NULL OUT, @AppUserId TSTRING = NULL OUT,
    @IsProductionEnvironment BIT = NULL OUT, @PaginationDefaultRecordCount INT = NULL OUT, @PaginationMaxRecordCount INT = NULL OUT,
    @IsUnitTestMode BIT = NULL OUT, @MaintenanceMode INT = NULL OUT, @IsVersioningEnable BIT = NULL OUT, @IsEnabledInitNewAppVersion BIT = NULL OUT,
    @StoredProcedureVersionNumberPrefix TSTRING = NULL OUTPUT, @IsEnabledRequestWroker BIT = NULL OUTPUT
AS
BEGIN

    SELECT --
        @AppName = AppName, --
        @AppVersion = AppVersion, -- 
        @SystemUserId = SystemUserId, -- 
        @AppUserId = AppUserId, -- 
        @AppVersion = AppVersion, -- 
        @IsProductionEnvironment = IsProductionEnvironment, --
        @PaginationDefaultRecordCount = PaginationDefaultRecordCount, --
        @PaginationMaxRecordCount = PaginationMaxRecordCount, --
        @IsUnitTestMode = IsUnitTestMode, --
        @MaintenanceMode = MaintenanceMode, --
        @IsVersioningEnable = IsVersioningEnable, --
        @IsEnabledInitNewAppVersion = IsEnabledInitNewAppVersion, --
        @StoredProcedureVersionNumberPrefix = StoredProcedureVersionNumberPrefix, --
        @IsEnabledRequestWroker = IsEnabledRequestWroker --
      FROM  dsp.Setting;

END;
GO
