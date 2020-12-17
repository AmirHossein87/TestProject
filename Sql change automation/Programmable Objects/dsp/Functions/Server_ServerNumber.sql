IF OBJECT_ID('[dsp].[Server_ServerNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[Server_ServerNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [dsp].[Server_ServerNumber] (@ServerName TSTRING)
RETURNS INT
AS
BEGIN
    SET @ServerName = SUBSTRING(@ServerName, LEN(@ServerName), 1);
    RETURN IIF(@ServerName IS NULL OR   ISNUMERIC(@ServerName) != 1, NULL, CAST(@ServerName AS INT));
END;
GO
