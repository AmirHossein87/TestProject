IF OBJECT_ID('[dsp].[Convert_BinaryToBase64]') IS NOT NULL
	DROP FUNCTION [dsp].[Convert_BinaryToBase64];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- #Inliner {"InlineMode":"none"} 
CREATE FUNCTION [dsp].[Convert_BinaryToBase64] (@bin VARBINARY(MAX))
RETURNS TSTRING
AS
BEGIN
	DECLARE @Base64 TSTRING;
	/*
        SELECT dbo.f_BinaryToBase64(CONVERT(VARBINARY(MAX), 'Converting this text to Base64...'))
    */
	SET @Base64 = CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:variable("@bin")))', 'TSTRING');
	RETURN @Base64;
END;

GO
