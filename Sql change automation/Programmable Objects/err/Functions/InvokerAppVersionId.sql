IF OBJECT_ID('[err].[InvokerAppVersionId]') IS NOT NULL
	DROP FUNCTION [err].[InvokerAppVersionId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [err].[InvokerAppVersionId]()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55026;  
END
GO
