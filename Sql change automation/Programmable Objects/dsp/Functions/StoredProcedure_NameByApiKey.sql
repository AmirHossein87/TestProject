IF OBJECT_ID('[dsp].[StoredProcedure_NameByApiKey]') IS NOT NULL
	DROP FUNCTION [dsp].[StoredProcedure_NameByApiKey];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoredProcedure_NameByApiKey] (@SchemaName TSTRING,
    @ApiKey TSTRING)
RETURNS @StoredProcedure_NameByApiKey TABLE (StoredProcedureName TSTRING)
AS
BEGIN
    DECLARE @StoredProcedureName TSTRING;

    -- Find stored procedure by api key and schema
    SELECT TOP 1    @StoredProcedureName = StoredProcedureName
      FROM  dsp.StoredProcedure_List(@SchemaName)
     WHERE  StoredProcedureKey = @ApiKey; --

    INSERT INTO @StoredProcedure_NameByApiKey (StoredProcedureName)
    VALUES (@StoredProcedureName);

    RETURN;
END;




GO
