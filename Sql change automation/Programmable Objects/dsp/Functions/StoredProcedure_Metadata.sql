IF OBJECT_ID('[dsp].[StoredProcedure_Metadata]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_Metadata];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsp].[StoredProcedure_Metadata] (@SchemaName TSTRING = 'api',
    @StoredProcedureName TSTRING)
RETURNS @StoredProcedure_Metadata TABLE (Metadata TSTRING)
AS
BEGIN
    -- Get script
    DECLARE @Script TBIGSTRING;
    SELECT  @Script = OBJECT_DEFINITION(P.object_id)
      FROM  sys.procedures AS P
     WHERE  P.schema_id = SCHEMA_ID(@SchemaName) AND P.name = @StoredProcedureName;

    --find start of text
    DECLARE @MetaStartIndex INT = CHARINDEX('#MetaStart', @Script);

    -- Check if the stored procedure does not have meta data
    IF (@MetaStartIndex = 0)
    BEGIN
        INSERT INTO @StoredProcedure_Metadata (Metadata)
        VALUES (N'{}');
        RETURN;
    END;


    SET @MetaStartIndex = @MetaStartIndex + LEN('#MetaStart');

    DECLARE @MetaEndIndex INT = CHARINDEX('#MetaEnd', @Script, @MetaStartIndex);

    INSERT INTO @StoredProcedure_Metadata (Metadata)
    VALUES (SUBSTRING(@Script, @MetaStartIndex, @MetaEndIndex - @MetaStartIndex));

    RETURN;
END;







GO
