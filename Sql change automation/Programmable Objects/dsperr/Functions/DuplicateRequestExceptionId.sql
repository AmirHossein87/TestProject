IF OBJECT_ID('[dsperr].[DuplicateRequestExceptionId]') IS NOT NULL
	DROP FUNCTION [dsperr].[DuplicateRequestExceptionId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[DuplicateRequestExceptionId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55024;  
END
			
GO
