IF OBJECT_ID('[dsp].[Table_DeleteRecords]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_DeleteRecords];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_DeleteRecords]
AS
BEGIN

    DECLARE @DeleteSqlCmd NVARCHAR(MAX);
    DECLARE @DeletetableName TSTRING;
    DECLARE @objectId INT;
    DECLARE @ConstraintName TSTRING;
    DECLARE @NOCHECKCONSTRAINT TSTRING;
    DECLARE @CHECKCONSTRAINT TSTRING;
    DECLARE @SchemaName TSTRING;
    DECLARE @IsTemporal BIT;

    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;

    BEGIN TRY
        -- Disable all constraints
        EXEC sys.sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all';

        -- Get list all tables for delete
        DECLARE Constraint_Cursor CURSOR FOR
        SELECT  s.name AS SchemaName, t.name, t.object_id, SFKT.name AS constraintname
          FROM  sys.tables t
                INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
                OUTER APPLY dsp.Table_GetForeignKeys(DEFAULT, t.name) SFKT
         WHERE  s.name <> N'tSQLt' AND  t.temporal_type <> 1;


        OPEN Constraint_Cursor;
        FETCH NEXT FROM Constraint_Cursor
         INTO @SchemaName, @DeletetableName, @objectId, @ConstraintName;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @IsTemporal =
                IIF(
                EXISTS (SELECT  history_table_id FROM   sys.tables WHERE object_id = OBJECT_ID(@SchemaName + '.' + @DeletetableName) AND
                                                                       history_table_id IS NOT NULL),
                1,
                0);

            IF @IsTemporal = 1
                EXEC dsp.Table_DisableTemporalAttribute @SchemaName = @SchemaName, @TableName = @DeletetableName;

            IF @IsTemporal = 1
            BEGIN
                SET @DeleteSqlCmd = N'DELETE FROM ' + @SchemaName + N'.' + @DeletetableName + N'History';
                EXEC (@DeleteSqlCmd);
            END;
            SET @DeleteSqlCmd = N'DELETE FROM ' + @SchemaName + N'.' + @DeletetableName;
            EXEC (@DeleteSqlCmd);

            -- Disable all Temporal
            IF @IsTemporal = 1
                EXEC dsp.Table_EnableTemporalAttribute @SchemaName = @SchemaName, @TableName = @DeletetableName;


            FETCH NEXT FROM Constraint_Cursor
             INTO @SchemaName, @DeletetableName, @objectId, @ConstraintName;
        END;

        CLOSE Constraint_Cursor;
        DEALLOCATE Constraint_Cursor;

        -- Enable all constraints
        EXEC sys.sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all';

        -- Enable temporaltype extended property


        IF (@TranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
