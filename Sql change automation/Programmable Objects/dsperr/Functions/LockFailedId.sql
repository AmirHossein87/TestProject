IF OBJECT_ID('[dsperr].[LockFailedId]') IS NOT NULL
	DROP FUNCTION [dsperr].[LockFailedId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[LockFailedId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55008;  
END
			
GO
