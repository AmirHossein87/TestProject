IF OBJECT_ID('[dsp].[Setting_SetProps]') IS NOT NULL
	DROP PROCEDURE [dsp].[Setting_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Setting_SetProps]
    @AppName TSTRING = N'<notset>', @AppVersion TSTRING = N'<notset>', @SystemUserId TSTRING = N'<notset>', @AppUserId TSTRING = N'<notset>',
    @PaginationDefaultRecordCount INT = -1, @PaginationMaxRecordCount INT = -1, @IsProductionEnvironment INT = -1, @IsUnitTestMode INT = -1,
    @ConfirmServerName TSTRING = NULL, @MaintenanceMode INT = -1, @IsVersioningEnable INT = -1, @IsEnabledInitNewAppVersion INT = -1
AS
BEGIN

    IF (dsp.Param_IsSet(@IsProductionEnvironment) = 1)
    BEGIN
        -- Verify server name if the IsProductionEnvironment is going to unset
        DECLARE @OldIsProductionEnvironment INT;
        EXEC dsp.Setting_GetProps @IsProductionEnvironment = @OldIsProductionEnvironment OUTPUT;
        IF (@IsProductionEnvironment = 0 AND @OldIsProductionEnvironment = 1) --
            EXEC dsp.Util_VerifyServerName @ConfirmServerName = @ConfirmServerName;

        -- Update IsProductionEnvironment
        UPDATE  dsp.Setting
           SET  IsProductionEnvironment = @IsProductionEnvironment;
    END;

    IF (dsp.Param_IsSet(@AppName) = 1)
        UPDATE  dsp.Setting
           SET  AppName = @AppName;

    IF (dsp.Param_IsSet(@AppVersion) = 1)
    BEGIN
        EXEC dsp.[Setting_$IncreaseAppVersion] @AppVersion = @AppVersion OUTPUT, @ForceIncrease = 0;
        IF (@AppVersion IS NULL) --
            EXEC dsp.ThrowGeneralException @ProcId = @@PROCID, @Message = 'AppVersion contains an invalid value!';
        UPDATE  dsp.Setting
           SET  AppVersion = @AppVersion;
    END;

    IF (dsp.Param_IsSet(@PaginationDefaultRecordCount) = 1)
        UPDATE  dsp.Setting
           SET  PaginationDefaultRecordCount = @PaginationDefaultRecordCount;

    IF (dsp.Param_IsSet(@PaginationMaxRecordCount) = 1)
        UPDATE  dsp.Setting
           SET  PaginationMaxRecordCount = @PaginationMaxRecordCount;

    IF (dsp.Param_IsSet(@IsUnitTestMode) = 1)
        UPDATE  dsp.Setting
           SET  IsUnitTestMode = @IsUnitTestMode;

    IF (dsp.Param_IsSet(@SystemUserId) = 1)
        UPDATE  dsp.Setting
           SET  SystemUserId = @SystemUserId;

    IF (dsp.Param_IsSet(@AppUserId) = 1)
        UPDATE  dsp.Setting
           SET  AppUserId = @AppUserId;

    IF (dsp.Param_IsSet(@MaintenanceMode) = 1)
        UPDATE  dsp.Setting
           SET  MaintenanceMode = @MaintenanceMode;

    IF (dsp.Param_IsSet(@IsVersioningEnable) = 1)
        UPDATE  dsp.Setting
           SET  IsVersioningEnable = @IsVersioningEnable;

    IF (dsp.Param_IsSet(@IsEnabledInitNewAppVersion) = 1)
        UPDATE  dsp.Setting
           SET  IsEnabledInitNewAppVersion = @IsEnabledInitNewAppVersion;

END;











GO
