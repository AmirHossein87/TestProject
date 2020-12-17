IF OBJECT_ID('[dbo].[Init_Cleanup]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_Cleanup];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Init_Cleanup]
AS
BEGIN
    SET NOCOUNT ON;

    -- Protect production environment
    EXEC dsp.Util_ProtectProductionEnvironment;

    -- Delete Setting
    DELETE  dbo.Setting;

    DELETE  dbo.Users;

END;
GO
