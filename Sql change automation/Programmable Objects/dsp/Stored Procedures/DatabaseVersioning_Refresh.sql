IF OBJECT_ID('[dsp].[DatabaseVersioning_Refresh]') IS NOT NULL
	DROP PROCEDURE [dsp].[DatabaseVersioning_Refresh];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[DatabaseVersioning_Refresh]
    @SnapshotTime DATETIME = NULL
AS
BEGIN

    -- Check MirroringIsEnabled
    DECLARE @MirroringIsEnabled INT;
    EXEC DatabaseVersioning.Setting_GetProps @MirroringIsEnabled = @MirroringIsEnabled OUTPUT;
    IF @MirroringIsEnabled = 0
        RETURN;

    -- Satisfied source and destionatin structure
    DECLARE @TablesJsonResult TJSON;
    EXEC DatabaseVersioning.Database_CompareTablesStructure @TablesJsonResult = @TablesJsonResult OUTPUT;

    -- Call sync engine
    EXEC DatabaseVersioning.Table_SyncAllData @SnapshotTime = @SnapshotTime;

END;

GO
