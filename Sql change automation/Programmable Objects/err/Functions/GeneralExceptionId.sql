IF OBJECT_ID('[err].[GeneralExceptionId]') IS NOT NULL
	DROP FUNCTION [err].[GeneralExceptionId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [err].[GeneralExceptionId]()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55001;  
END
GO
