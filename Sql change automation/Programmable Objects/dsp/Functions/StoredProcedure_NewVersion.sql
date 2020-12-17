IF OBJECT_ID('[dsp].[StoredProcedure_NewVersion]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_NewVersion];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_NewVersion] (@SchemaName TSTRING,
    @StoredProcedureName TSTRING,
    @StoredProcedureVersion INT)
RETURNS TABLE
AS
RETURN (   SELECT   TOP 1 AVD.AppVersionDetailId, --
               AVD.AppVersionId, --
               AVD.StoredProcedureName, --
               AVD.StoredProcedurePhysicalName, --
               AVD.SchemaName, --
               AVD.StoredProcedureVersionNumber, --
               AVD.ExpirationTime --
             FROM   dsp.AppVersionDetail AS AVD
            WHERE   AVD.SchemaName = @SchemaName --
               AND  AVD.StoredProcedureName = @StoredProcedureName --
               AND  AVD.StoredProcedureVersionNumber >= @StoredProcedureVersion
			   ORDER BY AVD.StoredProcedureVersionNumber);

GO
