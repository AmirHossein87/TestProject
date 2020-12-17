IF OBJECT_ID('[dspInboxMessage].[Init_$InitSettings]') IS NOT NULL
	DROP PROCEDURE [dspInboxMessage].[Init_$InitSettings];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dspInboxMessage].[Init_$InitSettings]
AS
BEGIN
    SET NOCOUNT ON;

    ----------------
    -- Insert the only dsp.Settings record
    ----------------
    IF (NOT EXISTS (SELECT  1 FROM  dspInboxMessage.Setting))
    BEGIN
        -- Report it is done
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'Creating default InboxMessage.Settings';
        INSERT  dspInboxMessage.Setting (SettingId)
        VALUES (1);
    END;    
END;
GO
