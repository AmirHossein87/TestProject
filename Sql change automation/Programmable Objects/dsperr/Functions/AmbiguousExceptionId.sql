IF OBJECT_ID('[dsperr].[AmbiguousExceptionId]') IS NOT NULL
	DROP FUNCTION [dsperr].[AmbiguousExceptionId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[AmbiguousExceptionId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55014;  
END
			
GO
