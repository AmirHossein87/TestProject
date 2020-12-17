IF OBJECT_ID('[dsp].[Validate_IsValidEmail]') IS NOT NULL
	DROP FUNCTION [dsp].[Validate_IsValidEmail];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Email must contain @ and dot and should not finish by dot
CREATE FUNCTION [dsp].[Validate_IsValidEmail] (@Email TSTRING)
RETURNS BIT
AS
BEGIN
	DECLARE @pattern TSTRING;
	IF (@Email LIKE '%_@_%' AND @Email LIKE '%_._%' AND @Email NOT LIKE '%[.]')
		RETURN 1;
	RETURN 0;
END;


GO
