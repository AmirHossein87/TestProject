IF OBJECT_ID('[err].[FatalErrorId]') IS NOT NULL
	DROP FUNCTION [err].[FatalErrorId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [err].[FatalErrorId]()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55012;  
END
GO
