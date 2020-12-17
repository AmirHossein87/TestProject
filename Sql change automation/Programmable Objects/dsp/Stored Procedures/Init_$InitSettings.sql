IF OBJECT_ID('[dsp].[Init_$InitSettings]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$InitSettings];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$InitSettings]
AS
BEGIN
    SET NOCOUNT ON;

    ----------------
    -- Insert the only dsp.Settings record
    ----------------
    IF (NOT EXISTS (SELECT  1 FROM  dsp.Setting))
    BEGIN
        -- Report it is done
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Creating default dsp.Settings';
        INSERT  dsp.Setting (SettingId)
        VALUES (1);
    END;    
END;

GO
