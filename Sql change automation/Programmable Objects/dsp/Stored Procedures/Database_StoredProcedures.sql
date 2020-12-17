IF OBJECT_ID('[dsp].[Database_StoredProcedures]') IS NOT NULL
	DROP PROCEDURE [dsp].[Database_StoredProcedures];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Database_StoredProcedures]
    @SchemaName TSTRING, @JustLastVersion BIT = 0, @StoredProceduresJsonResult TJSON = NULL OUTPUT
AS
BEGIN
    SET @JustLastVersion = ISNULL(@JustLastVersion, 0);
    -- Get the latest application version number
    DECLARE @LatestAppVersionId INT;
    SELECT TOP 1    @LatestAppVersionId = AV.VersionNumber
      FROM  dsp.AppVersion AS AV
     ORDER BY AV.CreatedTime DESC;

    IF (@LatestAppVersionId IS NULL) --
        EXEC dsperr.ThrowInvalidOperation @ProcId = @@PROCID, @Message = 'AppVersion is empty';

    CREATE TABLE #ApplicationStoredProcedures (StoredProcedureId INT,
        AppVersionId INT,
        AppVersionDetailId INT,
        ApplicationVersionNumber NVARCHAR(/*NCQ*/ 4000),
        StoredProcedureName NVARCHAR(/*NCQ*/ 4000) COLLATE Persian_100_CS_AI,
        StoredProcedureInvokeName NVARCHAR(/*NQC*/ 4000) COLLATE Persian_100_CS_AI,
        SchemaName NVARCHAR(/*NQC*/ 4000) COLLATE Persian_100_CS_AI,
        ExtendedProps NVARCHAR(/*NCQ*/ MAX));

    INSERT INTO #ApplicationStoredProcedures (StoredProcedureId, AppVersionId, AppVersionDetailId, ApplicationVersionNumber, StoredProcedureName,
        StoredProcedureInvokeName, SchemaName, ExtendedProps)
    SELECT --
        AVD.StoredProcedureId, --
        AVD.AppVersionId, --
        AVD.AppVersionDetailId, --
        AV.VersionNumber, --
        AVD.StoredProcedureName, --
        dsp.StoredProcedure_InvokeStoreProcedureName(AV.AppVersionId, AVD.StoredProcedureName, @LatestAppVersionId) StoredProcedureInvokeName, --
        AVD.SchemaName, --
        SPM.Metadata --
      FROM  dsp.AppVersion AS AV
            INNER JOIN dsp.AppVersionDetail AS AVD ON AV.AppVersionId = AVD.AppVersionId
            OUTER APPLY dsp.StoredProcedure_Metadata(@SchemaName, StoredProcedureName) AS SPM
     WHERE  AVD.StoredProcedureVersionNumber IS NULL --
        AND (@JustLastVersion = 0 OR AV.VersionNumber = @LatestAppVersionId);

    -- Get result
    SET @StoredProceduresJsonResult = (   SELECT --
                                                AVD.StoredProcedureName, --
                                              AVD.StoredProcedureInvokeName, --
                                              AVD.AppVersionId, --
                                              AVD.SchemaName, --
                                              AVD.AppVersionId, --
                                              AVD.ApplicationVersionNumber, --
                                              JSON_QUERY(AVD.ExtendedProps, '$') AS ExtendedProps, --        
                                              Params.ParamName, --
                                              Params.IsOutput, --
                                              Params.Length, --
                                              Params.SystemTypeName, --
                                              Params.UserTypeName --
                                            FROM    #ApplicationStoredProcedures AVD
                                                    OUTER APPLY dsp.StoredProcedure_Params(StoredProcedureId) AS Params
                                           ORDER BY AVD.AppVersionId, AVD.StoredProcedureName
                                          FOR JSON AUTO);

END;




GO
