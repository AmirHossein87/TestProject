IF OBJECT_ID('[tCodeQuality].[test ValidateSubstitutionOfFunctioncallWithInteger]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test ValidateSubstitutionOfFunctioncallWithInteger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test ValidateSubstitutionOfFunctioncallWithInteger]
AS
BEGIN
    SET NOCOUNT ON;

    -- Getting Stored Procedures and Functions definition
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting Stored Procedures definition';
    DECLARE Text_Cursor CURSOR FAST_FORWARD FORWARD_ONLY FORWARD_ONLY LOCAL FOR --
    SELECT  PD.StoredProcedureSchemaName, PD.StoredProcedureName, dsp.String_RemoveWhitespacesBig(PD.StoredProcedureDefinitionCode)
      FROM  dsp.StoredProcedure_List(NULL) AS PD
     WHERE  PD.StoredProcedureSchemaName IN ( 'api', 'dbo' )
    UNION ALL
    SELECT  FL.FunctionSchemaName, FL.FunctionName, FL.FunctionDefinitionCode
      FROM  dsp.Function_List(NULL) AS FL;


    OPEN Text_Cursor;

    DECLARE @Script TBIGSTRING;
    DECLARE @ObjectName TSTRING;
    DECLARE @SchemaName TSTRING;
    DECLARE @Pattern TSTRING = '/*co' + 'nst.';

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM Text_Cursor
         INTO @SchemaName, @ObjectName, @Script;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- Cutting out text before /*co+nst
        DECLARE @StartIndex INT = CHARINDEX(@Pattern, @Script);
        SET @Script = SUBSTRING(@Script, @StartIndex - 1, (LEN(@Script) - @StartIndex) + 1);

        IF (CHARINDEX(@Pattern, @Script) = 0)
            CONTINUE;

        -- Validate Function Id with Corresponding value
        WHILE (CHARINDEX(@Pattern, @Script) > 0)
        BEGIN
            DECLARE @ConstFunctionName TSTRING;
            DECLARE @ConstValueInFunction INT;
            DECLARE @ConstValueInScript INT;
            DECLARE @IsMatch BIT;
            EXEC tCodeQuality.Private_CompareConstFunctionReturnValueWithScriptValue @Script = @Script OUTPUT, @ConstFunctionName = @ConstFunctionName OUTPUT,
                @ConstValueInFunction = @ConstValueInFunction OUTPUT, @ConstValueInScript = @ConstValueInScript OUTPUT, @IsMatch = @IsMatch OUTPUT;

            IF (@IsMatch = 0)
            BEGIN
                DECLARE @FullObjectName TSTRING = @SchemaName + '.' + @ObjectName;
                DECLARE @Message TSTRING;
                EXEC @Message = dsp.Formatter_FormatMessage @Message = N'\nConstValueInFunction({0}) and ConstValueInScript({1}) are inconsistence;\nthe function name is: {2} in the SP: {3}',
                    @Param0 = @ConstValueInFunction, @Param1 = @ConstValueInScript, @Param2 = @ConstFunctionName, @Param3 = @FullObjectName;

                SET @Message = dsp.String_ReplaceEnter(@Message);
                EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message;
            END;

            SET @StartIndex = CHARINDEX(@Pattern, @Script);
            SET @Script = SUBSTRING(@Script, @StartIndex, (LEN(@Script) - @StartIndex) + 1);
        END;
    END;
    CLOSE Text_Cursor;
    DEALLOCATE Text_Cursor;
END;



GO
