IF OBJECT_ID('[dsp].[Param_IsSetForMaxSize]') IS NOT NULL
	DROP FUNCTION [dsp].[Param_IsSetForMaxSize];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Param_IsSetForMaxSize] (@Value NVARCHAR(MAX /*NCQ*/))
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
    IF (@Value IS NULL)
        RETURN 0;

    IF (CAST(@Value AS NVARCHAR(MAX /*NoCodeChecker*/)) = '<notset>' OR CAST(@Value AS NVARCHAR(/*NoCodeChecker*/ 10)) = '<noaccess>')
        RETURN 0;

    RETURN 1;
END;














GO
