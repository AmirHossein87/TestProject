IF OBJECT_ID('[dsp].[Database_ServerName]') IS NOT NULL
	DROP FUNCTION [dsp].[Database_ServerName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[Database_ServerName] ()
RETURNS TSTRING
AS
BEGIN
	RETURN @@SERVERNAME;
END;

GO
