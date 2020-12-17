IF OBJECT_ID('[dsperr].[ObjectIsInUseId]') IS NOT NULL
	DROP FUNCTION [dsperr].[ObjectIsInUseId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[ObjectIsInUseId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55004;  
END
			
GO