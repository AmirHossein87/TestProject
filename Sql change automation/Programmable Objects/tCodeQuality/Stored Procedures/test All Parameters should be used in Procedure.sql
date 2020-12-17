IF OBJECT_ID('[tCodeQuality].[test All Parameters should be used in Procedure]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test All Parameters should be used in Procedure];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test All Parameters should be used in Procedure]
AS
BEGIN
    DECLARE @ProcedureId INT;
    DECLARE @ProcedureSchemaName TSTRING;
    DECLARE @ProcedureName TSTRING;
    DECLARE @DefinitionCode TBIGSTRING;
    DECLARE @ProcedureTypeName TSTRING;

    DECLARE @ParameterObject TJSON;
    DECLARE @Procedures TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        ParameterObject TJSON);

    DECLARE Procedures_Cursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR -- 
    SELECT  SPL.StoredProcedureId, SPL.StoredProcedureSchemaName, SPL.StoredProcedureName, SPL.StoredProcedureDefinitionCode, 'P' AS ProcedureTypeName
      FROM  dsp.StoredProcedure_List(NULL) AS SPL
     WHERE  SPL.StoredProcedureSchemaName NOT IN ( 'tSQLt' )
    UNION ALL
    SELECT  FL.FunctionId, FL.FunctionSchemaName, FL.FunctionName, FL.FunctionDefinitionCode, FL.FunctionTypeName
      FROM  dsp.Function_List(NULL) AS FL;

    OPEN Procedures_Cursor;

    DECLARE @StartIndexDelimiter TSTRING;
    DECLARE @StartIndex BIGINT;
    DECLARE @Msg TSTRING;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM Procedures_Cursor
         INTO @ProcedureId, @ProcedureSchemaName, @ProcedureName, @DefinitionCode, @ProcedureTypeName;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- Remove whitespace from defination code
        SET @DefinitionCode = dsp.String_RemoveWhitespacesBig(@DefinitionCode);

        -- Validate Index after parameter declination
        SET @StartIndexDelimiter = IIF(@ProcedureTypeName = 'P', 'BEGIN', 'RET' + 'URNS');
        SET @StartIndex = CHARINDEX(@StartIndexDelimiter, @DefinitionCode);
        IF (@StartIndex = 0) --
        BEGIN
            SET @Msg = REPLACE(N'Procedure {0} has not BEGIN keyword', '{0}', @ProcedureName);
            EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Msg;
        END;

        -- Continue if procedure has not parameter
        IF NOT EXISTS (   SELECT    1
                            FROM    sys.parameters AS P
                           WHERE P.object_id = @ProcedureId --
        )
            CONTINUE;

        -- Get not used parameters
        SET @ParameterObject = (   SELECT   P.name
                                     FROM   sys.parameters AS P
                                    WHERE   P.name <> '' --
                                       AND  P.object_id = @ProcedureId --
                                       AND  CHARINDEX(P.name, @DefinitionCode, @StartIndex) = 0
                                   FOR JSON AUTO);

        IF (@ParameterObject IS NOT NULL)
            INSERT  @Procedures (SchemaName, ProcedureName, ParameterObject)
            VALUES (@ProcedureSchemaName, @ProcedureName, @ParameterObject);
    END;
    CLOSE Procedures_Cursor;
    DEALLOCATE Procedures_Cursor;

    IF EXISTS (SELECT   1 FROM  @Procedures AS P)
    BEGIN
        DECLARE @Message TBIGSTRING = '';
        SELECT  @Message = @Message + CONCAT('\n', P.SchemaName, '.', P.ProcedureName, ', Params: ', P.ParameterObject)
          FROM  @Procedures AS P
         ORDER BY P.SchemaName, P.ProcedureName;

        SET @Message = dsp.String_ReplaceEnter(@Message);

        DECLARE @ProceduresCount INT;
        SELECT  @ProceduresCount = COUNT(1)
          FROM  @Procedures AS P;

        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message;
    END;

END;
GO
