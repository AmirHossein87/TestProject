IF OBJECT_ID('[str].[String2]') IS NOT NULL
	DROP FUNCTION [str].[String2];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [str].[String2]() 
RETURNS TSTRING
AS 
BEGIN
	RETURN dsp.StringTable_Value('String2');
END
GO
