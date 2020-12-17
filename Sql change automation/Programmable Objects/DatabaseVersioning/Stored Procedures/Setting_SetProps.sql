IF OBJECT_ID('[DatabaseVersioning].[Setting_SetProps]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Setting_SetProps];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Setting_SetProps]
    @MirroringIsEnabled INT = -1
AS
BEGIN
IF dsp.Param_IsSetOrNotNull(@MirroringIsEnabled) = 1
    UPDATE  DatabaseVersioning.Setting
       SET  MirroringIsEnabled = @MirroringIsEnabled
     WHERE  Id = 1;
END;
GO
