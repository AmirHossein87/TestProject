IF OBJECT_ID('[const].[Application_IcLoyalty]') IS NOT NULL
	DROP FUNCTION [const].[Application_IcLoyalty];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [const].[Application_IcLoyalty] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1;
END;
GO
