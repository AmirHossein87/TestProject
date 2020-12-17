IF OBJECT_ID('[tCodeQuality].[test Table with IsDeleted Field must have vw... View & ..._GetProps Procedure]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Table with IsDeleted Field must have vw... View & ..._GetProps Procedure];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test Table with IsDeleted Field must have vw... View & ..._GetProps Procedure]
AS
BEGIN

    DECLARE @ViewId INT;
    DECLARE @ProcedureId INT;
    DECLARE @TableName sysname;
    DECLARE @ProcUseView BIT;
    DECLARE @ViewUseIsDeletedWhereClause BIT;
    DECLARE @msg TSTRING = '';

    DECLARE TablesCursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
    SELECT  TableName = T.name, ViewId = V.object_id, ProcedureId = PRC.object_id,
        ProcUseView = CASE
                          WHEN CHARINDEX('vw_' + T.name, OBJECT_DEFINITION(PRC.object_id)) < 1
                              THEN 0 ELSE 1
                      END, ViewUseIsDeletedWhereClause = CASE
                                                             WHEN OBJECT_DEFINITION(V.object_id) LIKE '%IsDeleted = 0%'
                                                                 THEN 1 ELSE 0
                                                         END
      FROM  sys.columns C
            INNER JOIN sys.tables T ON T.object_id = C.object_id
            LEFT OUTER JOIN sys.views V ON V.name = 'vw_' + T.name AND  V.schema_id = T.schema_id
            LEFT OUTER JOIN sys.procedures PRC ON PRC.name = T.name + '_GetProps' AND   PRC.schema_id = T.schema_id
     WHERE  (1 = 1) AND C.name LIKE '%IsDeleted%';

    OPEN TablesCursor;
    FETCH NEXT FROM TablesCursor
     INTO @TableName, @ViewId, @ProcedureId, @ProcUseView, @ViewUseIsDeletedWhereClause;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check view existance
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'For Table "{0}": Checking : View "vw_{1}" object existance', @Param0 = @TableName,
        @Param1 = @TableName;
        IF @ViewId IS NULL
            SET @msg = @msg + '--> For Table "' + @TableName + '": Check : View "vw_' + @TableName + '" object NOT Exist' + CHAR(13);

        -- Check view has "IsDeleted = 0" in where clause
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'For Table "{0}": Checking : View "vw_{1}" Use "IsDelete = 0" expression in where clause',
            @Param0 = @TableName, @Param1 = @TableName, @Param2 = @TableName;
        IF @ViewUseIsDeletedWhereClause = 0
            SET @msg =
                @msg + '--> For Table "' + @TableName + '": Check : View "vw_' + @TableName + '" Dont use "IsDelete = 0" expression in where clause' + CHAR(13);

        -- Check _GetProps procedure existance
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'For Table "{0}": Checking : Procedure "{1}_GetProps" object existance', @Param0 = @TableName,
            @Param1 = @TableName;
        IF @ProcedureId IS NULL
            SET @msg = @msg + '--> For Table "' + @TableName + '": Check : Procedure "' + @TableName + '_GetProps" object NOT Exist' + CHAR(13);

        -- Check _GetProps use vw_... view
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = 'For Table "{0}": Checking : Procedure "{1}_GetProps" Use View "vw_{2}" for fetch datas',
            @Param0 = @TableName, @Param1 = @TableName, @Param2 = @TableName;
        IF @ProcUseView = 0
            SET @msg =
                @msg + '--> For Table "' + @TableName + '": Check : Procedure "' + @TableName + '_GetProps" Dont use View "vw_' + @TableName
                + '" for fetch datas' + CHAR(13);

        FETCH NEXT FROM TablesCursor
         INTO @TableName, @ViewId, @ProcedureId, @ProcUseView, @ViewUseIsDeletedWhereClause;
    END;
    CLOSE TablesCursor;
    DEALLOCATE TablesCursor;

    IF @msg <> ''
    BEGIN
        SET @msg = CHAR(13) + @msg;
        EXEC dsptest.Fail @ProcId = @@PROCID, @Message0 = @msg;
    END;


END;

GO
