IF OBJECT_ID('[dspconst].[RequestProcessStatus_DisableBySetting]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessStatus_DisableBySetting];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[RequestProcessStatus_DisableBySetting] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 4;
END;
GO
