IF OBJECT_ID('[dsp].[Init_$ImpCleanup]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$ImpCleanup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$ImpCleanup]
AS
BEGIN
    SET NOCOUNT ON;
    -- Protect production environment
    EXEC dsp.Util_ProtectProductionEnvironment;

    -- delete all table's records in test environment
    EXEC dsp.Table_DeleteRecords;
END;



GO
