IF OBJECT_ID('[dspconst].[RequestProcessResultObjectPattern]') IS NOT NULL
	DROP FUNCTION [dspconst].[RequestProcessResultObjectPattern];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dspconst].[RequestProcessResultObjectPattern] ()
RETURNS TJSON
AS
BEGIN
    RETURN '{"ObjectNumber": 1, "ResultNumber": 1, "Error": ""}';
END;
GO
