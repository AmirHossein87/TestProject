IF OBJECT_ID('[err].[ObjectIsInUseId]') IS NOT NULL
	DROP FUNCTION [err].[ObjectIsInUseId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [err].[ObjectIsInUseId]()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55005;  
END
GO