IF OBJECT_ID('[dsp].[StoredProcedure_VersionNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_VersionNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_VersionNumber] (@StoredProcedureName TSTRING)
RETURNS @T TABLE (VersionNumber TSTRING)
AS
BEGIN

    DECLARE @StoredProcedureVersionNumberPrefix TSTRING;

    -- Get the StoredProcedureVersionNumberPrefix value from settings
    SELECT  TOP 1 @StoredProcedureVersionNumberPrefix = S.StoredProcedureVersionNumberPrefix
      FROM  dsp.Setting AS S;

    DECLARE @StartIndex INT = CHARINDEX(@StoredProcedureVersionNumberPrefix, @StoredProcedureName);
    DECLARE @Length INT = LEN(@StoredProcedureName);

    -- Check if the stored procedure name does not have version number
    IF (@StartIndex IS NULL OR  @StartIndex = 0)
        RETURN;

    -- Get the version number from the stored procedure name
    INSERT INTO @T (VersionNumber)
    VALUES (SUBSTRING(@StoredProcedureName, @StartIndex + LEN(@StoredProcedureVersionNumberPrefix), @Length - @StartIndex));

    RETURN;
END;




GO
