IF OBJECT_ID('[dsp].[Param_IsSet]') IS NOT NULL
	DROP FUNCTION [dsp].[Param_IsSet];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	FUNCTION [dsp].[Param_IsSet] (@Value SQL_VARIANT)
RETURNS BIT
AS
BEGIN
	RETURN	dsp.Param_IsSetBase(@Value, 0);
END;














GO
