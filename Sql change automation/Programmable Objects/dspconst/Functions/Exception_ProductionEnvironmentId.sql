IF OBJECT_ID('[dspconst].[Exception_ProductionEnvironmentId]') IS NOT NULL
	DROP FUNCTION [dspconst].[Exception_ProductionEnvironmentId];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dspconst].[Exception_ProductionEnvironmentId] ()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN 1000000000;
END;
GO
