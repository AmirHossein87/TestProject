IF OBJECT_ID('[dbo].[Setting_GetProps]') IS NOT NULL
	DROP PROCEDURE [dbo].[Setting_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Retrieve Application settings
CREATE PROCEDURE [dbo].[Setting_GetProps]
    @AppSetting1 INT = -1 OUT, @AppSetting2 INT = -1 OUT
AS
BEGIN
	SET NOCOUNT ON;

    SELECT  @AppSetting1 = AppSetting1, @AppSetting2 = AppSetting2
      FROM  dbo.Setting;

END;
GO
