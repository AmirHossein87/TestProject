IF OBJECT_ID('[dsperr].[ValidationErrorId]') IS NOT NULL
	DROP FUNCTION [dsperr].[ValidationErrorId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[ValidationErrorId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55009;  
END
			
GO
