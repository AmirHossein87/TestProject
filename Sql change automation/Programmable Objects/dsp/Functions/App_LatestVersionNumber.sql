IF OBJECT_ID('[dsp].[App_LatestVersionNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[App_LatestVersionNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[App_LatestVersionNumber] ()
RETURNS TSTRING
--WITH ENCRYPTION|SCHEMABINDING, ...
AS
BEGIN
    DECLARE @LatestAppVersionNumber TSTRING;

    -- Get the latest application version number
    SELECT  TOP 1 @LatestAppVersionNumber = AV.VersionNumber
      FROM  dsp.AppVersion AS AV
     ORDER BY AV.AppVersionId DESC;

    RETURN @LatestAppVersionNumber;
END;
GO
