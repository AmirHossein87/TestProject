IF OBJECT_ID('[dsp].[Param_IsSetOrNotNull]') IS NOT NULL
	DROP FUNCTION [dsp].[Param_IsSetOrNotNull];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Param_IsSetOrNotNull] (
	@value SQL_VARIANT
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(@value IS NULL OR dsp.Param_IsSet(@value) = 0, 0, 1);
END;












GO
