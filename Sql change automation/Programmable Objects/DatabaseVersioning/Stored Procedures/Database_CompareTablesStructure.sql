IF OBJECT_ID('[DatabaseVersioning].[Database_CompareTablesStructure]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Database_CompareTablesStructure];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Database_CompareTablesStructure]
    @TablesJsonResult TJSON = NULL OUTPUT
AS
BEGIN
    -- Get Destination structure
    DECLARE @SourceTablesJsonResult TJSON;
    EXEC dsp.Database_Tables @TablesJsonResult = @TablesJsonResult OUTPUT;

    -- Get Source structure
    EXEC syn.Database_Tables @TablesJsonResult = @SourceTablesJsonResult OUTPUT;

    EXEC dsp.Json_Compare @Json1 = @TablesJsonResult, @Json2 = @SourceTablesJsonResult, @TwoSided = 1, @IncludeValue = 1, @IsThrow = 1, @CaseSencitive = 1;
END;
GO
