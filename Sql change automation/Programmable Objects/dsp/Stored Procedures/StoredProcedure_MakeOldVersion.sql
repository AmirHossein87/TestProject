IF OBJECT_ID('[dsp].[StoredProcedure_MakeOldVersion]') IS NOT NULL
	DROP PROCEDURE [dsp].[StoredProcedure_MakeOldVersion];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[StoredProcedure_MakeOldVersion]
    @TargetStoredProcedureName TSTRING
AS
BEGIN

    -- Get the last version number
    DECLARE @LastVersionNumber TSTRING = dsp.StoreProcedure_MaxVersionNumber();

    -- Get the temp stored procedure defintion code
    DECLARE @ProcedureDefinitionCode TBIGSTRING;
    SELECT  @ProcedureDefinitionCode = DSP.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List('temp') AS DSP
     WHERE  DSP.StoredProcedureName = @TargetStoredProcedureName;

    -- Get the StoredProcedureVersionNumberPrefix  from settings
    DECLARE @StoredProcedureVersionNumberPrefix TSTRING;
    EXEC dsp.Setting_GetProps @StoredProcedureVersionNumberPrefix = @StoredProcedureVersionNumberPrefix OUTPUT;

    -- Replace the temp schema name with the api schema name
    DECLARE @StoredProcedureName TSTRING = @TargetStoredProcedureName + @StoredProcedureVersionNumberPrefix + @LastVersionNumber;
    SET @ProcedureDefinitionCode =
        REPLACE(@ProcedureDefinitionCode, 'CREATE PROCEDURE temp.' + @TargetStoredProcedureName, 'CREATE PROCEDURE api.' + @StoredProcedureName);
    EXEC sys.sp_executesql @ProcedureDefinitionCode;


END;











GO
