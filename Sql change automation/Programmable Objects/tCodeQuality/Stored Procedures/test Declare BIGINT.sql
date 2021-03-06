IF OBJECT_ID('[tCodeQuality].[test Declare BIGINT]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Declare BIGINT];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test Declare BIGINT]
AS
BEGIN
    -- Getting procedures which have bigint columns with int declaration
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting procedures which have bigint columns with int declaration';
    DECLARE @ProcInfo TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        DEFINITION TBIGSTRING,
        ColumnName TSTRING);
    INSERT  @ProcInfo (SchemaName, ProcedureName, DEFINITION, ColumnName)
    EXEC tCodeQuality.Private_ColumnsWithBigintTypes;

    -- Checking if there is any wrong type for Bigint Columns
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Checking if there is any wrong type for Bigint Columns';
    DECLARE @ProcName TSTRING = '';
    DECLARE @ParamName TSTRING = '';
    IF EXISTS (SELECT   1 FROM  @ProcInfo AS PI)
    BEGIN
        DECLARE @Message TSTRING =
                (   SELECT      CHAR(10) + N'in the procedure "' + PI.SchemaName + '.' + PI.ProcedureName + '", parameter "',
                        PI.ColumnName + '" has wrong parameter data type!'
                      FROM      @ProcInfo AS PI
                    FOR XML PATH(''));

        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @Message;
    END;
END;
GO
