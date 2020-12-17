IF OBJECT_ID('[dsp].[String_IsContain]') IS NOT NULL
	DROP FUNCTION [dsp].[String_IsContain];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[String_IsContain] (@ExpressionToFind TBIGSTRING,
    @ExpressionToSearch TBIGSTRING)
RETURNS TABLE
AS
RETURN (SELECT  IIF(CHARINDEX(@ExpressionToFind, @ExpressionToSearch, 0) = 0, 0, 1) AS IsContain);

GO
