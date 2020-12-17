IF OBJECT_ID('[dsperr].[ProductionEnvinronmentIsTurnedOnId]') IS NOT NULL
	DROP FUNCTION [dsperr].[ProductionEnvinronmentIsTurnedOnId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsperr].[ProductionEnvinronmentIsTurnedOnId]()
RETURNS INT 
WITH SCHEMABINDING
AS
BEGIN
	RETURN 55029;  
END
			
GO
