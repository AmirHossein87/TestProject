IF OBJECT_ID('[dsp].[StoreProcedure_MaxVersionNumber]') IS NOT NULL
	DROP FUNCTION [dsp].[StoreProcedure_MaxVersionNumber];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dsp].[StoreProcedure_MaxVersionNumber] ()
RETURNS INT
AS
BEGIN
    -- Get Schema name
    DECLARE @SchemaName TSTRING = dbo.Setting_VersioningSchemaName();

    -- The temp table definition
    DECLARE @MaxVersionNumber INT;
    SELECT  @MaxVersionNumber = SPM.VersionNumber --
      FROM  sys.procedures AS P
            CROSS APPLY dsp.StoredProcedure_VersionNumber(P.name) AS SPM
     WHERE  P.schema_id = SCHEMA_ID(@SchemaName)
     ORDER BY CAST(SPM.VersionNumber AS INT) DESC;

    SET @MaxVersionNumber = ISNULL(@MaxVersionNumber, 0);
    SET @MaxVersionNumber = @MaxVersionNumber + 1;
    RETURN @MaxVersionNumber;
END;



GO
