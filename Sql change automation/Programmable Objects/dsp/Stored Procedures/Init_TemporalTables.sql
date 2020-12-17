IF OBJECT_ID('[dsp].[Init_TemporalTables]') IS NOT NULL
	DROP PROCEDURE [dsp].[Init_TemporalTables];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Init_TemporalTables]
AS
BEGIN
    SET NOCOUNT ON;

    -- Cursor on all temporal tables
    DECLARE _Cursor CURSOR LOCAL FAST_FORWARD FORWARD_ONLY READ_ONLY FOR -- 
    SELECT  SchemaName, TableName
      FROM  dsp.SystemTable
     WHERE  TemporalTypeId = /*dspconst.TemporalType_Temporal()*/ 2;

    OPEN _Cursor;

    DECLARE @SchemaName TSTRING;
    DECLARE @TableName TSTRING;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _Cursor
         INTO @SchemaName, @TableName;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- Enable temporal
        EXEC dsp.Table_EnableTemporalAttribute @SchemaName = @SchemaName, @TableName = @TableName;
    END;
    CLOSE _Cursor;
    DEALLOCATE _Cursor;
END;
GO
