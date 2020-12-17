IF OBJECT_ID('[dsp].[Convert_RowVersionToString]') IS NOT NULL
	DROP FUNCTION [dsp].[Convert_RowVersionToString];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Convert_RowVersionToString] (@Value VARBINARY(/*Ignore CC*/8))
RETURNS TSTRING
BEGIN
    RETURN CONVERT(NVARCHAR(/*Ignore CC*/4000), CONVERT(BINARY(8), @Value), 1);
END;





GO
