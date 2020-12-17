IF OBJECT_ID('[dsp].[AppVersion_Details]') IS NOT NULL
	DROP FUNCTION [dsp].[AppVersion_Details];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[AppVersion_Details] (@AppVersionNumber TSTRING)
RETURNS TABLE
--WITH ENCRYPTION|SCHEMABINDING, ...
AS
RETURN (   SELECT   AVD.AppVersionDetailId, --
               AVD.AppVersionId, --
               AVD.StoredProcedureName, --
               AVD.StoredProcedurePhysicalName, --
               AVD.StoredProcedureVersionNumber, --
               AVD.SchemaName, --
               AVD.ExpirationTime, --
               AVD.CreatedTime --
             FROM   dsp.AppVersionDetail AS AVD
                    INNER JOIN --
               dsp.AppVersion AS AV ON AV.AppVersionId = AVD.AppVersionId
            WHERE   AV.VersionNumber = @AppVersionNumber);

GO
