IF OBJECT_ID('[DatabaseVersioning].[Setting_GetProps]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Setting_GetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Setting_GetProps]
    @GetDataRowCount INT = NULL OUT, @MirroringIsEnabled INT = NULL OUT
AS
BEGIN
    SELECT --
        @GetDataRowCount = GetDataRowCount, --
        @MirroringIsEnabled = ISNULL(MirroringIsEnabled, 10000)
      FROM  DatabaseVersioning.Setting;
END;
GO
