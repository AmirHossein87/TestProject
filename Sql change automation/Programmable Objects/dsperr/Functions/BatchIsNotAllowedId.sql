IF OBJECT_ID('[dsperr].[BatchIsNotAllowedId]') IS NOT NULL
	DROP FUNCTION [dsperr].[BatchIsNotAllowedId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[BatchIsNotAllowedId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55017;  
END
			
GO
