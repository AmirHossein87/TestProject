IF OBJECT_ID('[dsp].[StoredProcedure_InvokeStoreProcedureName]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_InvokeStoreProcedureName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_InvokeStoreProcedureName] (@TargetAppVersionId INT,
    @TargetStoredProcedureName TSTRING,
    @LatestAppVersionId INT)
RETURNS TSTRING
AS
BEGIN
    DECLARE @StoredProcedureInvokeName TSTRING = @TargetStoredProcedureName;

    IF (@TargetAppVersionId = @LatestAppVersionId)
        RETURN @StoredProcedureInvokeName;

    -- Get max stored procedure version number in the target application version
    DECLARE @MaxStoredProcedureVersionNumberInTarget INT;

    -- Find stored procedure invoke name
    DECLARE @NextApplicationVersionId INT = @TargetAppVersionId + 1;
    DECLARE @StordProcedureNameInNextVersion TSTRING;
    SELECT TOP 1    @StordProcedureNameInNextVersion = AVD.StoredProcedurePhysicalName
      FROM  dsp.AppVersionDetail AS AVD
     WHERE  AVD.AppVersionId = @NextApplicationVersionId --
        AND AVD.StoredProcedureVersionNumber > @MaxStoredProcedureVersionNumberInTarget
     ORDER BY AVD.StoredProcedureVersionNumber;

    SET @StoredProcedureInvokeName = ISNULL(@StordProcedureNameInNextVersion, @StoredProcedureInvokeName);

    RETURN @StoredProcedureInvokeName;
END;
GO
