IF OBJECT_ID('[dsp].[Exception_InvalidArgumentName]') IS NOT NULL
	DROP FUNCTION [dsp].[Exception_InvalidArgumentName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Exception_InvalidArgumentName] (
	@ErrorMessage TSTRING
)
RETURNS TSTRING
AS
BEGIN
	RETURN JSON_VALUE(JSON_VALUE(@ErrorMessage, '$.errorMessage'), '$.ArgumentName');
END;


GO
