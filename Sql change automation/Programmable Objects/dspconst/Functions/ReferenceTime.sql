IF OBJECT_ID('[dspconst].[ReferenceTime]') IS NOT NULL
	DROP FUNCTION [dspconst].[ReferenceTime];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dspconst].[ReferenceTime] ()
RETURNS DATETIME
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @ReferenceTime DATETIME = '1753-01-01';
	RETURN @ReferenceTime;
END;


GO
