IF OBJECT_ID('[dsperr].[NoOperationId]') IS NOT NULL
	DROP FUNCTION [dsperr].[NoOperationId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[NoOperationId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55015;  
END
			
GO
