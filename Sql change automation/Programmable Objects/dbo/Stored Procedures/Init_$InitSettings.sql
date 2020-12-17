IF OBJECT_ID('[dbo].[Init_$InitSettings]') IS NOT NULL
	DROP PROCEDURE [dbo].[Init_$InitSettings];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Init_$InitSettings]
AS
BEGIN
    -- Tof
    RETURN 1;
END;
GO
