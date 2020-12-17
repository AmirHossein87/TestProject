IF OBJECT_ID('[dsp].[StoredProcedure_MaxKey]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_MaxKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dsp].[StoredProcedure_MaxKey] (@SchemaName TSTRING)
RETURNS INT
AS
BEGIN
    DECLARE @MaxKey INT;

    -- Get the max API key
    SELECT  TOP 1 @MaxKey = CAST(DSP.StoredProcedureKey AS INT)
      FROM  dsp.StoredProcedure_List(@SchemaName) AS DSP
     ORDER BY CAST(DSP.StoredProcedureKey AS INT) DESC;

    SET @MaxKey = ISNULL(@MaxKey, 0);
    SET @MaxKey = @MaxKey + 1;

    RETURN @MaxKey;
END;




GO
