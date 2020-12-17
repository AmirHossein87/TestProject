IF OBJECT_ID('[dsp].[Table_ValidateExistance]') IS NOT NULL
	DROP PROCEDURE [dsp].[Table_ValidateExistance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[Table_ValidateExistance]
    @SchemaName TSTRING, @TableName TSTRING
AS
BEGIN
    IF NOT EXISTS (   SELECT TOP 1  1
                        FROM    sys.tables t
                                INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
                       WHERE s.name = @SchemaName AND   t.name = @TableName)
        EXEC dsperr.ThrowAccessDeniedOrObjectNotExists @ProcId = @@PROCID, @Message = 'Table {0}.{1}', @Param0 = @SchemaName, @Param1 = @TableName;
END;


GO
