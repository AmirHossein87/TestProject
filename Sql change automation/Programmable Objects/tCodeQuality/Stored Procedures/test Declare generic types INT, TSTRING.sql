IF OBJECT_ID('[tCodeQuality].[test Declare generic types INT, TSTRING]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Declare generic types INT, TSTRING];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test Declare generic types INT, TSTRING]
AS
BEGIN
    DECLARE @msg TSTRING;
    DECLARE @ProcedureName TSTRING;

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Getting list all procedures with api schema';
    DECLARE @t TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        Script TBIGSTRING);
    INSERT INTO @t
    SELECT  PD.StoredProcedureSchemaName, PD.StoredProcedureName, PD.StoredProcedureDefinitionCode
      FROM  dsp.StoredProcedure_List('api') AS PD
     WHERE  PD.StoredProcedureName NOT IN ( 'Convert_ToString', 'Convert_ToSqlvariant', 'CRYPT_PBKDF2_VARBINARY_SHA512' );

    -- Looking for "tinyint and smallint" phrase
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Looking for "tinyint and smallint" phrase';
    SET @ProcedureName = STUFF((   SELECT   '\n' + SchemaName + '.' + ProcedureName
                                     FROM   @t
                                    WHERE   (SchemaName IN ( 'dbo', 'api', 'dsp' )) AND (CHARINDEX('tinyint', Script) > 0 OR CHARINDEX('smallint', Script) > 0)
                                   FOR XML PATH('')), 1, 2, '');

    IF (@ProcedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should not contains SMALLINT or TINYINT in procedure: \n' + @ProcedureName;
        SET @msg = dsp.String_ReplaceEnter(@msg);
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;
    END;

    -- Looking for "NVARCHAR(MAX)" phrase
    EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = N'Looking for "NVARCHAR(MAX)" phrase';
    SET @ProcedureName = STUFF((   SELECT   '\n' + SchemaName + '.' + ProcedureName
                                     FROM   @t
                                    WHERE   (SchemaName IN ( 'dbo', 'api', 'dsp' )) AND (Script LIKE '%VARCHAR([0-9]%' OR   Script LIKE '%VARCHAR(MAX)%')
                                   FOR XML PATH('')), 1, 2, '');

    IF (@ProcedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should not contains NVARCHAR(XX) in procedure: \n' + @ProcedureName;
        SET @msg = dsp.String_ReplaceEnter(@msg);
        EXEC dsptest.ThrowFail @ProcId = @@PROCID, @Message = @msg;
    END;

END;
GO
