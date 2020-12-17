IF OBJECT_ID('[dbo].[Setting_SetProps]') IS NOT NULL
	DROP PROCEDURE [dbo].[Setting_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Retrieve Application settings
CREATE PROCEDURE [dbo].[Setting_SetProps]
    @AppSetting1 INT = -1, @AppSetting2 INT = -1
AS
BEGIN
    SET NOCOUNT ON;

    IF (dsp.Param_IsSet(@AppSetting1) = 1)
        UPDATE  dbo.Setting
           SET  AppSetting1 = @AppSetting1;

    IF (dsp.Param_IsSet(@AppSetting2) = 2)
        UPDATE  dbo.Setting
           SET  AppSetting2 = @AppSetting2;
END;
GO
