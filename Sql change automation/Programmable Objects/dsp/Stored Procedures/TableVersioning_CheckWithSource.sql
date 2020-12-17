IF OBJECT_ID('[dsp].[TableVersioning_CheckWithSource]') IS NOT NULL
	DROP PROCEDURE [dsp].[TableVersioning_CheckWithSource];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dsp].[TableVersioning_CheckWithSource]
    @SourceObject TJSON
AS
BEGIN
    -- Acheive the current database table's structure
    DECLARE @TablesJsonResult TJSON;
    EXEC dsp.Database_Tables @TablesJsonResult = @TablesJsonResult OUTPUT;
    -- Compare 2 Json 
    DECLARE @AreSame BIT;
    EXEC dsp.Json_Compare @Json1 = @SourceObject, @Json2 = @TablesJsonResult, @TwoSided = 1, @IncludeValue = 1, @IsThrow = 0, @AreSame = @AreSame OUTPUT;

    IF (@AreSame = 0) --
        EXEC dsperr.ThrowHasNotSameStrcutre @ProcId = @@PROCID, @Message = 'Source and target Json are not same';
END;
GO
