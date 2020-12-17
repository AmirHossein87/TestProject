IF OBJECT_ID('[dsp].[Init_$IncreaseAppVersion]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_$IncreaseAppVersion];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_$IncreaseAppVersion]
    @AppVersionId INT = NULL OUT
AS
BEGIN

    -- Get max version number
    DECLARE @MaxVersionNumber INT;
    SELECT  TOP 1 @MaxVersionNumber = AV.VersionNumber
      FROM  dsp.AppVersion AS AV
     ORDER BY AV.AppVersionId DESC;

    SET @MaxVersionNumber = ISNULL(@MaxVersionNumber, 0);
    SET @MaxVersionNumber = @MaxVersionNumber + 1;

    -- Insert new app version into the table
    INSERT INTO dsp.AppVersion (VersionNumber)
    VALUES (@MaxVersionNumber);

    SET @AppVersionId = @@IDENTITY;
END;

GO
