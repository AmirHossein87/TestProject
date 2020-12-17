IF OBJECT_ID('[DatabaseVersioning].[Init_$InitSettings]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Init_$InitSettings];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Init_$InitSettings]
AS
BEGIN
    SET NOCOUNT ON;

    ----------------
    -- Insert the only dsp.Settings record
    ----------------
    IF (NOT EXISTS (SELECT  1 FROM  DatabaseVersioning.Setting))
    BEGIN
        -- Report it is done
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Creating default DatabaseVersioning.Settings';
        INSERT  DatabaseVersioning.Setting (Id)
        VALUES (1);
    END;    
END;
GO
