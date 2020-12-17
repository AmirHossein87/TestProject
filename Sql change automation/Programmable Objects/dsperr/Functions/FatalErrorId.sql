IF OBJECT_ID('[dsperr].[FatalErrorId]') IS NOT NULL
	DROP FUNCTION [dsperr].[FatalErrorId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[FatalErrorId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55007;  
END
			
GO