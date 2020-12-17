IF OBJECT_ID('[DatabaseVersioning].[Init_FillLookups]') IS NOT NULL
	DROP PROCEDURE [DatabaseVersioning].[Init_FillLookups];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DatabaseVersioning].[Init_FillLookups]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TableName TSTRING;

	-- SQL Prompt formatting off

	-- TemporalType
    SET @TableName = N'TemporalType';
    SELECT  * 
    INTO    #TemporalType
      FROM  DatabaseVersioning.TemporalType AS A
     WHERE  1 = 0;

    INSERT INTO #TemporalType
    VALUES 
		(dspconst.TemporalType_Ordinary(), N'Historical'),
		(dspconst.TemporalType_Temporal(), N'Temporal'),
		(dspconst.TemporalType_Transactional(), N'Transactional'),
		(dspconst.TemporalType_Lookup(), N'Lookup')
		
    EXEC dsp.Table_CompareData @DestinationTableName = @TableName, @DestinationSchemaName = 'DatabaseVersioning';

	-- SQL Prompt formatting on
END;


GO
