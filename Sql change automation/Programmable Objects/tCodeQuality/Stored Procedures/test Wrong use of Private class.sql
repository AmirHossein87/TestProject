IF OBJECT_ID('[tCodeQuality].[test Wrong use of Private class]') IS NOT NULL
	DROP PROCEDURE [tCodeQuality].[test Wrong use of Private class];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [tCodeQuality].[test Wrong use of Private class]
AS
BEGIN
    -- Declaring pattern
    DECLARE @SchemaName TSTRING;
    DECLARE @ObjectName TSTRING;
    DECLARE @Script TBIGSTRING;
    DECLARE @ClassName TSTRING;

    -- Get procedures and find className
    DECLARE Procedures_Cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR --
    SELECT  PD.StoredProcedureSchemaName, --
        PD.StoredProcedureName, REPLACE(REPLACE(REPLACE(PD.StoredProcedureDefinitionCode, CHAR(10), ''), CHAR(13), ''), CHAR(9), ' '), --
        SUBSTRING(PD.StoredProcedureName, 1, CHARINDEX('_', PD.StoredProcedureName) - 1) AS ClassName
      FROM  dsp.StoredProcedure_List(NULL) AS PD
     WHERE  PD.StoredProcedureName NOT LIKE '%test%' --
        AND CHARINDEX('_', PD.StoredProcedureName) > 0 --
        AND CHARINDEX('_$', PD.StoredProcedureDefinitionCode) > 0 --
        AND CHARINDEX('_$', PD.StoredProcedureName) = 0 AND PD.StoredProcedureSchemaName <> 'tUtil';

    OPEN Procedures_Cursor;

    FETCH NEXT FROM Procedures_Cursor
     INTO @SchemaName, @ObjectName, @Script, @ClassName;

    SET @ClassName = REPLACE(@ClassName, '[', '');
    DECLARE @Msg TSTRING;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        DECLARE @HasWrongClassName BIT = 0;
        SELECT  @HasWrongClassName = 1
          FROM  STRING_SPLIT(@Script, ' ') AS SS
         WHERE  CHARINDEX('_$', SS.value) > 0 AND   REPLACE(SS.value, '[', '') NOT LIKE '%.' + @ClassName + '_$%';

        EXEC @Msg = dsp.Formatter_FormatMessage @Message = 'ObjectName: [{0}].[{1}]', @Param0 = @SchemaName, @Param1 = @ObjectName;
        IF (@HasWrongClassName = 1) --
            EXEC dsptest.Fail @ProcId = @@PROCID, @Message0 = @Msg;

        -- fetch next record
        FETCH NEXT FROM Procedures_Cursor
         INTO @SchemaName, @ObjectName, @Script, @ClassName;
    END;

    CLOSE Procedures_Cursor;
    DEALLOCATE Procedures_Cursor;
END;

GO
