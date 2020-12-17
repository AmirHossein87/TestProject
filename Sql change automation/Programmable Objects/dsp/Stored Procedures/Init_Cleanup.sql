IF OBJECT_ID('[dsp].[Init_Cleanup]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_Cleanup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dsp].[Init_Cleanup]
AS
BEGIN
    SET NOCOUNT ON;

	-- Protect production environment
	EXEC dsp.Util_ProtectProductionEnvironment
			
	-- Delete Junction Tables 

	-- Delete base tables 

	-- Delete Lookup tables (may not required)

END
		
GO
