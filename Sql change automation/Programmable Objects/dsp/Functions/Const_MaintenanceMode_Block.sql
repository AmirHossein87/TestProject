IF OBJECT_ID('[dsp].[Const_MaintenanceMode_Block]') IS NOT NULL
	DROP FUNCTION [dsp].[Const_MaintenanceMode_Block];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Const_MaintenanceMode_Block] ()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 2;
END;


GO
