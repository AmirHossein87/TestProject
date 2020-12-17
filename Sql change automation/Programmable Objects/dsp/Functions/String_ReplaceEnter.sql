IF OBJECT_ID('[dsp].[String_ReplaceEnter]') IS NOT NULL
	DROP FUNCTION [dsp].[String_ReplaceEnter];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Create Function String
CREATE FUNCTION [dsp].[String_ReplaceEnter] (@Value NVARCHAR(/*NCQ*/ 4000))
RETURNS NVARCHAR(/*NCQ*/ 4000)
WITH SCHEMABINDING
AS
BEGIN
    RETURN REPLACE(@Value, N'\n', CHAR(/*No Codequality Error*/ 13) + CHAR(/*No Codequality Error*/ 10));
END;

GO
