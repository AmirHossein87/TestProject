IF OBJECT_ID('[dsperr].[AccessDeniedOrObjectNotExistsId]') IS NOT NULL
	DROP FUNCTION [dsperr].[AccessDeniedOrObjectNotExistsId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[AccessDeniedOrObjectNotExistsId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55002;  
END
			
GO
