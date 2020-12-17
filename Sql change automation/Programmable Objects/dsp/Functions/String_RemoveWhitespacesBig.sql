IF OBJECT_ID('[dsp].[String_RemoveWhitespacesBig]') IS NOT NULL
	DROP FUNCTION [dsp].[String_RemoveWhitespacesBig];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[String_RemoveWhitespacesBig] ( @String TBIGSTRING )
RETURNS TBIGSTRING
AS
BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(@String, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '');
END;




GO
