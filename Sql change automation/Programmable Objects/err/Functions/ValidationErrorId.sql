IF OBJECT_ID('[err].[ValidationErrorId]') IS NOT NULL
	DROP FUNCTION [err].[ValidationErrorId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [err].[ValidationErrorId]()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55015;  
END
GO
