IF OBJECT_ID('[dsperr].[ObjectAlreadyExistsId]') IS NOT NULL
	DROP FUNCTION [dsperr].[ObjectAlreadyExistsId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[ObjectAlreadyExistsId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55003;  
END
			
GO