IF OBJECT_ID('[dsp].[Table_DisableTemporalAttribute]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_DisableTemporalAttribute];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_DisableTemporalAttribute]
    @SchemaName TSTRING = NULL, @TableName TSTRING = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Vaidate for existance
    EXEC dsp.Table_ValidateExistance @SchemaName = @SchemaName, @TableName = @TableName;

    DECLARE @Column TSTRING;
    DECLARE @Sql TSTRING;
    DECLARE @Temporal_Type INT;
    DECLARE @Name TSTRING;

    -- Get list table name by input parameter
    DECLARE @Temp TABLE (TableName TSTRING);
    INSERT INTO @Temp (TableName)
    SELECT  s.name + '.' + t.name
      FROM  sys.tables t
            INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
     WHERE  (@TableName IS NULL OR  t.name = @TableName) --
        AND t.temporal_type = 2;

    IF NOT EXISTS (SELECT TOP 1 1 FROM  @Temp)
        RETURN;

    DECLARE db_cursor CURSOR FOR --
    SELECT  TableName
      FROM  @Temp;

    OPEN db_cursor;
    FETCH NEXT FROM db_cursor
     INTO @Name;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Disable the system versioning
        SET @Column = '(SYSTEM_VERSIONING = OFF)';
        SET @Sql = 'ALTER TABLE ' + @Name + ' set ' + @Column;
        EXEC (@Sql);
        SET @Sql = 'ALTER TABLE ' + @Name + ' DROP PERIOD FOR SYSTEM_TIME';
        EXEC (@Sql);


        FETCH NEXT FROM db_cursor
         INTO @Name;
    END;
    CLOSE db_cursor;
    DEALLOCATE db_cursor;
END;





GO
