IF OBJECT_ID('[dsperr].[AuthUserNotFoundId]') IS NOT NULL
	DROP FUNCTION [dsperr].[AuthUserNotFoundId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[AuthUserNotFoundId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55019;  
END
			
GO
