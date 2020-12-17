IF OBJECT_ID('[tCodeQuality].[test Pagination]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Pagination];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	One of the following phrase must exits 
	1) @RecordIndex = @RecordIndex (Means the procedure is a wrapper)
	OR 
	1) EXEC dbo.Validate_RecordCount @RecordCount = @RecordCount OUT
	2) OFFSET @RecordIndex ROWS FETCH NEXT @RecordCount ROWS ONLY
*/
CREATE PROCEDURE [tCodeQuality].[test Pagination]
AS
BEGIN
    -- Declaring pattern
    DECLARE @Pattern_Offset TSTRING = dsp.String_RemoveWhitespaces('OFFSET @RecordIndex ROWS FETCH NEXT @RecordCount ROWS ONLY');
    DECLARE @Pattern_PageIndex TSTRING = dsp.String_RemoveWhitespaces('@RecordIndex = @RecordIndex');
    DECLARE @CurrentProcedure TSTRING;
    DECLARE @msg TSTRING;
    DECLARE @ProcedureName TSTRING;

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all procedures with pagination';
    DECLARE @t TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        Script TBIGSTRING);
    INSERT INTO @t
    SELECT  PD.StoredProcedureSchemaName, PD.StoredProcedureName, PD.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List(NULL) AS PD
     WHERE  CHARINDEX('@RecordIndex', PD.StoredProcedureDefinitionCode) > 0 AND CHARINDEX('@RecordCount', PD.StoredProcedureDefinitionCode) > 0 AND
            PD.StoredProcedureName NOT IN ( 'Context_ValidatePagination', 'Context_Verify' );


    -- Checking implementation paging in api and dbo StoreProcedure
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Checking implementation paging in api and dbo StoreProcedure';
    SELECT  @ProcedureName = SchemaName + '.' + ProcedureName
      FROM  @t
     WHERE  (   CHARINDEX(@Pattern_PageIndex, Script) > 0 --  Wrapper Phrase: (@RecordIndex = @RecordIndex) 
                AND CHARINDEX(@Pattern_Offset, Script) = 0); --ValidatePage size must exists if it not wrapper

    IF (@ProcedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Paging is not implemented properly in procedure: ' + @ProcedureName;
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;
    END;
END;
GO
