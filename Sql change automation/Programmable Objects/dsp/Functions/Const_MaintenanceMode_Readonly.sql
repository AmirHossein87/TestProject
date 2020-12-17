IF OBJECT_ID('[dsp].[Const_MaintenanceMode_Readonly]') IS NOT NULL
	DROP FUNCTION [dsp].[Const_MaintenanceMode_Readonly];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Const_MaintenanceMode_Readonly] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;



GO
